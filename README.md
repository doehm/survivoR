
<!-- README.md is generate from README.Rmd. Please edit that file -->

<img src='https://cranlogs.r-pkg.org/badges/survivoR'/><img src='https://cranlogs.r-pkg.org/badges/grand-total/survivoR'/><img src='https://www.r-pkg.org/badges/version/survivoR'/>

# survivoR <img src='dev/images/hex-torch.png' align="right" height="240" />

610 episodes. 41 seasons. 1 package!

survivoR is a collection of data sets detailing events across all 41
seasons of the US Survivor, including castaway information, vote
history, immunity and reward challenge winners and jury votes.

# Installation

Now on CRAN (v0.9.12).

``` r
install.packages("survivoR")
```

Or install from Git for the latest (v0.9.12). I’m constantly improving
the data sets and the github version is likely to be slightly improved.

``` r
devtools::install_github("doehm/survivoR")
```

# News

survivoR v0.9.12

-   Season 42 cast now added
-   POC flag on `castaway_details`
-   Updated Castaway IDs. Now in the format of USxxxx in preparation for
    non-US seasons. Original IDs can be extracted using
    `as.numeric(str_extract(castaway_id, '[:digit:]+'))` in a mutate
    step.

# Australian Survivor: Blood Vs Water

For episode by episode updates [follow me](https://twitter.com/danoehm)
on
<svg aria-hidden="true" role="img" viewBox="0 0 512 512" style="height:1em;width:1em;vertical-align:-0.125em;margin-left:auto;margin-right:auto;font-size:inherit;fill:currentColor;overflow:visible;position:relative;"><path d="M459.37 151.716c.325 4.548.325 9.097.325 13.645 0 138.72-105.583 298.558-298.558 298.558-59.452 0-114.68-17.219-161.137-47.106 8.447.974 16.568 1.299 25.34 1.299 49.055 0 94.213-16.568 130.274-44.832-46.132-.975-84.792-31.188-98.112-72.772 6.498.974 12.995 1.624 19.818 1.624 9.421 0 18.843-1.3 27.614-3.573-48.081-9.747-84.143-51.98-84.143-102.985v-1.299c13.969 7.797 30.214 12.67 47.431 13.319-28.264-18.843-46.781-51.005-46.781-87.391 0-19.492 5.197-37.36 14.294-52.954 51.655 63.675 129.3 105.258 216.365 109.807-1.624-7.797-2.599-15.918-2.599-24.04 0-57.828 46.782-104.934 104.934-104.934 30.213 0 57.502 12.67 76.67 33.137 23.715-4.548 46.456-13.32 66.599-25.34-7.798 24.366-24.366 44.833-46.132 57.827 21.117-2.273 41.584-8.122 60.426-16.243-14.292 20.791-32.161 39.308-52.628 54.253z"/></svg>.

This data will be added to the package once the season is complete. In
the meantime you can download complete confessional data
[here](https://github.com/doehm/survivoR/raw/master/dev/data/survivor-au-confessionals.xlsx).

<center>
<a href='https://gradientdescending.com/survivor/conf-tbl-episodes.html'><img src='https://gradientdescending.com/survivor/conf-tbl-episodes.png' align='center' width='50%' height='50%'></a>
</center>
<center>
<a href='https://gradientdescending.com/survivor/summary.html'><img src='https://gradientdescending.com/survivor/summary.png' align = 'center' width='50%' height='50%'></a>
</center>
<center>
Click to expand
</center>

# Dataset overview

## Season summary

A table containing summary details of each season of Survivor, including
the winner, runner ups and location.

``` r
season_summary
#> # A tibble: 42 x 20
#>    season_name  season location  country tribe_setup  full_name winner_id winner
#>    <chr>         <dbl> <chr>     <chr>   <chr>        <chr>     <chr>     <chr> 
#>  1 Survivor: B~      1 Pulau Ti~ Malays~ Two tribes ~ Richard ~ US0016    Richa~
#>  2 Survivor: T~      2 Herbert ~ Austra~ Two tribes ~ Tina Wes~ US0032    Tina  
#>  3 Survivor: A~      3 Shaba Na~ Kenya   Two tribes ~ Ethan Zo~ US0048    Ethan 
#>  4 Survivor: M~      4 Nuku Hiv~ Polyne~ Two tribes ~ Vecepia ~ US0064    Vecep~
#>  5 Survivor: T~      5 Ko Tarut~ Thaila~ Two tribes ~ Brian He~ US0080    Brian 
#>  6 Survivor: T~      6 Rio Negr~ Brazil  Two tribes ~ Jenna Mo~ US0096    Jenna 
#>  7 Survivor: P~      7 Pearl Is~ Panama  Two tribes ~ Sandra D~ US0112    Sandra
#>  8 Survivor: A~      8 Pearl Is~ Panama  Three tribe~ Amber Br~ US0027    Amber 
#>  9 Survivor: V~      9 Efate, S~ Vanuatu Two tribes ~ Chris Da~ US0130    Chris 
#> 10 Survivor: P~     10 Koror, P~ Palau   A schoolyar~ Tom West~ US0150    Tom   
#> # ... with 32 more rows, and 12 more variables: runner_ups <chr>,
#> #   final_vote <chr>, timeslot <chr>, premiered <date>, ended <date>,
#> #   filming_started <date>, filming_ended <date>, viewers_premier <dbl>,
#> #   viewers_finale <dbl>, viewers_reunion <dbl>, viewers_mean <dbl>, rank <dbl>
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
#> # A tibble: 22 x 20
#>    season_name     season full_name    castaway_id castaway   age city   state  
#>    <chr>            <dbl> <chr>        <chr>       <chr>    <dbl> <chr>  <chr>  
#>  1 Survivor: Winn~     40 Tony Vlachos US0424      Tony        45 Allen~ New Je~
#>  2 Survivor: Winn~     40 Natalie And~ US0442      Natalie     33 Edgew~ New Je~
#>  3 Survivor: Winn~     40 Michele Fit~ US0478      Michele     29 Hobok~ New Je~
#>  4 Survivor: Winn~     40 Sarah Lacina US0414      Sarah       34 Cedar~ Iowa   
#>  5 Survivor: Winn~     40 Ben Drieber~ US0516      Ben         36 Boise  Idaho  
#>  6 Survivor: Winn~     40 Denise Stap~ US0386      Denise      48 Marion Iowa   
#>  7 Survivor: Winn~     40 Nick Wilson  US0556      Nick        28 Willi~ Kentuc~
#>  8 Survivor: Winn~     40 Jeremy Coll~ US0433      Jeremy      41 Foxbo~ Massac~
#>  9 Survivor: Winn~     40 Kim Spradli~ US0371      Kim         36 San A~ Texas  
#> 10 Survivor: Winn~     40 Sophie Clar~ US0353      Sophie      29 Santa~ Califo~
#> # ... with 12 more rows, and 12 more variables: personality_type <chr>,
#> #   episode <dbl>, day <dbl>, order <dbl>, result <chr>, jury_status <chr>,
#> #   original_tribe <chr>, swapped_tribe <chr>, swapped_tribe_2 <chr>,
#> #   merged_tribe <chr>, total_votes_received <dbl>, immunity_idols_won <dbl>
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
#> #   vote_order <dbl>, castaway_id <chr>, vote_id <chr>, voted_out_id <chr>
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
#> # A tibble: 25 x 10
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
#> # ... with 15 more rows, and 3 more variables: outcome_type <chr>,
#> #   challenge_id <chr>, winners <list>
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
#> # A tibble: 48 x 7
#>    season_name            season castaway finalist  vote castaway_id finalist_id
#>    <chr>                   <dbl> <chr>    <chr>    <dbl> <chr>       <chr>      
#>  1 Survivor: Winners at ~     40 Adam     Michele      0 US0498      US0478     
#>  2 Survivor: Winners at ~     40 Amber    Michele      0 US0027      US0478     
#>  3 Survivor: Winners at ~     40 Ben      Michele      0 US0516      US0478     
#>  4 Survivor: Winners at ~     40 Danni    Michele      0 US0166      US0478     
#>  5 Survivor: Winners at ~     40 Denise   Michele      0 US0386      US0478     
#>  6 Survivor: Winners at ~     40 Ethan    Michele      0 US0048      US0478     
#>  7 Survivor: Winners at ~     40 Jeremy   Michele      0 US0433      US0478     
#>  8 Survivor: Winners at ~     40 Kim      Michele      0 US0371      US0478     
#>  9 Survivor: Winners at ~     40 Nick     Michele      0 US0556      US0478     
#> 10 Survivor: Winners at ~     40 Parvati  Michele      0 US0197      US0478     
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
season and episode. This has been collated from multiple sources.

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
#> # A tibble: 14 x 10
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
#> # ... with 4 more variables: viewers <dbl>, rating_18_49 <dbl>,
#> #   share_18_49 <dbl>, imdb_rating <dbl>
```

## Tribe colours

This data frame contains the tribe names and colours for each season,
including the RGB values. These colours can be joined with the other
data frames to customise colours for plots. Another option is to add
tribal colours to ggplots with the scale functions.

``` r
tribe_colours
#> # A tibble: 148 x 5
#>    season_name                      season tribe      tribe_colour tribe_status
#>    <chr>                             <dbl> <chr>      <chr>        <chr>       
#>  1 Survivor: Borneo                      1 Pagong     #FFFF05      Original    
#>  2 Survivor: Borneo                      1 Rattana    #7CFC00      Merged      
#>  3 Survivor: Borneo                      1 Tagi       #FF9900      Original    
#>  4 Survivor: The Australian Outback      2 Barramundi #FF6600      Merged      
#>  5 Survivor: The Australian Outback      2 Kucha      #32CCFF      Original    
#>  6 Survivor: The Australian Outback      2 Ogakor     #A7FC00      Original    
#>  7 Survivor: Africa                      3 Boran      #FFD700      Original    
#>  8 Survivor: Africa                      3 Moto Maji  #00A693      Merged      
#>  9 Survivor: Africa                      3 Samburu    #E41A2A      Original    
#> 10 Survivor: Marquesas                   4 Maraamu    #DFFF00      Original    
#> # ... with 138 more rows
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
