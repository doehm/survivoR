library(tidyverse)
library(dirmult)

.after <- 0

# data
df <- survivoR::auction_details |>
  filter(
    version == "US",
    auction_num == 1
  ) |>
  distinct(version_season, item, item_description, category, covered) |>
  group_by(version_season) |>
  summarise(
    n_items = n(),
    n_covered = sum(covered),
    n_bad = sum(category == "Bad item"),
    pos_first_bad = cumsum(covered)[which(category == "Bad item")[1]]
  ) |>
  left_join(
    survivoR::survivor_auction |>
      count(version_season, name = "n_cast"),
    by = "version_season"
  ) |>
  mutate(pos_first_bad = replace_na(pos_first_bad, 99)) |>
  filter(pos_first_bad > .after & n_covered > .after)

# number of castaways
df_n_cast <- df |>
  count(n_cast)

# number of items
df_n_items <- df |>
  count(n_items)

# number of covered items
df_n_covered <- df |>
  count(n_covered)

# number of bad items
df_bad <- df |>
  count(n_bad) |>
  mutate(p = n/sum(n))

# position of first bad
# need to add on
df_pos_first_bad <- df |>
  filter(pos_first_bad < 99) |>
  drop_na() |>
  count(n_covered, pos_first_bad) |>
  group_by(n_covered) |>
  mutate(p = n/sum(n)) |>
  bind_rows(
    tibble(
      n_covered = 4,
      pos_first_bad = .after, # change this to min
      n = 0
    )
  )

# simulation
n_covered <- table(df$n_covered)
n_bad <- table(df$n_bad)

# vector of freqs for position simulation
n_pos_obs <- map((.after+1):5, ~{
  i <- df_pos_first_bad |>
    filter(n_covered == .x) |>
    pull(pos_first_bad)
  n <- df_pos_first_bad |>
    filter(n_covered == .x) |>
    pull(n)
  obs <- rep(1, .x-.after)
  obs[i-.after] <- obs[i-.after] + n
  obs
})

# number of sims
n_sims <- 40000

# draw the probabilities
# theta
p_draws_n_covered <- rdirichlet(n = n_sims, alpha = n_covered+1)

# gamma
p_draws_n_bad <- rbeta(n_sims, n_bad[1]+1, n_bad[2]+1)

# draw the values
# y_covered
draws_n_covered <- apply(p_draws_n_covered, 1, function(x) sample((.after+1):5, 1, prob = x))

# y_bad
draws_n_bad <- rbinom(n = n_sims, 1, prob = p_draws_n_bad)

# sample position
pos <- rep(0, n_sims)

# run loop
fixed_n <- FALSE
i <- 3
equal_prob <- FALSE
for(k in 1:n_sims) {
  if(draws_n_bad[k] == 1) {
    if(!fixed_n) {
      i <- draws_n_covered[k]-.after
    }

    if(equal_prob) {
      pos[k] <- sample(1:i, 1, prob = rep(1/i, i))
    } else {
      p_k <- rdirichlet(1, alpha = n_pos_obs[[i]])
      pos[k] <- sample(1:i, 1, prob = p_k)
    }
  }
}

# get the probs
table(pos)/n_sims


