
<!-- README.md is generate from README.Rmd. Please edit that file -->

# survivoR <img src='dev/images/hex-1.png' align="right" height="240" />

596 episodes. 40 seasons. 1 package\!

survivoR is a collection of datasets detailing events across all 40
seasons of the US Survivor, including castaway information, vote
history, immunity and reward challenge winners and jury votes.

# Installation

``` r
devtools::install_github("doehm/survivoR")
```

# Dataset overview

## Season summary

A table containing summary details of each season of Survivor, including
the winner, runner ups and location. Note this is a nested data frame
given there may be 1 or 2 runner ups. The grain is maintained to 1 row
per season.

``` r
season_summary
#> # A tibble: 40 x 17
#>    season_name season location country tribe_setup winner nickname runner_ups
#>    <chr>        <int> <chr>    <chr>   <chr>       <glue> <chr>    <list>    
#>  1 Survivor: ~      1 Pulau T~ Malays~ Two tribes~ Richa~ Richard  <tibble [~
#>  2 Survivor: ~      2 Herbert~ Austra~ Two tribes~ Tina ~ Tina     <tibble [~
#>  3 Survivor: ~      3 Shaba N~ Kenya   Two tribes~ Ethan~ Ethan    <tibble [~
#>  4 Survivor: ~      4 Nuku Hi~ Polyne~ Two tribes~ Vecep~ Vecepia  <tibble [~
#>  5 Survivor: ~      5 Ko Taru~ Thaila~ Two tribes~ Brian~ Brian    <tibble [~
#>  6 Survivor: ~      6 Rio Neg~ Brazil  Two tribes~ Jenna~ Jenna    <tibble [~
#>  7 Survivor: ~      7 Pearl I~ Panama  Two tribes~ Sandr~ Sandra   <tibble [~
#>  8 Survivor: ~      8 Pearl I~ Panama  Three trib~ Amber~ Amber    <tibble [~
#>  9 Survivor: ~      9 Efate, ~ Vanuatu Two tribes~ Chris~ Chris    <tibble [~
#> 10 Survivor: ~     10 Koror, ~ Palau   A schoolya~ Tom W~ Tom      <tibble [~
#> # ... with 30 more rows, and 9 more variables: final_vote <chr>,
#> #   timeslot <chr>, premiered <date>, ended <date>, viewers_premier <dbl>,
#> #   viewers_finale <dbl>, viewers_reunion <dbl>, viewers_mean <dbl>, rank <dbl>
```

``` r
season_summary %>%
  select(season, viewers_premier, viewers_finale, viewers_reunion, viewers_mean) %>%
  pivot_longer(cols = -season, names_to = "episode", values_to = "viewers") %>%
  mutate(
    episode = to_title_case(str_replace(episode, "viewers_", ""))
  ) %>%
  ggplot(aes(x = season, y = viewers, colour = episode)) +
  geom_line() +
  geom_point(size = 2) +
  theme_minimal() +
  scale_colour_survivor(16) +
  labs(
    title = "Survivor viewers over the 40 seasons",
    x = "Season",
    y = "Viewers (Millions)",
    colour = "Episode"
  )
```

<img src='dev/images/viewers.png' align="center"/>

## Castaways

Season and demographic information about each castaway. If demographic
information is missing, it likely means that castaway re-entered the
game at a later stage.

``` r
castaways %>% 
  filter(season == 40)
#> # A tibble: 22 x 15
#>    season_name season castaway nickname age   city  state   day order result
#>    <chr>        <dbl> <chr>    <chr>    <chr> <chr> <chr> <dbl> <int> <chr> 
#>  1 Survivor: ~     40 Natalie~ Natalie  <NA>  <NA>  <NA>      2     1 1st v~
#>  2 Survivor: ~     40 Amber M~ Amber    40    Pens~ Flor~     3     2 2nd v~
#>  3 Survivor: ~     40 Danni B~ Danni    43    Shaw~ Kans~     6     3 3rd v~
#>  4 Survivor: ~     40 Ethan Z~ Ethan    45    Hill~ New ~     9     4 4th v~
#>  5 Survivor: ~     40 Tyson A~ Tyson    <NA>  <NA>  <NA>     11     5 5th v~
#>  6 Survivor: ~     40 Rob Mar~ Rob      43    Pens~ Flor~    14     6 6th v~
#>  7 Survivor: ~     40 Parvati~ Parvati  36    Los ~ Cali~    16     7 7th v~
#>  8 Survivor: ~     40 Sandra ~ Sandra   44    Rive~ Flor~    16     8 8th v~
#>  9 Survivor: ~     40 Yul Kwon Yul      44    Los ~ Cali~    18     9 9th v~
#> 10 Survivor: ~     40 Wendell~ Wendell  35    Phil~ Penn~    21    10 10th ~
#> # ... with 12 more rows, and 5 more variables: jury_status <chr>,
#> #   original_tribe <chr>, merged_tribe <chr>, swapped_tribe <chr>,
#> #   swapped_tribe2 <chr>
```

## Vote history

Detailed data on the vote history for each tribal council. See the help
doc for more detailed description.

``` r
vh <- vote_history %>% 
  filter(
    season == 40,
    episode == 10
  )
vh
#> # A tibble: 9 x 11
#>   season_name season episode   day castaway tribe_status vote  voted_out order
#>   <chr>        <dbl>   <dbl> <dbl> <chr>    <chr>        <chr> <chr>     <int>
#> 1 Survivor: ~     40      10    25 Tony     merged       Tyson Tyson        12
#> 2 Survivor: ~     40      10    25 Michele  merged       Tyson Tyson        12
#> 3 Survivor: ~     40      10    25 Sarah    merged       Deni~ Tyson        12
#> 4 Survivor: ~     40      10    25 Sarah    merged       Tyson Tyson        12
#> 5 Survivor: ~     40      10    25 Ben      merged       Tyson Tyson        12
#> 6 Survivor: ~     40      10    25 Nick     merged       Tyson Tyson        12
#> 7 Survivor: ~     40      10    25 Kim      merged       Soph~ Tyson        12
#> 8 Survivor: ~     40      10    25 Sophie   merged       Deni~ Tyson        12
#> 9 Survivor: ~     40      10    25 Tyson    merged       Soph~ Tyson        12
#> # ... with 2 more variables: immunity <chr>, nullified <lgl>
```

``` r
vh %>% 
  count(vote)
#> # A tibble: 3 x 2
#>   vote       n
#>   <chr>  <int>
#> 1 Denise     2
#> 2 Sophie     2
#> 3 Tyson      5
```

## Immunity

A nested tidy data frame of immunity challenge results. Each row is a
tribal council. There may be multiple people or tribes that win immunity
which can be determined by expanding the data set.

``` r
immunity %>% 
  filter(season == 40) %>% 
  unnest(c(immunity))
#> # A tibble: 23 x 8
#>    season_name       season episode title         voted_out   day order immunity
#>    <chr>              <dbl>   <dbl> <chr>         <chr>     <dbl> <int> <chr>   
#>  1 Survivor: Winner~     40       1 Greatest of ~ Natalie       2     1 Dakal   
#>  2 Survivor: Winner~     40       1 Greatest of ~ Amber         3     2 Sele    
#>  3 Survivor: Winner~     40       2 It's Like a ~ Danni         6     3 Dakal   
#>  4 Survivor: Winner~     40       3 Out for Blood Ethan         9     4 Dakal   
#>  5 Survivor: Winner~     40       4 I Like Reven~ Tyson        11     5 Sele    
#>  6 Survivor: Winner~     40       5 The Buddy Sy~ Rob          14     6 Sele    
#>  7 Survivor: Winner~     40       5 The Buddy Sy~ Rob          14     6 Dakal   
#>  8 Survivor: Winner~     40       6 Quick on the~ Parvati      16     7 Yara    
#>  9 Survivor: Winner~     40       6 Quick on the~ Sandra       16     8 Yara    
#> 10 Survivor: Winner~     40       7 We're in the~ Yul          18     9 Yara    
#> # ... with 13 more rows
```

## Rewards

A nested data frame of reward challenge results. Each row is a reward
challenge. Typically in the merge, if a single person win a reward they
are allowed to bring others along with them. The first castaway in the
expanded list is likely to be the winner and the subsequent players
those they brought along with them.

``` r
rewards %>% 
  filter(season == 40) %>% 
  unnest(c(reward))
#> # A tibble: 29 x 6
#>    season_name            season episode title                        day reward
#>    <chr>                   <dbl>   <dbl> <chr>                      <dbl> <chr> 
#>  1 Survivor: Winners at ~     40       1 Greatest of the Greats         2 Dakal 
#>  2 Survivor: Winners at ~     40       1 Greatest of the Greats         3 <NA>  
#>  3 Survivor: Winners at ~     40       2 It's Like a Survivor Econ~     6 Dakal 
#>  4 Survivor: Winners at ~     40       3 Out for Blood                  9 Dakal 
#>  5 Survivor: Winners at ~     40       4 I Like Revenge                11 Sele  
#>  6 Survivor: Winners at ~     40       5 The Buddy System on Stero~    14 <NA>  
#>  7 Survivor: Winners at ~     40       6 Quick on the Draw             16 Yara  
#>  8 Survivor: Winners at ~     40       7 We're in the Majors           18 Yara  
#>  9 Survivor: Winners at ~     40       7 We're in the Majors           18 Sele  
#> 10 Survivor: Winners at ~     40       8 This is Where the Battle ~    21 Tyson 
#> # ... with 19 more rows
```

## Jury votes

History of jury votes. It is more verbose than it needs to be, however
having a 0-1 column indicating if a vote was placed or not makes it
easier to summarise castaways that received no votes.

``` r
jury_votes %>% 
  filter(season == 40)
#> # A tibble: 48 x 5
#>    season_name              season castaway finalist  vote
#>    <chr>                     <dbl> <chr>    <chr>    <dbl>
#>  1 Survivor: Winners at War     40 Sarah    Michele      0
#>  2 Survivor: Winners at War     40 Sarah    Natalie      0
#>  3 Survivor: Winners at War     40 Sarah    Tony         1
#>  4 Survivor: Winners at War     40 Ben      Michele      0
#>  5 Survivor: Winners at War     40 Ben      Natalie      0
#>  6 Survivor: Winners at War     40 Ben      Tony         1
#>  7 Survivor: Winners at War     40 Denise   Michele      0
#>  8 Survivor: Winners at War     40 Denise   Natalie      0
#>  9 Survivor: Winners at War     40 Denise   Tony         1
#> 10 Survivor: Winners at War     40 Nick     Michele      0
#> # ... with 38 more rows
```

``` r
jury_votes %>% 
  filter(season == 40) %>% 
  group_by(finalist) %>% 
  summarise(votes = sum(vote))
#> `summarise()` ungrouping output (override with `.groups` argument)
#> # A tibble: 3 x 2
#>   finalist votes
#>   <chr>    <dbl>
#> 1 Michele      0
#> 2 Natalie      4
#> 3 Tony        12
```

## Tribe colours

A data frame that contains the tribe names and colours for each season.

``` r
tribe_colours
#> # A tibble: 139 x 8
#> # Groups:   season, tribe [139]
#>    season_name         season tribe      r     g     b tribe_colour tribe_status
#>    <chr>                <dbl> <chr>  <dbl> <dbl> <dbl> <chr>        <chr>       
#>  1 Survivor: Winners ~     40 Koru       0     0     0 #000000      merged      
#>  2 Survivor: Winners ~     40 Dakal    216    14    14 #D80E0E      original    
#>  3 Survivor: Winners ~     40 Sele       0   103   214 #0067D6      original    
#>  4 Survivor: Winners ~     40 Yara       4   148    81 #049451      swapped     
#>  5 Survivor: Island o~     39 Lumuw~    48    78   210 #304ED2      merged      
#>  6 Survivor: Island o~     39 Lairo    243   148    66 #F39442      original    
#>  7 Survivor: Island o~     39 Vokai    217   156   211 #D99CD3      original    
#>  8 Survivor: Edge of ~     38 Vata     211    35    35 #D32323      merged      
#>  9 Survivor: Edge of ~     38 Kama     250   207    34 #FACF22      original    
#> 10 Survivor: Edge of ~     38 Manu      16    80   186 #1050BA      original    
#> # ... with 129 more rows
```

<img src='dev/images/tribe_colours.png' align="center"/>

# Scale functions

Included are ggplot2 scale functions (of the form
<code>scale\_\*\_survivor()</code>) to add tribe colours to ggplot.
Simply input the season number desired to use those tribe colours. If
the fill or colour aesthetic is the tribe name, this needs to be passed
to the scale function as <code>scale\_fill\_function(…, tribe =
tribe)</code> (for now) where <code>tribe</code> is on the input data
frame. If the fill or colour aesthetic is independent from the actual
tribe names, like gender for example, <code>tribe</code> does not need
to be specified and will simply use the tribe colours as a colour
palette, such as the viewers line graph above.

``` r
ssn <- 35
labels <- castaways %>% 
  filter(
    season == ssn, 
    str_detect(result, "Sole|unner")
  ) %>% 
  select(nickname, original_tribe) %>% 
  mutate(label = glue("{nickname} ({original_tribe})")) %>% 
  select(label, nickname)
jury_votes %>% 
  filter(season == ssn) %>% 
  left_join(
    castaways %>% 
      filter(season == ssn) %>% 
      select(nickname, original_tribe),
    by = c("castaway" = "nickname")
    ) %>% 
  group_by(finalist, original_tribe) %>% 
  summarise(votes = sum(vote)) %>% 
  left_join(labels, by = c("finalist" = "nickname")) %>% {
    ggplot(., aes(x = label, y = votes, fill = original_tribe)) +
    geom_bar(stat = "identity", width = 0.5) +
    scale_fill_survivor(ssn, tribe = .$original_tribe) +
    theme_minimal() +
    labs(
      x = "Finalist (original tribe)",
      y = "Votes",
      fill = "Original\ntribe",
      title = "Votes received by each finalist"
    )
  }
```

<img src='dev/images/votes.png' align="center"/>

# Issues

Given the variable nature of the game of Survivor and changing of the
rules, there are bound to be edges cases where the data is not quite
right. Please log an issue and I will correct the datasets.

# References

Data was almost entirely sourced from
[Wikipedia](https://en.wikipedia.org/wiki/Survivor_\(American_TV_series\)).
Other data, such as the tribe colours, was manually recorded and entered
by myself.
