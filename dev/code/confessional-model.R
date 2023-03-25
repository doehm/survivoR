
library(tidyverse)
library(brms)
library(ggpath)
library(ggtext)
library(epitools)

# functions ---------------------------------------------------------------

make_conf_index <- function(
    .vs,
    .final = NULL,
    .ep = NULL
) {

  # set pars if NULL
  if(is.null(.final) & is.null(.ep)) {
    .ep <- 99
  } else if(!is.null(.final)){
    df_final_n <- survivoR::castaways |>
      filter(version_season == .vs) |>
      slice_max(order, n = .final)

    .ep <- min(df_final_n$episode)
  } else if(!is.null(.ep)) {
    .ep <- .ep + 1
  }

  # filter confessionals to episode
  df_conf_ep <- survivoR::confessionals |>
    filter(
      version_season == .vs,
      episode < .ep
    ) |>
    add_tribe() |>
    group_by(season, episode, tribe) |>
    summarise(
      total = sum(confessional_count),
      ep_mean = mean(confessional_count),
      n_cast = n(),
      .groups = "drop"
    )

  # who's still alive
  alive <- survivoR::castaways |>
    filter(version_season == .vs) |>
    mutate(episode = replace_na(episode, 99)) |>
    filter(episode >= .ep)

  # pull it together
  survivoR::confessionals |>
    filter(
      version_season == .vs,
      episode < .ep
    ) |>
    add_tribe() |>
    left_join(df_conf_ep, by = c("season", "episode", "tribe")) |>
    group_by(season, castaway_id) |>
    summarise(
      total = sum(confessional_count),
      n_conf = sum(confessional_count),
      n_eps = n_distinct(season, episode),
      mean_conf = round(mean(confessional_count), 1),
      exp_conf = sum(ep_mean)
    ) |>
    group_by(castaway_id) |>
    summarise(
      version_season = .vs,
      total = sum(total),
      n_eps = sum(n_eps),
      n_conf = sum(n_conf),
      exp_conf = sum(exp_conf),
    ) |>
    ungroup() |>
    add_castaway() |>
    mutate(
      index = n_conf/exp_conf,
      edit_pct = round(n_conf/exp_conf - 1, 2)*100,
      alive = castaway_id %in% alive$castaway_id
    ) |>
    arrange(desc(index)) |>
    select(version_season, everything())
}

cast_in_final_n <- function(.n) {
  survivoR::boot_mapping |>
    filter(game_status %in% c("In the game", "Returned")) |>
    left_join(get_final_n(), by = c("version_season", "order")) |>
    filter(final_n == .n)
}



# data set up -------------------------------------------------------------

.v <- "US"

# final 5
f5 <- cast_in_final_n(5) |>
  filter(
    !version_season %in% c("US44", "AU08"),
    version %in% .v
  ) |>
  group_by(version_season) |>
  distinct(version_season, f5_ep = episode)

# final 3
f3 <- cast_in_final_n(3) |>
  filter(
    !version_season %in% c("US44", "AU08"),
    version %in% .v
  ) |>
  distinct(version_season, castaway_id) |>
  mutate(f3 = 1)

# winner
winner <- survivoR::castaways |>
  filter(
    !version_season %in% c("US44", "AU08"),
    version %in% .v
  ) |>
  filter(str_detect(result, "Sole")) |>
  distinct(version_season, castaway_id) |>
  mutate(winner = 1)

# list of seasons
df_vs <- f5 |>
  mutate(
    season = as.numeric(str_extract(version_season, "[:digit:]+")),
    version = str_sub(version_season, 1, 2)
  )

# bind indexes
df_index <- NULL
for(k in 1:nrow(df_vs)) {
  df_index <- df_index |>
    bind_rows(
      make_conf_index(
        .vs = df_vs$version_season[k],
        .final = 5
      ) |>
        mutate(
          season = df_vs$season[k],
          version = df_vs$version[k]
        )
    )
}

# main data frame
df <- survivoR::confessionals |>
  left_join(f5, by = "version_season") |>
  filter(episode < f5_ep) |>
  semi_join(cast_in_final_n(5), by = c("version_season", "castaway_id")) |>
  group_by(version, version_season, castaway_id) |>
  summarise(n = sum(confessional_count)) |>
  group_by(version_season) |>
  mutate(is_max = as.numeric(n == max(n))) |>
  left_join(f3, by = c("version_season", "castaway_id")) |>
  left_join(winner, by = c("version_season", "castaway_id")) |>
  mutate(
    f3 = replace_na(f3, 0),
    winner = replace_na(winner, 0)
  ) |>
  group_by(version_season) |>
  mutate(mean = mean(n)) |>
  ungroup() |>
  mutate(
    sd = sd(n),
    n_scaled = (n - mean)/sd
  ) |>
  left_join(
    df_index |>
      mutate(log_index = log(index)) |>
      select(version_season, castaway_id, index, log_index),
    by = c("version_season", "castaway_id")
  )

# quick 2x2
X <- df |>
  count(is_max, winner) |>
  pull(n) |>
  matrix(nrow = 2, byrow = TRUE)
dimnames(X) <- list("is_max" = c("Not max", "Max"), "winner" = c("Not winner", "Winner"))

# odds ratio
oddsratio(X)

# check sq test
chisq.test(X)

# quick glm
mod <- glm(winner ~ log_index, data = df, family = binomial())
summary(mod)


# 2. probability of winning -----------------------------------------------

# bayes model
mod_brm <- brm(
  winner ~ log_index,
  data = df,
  family = bernoulli(),
  prior = prior(normal(0, 1), class = "b", coef = "log_index")
)

mod_brm

# posteriors
new_data <- tibble(log_index = log(seq(0, 2.75, 0.05)))
pred <- posterior_epred(mod_brm, newdata = new_data)

df_pred <- t(pred) |>
  as_tibble() |>
  bind_cols(new_data) |>
  mutate(index = exp(log_index)) |>
  select(-log_index) |>
  pivot_longer(-index, names_to = "id", values_to = "draw") |>
  group_by(index) |>
  summarise(
    q5 = quantile(draw, 0.05),
    q10 = quantile(draw, 0.1),
    q25 = quantile(draw, 0.25),
    q50 = quantile(draw, 0.5),
    q75 = quantile(draw, 0.75),
    q90 = quantile(draw, 0.9),
    q95 = quantile(draw, 0.95)
  )

# plot
bg <- "white"
txt <- "grey20"
ft <- "karla"
line <- "grey70"
accent <- "#35B0AB"

df_pred |>
  ggplot() +
  geom_ribbon(aes(x = index, ymin = q5, ymax = q95), alpha = 0.15, fill = accent) +
  geom_ribbon(aes(x = index, ymin = q10, ymax = q90), alpha = 0.15, fill = accent) +
  geom_ribbon(aes(x = index, ymin = q25, ymax = q75), alpha = 0.15, fill = accent) +
  geom_line(aes(x = index, y = q50), colour = accent) +
  annotate("richtext", x = 0.2, y = 0.65, label = "Probability<br>of winning", lineheight = 0.3, family = ft, size = 16, colour = txt, hjust = 0, label.colour = NA) +
  scale_x_continuous(breaks = seq(0, 2.75, 0.5), labels = seq(0, 2.75, 0.5), limits = c(0.2, 2.75)) +
  scale_y_continuous(breaks = seq(0, 1, 0.1), labels = paste0(seq(0, 1, 0.1)*100, "%")) +
  labs(
    title = "Final 5 probability of winning",
    subtitle = "The higher the relative confessional count, the higher the probability of winning the season.",
    x = "Confessional index",
    caption =
      "The confessionals have been standarised to an index estimating the proportion of confessionals above or below expectation.<br>
    This accounts for seasons which have more cast, episodes, or editing styles."
  ) +
  theme_void() +
  theme(
    text = element_text(family = ft, colour = txt, size = 48),
    plot.background = element_rect(fill = bg, colour = bg),
    plot.title = element_text(family = ft, size = 84),
    plot.subtitle = element_text(margin = margin(b = 30, t = 10), lineheight = 0.3),
    plot.margin = margin(t = 50, b = 30, l = 50, r = 80),
    plot.caption = element_markdown(size = 36, hjust = 0, margin = margin(t = 20), lineheight = 0.3),
    axis.title.x = element_text(),
    axis.text = element_text(margin = margin(t = 10, b = 10, l = 10, r = 10)),
    axis.ticks = element_line(colour = line),
    axis.line = element_line(colour = line, arrow = arrow(type = "closed", length = unit(0.15, "inches"))),
    panel.grid = element_line(colour = line, linetype = 3)
  )

ggsave("prop-winning.png", height = 8, width = 12)

# rank plot ---------------------------------------------------------------

font_add("fa-brands", regular = "C:/Users/Dan/Documents/R/repos/survivorDev/assets/fonts/fontawesome-free-6.2.0-web/webfonts/fa-brands-400.ttf")
font_add("fa-solid", regular = "C:/Users/Dan/Documents/R/repos/survivorDev/assets/fonts/fontawesome-free-6.2.0-web/webfonts/fa-solid-900.ttf")
font_add("fa-reg", regular = "C:/Users/Dan/Documents/R/repos/survivorDev/assets/fonts/fontawesome-free-6.2.0-web/webfonts/fa-regular-400.ttf")
showtext_auto()

mastodon <- glue("<span style='font-family:fa-brands; color:{accent}'>&#xf4f6;</span>")
twitter <- glue("<span style='font-family:fa-brands; color:{accent}'>&#xf099;</span>")
github <- glue("<span style='font-family:fa-brands; color:{accent}'>&#xf09b;</span>")
space <- glue("<span style='color:{bg};font-size:1px'>'</span>")
space2 <- glue("<span style='color:{bg}'>--</span>") # can't believe I'm doing this
caption <- glue("{mastodon}{space2}@danoehm@{space}fosstodon.org{space2}{twitter}{space2}@danoehm{space2}{github}{space2}doehm/survivoR{space2}")

df_x <- df |>
  arrange(version_season, desc(n)) |>
  group_by(version_season) |>
  mutate(
    rank = 5 - rank(n, ties.method = "first"),
    season = 44-as.numeric(str_extract(version_season, "[:digit:]+"))
  ) |>
  arrange(desc(winner), rank) |>
  add_castaway_image() |>
  add_castaway() |>
  left_join(
    survivoR::castaways |>
      group_by(version_season, castaway_id) |>
      slice_max(order) |>
      select(result),
    by = c("version_season", "castaway_id")
  ) |>
  mutate(label = glue("{result}\n{n}")) |>
  ungroup()

df_x <- df_x |>
  mutate(y = 44-as.numeric(factor(version_season, levels = df_x$version_season[1:43])))

df_s_name <- survivoR::season_summary |>
  filter(version == "US") |>
  distinct(version_season, season_name) |>
  mutate(season_name = str_remove(season_name, "Survivor: "))

df_rect <- df_x |>
  filter(result == "Sole Survivor") |>
  left_join(df_s_name, by = "version_season")

df_labs <- tibble(
  rank = 0:4,
  y = 44,
  lab = c("Most confessionals", "2nd most", "3rd most", "4th most", "least cofessionals")
)

df_x |>
  mutate(castaway = ifelse(castaway == "Jonny Fairplay", "J. Fairplay", castaway)) |>
  ggplot(aes(rank, y)) +
  geom_rrect(aes(xmin = rank-0.135, xmax = rank+0.87, ymin = y-0.475, ymax = y+0.475), df_rect, fill = accent, radius = grid::unit(14, "pt")) +
  geom_from_path(aes(path = castaway_image), width = 0.035) +
  geom_text(aes(rank+0.2, y+0.25, label = toupper(castaway)), family = ft, size = 12, colour = txt, fontface = "bold", hjust = 0) +
  geom_text(aes(rank+0.2, y-0.2, label = label), family = ft, size = 9, colour = txt, lineheight = 0.25, hjust = 0) +
  geom_text(aes(-0.25, y+0.2, label = version_season), df_rect, family = ft, size = 16, colour = txt, lineheight = 0.2, hjust = 1, fontface = "bold") +
  geom_text(aes(-0.25, y-0.2, label = season_name), df_rect, family = ft, size = 12, colour = txt, lineheight = 0.2, hjust = 1) +
  geom_text(aes(rank, y, label = lab), df_labs, family = ft, size = 12, colour = txt, lineheight = 0.2, hjust = 0) +
  xlim(-1.2, 5) +
  labs(
    title = "FINAL 5 CONFESSIONAL RANK",
    subtitle = "The castaway with the most confessionals at the final 5 has won the season\non 17 occasions. The castaway with the least has won on 3 occasions.",
    caption = caption
  ) +
  coord_cartesian(clip = "off") +
  theme_void() +
  theme(
    text = element_text(family = ft, size = 12, colour = txt),
    plot.background = element_rect(fill = bg, colour = bg),
    plot.title = element_text(size = 180, family = "survivor", hjust = 0.5, margin = margin(b = 10)),
    plot.subtitle = element_text(size = 48, hjust = 0.5, lineheight = 0.25, margin = margin(b = -50)),
    plot.caption = element_markdown(size = 32, margin = margin(t = -40), hjust = 0.5),
    plot.margin = margin(l = 20, r = 50, t = 40, b = 0),
    legend.position = "none"
  )

ggsave("rank.png", height = 22, width = 12)


# 3. end of season model ---------------------------------------------------------

df_index_win <- map2_dfr(df_vs$season, df_vs$version, ~{
  make_edit_index(.season = .x, .version = .y) |>
    mutate(
      version_season = paste0(.y, str_pad(.x, width = 2, pad = 0)),
      version = .y
    )
}) |>
  mutate(log_index = log(edit_index))

df_x <- df_index_win |>
  semi_join(winner, by = c("version_season", "castaway_id"))

mod_win <- brm(log_index ~ 1, data = df_x)

mod_win

plot(mod_win)

# posterior check
pp_check(mod_win)

# posteriors
y_win <- posterior_predict(mod_win, ndraws = 100) |>
  as.numeric()

mu_win <- posterior_epred(mod_win) |>
  as.numeric() |>
  sample(4300)

# a quick look
hist(exp(y_win), breaks = 60)
hist(exp(mu_win), breaks = 60)
mean(mu_win < 0)

# 3. final 5 model -------------------------------------------------------------------

df_x <- df_index |>
  semi_join(winner, by = c("version_season", "castaway_id")) |>
  mutate(log_index = log(index))

mod_f5 <- brm(log_index ~ 1, data = df_x)

mod_f5

plot(mod_f5)

# posterior predictive check
pp_check(mod_f5)

# posteriors
y_f5 <- posterior_predict(mod_f5, ndraws = 100) |>
  as.numeric()

mu_f5 <- posterior_epred(mod_f5) |>
  as.numeric() |>
  sample(4300)

# a quick look
hist(exp(y_f5), breaks = 60)
hist(exp(mu_f5), breaks = 60)
mean(y_mean_f5 < 0)

# build data and plot -----------------------------------------------------

df_draws <- tibble(
  draws = exp(c(y_win, mu_win, y_f5, mu_f5)),
  par = c(rep("y (End)", 4300), rep("mu (End)", 4300), rep("y (f5)", 4300), rep("mu (f5)", 4300))
  ) |>
  mutate(par = factor(par, levels = c("y (f5)", "mu (f5)", "y (End)", "mu (End)")))

df_draws |>
  ggplot() +
  geom_histogram(aes(draws), fill = accent, bins = 120, colour = txt, size = 0.1, alpha = 0.8) +
  geom_vline(aes(xintercept = 1), colour = "red4") +
  facet_wrap(~par, scales = "free") +
  labs(
    title = "Posterior distributions",
    subtitle = "Posterior distributions of the index (y) and mean (mu) for the winner at the conlusion of the season and the final 5
The models suggest ~10-14% more confessionals for the winner.",
    x = "Index"
  ) +
  theme_void() +
  theme(
    text = element_text(family = ft, colour = txt, size = 48),
    plot.background = element_rect(fill = bg, colour = bg),
    plot.title = element_text(family = ft, size = 84),
    plot.subtitle = element_text(margin = margin(b = 30, t = 10), lineheight = 0.3),
    plot.margin = margin(t = 50, b = 30, l = 50, r = 80),
    plot.caption = element_markdown(size = 36, hjust = 0, margin = margin(t = 20), lineheight = 0.3),
    axis.title.x = element_text(),
    axis.text.x = element_text(margin = margin(t = 10, b = 10, l = 10, r = 10)),
    axis.ticks = element_line(colour = line)
  )

ggsave("post-win.png", height = 8, width = 12)
