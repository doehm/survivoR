
<!-- README.md is generate from README.Rmd. Please edit that file -->

# survivoR <img src='dev/images/hex-torch.png' align="right" height="240" />

596 episodes. 40 seasons. 1 package!

survivoR is a collection of data sets detailing events across all 40
seasons of the US Survivor, including castaway information, vote
history, immunity and reward challenge winners and jury votes.

# Installation

Now on CRAN.

``` r
install.packages("survivoR")
```

Or install from Git for the latest.

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
#> # A tibble: 40 x 19
#>    season_name  season location  country tribe_setup full_name winner runner_ups
#>    <chr>         <int> <chr>     <chr>   <chr>       <glue>    <chr>  <chr>     
#>  1 Survivor: B~      1 Pulau Ti~ Malays~ Two tribes~ Richard ~ Richa~ Kelly Wig~
#>  2 Survivor: T~      2 Herbert ~ Austra~ Two tribes~ Tina Wes~ Tina   Colby Don~
#>  3 Survivor: A~      3 Shaba Na~ Kenya   Two tribes~ Ethan Zo~ Ethan  Kim Johns~
#>  4 Survivor: M~      4 Nuku Hiv~ Polyne~ Two tribes~ Vecepia ~ Vecep~ Neleh Den~
#>  5 Survivor: T~      5 Ko Tarut~ Thaila~ Two tribes~ Brian He~ Brian  Clay Jord~
#>  6 Survivor: T~      6 Rio Negr~ Brazil  Two tribes~ Jenna Mo~ Jenna  Matthew V~
#>  7 Survivor: P~      7 Pearl Is~ Panama  Two tribes~ Sandra D~ Sandra Lillian M~
#>  8 Survivor: A~      8 Pearl Is~ Panama  Three trib~ Amber Br~ Amber  Rob Maria~
#>  9 Survivor: V~      9 Efate, S~ Vanuatu Two tribes~ Chris Da~ Chris  Twila Tan~
#> 10 Survivor: P~     10 Koror, P~ Palau   A schoolya~ Tom West~ Tom    Katie Gal~
#> # ... with 30 more rows, and 11 more variables: final_vote <chr>,
#> #   timeslot <chr>, premiered <date>, ended <date>, filming_started <date>,
#> #   filming_ended <date>, viewers_premier <dbl>, viewers_finale <dbl>,
#> #   viewers_reunion <dbl>, viewers_mean <dbl>, rank <dbl>
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
  scale_colour_tribes(16) +
  labs(
    title = "Survivor viewers over the 40 seasons",
    x = "Season",
    y = "Viewers (Millions)",
    colour = "Episode"
  )
```

<img src='dev/images/viewers.png' align="center"/>

## Castaways

Season and demographic information about each castaway. Within a season
the data is ordered by the first voted out, to sole survivor indicated
by <code>order</code>. When demographic information is missing, it
likely means that the castaway re-entered the game at a later stage by
winning the opportunity to return. Also meaning the castaway will
feature in the data twice for the season. Castaways that have played in
multiple seasons will feature more than once with the age and location
representing that point in time.

``` r
castaways %>% 
  filter(season == 40)
#> # A tibble: 22 x 18
#>    season_name   season full_name   castaway   age city  state  personality_type
#>    <chr>          <dbl> <chr>       <chr>    <dbl> <chr> <chr>  <chr>           
#>  1 Survivor: Wi~     40 Natalie An~ Natalie     33 Edge~ New J~ ESTP            
#>  2 Survivor: Wi~     40 Amber Mari~ Amber       40 Pens~ Flori~ ISFP            
#>  3 Survivor: Wi~     40 Danni Boat~ Danni       43 Shaw~ Kansas ENFJ            
#>  4 Survivor: Wi~     40 Ethan Zohn  Ethan       45 Hill~ New H~ ISFP            
#>  5 Survivor: Wi~     40 Tyson Apos~ Tyson       39 Mesa  Arizo~ ESTP            
#>  6 Survivor: Wi~     40 Rob Mariano Rob         43 Pens~ Flori~ ESTJ            
#>  7 Survivor: Wi~     40 Parvati Sh~ Parvati     36 Los ~ Calif~ ENFJ            
#>  8 Survivor: Wi~     40 Sandra Dia~ Sandra      44 Rive~ Flori~ ESTP            
#>  9 Survivor: Wi~     40 Yul Kwon    Yul         44 Los ~ Calif~ INTJ            
#> 10 Survivor: Wi~     40 Wendell Ho~ Wendell     35 Phil~ Penns~ INFJ            
#> # ... with 12 more rows, and 10 more variables: day <dbl>, order <int>,
#> #   result <chr>, jury_status <chr>, original_tribe <chr>, swapped_tribe <chr>,
#> #   swapped_tribe2 <chr>, merged_tribe <chr>, total_votes_received <dbl>,
#> #   immunity_idols_won <dbl>
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
#>    season_name        season episode   day tribe_status castaway immunity  vote 
#>    <chr>               <dbl>   <dbl> <dbl> <chr>        <chr>    <chr>     <chr>
#>  1 Survivor: Winners~     40      10    25 merged       Ben      <NA>      Tyson
#>  2 Survivor: Winners~     40      10    25 merged       Denise   hidden    None 
#>  3 Survivor: Winners~     40      10    25 merged       Jeremy   <NA>      Immu~
#>  4 Survivor: Winners~     40      10    25 merged       Kim      <NA>      Soph~
#>  5 Survivor: Winners~     40      10    25 merged       Michele  <NA>      Tyson
#>  6 Survivor: Winners~     40      10    25 merged       Nick     <NA>      Tyson
#>  7 Survivor: Winners~     40      10    25 merged       Sarah    <NA>      Deni~
#>  8 Survivor: Winners~     40      10    25 merged       Sarah    <NA>      Tyson
#>  9 Survivor: Winners~     40      10    25 merged       Sophie   <NA>      Deni~
#> 10 Survivor: Winners~     40      10    25 merged       Tony     individu~ Tyson
#> 11 Survivor: Winners~     40      10    25 merged       Tyson    <NA>      Soph~
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
<code>vote</code> field. I have included a function
<code>clean\_votes</code> for when only need the votes cast for
individuals. If the input data frame has the <code>vote</code> column it
can simply be piped.

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

## Challenges

A nested tidy data frame of immunity and reward challenge results. The
winners and winning tribe of the challenge are found by expanding the
`winners` column. For individual immunity challenges the winning tribe
is simply `NA`.

``` r
challenges %>% 
  filter(season == 40)
#> # A tibble: 28 x 7
#>    season_name      season episode title          day challenge_type winners    
#>    <chr>             <dbl>   <dbl> <chr>        <dbl> <chr>          <list>     
#>  1 Survivor: Winne~     40       1 Greatest of~     2 reward         <tibble[,2~
#>  2 Survivor: Winne~     40       1 Greatest of~     2 immunity       <tibble[,2~
#>  3 Survivor: Winne~     40       1 Greatest of~     3 immunity       <tibble[,2~
#>  4 Survivor: Winne~     40       2 It's Like a~     6 reward         <tibble[,2~
#>  5 Survivor: Winne~     40       2 It's Like a~     6 immunity       <tibble[,2~
#>  6 Survivor: Winne~     40       3 Out for Blo~     9 reward         <tibble[,2~
#>  7 Survivor: Winne~     40       3 Out for Blo~     9 immunity       <tibble[,2~
#>  8 Survivor: Winne~     40       4 I Like Reve~    11 reward         <tibble[,2~
#>  9 Survivor: Winne~     40       4 I Like Reve~    11 immunity       <tibble[,2~
#> 10 Survivor: Winne~     40       5 The Buddy S~    14 immunity       <tibble[,2~
#> # ... with 18 more rows
```

Typically in the merge if a single person win a reward they are allowed
to bring others along with them. The first castaway in the expanded list
is likely to be the winner and the subsequent players those they brought
along with them. Although, not always. Occasionally in the merge the
castaways are split into two teams for the purpose of the reward, in
which case all castaways win the reward rather than a single person.

The `day` field on this data set represents the day of the tribal
council rather than the day of the challenge. This is to more easily
associate the reward challenge with the immunity challenge and result of
the tribal council. It also helps for joining tables.

Note the challenges table is the combined immunity and rewards tables
which will eventually be dropped in later releases.

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
#> # A tibble: 3 x 2
#>   finalist votes
#>   <chr>    <dbl>
#> 1 Michele      0
#> 2 Natalie      4
#> 3 Tony        12
```

## Hidden Idols

A dataset containing the history of hidden immunity idols including who
found them, on what day and which day they were played. The idol number
increments for each idol the castaway finds during the game.

``` r
hidden_idols %>% 
  filter(season == 40)
#> # A tibble: 10 x 9
#>    season_name  season castaway idol_number idols_held votes_nullified day_found
#>    <chr>         <dbl> <chr>    <chr>            <dbl> <chr>               <dbl>
#>  1 Survivor: W~     40 Sandra ~ 1                    1 <NA>                    3
#>  2 Survivor: W~     40 Denise ~ 1                    1 0                       4
#>  3 Survivor: W~     40 Kim Spr~ 1                    1 2                       4
#>  4 Survivor: W~     40 Sophie ~ 1                    1 <NA>                   12
#>  5 Survivor: W~     40 Denise ~ 2                    1 4                      16
#>  6 Survivor: W~     40 Michele~ 1                    1 2                      22
#>  7 Survivor: W~     40 Tony Vl~ 1                    1 0                      28
#>  8 Survivor: W~     40 Ben Dri~ 1                    1 2                      29
#>  9 Survivor: W~     40 Natalie~ 1                    1 4                      35
#> 10 Survivor: W~     40 Natalie~ 2                    1 0                      37
#> # ... with 2 more variables: day_played <dbl>, legacy_advantage <lgl>
```

## Viewers

A data frame containing the viewer information for every episode across
all sesasons. It also includes the rating and viewer share information
for viewers aged 18 to 49 years of age.

``` r
viewers %>% 
  filter(season == 40)
#> # A tibble: 14 x 9
#>    season_name    season episode_number_~ episode title     episode_date viewers
#>    <chr>           <dbl>            <dbl>   <dbl> <chr>     <date>         <dbl>
#>  1 Survivor: Win~     40              583       1 Greatest~ 2020-02-12      6.68
#>  2 Survivor: Win~     40              584       2 It's Lik~ 2020-02-19      7.16
#>  3 Survivor: Win~     40              585       3 Out for ~ 2020-02-26      7.14
#>  4 Survivor: Win~     40              586       4 I Like R~ 2020-03-04      7.08
#>  5 Survivor: Win~     40              587       5 The Budd~ 2020-03-11      6.91
#>  6 Survivor: Win~     40              588       6 Quick on~ 2020-03-18      7.83
#>  7 Survivor: Win~     40              589       7 We're in~ 2020-03-25      8.18
#>  8 Survivor: Win~     40              590       8 This is ~ 2020-04-01      8.23
#>  9 Survivor: Win~     40              591       9 War is N~ 2020-04-08      7.85
#> 10 Survivor: Win~     40              592      10 The Full~ 2020-04-15      8.14
#> 11 Survivor: Win~     40              593      11 This is ~ 2020-04-22      8.16
#> 12 Survivor: Win~     40              594      12 Friendly~ 2020-04-29      8.08
#> 13 Survivor: Win~     40              595      13 The Penu~ 2020-05-06      7.57
#> 14 Survivor: Win~     40              596      14 It All B~ 2020-05-13      7.94
#> # ... with 2 more variables: rating_18_49 <dbl>, share_18_49 <dbl>
```

## Tribe colours

This data frame contains the tribe names and colours for each season,
including the RGB values. These colours can be joined with the other
data frames to customise colours for plots. Another option is to add
tribal colours to ggplots with the scale functions.

``` r
tribe_colours
#> # A tibble: 139 x 5
#> # Groups:   season, tribe [139]
#>    season_name                   season tribe    tribe_colour tribe_status
#>    <chr>                          <dbl> <chr>    <chr>        <chr>       
#>  1 Survivor: Winners at War          40 Koru     #000000      merged      
#>  2 Survivor: Winners at War          40 Dakal    #D80E0E      original    
#>  3 Survivor: Winners at War          40 Sele     #0067D6      original    
#>  4 Survivor: Winners at War          40 Yara     #049451      swapped     
#>  5 Survivor: Island of the Idols     39 Lumuwaku #304ED2      merged      
#>  6 Survivor: Island of the Idols     39 Lairo    #F39442      original    
#>  7 Survivor: Island of the Idols     39 Vokai    #D99CD3      original    
#>  8 Survivor: Edge of Extinction      38 Vata     #D32323      merged      
#>  9 Survivor: Edge of Extinction      38 Kama     #FACF22      original    
#> 10 Survivor: Edge of Extinction      38 Manu     #1050BA      original    
#> # ... with 129 more rows
```

<img src='dev/images/tribe-colours.png' align="center"/>

# Scale functions

Included are ggplot2 scale functions of the form
<code>scale\_fill\_survivor()</code> and
<code>scale\_fill\_tribes()</code> to add season and tribe colours to
ggplot. The <code>scale\_fill\_survivor()</code> scales uses a colour
palette extracted from the season logo and
<code>scale\_fill\_tribes()</code> scales uses the tribal colours of the
specified season as a colour palette.

All that is required for the ‘survivor’ palettes is the desired season
as input. If not season is provided it will default to season 40.

<img src='dev/images/season-40-logo.png' align="center"/>

``` r
castaways %>% 
  count(season, personality_type) %>% 
  ggplot(aes(x = season, y = n, fill = personality_type)) +
  geom_bar(stat = "identity") +
  scale_fill_survivor(40) +
  theme_minimal()
```

<img src='dev/images/survivor-pal-example.png' align="center"/>

Below are the palettes for all seasons.

<img src='dev/images/palettes1.png' align="center"/>

<img src='dev/images/palettes2.png' align="center"/>

To use the tribe scales, simply input the season number desired to use
those tribe colours. If the fill or colour aesthetic is the tribe name,
this needs to be passed to the scale function as
<code>scale\_fill\_tribes(season, tribe = tribe)</code> (for now) where
<code>tribe</code> is on the input data frame. If the fill or colour
aesthetic is independent from the actual tribe names, like gender for
example, <code>tribe</code> does not need to be specified and will
simply use the tribe colours as a colour palette, such as the viewers
line graph above.

``` r
ssn <- 35
labels <- castaways %>%
  filter(
    season == ssn,
    str_detect(result, "Sole|unner")
  ) %>%
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
  left_join(labels, by = c("finalist" = "castaway")) %>%
  {
    ggplot(., aes(x = label, y = votes, fill = original_tribe)) +
      geom_bar(stat = "identity", width = 0.5) +
      scale_fill_tribes(ssn, tribe = .$original_tribe) +
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

New features will be added, such as details on exiled castaways across
the seasons. If you have a request for specific data let me know in the
issues and I’ll see what I can do. Also, if you’d like to contribute by
adding to existing datasets or contribute a new dataset, please [contact
me directly](http://gradientdescending.com/contact/).

# Showcase

Data viz projects to showcase the data sets. This looks at the number of
immunity idols won and votes received for each winner.

<img src='dev/images/torches_png.png' align="center"/>

# Contributors

A big thank you to:

-   **Camilla Bendetti** for collating the personality type data for
    each castaway.
-   **Uygar Sozer** for adding the filming start and end dates for each
    season.

# References

Data was almost entirely sourced from
[Wikipedia](https://en.wikipedia.org/wiki/Survivor_(American_TV_series)).
Other data, such as the tribe colours, was manually recorded and entered
by myself and contributors.

Torch graphic in hex: [Fire Torch Vectors by
Vecteezy](https://www.vecteezy.com/free-vector/fire-torch)
