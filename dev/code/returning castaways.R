library(tidyverse)
library(ggtext)
library(survivoR)
library(glue)
library(showtext)

# fonts and palettes ------------------------------------------------------

good_pal <<- c("#ffffff", "#f2fbd2", "#c9ecb4", "#93d3ab", "#35b0ab")

sysfonts::font_add_google("Josefin Sans", "jose")
sysfonts::font_add(family = "survivor", regular = "survivor-2/Survivor Font.ttf")
showtext_auto()

# data --------------------------------------------------------------------

# returning cast
df_returning <- survivoR::castaways |>
  distinct(season_name, season, castaway_id) |>
  group_by(castaway_id) |>
  filter(n() > 1) |>
  mutate(first_season = min(season))

# all new seasons
all_new <- survivoR::castaways |>
  distinct(season, castaway_id) |>
  count(season) |>
  left_join(
    survivoR::castaways |>
      distinct(season, castaway_id) |>
      group_by(castaway_id) |>
      slice_min(season) |>
      ungroup() |>
      count(season),
    by = "season"
  ) |>
  mutate(n.y = replace_na(n.y, 0)) |>
  mutate(all_new = n.x == n.y) |>
  filter(all_new) |>
  left_join(
    df_returning |>
      distinct(first_season, n_returned = n),
    by = c("season" = "first_season")
  ) |>
  ungroup()

# season name labels
df_labels <- survivoR::season_summary |>
  left_join(all_new, by = "season") |>
  mutate(
    all_new = replace_na(all_new, FALSE),
    season_name = str_remove(season_name, "Survivor: "),
    season_name_1 = glue("<span style='color:{ifelse(all_new, good_pal[4], '#ffffff')};'>{season_name}</span>"),
    first_season = season,
    n = 0
  ) |>
  arrange(season)

# set plot grid
df_grid <- tibble(
  x = 1:41,
  y = 1,
  yend = 1:41,
  first_season = 1,
  n = 0
)

# legend data frame
df_legend <- tribble(
  ~x, ~y, ~n, ~first_season,
  1, 30, 3, 0,
  4, 30, 2, 0
)

# final data
df <- df_returning |>
  count(first_season, season) |>
  bind_rows(
    tibble(
      season = c(26, 38, 39, 41),
      first_season = c(26, 38, 39, 41),
      n = 0
    )
  ) |>
  arrange(first_season, season) |>
  left_join(all_new, by = "season") |>
  mutate(text_colour = ifelse(n >= 6, "grey70", "black"))

# subtitle
subtitle <- glue(
  "103 castaways have returned to play in future seasons.<br>
  On average 4 castaways return for future season from<br>
  <span style='color:{good_pal[4]};'>seasons of all new castaways</span>. This is where they went.")


# plot --------------------------------------------------------------------

df |>

  # main plot
  ggplot(aes(season, first_season, group = first_season, colour = n)) +
  geom_segment(aes(x = x, xend = x, y = y, yend = yend), df_grid, colour = "white", alpha = 0.1) +
  geom_line() +
  geom_point(aes(x, yend), df_grid, size = 8.5, pch = 1, colour = "white") +
  geom_point(size = 8) +
  geom_text(aes(label = n), family = "jose", size = 18, colour = df$text_colour, fontface = "bold") +

  # season name text
  geom_richtext(aes(season-0.5, season + 0.5, label = season_name_1), df_labels, family = "jose", size = 16, hjust = 1, vjust = 0.25, fontface = "bold", label.colour = NA, fill = NA) +

  # titles
  annotate("text", x = -4, y = 41, label = "RETURNING CASTAWAYS", family = "survivor", size = 64, hjust = 0, colour = "white") +
  annotate("richtext", x = -4, y = 40, label = subtitle, family = "jose", size = 20, hjust = 0, colour = "white", lineheight = 0.25, vjust = 1, label.colour = NA, fill = NA) +

  # legend ---
  # legend diagram
  geom_point(aes(x, y, colour = n), df_legend, size = 8) +
  geom_line(aes(x, y, colour = n), df_legend) +
  geom_text(aes(x, y, label = n), df_legend, family = "jose", size = 18, colour = "black", fontface = "bold") +
  annotate("point", x = 1, y = 30, pch = 1, size = 8.5, colour = "white") +
  annotate("point", x = 4, y = 33, pch = 1, size = 8, colour = "white") +
  annotate("segment", x = 4, xend = 4, y = 30, yend = 33, colour = "white", alpha = 0.1) +
  annotate("text", x = 0.3, y = 30.5, label = "Season A", family = "jose", size = 16, colour = "white", fontface = "bold", hjust = 1) +
  annotate("text", x = 3.3, y = 33.5, label = "Season B", family = "jose", size = 16, colour = "white", fontface = "bold", hjust = 1) +

  # legend text and arrows
  annotate("text", x = -4, y = 27, label = str_wrap("Total number of castaways from season A (their first season) that returned to play in future seasons", 18), family = "jose", size = 16, colour = "white", hjust = 0, lineheight = 0.25, vjust = 1) +
  annotate("text", x = 6, y = 27, label = str_wrap("Number of castaways from season A that returned to play in season B", 18), family = "jose", size = 16, colour = "white", hjust = 0, lineheight = 0.25, vjust = 1) +
  annotate("text", x = 5, y = 33, label = str_wrap("A season of all returning castaways", 28), family = "jose", size = 16, colour = "white", hjust = 0, lineheight = 0.25, vjust = 0.5) +
  annotate("curve", x = -2, y = 27.2, xend = 0.3, yend = 29.9, arrow = arrow(length = unit(0.01, "npc"), type = "closed"), colour = "white", curvature = -0.5) +
  annotate("curve", x = 8, y = 27.2, xend = 4.7, yend = 29.9, arrow = arrow(length = unit(0.01, "npc"), type = "closed"), colour = "white", curvature = 0.5) +
  # legend --- end

  # scales and themes
  scale_colour_survivor(35, scale_type = "c") +
  xlim(c(-5, 41)) +
  ylim(c(1, 42)) +
  labs(caption = "Graphic: @danoehm / Data: github doehm/survivoR #rstats") +
  coord_cartesian(clip = "off") +
  theme_void() +
  theme(
    text = element_text(family = "jose", size = 12, colour = "white"),
    plot.background = element_rect(fill = "#181510"),
    plot.caption = element_text(size = 32, margin = margin(t = 5, b = 10)),
    plot.margin = margin(l = 20, r = 20, t = 20, b = 0),
    strip.text = element_text(size = 96, family = "survivor", lineheight = 0.2),
    strip.background = element_rect(colour = "white", fill = NA),
    legend.title = element_text(size = 48, lineheight = 0.25),
    legend.text = element_text(size = 48, lineheight = 0.25),
    legend.position = "none"
  ) +
  ggsave("images/random/returning.png", height = 14, width = 14.5)
