
<!-- README.md is generate from README.Rmd. Please edit that file -->

<img src='https://cranlogs.r-pkg.org/badges/survivoR'/><img src='https://cranlogs.r-pkg.org/badges/grand-total/survivoR'/><img src='https://www.r-pkg.org/badges/version/survivoR'/>

<!-- <img src='https://img.shields.io/github/downloads/doehm/survivoR/total.svg'/><img src='https://img.shields.io/github/downloads/doehm/survivor/total.svg'/> -->

# survivoR <img src='dev/images/hex-torch.png' align="right" height="240" />

596 episodes. 40 seasons. 1 package!

survivoR is a collection of data sets detailing events across all 40
seasons of the US Survivor, including castaway information, vote
history, immunity and reward challenge winners and jury votes.

# Installation

Now on CRAN (v0.9.6).

``` r
install.packages("survivoR")
```

Or install from Git for the latest (v1.0). I’m constantly improving the
data sets and the github version is likely to be slightly improved.

``` r
devtools::install_github("doehm/survivoR")
```

# News

survivoR 1.0

-   New challenges data sets
    -   `challenge_results`
    -   `challenge_description`
-   Gender, race and ethnicity features on `castaways`
-   Complete season 41 data

# Season 41

For episode by episode updates [follow me](https://twitter.com/danoehm)
on twitter.

<a href='https://gradientdescending.com/survivor/s41e12-graphic.png'><img src='https://gradientdescending.com/survivor/s41e12-graphic.png' align = 'center'/></a>
<a href='https://gradientdescending.com/survivor/s41e12-table.png'><img src='https://gradientdescending.com/survivor/s41e12-table.png' align = 'center'/></a>

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
#>  1 Survivor: 41     41 Mamanuca~ Fiji    "Three trib~ Eirka Ca~       597 Erika 
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
#> #   final_vote <chr>, timeslot <chr>, premiered <date>, ended <date>,
#> #   filming_started <date>, filming_ended <date>, viewers_premier <dbl>,
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

Season and demographic information about each castaway. Castaways that
have played in multiple seasons will feature more than once with the age
and location representing that point in time. Castaways that re-entered
the game will feature more than once in the same season as they
technically have more than one boot order e.g. Natalie Anderson -
Winners at War.

Each castaway has a unique `castaway_id` which links the individual
across all data sets and season. Many casaways have changed their name
from season to season, have been referred to as a different name during
the season e.g. in season 8 Survivor All-Stars there was Rob C and Rob
M. `castaway_id` links to other ID’s across the data sets such as:

-   `vote_id`
-   `voted_out_id`
-   `finalist_id`
-   `winner_id`

If no source was found to determine a castaways race and ethnicity, the
data is kept as missing rather than making an assumption.

``` r
castaways |> 
  filter(season == 40)
#> # A tibble: 22 x 23
#>    season_name       season full_name    castaway_id castaway   age gender race 
#>    <chr>              <dbl> <chr>              <dbl> <chr>    <dbl> <chr>  <chr>
#>  1 Survivor: Winner~     40 Tony Vlachos         424 Tony        45 Male   <NA> 
#>  2 Survivor: Winner~     40 Natalie And~         442 Natalie     33 Female Asian
#>  3 Survivor: Winner~     40 Michele Fit~         478 Michele     29 Female <NA> 
#>  4 Survivor: Winner~     40 Sarah Lacina         414 Sarah       34 Female <NA> 
#>  5 Survivor: Winner~     40 Ben Drieber~         516 Ben         36 Male   <NA> 
#>  6 Survivor: Winner~     40 Denise Stap~         386 Denise      48 Female <NA> 
#>  7 Survivor: Winner~     40 Nick Wilson          556 Nick        28 Male   <NA> 
#>  8 Survivor: Winner~     40 Jeremy Coll~         433 Jeremy      41 Male   Black
#>  9 Survivor: Winner~     40 Kim Spradli~         371 Kim         36 Female <NA> 
#> 10 Survivor: Winner~     40 Sophie Clar~         353 Sophie      29 Female <NA> 
#> # ... with 12 more rows, and 15 more variables: ethnicity <chr>, city <chr>,
#> #   state <chr>, personality_type <chr>, episode <dbl>, day <dbl>, order <dbl>,
#> #   result <chr>, jury_status <chr>, original_tribe <chr>, swapped_tribe <chr>,
#> #   swapped_tribe_2 <chr>, merged_tribe <chr>, total_votes_received <dbl>,
#> #   immunity_idols_won <dbl>
```

For consistent names across all seasons, you can use the following to
create a unique name / ID combo

``` r
castaways |> 
    distinct(castaway_id, full_name, season) |> 
  group_by(castaway_id) |>  
  slice_max(season) |> 
  select(castaway_id, full_name) |> 
  left_join(
    castaways |> 
    distinct(castaway_id, castaway) |> 
    group_by(castaway_id) |> 
    mutate(name_length = str_length(castaway)) |> 
    slice_max(name_length, with_ties = FALSE) |> 
    select(-name_length),
    by = "castaway_id"
  )
#> # A tibble: 608 x 3
#> # Groups:   castaway_id [608]
#>    castaway_id full_name         castaway
#>          <dbl> <chr>             <chr>   
#>  1           1 Sonja Christopher Sonja   
#>  2           2 B.B. Anderson     B.B.    
#>  3           3 Stacey Stillman   Stacey  
#>  4           4 Ramona Gray       Ramona  
#>  5           5 Dirk Been         Dirk    
#>  6           6 Joel Klug         Joel    
#>  7           7 Gretchen Cordy    Gretchen
#>  8           8 Greg Buis         Greg    
#>  9           9 Jenna Lewis       Jenna L.
#> 10          10 Gervase Peterson  Gervase 
#> # ... with 598 more rows
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
#>  1 Survivor: Winners~     40      10    25 Merged       Ben      <NA>      Tyson
#>  2 Survivor: Winners~     40      10    25 Merged       Denise   Hidden    None 
#>  3 Survivor: Winners~     40      10    25 Merged       Jeremy   <NA>      Immu~
#>  4 Survivor: Winners~     40      10    25 Merged       Kim      <NA>      Soph~
#>  5 Survivor: Winners~     40      10    25 Merged       Michele  <NA>      Tyson
#>  6 Survivor: Winners~     40      10    25 Merged       Nick     <NA>      Tyson
#>  7 Survivor: Winners~     40      10    25 Merged       Sarah    <NA>      Deni~
#>  8 Survivor: Winners~     40      10    25 Merged       Sarah    <NA>      Tyson
#>  9 Survivor: Winners~     40      10    25 Merged       Sophie   <NA>      Deni~
#> 10 Survivor: Winners~     40      10    25 Merged       Tony     Individu~ Tyson
#> 11 Survivor: Winners~     40      10    25 Merged       Tyson    <NA>      Soph~
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

The `challenge_results` and `challenge_description` data sets supersede
the `challenges` data set.

### Challenge results

A nested tidy data frame of immunity and reward challenge results. The
winners and winning tribe of the challenge are found by expanding the
`winners` column. For individual immunity challenges the winning tribe
is simply `NA`.

``` r
challenge_results |> 
  filter(season == 40)
#> # A tibble: 26 x 12
#>    season_name  season episode   day episode_title challenge_name challenge_type
#>    <chr>         <dbl>   <dbl> <dbl> <chr>         <chr>          <chr>         
#>  1 Survivor: W~     40       1     2 Greatest of ~ By Any Means ~ Reward and Im~
#>  2 Survivor: W~     40       1     3 Greatest of ~ Blue Lagoon B~ Immunity      
#>  3 Survivor: W~     40       2     6 It's Like a ~ Draggin' the ~ Reward and Im~
#>  4 Survivor: W~     40       3     9 Out for Blood Rise and Shine Reward and Im~
#>  5 Survivor: W~     40       4    11 I Like Reven~ Beyond the Wh~ Reward and Im~
#>  6 Survivor: W~     40       5    14 The Buddy Sy~ Sea Crates     Immunity      
#>  7 Survivor: W~     40       6    16 Quick on the~ Rice Race      Reward and Im~
#>  8 Survivor: W~     40       7    18 We're in the~ Dear Liza      Immunity      
#>  9 Survivor: W~     40       7    18 We're in the~ Losing Face    Reward        
#> 10 Survivor: W~     40       8    21 This is Wher~ Get a Grip     Immunity      
#> # ... with 16 more rows, and 5 more variables: outcome_type <chr>,
#> #   outcome_status <chr>, challenge_id <chr>, challenge_id_1 <chr>,
#> #   winners <list>
```

Typically in the merge if a single person win a reward they are allowed
to bring others along with them. This is identified by `outcome_status`
column. If it states `Chosen to particpate` it means they were chosen by
the winner to particpate in the reward.

The `day` field on this data set represents the day of the tribal
council rather than the day of the challenge. This is to more easily
associate the reward challenge with the immunity challenge and result of
the tribal council. It also helps for joining tables.

The `challenge_id` is the primary key for the `challenge_description`
data set. The `challange_id` will change as the data or descriptions
change.

### Challenge description

This data set contains descriptive binary fields for each challenge.
Challenges can go by different names but where possible recurring
challenges are kept consistent. While there are tweaks to the
challenges, where the main components of the challenge consistent they
share the same name.

The features of each challenge have been determined largely through
string searches of key words that describe the challenge. It may not
capture the full essence of the challenge but on the whole will provide
a good basis for analysis. Since the description is simply a short
paragraph or sentence it may not flag all appropriate features. If any
descriptive features need altering please let me know in the
[issues](https://github.com/doehm/survivoR/issues).

Features:

-   `puzzle`: If the challenge contains a puzzle element.
-   `race`: If the challenge is a race between tribes, teams or
    individuals.
-   `precision`: If the challenge contains a precision element
    e.g. shooting an arrow, hitting a target, etc.
-   `endurance`: If the challenge is an endurance event e.g. last tribe,
    team, individual standing.
-   `strength`: If the challenge is largerly strength based
    e.g. Shoulder the Load.
-   `turn_based`: If the challenge is conducted in a series of rounds
    until a certain amount of points are scored or there is one player
    remaining.
-   `balance`: If the challenge contains a balancing element.
-   `food`: If the challenge contains a food element e.g. the food
    challenge, biting off chunks of meat.
-   `knowledge`: If the challenge contains a knowledge component e.g. Q
    and A about the location.
-   `memory`: If the challenge contains a memory element e.g. memorising
    a sequence of items.
-   `fire`: If the challenge contains an element of fire making /
    maintaining.
-   `water`: If the challenge is held, in part, in the water.

``` r
challenge_description
#> # A tibble: 892 x 14
#>    challenge_id challenge_name    puzzle race  precision endurance strength
#>    <chr>        <chr>             <lgl>  <lgl> <lgl>     <lgl>     <lgl>   
#>  1 CH0001       Quest for Fire    FALSE  TRUE  FALSE     FALSE     FALSE   
#>  2 CH0002       Bridging the Gap  FALSE  TRUE  FALSE     FALSE     FALSE   
#>  3 CH0003       Trail Blazer      FALSE  TRUE  FALSE     FALSE     FALSE   
#>  4 CH0004       Buggin' Out       FALSE  FALSE FALSE     FALSE     FALSE   
#>  5 CH0005       Tucker'd Out      FALSE  TRUE  TRUE      FALSE     FALSE   
#>  6 CH0006       Safari Supper     FALSE  TRUE  FALSE     FALSE     FALSE   
#>  7 CH0007       Marquesan Menu    FALSE  FALSE FALSE     FALSE     FALSE   
#>  8 CH0008       Thai Menu         FALSE  FALSE FALSE     TRUE      FALSE   
#>  9 CH0009       Amazon Menu       FALSE  TRUE  FALSE     FALSE     FALSE   
#> 10 CH0010       Survivor Smoothie FALSE  FALSE FALSE     FALSE     FALSE   
#> # ... with 882 more rows, and 7 more variables: turn_based <lgl>,
#> #   balance <lgl>, food <lgl>, knowledge <lgl>, memory <lgl>, fire <lgl>,
#> #   water <lgl>

challenge_description |> 
  summarise_if(is_logical, sum)
#> # A tibble: 1 x 12
#>   puzzle  race precision endurance strength turn_based balance  food knowledge
#>    <int> <int>     <int>     <int>    <int>      <int>   <int> <int>     <int>
#> 1    240   725       182       120       49        132     144    36        55
#> # ... with 3 more variables: memory <int>, fire <int>, water <int>
```

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
#>  2 Survivor: Winners at ~     40 Amber    Michele      0          27         478
#>  3 Survivor: Winners at ~     40 Ben      Michele      0         516         478
#>  4 Survivor: Winners at ~     40 Danni    Michele      0         166         478
#>  5 Survivor: Winners at ~     40 Denise   Michele      0         386         478
#>  6 Survivor: Winners at ~     40 Ethan    Michele      0          48         478
#>  7 Survivor: Winners at ~     40 Jeremy   Michele      0         433         478
#>  8 Survivor: Winners at ~     40 Kim      Michele      0         371         478
#>  9 Survivor: Winners at ~     40 Nick     Michele      0         556         478
#> 10 Survivor: Winners at ~     40 Parvati  Michele      0         197         478
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
#>  1 Adam                    37
#>  2 Amber                   21
#>  3 Ben                     30
#>  4 Boston Rob              28
#>  5 Danni                   14
#>  6 Denise                  18
#>  7 Ethan                   19
#>  8 Jeremy                  32
#>  9 Kim                     19
#> 10 Michele                 25
#> 11 Natalie                 24
#> 12 Nick                    21
#> 13 Parvati                 25
#> 14 Sandra                  16
#> 15 Sarah                   31
#> 16 Sophie                  20
#> 17 Tony                    52
#> 18 Tyson                   26
#> 19 Wendell                 12
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
#>    season_name    season episode_number_o~ episode episode_title    episode_date
#>    <chr>           <dbl>             <dbl>   <dbl> <chr>            <date>      
#>  1 Survivor: Win~     40               583       1 Greatest of the~ 2020-02-12  
#>  2 Survivor: Win~     40               584       2 It's Like a Sur~ 2020-02-19  
#>  3 Survivor: Win~     40               585       3 Out for Blood    2020-02-26  
#>  4 Survivor: Win~     40               586       4 I Like Revenge   2020-03-04  
#>  5 Survivor: Win~     40               587       5 The Buddy Syste~ 2020-03-11  
#>  6 Survivor: Win~     40               588       6 Quick on the Dr~ 2020-03-18  
#>  7 Survivor: Win~     40               589       7 We're in the Ma~ 2020-03-25  
#>  8 Survivor: Win~     40               590       8 This is Where t~ 2020-04-01  
#>  9 Survivor: Win~     40               591       9 War is Not Pret~ 2020-04-08  
#> 10 Survivor: Win~     40               592      10 The Full Circle  2020-04-15  
#> 11 Survivor: Win~     40               593      11 This is Extorti~ 2020-04-22  
#> 12 Survivor: Win~     40               594      12 Friendly Fire    2020-04-29  
#> 13 Survivor: Win~     40               595      13 The Penultimate~ 2020-05-06  
#> 14 Survivor: Win~     40               596      14 It All Boils Do~ 2020-05-13  
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
right. Before logging an issue please install the git version to see if
it has already been corrected. If not, please log an issue and I will
correct the datasets.

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
-   **Carly Levitz** for providing
    -   Data corrections across all data sets.
    -   Gender, race and ethnicity data.

# References

Data was almost entirely sourced from
[Wikipedia](https://en.wikipedia.org/wiki/Survivor_(American_TV_series)).
Other data, such as the tribe colours, was manually recorded and entered
by myself and contributors.

Torch graphic in hex: [Fire Torch Vectors by
Vecteezy](https://www.vecteezy.com/free-vector/fire-torch)
