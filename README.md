
<!-- README.md is generate from README.Rmd. Please edit that file -->

<img src='https://cranlogs.r-pkg.org/badges/survivoR'/>
<img src='https://www.r-pkg.org/badges/version/survivoR'/>

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

# News

survivoR 0.9.5

-   Added season 41 episodes 1 to 9
-   Added new `confessionals` data set
-   Bug fixes / data cleaning
    -   The castaway names are consistent across data sets
    -   Tribe mapping is updated filling in missing tribe status and
        Bobby Jon
    -   Incorrect records from vote history removed.

# Season 41

For episode by episode updates [follow me](https://twitter.com/danoehm)
on twitter.

<a href='https://gradientdescending.com/survivor/s41e09-graphic.png'><img src='https://gradientdescending.com/survivor/s41e09-graphic.png' align = 'center'/></a>
<a href='https://gradientdescending.com/survivor/s41e09-table.png'><img src='https://gradientdescending.com/survivor/s41e09-table.png' align = 'center'/></a>

# Dataset overview

## Season summary

A table containing summary details of each season of Survivor, including
the winner, runner ups and location. Note this is a nested data frame
given there may be 1 or 2 runner ups. The grain is maintained to 1 row
per season.

``` r
season_summary
#> # A tibble: 41 x 20
#>    season_name  season location  country tribe_setup  full_name winner_id winner
#>    <chr>         <dbl> <chr>     <chr>   <chr>        <chr>         <dbl> <chr> 
#>  1 Survivor: 41     41 Mamanuca~ Fiji    "Three trib~ <NA>             NA <NA>  
#>  2 Survivor: W~     40 Mamanuca~ Fiji    "Two tribes~ Tony Vla~       424 Tony  
#>  3 Survivor: I~     39 Mamanuca~ Fiji    "Two tribes~ Tommy Sh~       590 Tommy 
#>  4 Survivor: E~     38 Mamanuca~ Fiji    "Two tribes~ Chris Un~       559 Chris 
#>  5 Survivor: D~     37 Mamanuca~ Fiji    "Two tribes~ Nick Wil~       556 Nick  
#>  6 Survivor: G~     36 Mamanuca~ Fiji    "Two tribes~ Wendell ~       536 Wende~
#>  7 Survivor: H~     35 Mamanuca~ Fiji    "Three trib~ Ben Drie~       516 Ben   
#>  8 Survivor: G~     34 Mamanuca~ Fiji    "Two tribes~ Sarah La~       414 Sarah 
#>  9 Survivor: M~     33 Mamanuca~ Fiji    "Two tribes~ Adam Kle~       498 Adam  
#> 10 Survivor: K~     32 Koh Rong~ Cambod~ "Three trib~ Michele ~       478 Miche~
#> # ... with 31 more rows, and 12 more variables: runner_ups <chr>,
#> #   final_vote <chr>, timeslot <chr>, premiered <dttm>, ended <dttm>,
#> #   filming_started <dttm>, filming_ended <dttm>, viewers_premier <dbl>,
#> #   viewers_finale <dbl>, viewers_reunion <dbl>, viewers_mean <dbl>, rank <dbl>
```

``` r
season_summary |>
  select(season, viewers_premier, viewers_finale, viewers_reunion, viewers_mean) |>
  pivot_longer(cols = -season, names_to = "episode", values_to = "viewers") |>
  mutate(
    episode = to_title_case(str_replace(episode, "viewers_", ""))) |>
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
castaways |> 
  filter(season == 40)
#> # A tibble: 22 x 20
#>    season_name     season full_name    castaway_id castaway   age city   state  
#>    <chr>            <dbl> <chr>              <dbl> <chr>    <dbl> <chr>  <chr>  
#>  1 Survivor: Winn~     40 Natalie And~         442 Natalie     33 Edgew~ New Je~
#>  2 Survivor: Winn~     40 Amber Maria~          27 Amber       40 Pensa~ Florida
#>  3 Survivor: Winn~     40 Danni Boatw~         166 Danni       43 Shawn~ Kansas 
#>  4 Survivor: Winn~     40 Ethan Zohn            48 Ethan       45 Hills~ New Ha~
#>  5 Survivor: Winn~     40 Tyson Apost~         274 Tyson       39 Mesa   Arizona
#>  6 Survivor: Winn~     40 Rob Mariano           55 Boston ~    43 Pensa~ Florida
#>  7 Survivor: Winn~     40 Parvati Sha~         197 Parvati     36 Los A~ Califo~
#>  8 Survivor: Winn~     40 Sandra Diaz~         112 Sandra      44 River~ Florida
#>  9 Survivor: Winn~     40 Yul Kwon             202 Yul         44 Los A~ Califo~
#> 10 Survivor: Winn~     40 Wendell Hol~         536 Wendell     35 Phila~ Pennsy~
#> # ... with 12 more rows, and 12 more variables: personality_type <chr>,
#> #   episode <dbl>, day <dbl>, order <chr>, result <chr>, jury_status <chr>,
#> #   original_tribe <chr>, swapped_tribe <chr>, swapped_tribe_2 <chr>,
#> #   merged_tribe <chr>, total_votes_received <dbl>, immunity_idols_won <dbl>
```

## Vote history

This data frame contains a complete history of votes cast across all
seasons of Survivor. This allows you to see who who voted for who at
which Tribal Council. It also includes details on who had individual
immunity as well as who had their votes nullified by a hidden immunity
idol. This details the key events for the season.

``` r
vh <- vote_history |> 
  filter(
    season == 40,
    episode == 10
  ) 
vh
#> # A tibble: 11 x 15
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
#> # ... with 7 more variables: nullified <lgl>, voted_out <chr>, order <dbl>,
#> #   vote_order <dbl>, castaway_id <dbl>, vote_id <dbl>, voted_out_id <dbl>
```

``` r
vh |> 
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
vh |> 
  clean_votes() |> 
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
challenges |> 
  filter(season == 40)
#> # A tibble: 28 x 8
#>    season_name   season episode   day challenge_type challenge_name outcome_type
#>    <chr>          <dbl>   <dbl> <dbl> <chr>          <lgl>          <chr>       
#>  1 Survivor: Wi~     40       1     2 immunity       NA             tribal      
#>  2 Survivor: Wi~     40       1     3 immunity       NA             tribal      
#>  3 Survivor: Wi~     40       1     2 reward         NA             tribal      
#>  4 Survivor: Wi~     40       2     6 immunity       NA             tribal      
#>  5 Survivor: Wi~     40       2     6 reward         NA             tribal      
#>  6 Survivor: Wi~     40       3     9 immunity       NA             tribal      
#>  7 Survivor: Wi~     40       3     9 reward         NA             tribal      
#>  8 Survivor: Wi~     40       4    11 immunity       NA             tribal      
#>  9 Survivor: Wi~     40       4    11 reward         NA             tribal      
#> 10 Survivor: Wi~     40       5    14 immunity       NA             tribal      
#> # ... with 18 more rows, and 1 more variable: winners <list>
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
jury_votes |> 
  filter(season == 40)
#> # A tibble: 48 x 7
#>    season_name            season castaway finalist  vote castaway_id finalist_id
#>    <chr>                   <dbl> <chr>    <chr>    <dbl>       <dbl>       <dbl>
#>  1 Survivor: Winners at ~     40 Adam     Michele      0         498         478
#>  2 Survivor: Winners at ~     40 Adam     Natalie      0         498         442
#>  3 Survivor: Winners at ~     40 Adam     Tony         1         498         424
#>  4 Survivor: Winners at ~     40 Amber    Michele      0          27         478
#>  5 Survivor: Winners at ~     40 Amber    Natalie      0          27         442
#>  6 Survivor: Winners at ~     40 Amber    Tony         1          27         424
#>  7 Survivor: Winners at ~     40 Ben      Michele      0         516         478
#>  8 Survivor: Winners at ~     40 Ben      Natalie      0         516         442
#>  9 Survivor: Winners at ~     40 Ben      Tony         1         516         424
#> 10 Survivor: Winners at ~     40 Danni    Michele      0         166         478
#> # ... with 38 more rows
```

``` r
jury_votes |> 
  filter(season == 40) |> 
  group_by(finalist) |> 
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
hidden_idols |> 
  filter(season == 40)
#> # A tibble: 10 x 10
#>    season_name              season castaway_id castaway idol_number idols_held
#>    <chr>                     <dbl>       <dbl> <chr>    <chr>            <dbl>
#>  1 Survivor: Winners at War     40         112 Sandra   1                    1
#>  2 Survivor: Winners at War     40         386 Denise   1                    1
#>  3 Survivor: Winners at War     40         371 Kim      1                    1
#>  4 Survivor: Winners at War     40         353 Sophie   1                    1
#>  5 Survivor: Winners at War     40         386 Denise   2                    1
#>  6 Survivor: Winners at War     40         478 Michele  1                    1
#>  7 Survivor: Winners at War     40         424 Tony     1                    1
#>  8 Survivor: Winners at War     40         516 Ben      1                    1
#>  9 Survivor: Winners at War     40         442 Natalie  1                    1
#> 10 Survivor: Winners at War     40         442 Natalie  2                    1
#> # ... with 4 more variables: votes_nullified <chr>, day_found <dbl>,
#> #   day_played <dbl>, legacy_advantage <lgl>
```

## Confessionals

A dataset containing the number of confessionals for each castaway by
season and episode.

``` r
confessionals |> 
  filter(season == 40) |> 
  group_by(castaway) |> 
  summarise(n_confessionals = sum(confessional_count))
#> # A tibble: 20 x 2
#>    castaway   n_confessionals
#>    <chr>                <dbl>
#>  1 Adam                    36
#>  2 Amber                   21
#>  3 Ben                     32
#>  4 Boston Rob              28
#>  5 Danni                   14
#>  6 Denise                  20
#>  7 Ethan                   19
#>  8 Jeremy                  31
#>  9 Kim                     19
#> 10 Michele                 33
#> 11 Natalie                 58
#> 12 Nick                    27
#> 13 Parvati                 25
#> 14 Sandra                  18
#> 15 Sarah                   35
#> 16 Sophie                  19
#> 17 Tony                    59
#> 18 Tyson                   56
#> 19 Wendell                 13
#> 20 Yul                     17
```

## Viewers

A data frame containing the viewer information for every episode across
all seasons. It also includes the rating and viewer share information
for viewers aged 18 to 49 years of age.

``` r
viewers |> 
  filter(season == 40)
#> # A tibble: 14 x 9
#>    season_name season episode_number_~ episode episode_title episode_date       
#>    <chr>        <dbl>            <dbl>   <dbl> <chr>         <dttm>             
#>  1 Survivor: ~     40              583       1 Greatest of ~ 2020-02-12 00:00:00
#>  2 Survivor: ~     40              584       2 It's Like a ~ 2020-02-19 00:00:00
#>  3 Survivor: ~     40              585       3 Out for Blood 2020-02-26 00:00:00
#>  4 Survivor: ~     40              586       4 I Like Reven~ 2020-03-04 00:00:00
#>  5 Survivor: ~     40              587       5 The Buddy Sy~ 2020-03-11 00:00:00
#>  6 Survivor: ~     40              588       6 Quick on the~ 2020-03-18 00:00:00
#>  7 Survivor: ~     40              589       7 We're in the~ 2020-03-25 00:00:00
#>  8 Survivor: ~     40              590       8 This is Wher~ 2020-04-01 00:00:00
#>  9 Survivor: ~     40              591       9 War is Not P~ 2020-04-08 00:00:00
#> 10 Survivor: ~     40              592      10 The Full Cir~ 2020-04-15 00:00:00
#> 11 Survivor: ~     40              593      11 This is Exto~ 2020-04-22 00:00:00
#> 12 Survivor: ~     40              594      12 Friendly Fire 2020-04-29 00:00:00
#> 13 Survivor: ~     40              595      13 The Penultim~ 2020-05-06 00:00:00
#> 14 Survivor: ~     40              596      14 It All Boils~ 2020-05-13 00:00:00
#> # ... with 3 more variables: viewers <dbl>, rating_18_49 <dbl>,
#> #   share_18_49 <dbl>
```

## Tribe colours

This data frame contains the tribe names and colours for each season,
including the RGB values. These colours can be joined with the other
data frames to customise colours for plots. Another option is to add
tribal colours to ggplots with the scale functions.

``` r
tribe_colours
#> # A tibble: 145 x 5
#>    season_name                      season tribe      tribe_colour tribe_status
#>    <chr>                             <dbl> <chr>      <chr>        <chr>       
#>  1 Survivor: Borneo                      1 Pagong     #FFFF05      original    
#>  2 Survivor: Borneo                      1 Rattana    #7CFC00      merged      
#>  3 Survivor: Borneo                      1 Tagi       #FF9900      original    
#>  4 Survivor: The Australian Outback      2 Barramundi #FF6600      merged      
#>  5 Survivor: The Australian Outback      2 Kucha      #32CCFF      original    
#>  6 Survivor: The Australian Outback      2 Ogakor     #A7FC00      original    
#>  7 Survivor: Africa                      3 Boran      #FFD700      original    
#>  8 Survivor: Africa                      3 Moto Maji  #00A693      merged      
#>  9 Survivor: Africa                      3 Samburu    #E41A2A      original    
#> 10 Survivor: Marquesas                   4 Maraamu    #DFFF00      original    
#> # ... with 135 more rows
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
castaways |> 
  count(season, personality_type) |> 
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
labels <- castaways |>
  filter(
    season == ssn,
    str_detect(result, "Sole|unner")
  ) |>
  mutate(label = glue("{castaway} ({original_tribe})")) |>
  select(label, castaway)

jury_votes |>
  filter(season == ssn) |>
  left_join(
    castaways |>
      filter(season == ssn) |>
      select(castaway, original_tribe),
    by = "castaway"
  ) |>
  group_by(finalist, original_tribe) |>
  summarise(votes = sum(vote)) |>
  left_join(labels, by = c("finalist" = "castaway")) |>
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
-   **Holt Skinner** for creating the castaway ID to map people across
    seasons and manage name changes.
-   **Carly Levitz** for providing data corrections across all data
    sets.

# References

Data was almost entirely sourced from
[Wikipedia](https://en.wikipedia.org/wiki/Survivor_(American_TV_series)).
Other data, such as the tribe colours, was manually recorded and entered
by myself and contributors.

Torch graphic in hex: [Fire Torch Vectors by
Vecteezy](https://www.vecteezy.com/free-vector/fire-torch)
