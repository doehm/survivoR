
library(tidyverse)
library(tidybayes)
library(brms)
library(ggchicklet)
library(showtext)

# 🎨 fonts and palettes ---------------------------------------------------

pal <- c('#231942', '#3D3364', '#584E87', '#7566A0', '#937CB6', '#AAA1BC', '#BDD0B7', '#BFE7B2', '#A6DCAE', '#8ACFAB', '#5FBFAB', '#35B0AB')
accent <- pal[12]
grad_pal <- prgr_div
txt <- "grey20"
bg <- "white"

font_add_google("Karla", "karla")
ft <- "karla"
showtext_auto()

# 🏗️ functions -----------------------------------------------------------

my_pp_check <- function(mod, title = "**Posterior predictive check**", xlim = c(NA, NA), adj = 1) {

  z <- density(mod$data[,1], adjust = adj)
  df_y <- tibble(
    x = z$x,
    y = z$y
  )

  pred <- posterior_predict(mod)
  id <- sample(1:4000, 50)
  df <- map_dfr(id, ~{
    z <- density(pred[.x,], adjust = adj)
    tibble(
      x = z$x,
      y = z$y,
      id = .x
    )
  })
  df |>
    ggplot() +
    geom_line(aes(x, y, group = id), alpha = 0.1, colour = accent) +
    geom_line(aes(x, y), df_y, colour = "black", linewidth = 1) +
    xlim(xlim[1], xlim[2]) +
    labs(title = title) +
    theme_minimal() +
    theme(
      text = element_text(size = 32, family = ft, colour = txt, hjust = 0),
      plot.title = element_markdown(size = 64, family = ft, colour = txt, hjust = 0),
      plot.background = element_rect(fill = bg, colour = bg),
      axis.title = element_blank()
    )

}

add_castaway <- function(df) {
  df |>
    left_join(
      survivoR::castaway_details |>
        select(castaway_id, castaway),
      by = "castaway_id"
    ) |>
    select(castaway_id, castaway, everything())
}

# 🤼 wrangle --------------------------------------------------------------

df_tribal_council <- survivoR::vote_history |>
  distinct(version, season, episode, tribe, castaway_id) |>
  mutate(tribal_council = 1)

df_length <- survivoR::episodes |>
  ungroup() |>
  filter(version == "US") |>
  mutate(episode_length = ifelse(season == 44 & episode == 13, 128, episode_length)) |>
  distinct(version, season, episode, episode_length)

df_confs <- survivoR::confessionals |>
  filter(version == "US") |>
  add_tribe() |>
  group_by(version, season, episode, castaway_id) |>
  summarise(
    n_confs = sum(confessional_count),
    n_time = sum(confessional_time),
    .groups = "drop"
    ) |>
  group_by(version, season, episode) |>
  mutate(n_cast = n_distinct(castaway_id))

df_boot <- survivoR::boot_mapping |>
  filter(
    version == "US",
    game_status %in% c("In the game", "Returned")
    ) |>
  distinct(version, season, episode, tribe_status, order, castaway_id) |>
  group_by(version, season, episode, castaway_id) |>
  slice_min(order) |>
  select(-order)

df_advantages <- survivoR::advantage_movement |>
  filter(
    version == "US"
    ) |>
  group_by(version, season, episode, castaway_id) |>
  summarise(
    found_adv = sum(event == "Found"),
    .groups = "drop"
    )

df_reward <- survivoR::challenge_results |>
  filter(
    version == "US",
    str_detect(tribe_status, "Orig|Swap|Merg")
    ) |>
  group_by(version, season, episode, castaway_id) |>
  summarise(
    reward = sum(challenge_type == "Reward" & result == "Won"),
    chosen_for_reward = sum(chosen_for_reward),
    .groups = "drop"
  )

# 🔌 join --------------------------------------------------------------------

df_tribe <- df_confs |>
  filter(
    season < 45,
    version == "US"
  ) |>
  left_join(df_boot, by = c("version", "season", "episode", "castaway_id")) |>
  left_join(df_advantages, by = c("version", "season", "episode", "castaway_id")) |>
  left_join(df_reward, by = c("version", "season", "episode", "castaway_id")) |>
  left_join(df_length, by = c("version", "season", "episode")) |>
  left_join(df_tribal_council, by = c("version", "season", "episode", "castaway_id")) |>
  mutate(
    tribal_council = replace_na(tribal_council, 0),
    found_adv = replace_na(found_adv, 0),
    reward = replace_na(reward, 0),
    chosen_for_reward = replace_na(chosen_for_reward, 0),
    n_confs = n_confs,
    y = n_confs/episode_length*60+1,
    y_time = n_time/episode_length*60
  ) |>
  filter(!is.na(episode_length)) |>
  ungroup()

df_pre_merge <- df_tribe |>
  filter(str_detect(tribe_status, "Orig|Swap"))

df_post_merge <- df_tribe |>
  filter(tribe_status == "Merged")

# 📊 plot -----------------------------------------------------------------

g1 <- df_tribe |>
  count(n_confs) |>
  ggplot() +
  geom_col(aes(n_confs, n), fill = accent) +
  labs(
    x = "Number of confessionals",
    y = "Count",
    title = "Episode x person"
  ) +
  theme_minimal() +
  theme(
    text = element_text(family = ft, colour = txt, lineheight = 0.3, size = 32),
    plot.background = element_rect(fill = bg, colour = bg),
    plot.title = element_markdown(size = 64, family = ft, colour = txt, hjust = 0),
    axis.text.y = element_text(vjust = 0),
    axis.title.y = element_blank(),
    plot.caption = element_text(size = 16, hjust = 0)
  )

g2 <- df_tribe |>
  group_by(season, episode) |>
  summarise(n_confs = sum(n_confs)) |>
  ggplot() +
  geom_histogram(aes(n_confs), fill = accent) +
  labs(
    x = "Number of confessionals",
    title = "Episode"
  ) +
  theme_minimal() +
  theme(
    text = element_text(family = ft, colour = txt, lineheight = 0.3, size = 32),
    plot.background = element_rect(fill = bg, colour = bg),
    plot.title = element_markdown(size = 64, family = ft, colour = txt, hjust = 0),
    axis.text.y = element_text(vjust = 0),
    axis.title.y = element_blank(),
    plot.caption = element_text(size = 16, hjust = 0)
  )

g3 <- df_tribe |>
  group_by(season) |>
  summarise(n_confs = sum(n_confs)) |>
  ggplot() +
  geom_histogram(aes(n_confs), fill = accent) +
  labs(
    x = "Number of confessionals",
    title = "Season"
  ) +
  theme_minimal() +
  theme(
    text = element_text(family = ft, colour = txt, lineheight = 0.3, size = 32),
    plot.background = element_rect(fill = bg, colour = bg),
    plot.title = element_markdown(size = 64, family = ft, colour = txt, hjust = 0),
    axis.text.y = element_text(vjust = 0),
    axis.title.y = element_blank(),
    plot.caption = element_text(size = 16, hjust = 0)
  )

g1 + g2 + g3

ggsave("../survivoR-Bucket/images/blog/confessionals-and-tribal/counts.png", height = 5, width = 12)

# 💃 brms model (pre-merge) --------------------------------------------------------------

get_prior(y ~ tribal_council + reward + found_adv + n_cast, data = df_tribe, family = "gamma")
prior_b0 <- prior(normal(2, 0.5), class = "Intercept")
prior_b1 <- prior(normal(0, 2), class = "b")
priors <- c(prior_b0, prior_b1)

mod_pre <- brm(y ~ tribal_council + reward + found_adv + n_cast, data = df_pre_merge, family = "gamma", prior = priors)
mod_pre
my_pp_check(mod_pre, c(0, 25), adj = 2.5, title = "**Posterior predictive check:** Pre-merge")
ggsave("../survivoR-Bucket/images/blog/confessionals-and-tribal/pp-check-pre.png", height = 5, width = 9)

new_data <- tibble(
  tribal_council = c(0, 1, 0, 0, 0),
  reward = c(0, 0, 1, 0, 0),
  found_adv = c(0, 0, 0, 1, 0),
  n_cast = c(18, 18, 18, 18, 17)
)

epred <- posterior_epred(mod_pre, newdata = new_data)-1

# intercept
quantile(epred[,1], c(0.5, 0.025, 0.975))

# tribal
quantile(epred[,2]-epred[,1], c(0.5, 0.025, 0.975))

# won reward
quantile(epred[,3]-epred[,1], c(0.5, 0.025, 0.975))

# Found adv
quantile(epred[,4]-epred[,1], c(0.5, 0.025, 0.975))

# n cast
quantile(epred[,5]-epred[,1], c(0.5, 0.025, 0.975))

# pred data for plot
df_base <- as_draws_df(mod_pre) |>
  as_tibble() |>
  select(starts_with("b")) |>
  set_names(c("Intercept", "Attended\ntribal council", "Won reward", "Found an\nadvantage", "Number of\nplayers")) |>
  pivot_longer(everything(), names_to = "beta", values_to = "draw") |>
  mutate(beta = fct_reorder(beta, draw, mean)) |>
  filter(beta != "No reward\nchallenge")

# 🔠 text -----------------------------------------------------------------

caption <- "1. Confessional count mean estimated by comparing an individual that did not attend tribal,
find an advantage, or win a reward when there are 18 players in the game."

df_lab <- df_base |>
  group_by(beta) |>
  summarise(
    median = round(median(draw), 2),
    l95 = round(quantile(draw, 0.025), 2),
    u95 = round(quantile(draw, 0.975), 2),
    x = max(draw)
  ) |>
  bind_cols(
    tibble(
      lab = c(
        "If the castaway wins the tribal reward challenge there's some evidence they recieve slightly less confessionals.",
        "More players the fewer confonessionals castaways get on average.",
        "If the castaway attends tribal, on average, they receive **~1 more confessional** than those on the other tribe(s).",
        "Castaways that find advantages / hidden immunity idols tend to get, on average, **2-3 more confessionals** as they replay the events.",
        "Intercept: When there are 18 players, if the tribe wins immunity, on average, each castaway receives **~2 confessionals per hour**."
      )
    )
  ) |>
  mutate(
    lab = glue("{median} ({l95}, {u95})<br>{str_rich_wrap(lab, 45)}")
    )

# 📊 plot --------------------------------------------------------------------

df_base |>
  ggplot() +
  geom_vline(aes(xintercept = 0), colour = "darkred", linetype = 2) +
  stat_halfeye(aes(draw, beta, group = beta), fill_type = "segments", fill = accent, normalize = "xy", orientation = "horizontal", slab_alpha = 0.75) +
  geom_richtext(aes(x+0.05, beta, label = lab), df_lab, family = ft, colour = txt, size = 8, hjust = 0, lineheight = 0.35, label.colour = NA, fill = bg, vjust = 0) +
  xlim(NA, 3) +
  labs(
    title = "**Coefficients:** Pre-merge",
    x = "Coefficient size",
    caption = str_wrap(caption, 500)
  ) +
  coord_cartesian(clip = "off") +
  theme_minimal() +
  theme(
    text = element_text(family = ft, colour = txt, lineheight = 0.3, size = 32),
    plot.background = element_rect(fill = bg, colour = bg),
    plot.title = element_markdown(size = 64, family = ft, colour = txt, hjust = 0),
    axis.text.y = element_text(vjust = 0),
    axis.title.y = element_blank(),
    plot.caption = element_text(size = 16, hjust = 0)
  )

ggsave("../survivoR-Bucket/images/blog/confessionals-and-tribal/coefficients-pre.png", height = 5, width = 9)

# 💃 model (post merge) --------------------------------------------------------------

get_prior(y ~ reward + found_adv + n_cast, data = df_post_merge, family = "gamma")
prior_b0 <- prior(normal(3, 1), class = "Intercept")
prior_b1 <- prior(normal(0, 2), class = "b")
priors <- c(prior_b0, prior_b1)

mod_post <- brm(y ~ reward + chosen_for_reward + found_adv + n_cast, data = df_post_merge, family = "gamma", prior = priors)
mod_post
my_pp_check(mod_post, c(0, 50), adj = 1.8, title = "**Posterior predictive check:** Post-merge")

ggsave("../survivoR-Bucket/images/blog/confessionals-and-tribal/pp-check-post.png", height = 5, width = 9)

new_data <- tibble(
  reward = c(0, 0, 1, 0, 0),
  chosen_for_reward = c(0, 1, 0, 0, 0),
  found_adv = c(0, 0, 0, 1, 0),
  n_cast = c(8, 8, 8, 8, 7)
)

epred <- posterior_epred(mod_post, newdata = new_data)-1

# intercept
quantile(epred[,1], c(0.5, 0.025, 0.975))

# chosen reward
quantile(epred[,2]-epred[,1], c(0.5, 0.025, 0.975))

# reward
quantile(epred[,3]-epred[,1], c(0.5, 0.025, 0.975))

# Found adv
quantile(epred[,4]-epred[,1], c(0.5, 0.025, 0.975))

# n cast
quantile(epred[,5]-epred[,1], c(0.5, 0.025, 0.975))

# pred data for plot
df_base <- as_draws_df(mod_post) |>
  as_tibble() |>
  select(starts_with("b")) |>
  set_names(c("Intercept", "Won reward", "Chosen for\nreward", "Found an\nadvantage", "Number of\nplayers")) |>
  pivot_longer(everything(), names_to = "beta", values_to = "draw") |>
  mutate(beta = fct_reorder(beta, draw, mean))

# 🔠 text -----------------------------------------------------------------

caption <- "1. Confessional count mean estimated by comparing an individual that did not win the reward challenge, was not
chosen for the reward, and did not find an advantage when there are 8 players in the game."

df_lab <- df_base |>
  group_by(beta) |>
  summarise(
    median = round(median(draw), 2),
    l95 = round(quantile(draw, 0.025), 2),
    u95 = round(quantile(draw, 0.975), 2),
    x = max(draw)
  ) |>
  bind_cols(
    tibble(
      lab = c(
        "More players the fewer confonessionals castaways get on average.",
        "If the castaway is chosen to participate in the reward there is no difference in the confessionals they recieve.",
        "If the castaway wins the reward challenge, on average, they receive **~1 more confessional**.",
        "Castaways that find advantages / hidden immunity idols tend to get, on average, **3-6 more confessionals** as they replay the events.",
        "Intercept: When there are 8 players and if the player doesn't win reward, get chosen for reward or found an advantage, on average, each castaway receives **4-5 confessionals per hour**."
      )
    )
  ) |>
  mutate(lab = glue("{median} ({l95}, {u95})<br>{str_rich_wrap(lab, 45)}"))

# 📊 plot --------------------------------------------------------------------

df_base |>
  ggplot() +
  geom_vline(aes(xintercept = 0), colour = "darkred", linetype = 2) +
  stat_halfeye(aes(draw, beta, group = beta), fill = accent, fill_type = "segments", normalize = "xy", orientation = "horizontal", slab_alpha = 0.75) +
  geom_richtext(aes(x+0.05, beta, label = lab), df_lab, family = ft, colour = txt, size = 8, hjust = 0, lineheight = 0.35, label.colour = NA, fill = bg, vjust = 0) +
  xlim(NA, 3.7) +
  labs(
    title = "**Coefficients:** Post-merge",
    x = "Coefficient size",
    caption = str_wrap(caption, 500)
  ) +
  coord_cartesian(clip = "off") +
  theme_minimal() +
  theme(
    text = element_text(family = ft, colour = txt, lineheight = 0.3, size = 32),
    plot.title = element_markdown(size = 64, family = ft, colour = txt, hjust = 0),
    plot.background = element_rect(fill = bg, colour = bg),
    axis.text.y = element_text(vjust = 0),
    axis.title.y = element_blank(),
    plot.caption = element_text(size = 16, hjust = 0)
  )

ggsave("../survivoR-Bucket/images/blog/confessionals-and-tribal/coefficients-post.png", height = 5, width = 9)

# 📍 adjust 44 ---------------------------------------------------------------

df_44 <- df_tribe |>
  ungroup() |>
  filter(season == 44) |>
  mutate(stage = ifelse(str_detect(tribe_status, "Orig|Swap"), "Pre-merge", "Post-merge"))

# predictions
pred_44_pre <- apply(posterior_epred(mod_pre, newdata = filter(df_44, stage == "Pre-merge"))-1, 2, median)
pred_44_post <- apply(posterior_epred(mod_post, newdata = filter(df_44, stage == "Post-merge"))-1, 2, median)

# data frame
df_res <- df_44 |>
  add_castaway() |>
  select(episode, castaway_id, castaway, n_confs, y, n_cast, found_adv, tribal_council, episode_length) |>
  mutate(y_hat = c(pred_44_pre, pred_44_post)) |>
  group_by(episode) |>
  mutate(
    wt = sum(y)/sum(y_hat),
    mean_confs = mean(n_confs),
    y_hat_scaled = y_hat*wt,
    y_res = y - y_hat_scaled,
    y_hat_ep_len = y_hat/60*episode_length,
    y_res_ep_len = n_confs - y_hat_ep_len
  ) |>
  group_by(castaway) |>
  summarise(
    n_confs = sum(n_confs),
    mean_confs = sum(mean_confs),
    y = sum(y),
    y_hat_scaled = sum(y_hat_scaled),
    y_hat_ep_len = sum(y_hat_ep_len),
    y_res_ep_len = sum(y_res_ep_len)
  ) |>
  mutate(
    y_res = y - y_hat_scaled,
    index_confs = n_confs/mean_confs-1,
    index_res = n_confs/y_hat_ep_len-1,
    castaway = fct_reorder(castaway, y_res_ep_len),
    y_text = ifelse(y_res_ep_len > 0, -1, 1),
    y_num = ifelse(y_res_ep_len > 0, y_res_ep_len+3, y_res_ep_len-4),
    hjust = ifelse(y_res_ep_len > 0, 1, 0),
    y_lab = ifelse(y_res_ep_len > 0, paste0("+", round(y_res_ep_len)), round(y_res_ep_len)),
    nudge_y = ifelse(y_res_ep_len > 0, 1, 0),
    pct = paste0(round(index_res, 2)*100, "%")
    )

# bar chart
df_res |>
  ggplot() +
  geom_chicklet(aes(castaway, y_res_ep_len, fill = y_res_ep_len), width = 0.8, colour = txt, size = 0.2) +
  geom_text(aes(castaway, y = y_text, label = castaway), family = ft, colour = txt, size = 12, hjust = df_res$hjust, fontface = "italic") +
  geom_text(aes(castaway, y = y_num, label = y_lab), family = ft, colour = txt, size = 8, hjust = df_res$hjust, nudge_x = 0.2) +
  geom_text(aes(castaway, y = y_num+nudge_y, label = pct), family = ft, colour = txt, size = 8, hjust = df_res$hjust, nudge_x = -0.2) +
  scale_fill_gradient2(low = prgr_div[1], mid = "grey90", high = prgr_div[12]) +
  coord_flip() +
  theme_void() +
  theme(
    text = element_text(family = ft, colour = txt, lineheight = 0.3, size = 32),
    plot.title = element_markdown(size = 64, family = ft, colour = txt, hjust = 0),
    plot.background = element_rect(fill = bg, colour = bg),
    axis.title.y = element_blank(),
    plot.caption = element_text(size = 16, hjust = 0),
    legend.position = "none",
    plot.margin = margin(t = 50, b = 5, l = 5, r = 5)
  )

ggsave("../survivoR-Bucket/images/blog/confessionals-and-tribal/y-res.png", height = 6, width = 4)

# table
df_res |>
  arrange(desc(y_res_ep_len)) |>
  transmute(
    Castaway = castaway,
    `Confessionals` = n_confs,
    `Residual\n(difference from expected)` = round(y_res_ep_len),
    `Percentage\ndifference` = pct
    ) |>
  gt() |>
  gt_theme_espn() |>
  cols_width(everything() ~ px(110)) |>
  cols_align(align = "center") |>
  gtsave("../survivoR-Bucket/images/blog/confessionals-and-tribal/y-res-tbl.png")


# comparison table
df_comp <- df_res |>
  mutate(castaway = fct_reorder(castaway, index_res)) |>
  pivot_longer(
    c(index_res, index_confs),
    names_to = "measure",
    values_to = "index"
  )

df_res |>
  arrange(desc(y_res_ep_len)) |>
  transmute(
    Castaway = castaway,
    `Confessionals` = n_confs,
    `Expected (equal distribution)` = round(mean_confs),
    `Expected (adjusted)` = round(y_hat_ep_len),
    `Index (equal distribution)` = paste0(round(index_confs, 2)*100, "%"),
    `Index (adjusted)` = paste0(round(index_res, 2)*100, "%")
  ) |>
  gt() |>
  gt_theme_espn() |>
  cols_width(everything() ~ px(110)) |>
  cols_align(align = "center") |>
  gtsave("../survivoR-Bucket/images/blog/confessionals-and-tribal/y-res-comp-tbl.png")
