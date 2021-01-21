
<!-- README.md is generate from README.Rmd. Please edit that file -->

# survivoR <img src='man/dev/images/hex-torch.png' align="right" height="240" />

596 episodes. 40 seasons. 1 package\!

survivoR is a collection of data sets detailing events across all 40
seasons of the US Survivor, including castaway information, vote
history, immunity and reward challenge winners and jury votes.

# Installation

``` r
devtools::install_github("doehm/survivoR")
```

CRAN: TBA - releasing it into the wild before pushing it to V1.0 and
onto CRAN

# Dataset overview

## Season summary

A table containing summary details of each season of Survivor, including
the winner, runner ups and location. Note this is a nested data frame
given there may be 1 or 2 runner ups. The grain is maintained to 1 row
per season.

``` r
season_summary
#> # A tibble: 40 x 17
#>    season_name season location country tribe_setup full_name winner runner_ups
#>    <chr>        <int> <chr>    <chr>   <chr>       <glue>    <chr>  <list>    
#>  1 Survivor: ~      1 Pulau T~ Malays~ Two tribes~ Richard ~ Richa~ <tibble [~
#>  2 Survivor: ~      2 Herbert~ Austra~ Two tribes~ Tina Wes~ Tina   <tibble [~
#>  3 Survivor: ~      3 Shaba N~ Kenya   Two tribes~ Ethan Zo~ Ethan  <tibble [~
#>  4 Survivor: ~      4 Nuku Hi~ Polyne~ Two tribes~ Vecepia ~ Vecep~ <tibble [~
#>  5 Survivor: ~      5 Ko Taru~ Thaila~ Two tribes~ Brian He~ Brian  <tibble [~
#>  6 Survivor: ~      6 Rio Neg~ Brazil  Two tribes~ Jenna Mo~ Jenna  <tibble [~
#>  7 Survivor: ~      7 Pearl I~ Panama  Two tribes~ Sandra D~ Sandra <tibble [~
#>  8 Survivor: ~      8 Pearl I~ Panama  Three trib~ Amber Br~ Amber  <tibble [~
#>  9 Survivor: ~      9 Efate, ~ Vanuatu Two tribes~ Chris Da~ Chris  <tibble [~
#> 10 Survivor: ~     10 Koror, ~ Palau   A schoolya~ Tom West~ Tom    <tibble [~
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

<img src='man/dev/images/viewers.png' align="center"/>

## Castaways

Season and demographic information about each castaway. Within a season
the data is ordered by the first voted out, to sole survivor indicated
by . When demographic information is missing, it likely means that the
castaway re-entered the game at a later stage by winning the opportunity
to return. Also meaning the castaway will feature in the data twice for
the season. Castaways that have played in multiple seasons will feature
more than once with the age and location representing that point in
time.

``` r
castaways %>% 
  filter(season == 40)
#> # A tibble: 22 x 15
#>    season_name season full_name castaway age   city  state   day order result
#>    <chr>        <dbl> <chr>     <chr>    <chr> <chr> <chr> <dbl> <int> <chr> 
#>  1 Survivor: ~     40 Natalie ~ Natalie  <NA>  <NA>  <NA>      2     1 1st v~
#>  2 Survivor: ~     40 Amber Ma~ Amber    40    Pens~ Flor~     3     2 2nd v~
#>  3 Survivor: ~     40 Danni Bo~ Danni    43    Shaw~ Kans~     6     3 3rd v~
#>  4 Survivor: ~     40 Ethan Zo~ Ethan    45    Hill~ New ~     9     4 4th v~
#>  5 Survivor: ~     40 Tyson Ap~ Tyson    <NA>  <NA>  <NA>     11     5 5th v~
#>  6 Survivor: ~     40 Rob Mari~ Rob      43    Pens~ Flor~    14     6 6th v~
#>  7 Survivor: ~     40 Parvati ~ Parvati  36    Los ~ Cali~    16     7 7th v~
#>  8 Survivor: ~     40 Sandra D~ Sandra   44    Rive~ Flor~    16     8 8th v~
#>  9 Survivor: ~     40 Yul Kwon  Yul      44    Los ~ Cali~    18     9 9th v~
#> 10 Survivor: ~     40 Wendell ~ Wendell  35    Phil~ Penn~    21    10 10th ~
#> # ... with 12 more rows, and 5 more variables: jury_status <chr>,
#> #   original_tribe <chr>, merged_tribe <chr>, swapped_tribe <chr>,
#> #   swapped_tribe2 <chr>
```

## Vote history

This data frame contains a complete history of votes cast across all
seasons of Survivor. This allows you to see who who voted for who at
which Tribal Council. It also includes details on who had individual
immunity as well as who had their votes nullified by a hidden immunity
idol. This details the key events for the season.

``` r
vh <- vote_history %>% 
  filter(
    season == 40,
    episode == 10
  ) 
vh
#> # A tibble: 11 x 12
#>    season_name season episode   day tribe_status castaway immunity vote 
#>    <chr>        <dbl>   <dbl> <dbl> <chr>        <chr>    <chr>    <chr>
#>  1 Survivor: ~     40      10    25 merged       Ben      <NA>     Tyson
#>  2 Survivor: ~     40      10    25 merged       Denise   hidden   None 
#>  3 Survivor: ~     40      10    25 merged       Jeremy   <NA>     Immu~
#>  4 Survivor: ~     40      10    25 merged       Kim      <NA>     Soph~
#>  5 Survivor: ~     40      10    25 merged       Michele  <NA>     Tyson
#>  6 Survivor: ~     40      10    25 merged       Nick     <NA>     Tyson
#>  7 Survivor: ~     40      10    25 merged       Sarah    <NA>     Deni~
#>  8 Survivor: ~     40      10    25 merged       Sarah    <NA>     Tyson
#>  9 Survivor: ~     40      10    25 merged       Sophie   <NA>     Deni~
#> 10 Survivor: ~     40      10    25 merged       Tony     individ~ Tyson
#> 11 Survivor: ~     40      10    25 merged       Tyson    <NA>     Soph~
#> # ... with 4 more variables: nullified <lgl>, voted_out <chr>, order <dbl>,
#> #   vote_order <dbl>
```

``` r
vh %>% 
  count(vote)
#> # A tibble: 5 x 2
#>   vote       n
#>   <chr>  <int>
#> 1 Denise     2
#> 2 Immune     1
#> 3 None       1
#> 4 Sophie     2
#> 5 Tyson      5
```

Events in the game such as fire challenges, rock draws, steal-a-vote
advantages or countbacks in the early days often mean a vote wasn’t
placed for an individual. Rather a challenge may be won, lost, no vote
cast but attended Tribal Council, etc. These events are recorded in the 
field. I have included a function  for when only need the votes cast for
individuals. If the input data frame has the  column it can simply be
piped.

``` r
vh %>% 
  clean_votes() %>% 
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
Tribal Council. There may be multiple people or tribes that win immunity
which can be determined by expanding the data set. There may be
duplicates for the rare event when there are multiple eliminations after
a single immunity challenged.

``` r
immunity %>% 
  filter(season == 40) %>% 
  unnest(immunity)
#> # A tibble: 23 x 8
#>    season_name       season episode title           day immunity voted_out order
#>    <chr>              <dbl>   <dbl> <chr>         <dbl> <chr>    <chr>     <int>
#>  1 Survivor: Winner~     40       1 Greatest of ~     2 Dakal    Natalie       1
#>  2 Survivor: Winner~     40       1 Greatest of ~     3 Sele     Amber         2
#>  3 Survivor: Winner~     40       2 It's Like a ~     6 Dakal    Danni         3
#>  4 Survivor: Winner~     40       3 Out for Blood     9 Dakal    Ethan         4
#>  5 Survivor: Winner~     40       4 I Like Reven~    11 Sele     Tyson         5
#>  6 Survivor: Winner~     40       5 The Buddy Sy~    14 Sele     Rob           6
#>  7 Survivor: Winner~     40       5 The Buddy Sy~    14 Dakal    Rob           6
#>  8 Survivor: Winner~     40       6 Quick on the~    16 Yara     Parvati       7
#>  9 Survivor: Winner~     40       6 Quick on the~    16 Yara     Sandra        8
#> 10 Survivor: Winner~     40       7 We're in the~    18 Yara     Yul           9
#> # ... with 13 more rows
```

## Rewards

A nested data frame of reward challenge results. Typically in the merge,
if a single person win a reward they are allowed to bring others along
with them. The first castaway in the expanded list is likely to be the
winner and the subsequent players those they brought along with them.
Although, not always. Occasionally in the merge the castaways are split
into two teams for the purpose of the reward, in which case all
castaways win the reward rather than a single person.

``` r
rewards %>% 
  filter(season == 40) %>% 
  select(-day) %>% 
  unnest(reward)
#> # A tibble: 29 x 5
#>    season_name              season episode title                          reward
#>    <chr>                     <dbl>   <dbl> <chr>                          <chr> 
#>  1 Survivor: Winners at War     40       1 Greatest of the Greats         Dakal 
#>  2 Survivor: Winners at War     40       1 Greatest of the Greats         <NA>  
#>  3 Survivor: Winners at War     40       2 It's Like a Survivor Economy   Dakal 
#>  4 Survivor: Winners at War     40       3 Out for Blood                  Dakal 
#>  5 Survivor: Winners at War     40       4 I Like Revenge                 Sele  
#>  6 Survivor: Winners at War     40       5 The Buddy System on Steroids   <NA>  
#>  7 Survivor: Winners at War     40       6 Quick on the Draw              Yara  
#>  8 Survivor: Winners at War     40       7 We're in the Majors            Yara  
#>  9 Survivor: Winners at War     40       7 We're in the Majors            Sele  
#> 10 Survivor: Winners at War     40       8 This is Where the Battle Begi~ Tyson 
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

## Viewers

A data frame containing the viewer information for every episode across
all sesasons. It also includes the rating and viewer share information
for viewers aged 18 to 49 years of age.

``` r
viewers %>% 
  filter(season == 40)
#> # A tibble: 14 x 9
#>    season_name season episode_number_~ episode title episode_date viewers
#>    <chr>        <dbl>            <dbl>   <dbl> <chr> <date>         <dbl>
#>  1 Survivor: ~     40              583       1 Grea~ 2020-02-12      6.68
#>  2 Survivor: ~     40              584       2 It's~ 2020-02-19      7.16
#>  3 Survivor: ~     40              585       3 Out ~ 2020-02-26      7.14
#>  4 Survivor: ~     40              586       4 I Li~ 2020-03-04      7.08
#>  5 Survivor: ~     40              587       5 The ~ 2020-03-11      6.91
#>  6 Survivor: ~     40              588       6 Quic~ 2020-03-18      7.83
#>  7 Survivor: ~     40              589       7 We'r~ 2020-03-25      8.18
#>  8 Survivor: ~     40              590       8 This~ 2020-04-01      8.23
#>  9 Survivor: ~     40              591       9 War ~ 2020-04-08      7.85
#> 10 Survivor: ~     40              592      10 The ~ 2020-04-15      8.14
#> 11 Survivor: ~     40              593      11 This~ 2020-04-22      8.16
#> 12 Survivor: ~     40              594      12 Frie~ 2020-04-29      8.08
#> 13 Survivor: ~     40              595      13 The ~ 2020-05-06      7.57
#> 14 Survivor: ~     40              596      14 It A~ 2020-05-13      7.94
#> # ... with 2 more variables: rating_18_49 <dbl>, share_18_49 <dbl>
```

## Tribe colours

This data frame contains the tribe names and colours for each season,
including the RGB values. These colours can be joined with the other
data frames to customise colours for plots. Another option is to add
tribal colours to ggplots with the scale functions.

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

<img src='man/dev/images/tribe_colours.png' align="center"/>

# Scale functions

Included are ggplot2 scale functions (of the form
<code>scale\_\*\_survivor()</code>) to add tribe colours to ggplot.
Simply input the season number desired to use those tribe colours. If
the fill or colour aesthetic is the tribe name, this needs to be passed
to the scale function as <code>scale\_fill\_survivor(…, tribe =
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
  select(castaway, original_tribe) %>% 
  mutate(label = glue("{castaway} ({original_tribe})")) %>% 
  select(label, castaway)
jury_votes %>% 
  filter(season == ssn) %>% 
  left_join(
    castaways %>% 
      filter(season == ssn) %>% 
      select(castaway, original_tribe),
    by = "castaway"
    ) %>% 
  group_by(finalist, original_tribe) %>% 
  summarise(votes = sum(vote)) %>% 
  left_join(labels, by = c("finalist" = "castaway")) %>% {
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

<img src='man/dev/images/votes.png' align="center"/>

# Issues

Given the variable nature of the game of Survivor and changing of the
rules, there are bound to be edges cases where the data is not quite
right. Please log an issue and I will correct the datasets.

New features will be added, such as details on exiled castaways across
the seasons. If you have a request for specific data let me know in the
issues and I’ll see what I can do. Also, if you’d like to contribute by
adding to existing datasets or contribute a new dataset, please [contact
me directly](http://gradientdescending.com/contact/).

# References

Data was almost entirely sourced from
[Wikipedia](https://en.wikipedia.org/wiki/Survivor_\(American_TV_series\)).
Other data, such as the tribe colours, was manually recorded and entered
by myself.

Torch graphic in hex: [Fire Torch Vectors by
Vecteezy](https://www.vecteezy.com/free-vector/fire-torch)
