
<!-- README.md is generate from README.Rmd. Please edit that file -->

<img src='https://cranlogs.r-pkg.org/badges/survivoR'/><img src='https://cranlogs.r-pkg.org/badges/grand-total/survivoR'/><img src='https://www.r-pkg.org/badges/version/survivoR'/>

# survivoR <img src='dev/images/hex-torch.png' align="right" height="240" />

621 episodes. 42 seasons. 1 package!

survivoR is a collection of data sets detailing events across all 41
seasons of the US Survivor, including castaway information, vote
history, immunity and reward challenge winners and jury votes.

# Installation

Now on CRAN (v0.9.12).

``` r
install.packages("survivoR")
```

Or install from Git for the latest (v0.9.14). I’m constantly improving
the data sets and the github version is likely to be slightly improved.

``` r
devtools::install_github("doehm/survivoR")
```

# News

survivoR v0.9.14

-   `split_vote` now included on `vote_history` to idenitify if there
    was an orchestrated split to flush an idol.
-   `vote_event` includes extra details such as extra vote, won (Fire
    challenge), etc
-   `tie` to indicate if the first voting round was tie rather than it
    being recorded in `voted_out`

# Australian Survivor: Blood Vs Water

For episode by episode updates [follow me](https://twitter.com/danoehm)
on
<svg aria-hidden="true" role="img" viewBox="0 0 512 512" style="height:1em;width:1em;vertical-align:-0.125em;margin-left:auto;margin-right:auto;font-size:inherit;fill:currentColor;overflow:visible;position:relative;"><path d="M459.37 151.716c.325 4.548.325 9.097.325 13.645 0 138.72-105.583 298.558-298.558 298.558-59.452 0-114.68-17.219-161.137-47.106 8.447.974 16.568 1.299 25.34 1.299 49.055 0 94.213-16.568 130.274-44.832-46.132-.975-84.792-31.188-98.112-72.772 6.498.974 12.995 1.624 19.818 1.624 9.421 0 18.843-1.3 27.614-3.573-48.081-9.747-84.143-51.98-84.143-102.985v-1.299c13.969 7.797 30.214 12.67 47.431 13.319-28.264-18.843-46.781-51.005-46.781-87.391 0-19.492 5.197-37.36 14.294-52.954 51.655 63.675 129.3 105.258 216.365 109.807-1.624-7.797-2.599-15.918-2.599-24.04 0-57.828 46.782-104.934 104.934-104.934 30.213 0 57.502 12.67 76.67 33.137 23.715-4.548 46.456-13.32 66.599-25.34-7.798 24.366-24.366 44.833-46.132 57.827 21.117-2.273 41.584-8.122 60.426-16.243-14.292 20.791-32.161 39.308-52.628 54.253z"/></svg>.

<!-- <center><a href='https://gradientdescending.com/survivor/AU/07/vote-circle.png'><img src='https://gradientdescending.com/survivor/AU/07/vote-circle.png' align='center' width='300' height='auto'></a></center> -->

<a href='https://gradientdescending.com/survivor/AU/07/confessionals.html'><img height='50' width='auto' src="https://gradientdescending.com/survivor/AU/07/confessionals.png" align = 'center'>    Confessional
counts</a>

# Survivor: 42

Dev version v0.9.14 includes episodes 1 to 10.

<a href='https://gradientdescending.com/survivor/US/42/infographic.png'><img src='https://gradientdescending.com/survivor/US/42/infographic.png' align = 'center' height='50' width='auto'>    Infographic</a>

<!-- <center><a href='https://gradientdescending.com/survivor/US/42/confessionals.html'><iframe style="border: none; width: 100%; height: 700px;" src="https://gradientdescending.com/survivor/US/42/confessionals.html"></iframe></a></center> -->

<a href='https://gradientdescending.com/survivor/US/42/confessionals-rmd.html'><img  height='50' width='auto' src="https://gradientdescending.com/survivor/US/42/confessionals.png" align = 'center'>    Confessional
counts</a>

Confessional counts from [myself](https://twitter.com/danoehm), [Carly
Levitz](https://twitter.com/carlylevitz) and
[juststrategic](https://twitter.com/justrategic)

# Dataset overview

## Season summary

A table containing summary details of each season of Survivor, including
the winner, runner ups and location.

``` r
season_summary
#> # A tibble: 42 x 22
#>    version version_season season_name   season location   country tribe_setup   
#>    <chr>   <chr>          <chr>          <dbl> <chr>      <chr>   <chr>         
#>  1 US      US01           Survivor: Bo~      1 Pulau Tig~ Malays~ Two tribes of~
#>  2 US      US02           Survivor: Th~      2 Herbert R~ Austra~ Two tribes of~
#>  3 US      US03           Survivor: Af~      3 Shaba Nat~ Kenya   Two tribes of~
#>  4 US      US04           Survivor: Ma~      4 Nuku Hiva~ Polyne~ Two tribes of~
#>  5 US      US05           Survivor: Th~      5 Ko Taruta~ Thaila~ Two tribes of~
#>  6 US      US06           Survivor: Th~      6 Rio Negro~ Brazil  Two tribes of~
#>  7 US      US07           Survivor: Pe~      7 Pearl Isl~ Panama  Two tribes of~
#>  8 US      US08           Survivor: Al~      8 Pearl Isl~ Panama  Three tribes ~
#>  9 US      US09           Survivor: Va~      9 Efate, Sh~ Vanuatu Two tribes of~
#> 10 US      US10           Survivor: Pa~     10 Koror, Pa~ Palau   A schoolyard ~
#> # ... with 32 more rows, and 15 more variables: full_name <chr>,
#> #   winner_id <chr>, winner <chr>, runner_ups <chr>, final_vote <chr>,
#> #   timeslot <chr>, premiered <date>, ended <date>, filming_started <date>,
#> #   filming_ended <date>, viewers_premier <dbl>, viewers_finale <dbl>,
#> #   viewers_reunion <dbl>, viewers_mean <dbl>, rank <dbl>
```

<!-- <img src='dev/images/viewers.png' align="center"/> -->

## Castaways

This data set contains season and demographic information about each
castaway. It is structured to view their results for each season.
Castaways that have played in multiple seasons will feature more than
once with the age and location representing that point in time.
Castaways that re-entered the game will feature more than once in the
same season as they technically have more than one boot order
e.g. Natalie Anderson - Winners at War.

Each castaway has a unique `castaway_id` which links the individual
across all data sets and seasons. It also links to the following ID’s
found on the `vote_history`, `jury_votes` and `challenges` data sets.

-   `vote_id`
-   `voted_out_id`
-   `finalist_id`
-   `winner_id`

``` r
castaways |> 
  filter(season == 40)
#> # A tibble: 22 x 22
#>    version version_season season_name    season full_name   castaway_id castaway
#>    <chr>   <chr>          <chr>           <dbl> <chr>       <chr>       <chr>   
#>  1 US      US40           Survivor: Win~     40 Tony Vlach~ US0424      Tony    
#>  2 US      US40           Survivor: Win~     40 Natalie An~ US0442      Natalie 
#>  3 US      US40           Survivor: Win~     40 Michele Fi~ US0478      Michele 
#>  4 US      US40           Survivor: Win~     40 Sarah Laci~ US0414      Sarah   
#>  5 US      US40           Survivor: Win~     40 Ben Driebe~ US0516      Ben     
#>  6 US      US40           Survivor: Win~     40 Denise Sta~ US0386      Denise  
#>  7 US      US40           Survivor: Win~     40 Nick Wilson US0556      Nick    
#>  8 US      US40           Survivor: Win~     40 Jeremy Col~ US0433      Jeremy  
#>  9 US      US40           Survivor: Win~     40 Kim Spradl~ US0371      Kim     
#> 10 US      US40           Survivor: Win~     40 Sophie Cla~ US0353      Sophie  
#> # ... with 12 more rows, and 15 more variables: age <dbl>, city <chr>,
#> #   state <chr>, personality_type <chr>, episode <dbl>, day <dbl>, order <dbl>,
#> #   result <chr>, jury_status <chr>, original_tribe <chr>, swapped_tribe <chr>,
#> #   swapped_tribe_2 <chr>, merged_tribe <chr>, total_votes_received <dbl>,
#> #   immunity_idols_won <dbl>
```

### Castaway details

A few castaways have changed their name from season to season or have
been referred to by a different name during the season e.g. Amber
Mariano; in season 8 Survivor All-Stars there was Rob C and Rob M. That
information has been retained here in the `castaways` data set.

`castaway_details` contains unique information for each castaway. It
takes the full name from their most current season and their most
verbose short name which is handy for labelling.

It also includes gender, date of birth, occupation, race and ethnicity
data. If no source was found to determine a castaways race and
ethnicity, the data is kept as missing rather than making an assumption.

``` r
castaway_details
#> # A tibble: 626 x 11
#>    castaway_id full_name     short_name date_of_birth date_of_death gender race 
#>    <chr>       <chr>         <chr>      <date>        <date>        <chr>  <chr>
#>  1 US0001      Sonja Christ~ Sonja      1937-01-28    NA            Female <NA> 
#>  2 US0002      B.B. Andersen B.B.       1936-01-18    2013-10-29    Male   <NA> 
#>  3 US0003      Stacey Still~ Stacey     1972-08-11    NA            Female <NA> 
#>  4 US0004      Ramona Gray   Ramona     1971-01-20    NA            Female Black
#>  5 US0005      Dirk Been     Dirk       1976-06-15    NA            Male   <NA> 
#>  6 US0006      Joel Klug     Joel       1972-04-13    NA            Male   <NA> 
#>  7 US0007      Gretchen Cor~ Gretchen   1962-02-07    NA            Female <NA> 
#>  8 US0008      Greg Buis     Greg       1975-12-31    NA            Male   <NA> 
#>  9 US0009      Jenna Lewis   Jenna L.   1977-07-16    NA            Female <NA> 
#> 10 US0010      Gervase Pete~ Gervase    1969-11-02    NA            Male   Black
#> # ... with 616 more rows, and 4 more variables: ethnicity <chr>, poc <chr>,
#> #   occupation <chr>, personality_type <chr>
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
    episode == 9
  ) 
vh
#> # A tibble: 11 x 21
#>    version version_season season_name    season episode   day tribe_status tribe
#>    <chr>   <chr>          <chr>           <dbl>   <dbl> <dbl> <chr>        <chr>
#>  1 US      US40           Survivor: Win~     40       9    23 Merged       Koru 
#>  2 US      US40           Survivor: Win~     40       9    23 Merged       Koru 
#>  3 US      US40           Survivor: Win~     40       9    23 Merged       Koru 
#>  4 US      US40           Survivor: Win~     40       9    23 Merged       Koru 
#>  5 US      US40           Survivor: Win~     40       9    23 Merged       Koru 
#>  6 US      US40           Survivor: Win~     40       9    23 Merged       Koru 
#>  7 US      US40           Survivor: Win~     40       9    23 Merged       Koru 
#>  8 US      US40           Survivor: Win~     40       9    23 Merged       Koru 
#>  9 US      US40           Survivor: Win~     40       9    23 Merged       Koru 
#> 10 US      US40           Survivor: Win~     40       9    23 Merged       Koru 
#> 11 US      US40           Survivor: Win~     40       9    23 Merged       Koru 
#> # ... with 13 more variables: castaway <chr>, immunity <chr>, vote <chr>,
#> #   vote_event <chr>, split_vote <chr>, nullified <lgl>, tie <lgl>,
#> #   voted_out <chr>, order <dbl>, vote_order <dbl>, castaway_id <chr>,
#> #   vote_id <chr>, voted_out_id <chr>
```

``` r
vh |> 
  count(vote)
#> # A tibble: 3 x 2
#>   vote      n
#>   <chr> <int>
#> 1 Adam      8
#> 2 Nick      2
#> 3 Sarah     1
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
#>   vote      n
#>   <chr> <int>
#> 1 Adam      8
#> 2 Nick      2
#> 3 Sarah     1
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
#> # A tibble: 25 x 12
#>    version version_season season_name     season episode   day episode_title    
#>    <chr>   <chr>          <chr>            <dbl>   <dbl> <dbl> <chr>            
#>  1 US      US40           Survivor: Winn~     40       1     2 Greatest of the ~
#>  2 US      US40           Survivor: Winn~     40       1     3 Greatest of the ~
#>  3 US      US40           Survivor: Winn~     40       2     6 It's Like a Surv~
#>  4 US      US40           Survivor: Winn~     40       3     9 Out for Blood    
#>  5 US      US40           Survivor: Winn~     40       4    11 I Like Revenge   
#>  6 US      US40           Survivor: Winn~     40       5    14 The Buddy System~
#>  7 US      US40           Survivor: Winn~     40       6    16 Quick on the Draw
#>  8 US      US40           Survivor: Winn~     40       7    18 We're in the Maj~
#>  9 US      US40           Survivor: Winn~     40       7    18 We're in the Maj~
#> 10 US      US40           Survivor: Winn~     40       8    21 This is Where th~
#> # ... with 15 more rows, and 5 more variables: challenge_name <chr>,
#> #   challenge_type <chr>, outcome_type <chr>, challenge_id <chr>,
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
challenges, where the main components of the challenge is consistent,
they share the same name.

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
#> # A tibble: 886 x 14
#>    challenge_id challenge_name     puzzle race  precision endurance strength
#>    <chr>        <chr>              <lgl>  <lgl> <lgl>     <lgl>     <lgl>   
#>  1 CC0053       Barrel of Monkeys  FALSE  TRUE  TRUE      FALSE     FALSE   
#>  2 CC0079       Blue Lagoon Bustle TRUE   TRUE  TRUE      FALSE     FALSE   
#>  3 CC0114       By the Numbers     FALSE  TRUE  FALSE     FALSE     FALSE   
#>  4 CC0138       Choose Your Weapon FALSE  TRUE  TRUE      FALSE     FALSE   
#>  5 CC0232       Flashback          FALSE  FALSE FALSE     TRUE      FALSE   
#>  6 CC0305       Home Stretch       TRUE   TRUE  TRUE      FALSE     FALSE   
#>  7 CC0334       Kenny Log-Ins      TRUE   TRUE  TRUE      FALSE     FALSE   
#>  8 CC0358       Log Jam            FALSE  TRUE  FALSE     TRUE      FALSE   
#>  9 CC0371       Marooning          FALSE  TRUE  FALSE     FALSE     FALSE   
#> 10 CC0408       O-Black Water      FALSE  TRUE  TRUE      FALSE     FALSE   
#> # ... with 876 more rows, and 7 more variables: turn_based <lgl>,
#> #   balance <lgl>, food <lgl>, knowledge <lgl>, memory <lgl>, fire <lgl>,
#> #   water <lgl>

challenge_description |> 
  summarise_if(is_logical, sum)
#> # A tibble: 1 x 12
#>   puzzle  race precision endurance strength turn_based balance  food knowledge
#>    <int> <int>     <int>     <int>    <int>      <int>   <int> <int>     <int>
#> 1    238   721       184       115       50        132     143    23        55
#> # ... with 3 more variables: memory <int>, fire <int>, water <int>
```

## Jury votes

History of jury votes. It is more verbose than it needs to be, however
having a 0-1 column indicating if a vote was placed or not makes it
easier to summarise castaways that received no votes.

``` r
jury_votes |> 
  filter(season == 40)
#> # A tibble: 48 x 9
#>    version version_season season_name season castaway finalist  vote castaway_id
#>    <chr>   <chr>          <chr>        <dbl> <chr>    <chr>    <dbl> <chr>      
#>  1 US      US40           Survivor: ~     40 Adam     Michele      0 US0498     
#>  2 US      US40           Survivor: ~     40 Amber    Michele      0 US0027     
#>  3 US      US40           Survivor: ~     40 Ben      Michele      0 US0516     
#>  4 US      US40           Survivor: ~     40 Danni    Michele      0 US0166     
#>  5 US      US40           Survivor: ~     40 Denise   Michele      0 US0386     
#>  6 US      US40           Survivor: ~     40 Ethan    Michele      0 US0048     
#>  7 US      US40           Survivor: ~     40 Jeremy   Michele      0 US0433     
#>  8 US      US40           Survivor: ~     40 Kim      Michele      0 US0371     
#>  9 US      US40           Survivor: ~     40 Nick     Michele      0 US0556     
#> 10 US      US40           Survivor: ~     40 Parvati  Michele      0 US0197     
#> # ... with 38 more rows, and 1 more variable: finalist_id <chr>
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
#>    <chr>                     <dbl> <chr>       <chr>          <dbl>      <dbl>
#>  1 Survivor: Winners at War     40 US0112      Sandra             1          1
#>  2 Survivor: Winners at War     40 US0386      Denise             1          1
#>  3 Survivor: Winners at War     40 US0371      Kim                1          1
#>  4 Survivor: Winners at War     40 US0353      Sophie             1          1
#>  5 Survivor: Winners at War     40 US0386      Denise             2          1
#>  6 Survivor: Winners at War     40 US0478      Michele            1          1
#>  7 Survivor: Winners at War     40 US0424      Tony               1          1
#>  8 Survivor: Winners at War     40 US0516      Ben                1          1
#>  9 Survivor: Winners at War     40 US0442      Natalie            1          1
#> 10 Survivor: Winners at War     40 US0442      Natalie            2          1
#> # ... with 4 more variables: votes_nullified <dbl>, day_found <dbl>,
#> #   day_played <dbl>, legacy_advantage <lgl>
```

## Confessionals

A dataset containing the number of confessionals for each castaway by
season and episode. The data has been counted by contributors of the
survivoR R package and consolidated with external sources. The aim is to
establish consistency in confessional counts in the absence of official
sources. Given the subjective nature of the counts and the potential for
clerical error no single source is more valid than another. Therefore,
it is reasonable to average across all sources.

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
#> # A tibble: 14 x 12
#>    version version_season season_name         season episode_number_ove~ episode
#>    <chr>   <chr>          <chr>                <dbl>               <dbl>   <dbl>
#>  1 US      US40           Survivor: Winners ~     40                 583       1
#>  2 US      US40           Survivor: Winners ~     40                 584       2
#>  3 US      US40           Survivor: Winners ~     40                 585       3
#>  4 US      US40           Survivor: Winners ~     40                 586       4
#>  5 US      US40           Survivor: Winners ~     40                 587       5
#>  6 US      US40           Survivor: Winners ~     40                 588       6
#>  7 US      US40           Survivor: Winners ~     40                 589       7
#>  8 US      US40           Survivor: Winners ~     40                 590       8
#>  9 US      US40           Survivor: Winners ~     40                 591       9
#> 10 US      US40           Survivor: Winners ~     40                 592      10
#> 11 US      US40           Survivor: Winners ~     40                 593      11
#> 12 US      US40           Survivor: Winners ~     40                 594      12
#> 13 US      US40           Survivor: Winners ~     40                 595      13
#> 14 US      US40           Survivor: Winners ~     40                 596      14
#> # ... with 6 more variables: episode_title <chr>, episode_date <date>,
#> #   viewers <dbl>, rating_18_49 <dbl>, share_18_49 <dbl>, imdb_rating <dbl>
```

## Tribe colours

This data frame contains the tribe names and colours for each season,
including the RGB values. These colours can be joined with the other
data frames to customise colours for plots. Another option is to add
tribal colours to ggplots with the scale functions.

``` r
tribe_colours
#> # A tibble: 150 x 7
#>    version version_season season_name     season tribe tribe_colour tribe_status
#>    <chr>   <chr>          <chr>            <dbl> <chr> <chr>        <chr>       
#>  1 US      US01           Survivor: Born~      1 Pago~ #FFFF05      Original    
#>  2 US      US01           Survivor: Born~      1 Ratt~ #7CFC00      Merged      
#>  3 US      US01           Survivor: Born~      1 Tagi  #FF9900      Original    
#>  4 US      US02           Survivor: The ~      2 Barr~ #FF6600      Merged      
#>  5 US      US02           Survivor: The ~      2 Kucha #32CCFF      Original    
#>  6 US      US02           Survivor: The ~      2 Ogak~ #A7FC00      Original    
#>  7 US      US03           Survivor: Afri~      3 Boran #FFD700      Original    
#>  8 US      US03           Survivor: Afri~      3 Moto~ #00A693      Merged      
#>  9 US      US03           Survivor: Afri~      3 Samb~ #E41A2A      Original    
#> 10 US      US04           Survivor: Marq~      4 Mara~ #DFFF00      Original    
#> # ... with 140 more rows
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

## Survivor Dashboard

[**Carly Levitz**](https://twitter.com/carlylevitz) has developed a
fantastic
[dashboard](https://public.tableau.com/app/profile/carly.levitz/viz/SurvivorCBSData-Acknowledgements/Acknowledgements)
showcasing the data and allowing you to drill down into seasons,
castaways, voting history and challenges.

[<img src='dev/images/dash.png' align="center"/>](https://public.tableau.com/app/profile/carly.levitz/viz/SurvivorCBSData-Acknowledgements/Acknowledgements)

## Data viz

This looks at the number of immunity idols won and votes received for
each winner.

[<img src='dev/images/torches_png.png' align="center"/>](https://gradientdescending.com/survivor/torches_png.png)

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
-   **Kosta Psaltis** for sharing the race data for validation

# References

Data was almost entirely sourced from
[Wikipedia](https://en.wikipedia.org/wiki/Survivor_(American_TV_series)).
Other data, such as the tribe colours, was manually recorded and entered
by myself and contributors.

Torch graphic in hex: [Fire Torch Vectors by
Vecteezy](https://www.vecteezy.com/free-vector/fire-torch)
