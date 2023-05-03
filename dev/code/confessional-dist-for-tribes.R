library(tidyverse)

df_tribal_council <- survivoR::vote_history |>
  filter(
    version == "US",
    str_detect(tribe_status, "Orig|Swap")
  ) |>
  distinct(season, episode, tribe) |>
  mutate(tribal_council = "Yes")

df_length <- survivoR::viewers |>
  ungroup() |>
  filter(version == "US") |>
  distinct(season, episode, episode_length)

df_confs <- survivoR::confessionals |>
  filter(version == "US") |>
  add_tribe() |>
  group_by(season, episode, tribe) |>
  summarise(
    n_confs = sum(confessional_count),
    n_cast = n_distinct(castaway_id),
    .groups = "drop"
  )

df_tribe <- survivoR::tribe_mapping |>
  filter(
    version == "US",
    str_detect(tribe_status, "Orig|Swap")
  ) |>
  distinct(season, episode, tribe) |>
  left_join(df_confs, by = c("season", "episode", "tribe")) |>
  left_join(df_length, by = c("season", "episode")) |>
  left_join(df_tribal_council, by = c("season", "episode", "tribe")) |>
  group_by(season, episode) |>
  mutate(
    tribal_council = replace_na(tribal_council, "No"),
    theta = (n_confs/n_cast)/episode_length*60,
    p = n_confs/sum(n_confs)
  ) |>
  filter(p > 0)
