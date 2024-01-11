
<img src='https://cranlogs.r-pkg.org/badges/survivoR'/><img src='https://cranlogs.r-pkg.org/badges/grand-total/survivoR'/><img src='https://www.r-pkg.org/badges/version/survivoR'/>

# survivoR <img src='dev/images/hex-flame-final.png' align="right" height="240" />

67 seasons. 1058 people. 1 package!

survivoR is a collection of data sets detailing events across 67 seasons
of Survivor US, Australia, South Africa, New Zealand and UK. It includes
castaway information, vote history, immunity and reward challenge
winners, jury votes, advantage details and a lot more.

# Installation

Now on CRAN (v2.3.0) or Git (v2.3.0).

If Git \> CRAN I’d suggest install from Git. We are constantly improving
the data sets so the github version is likely to be slightly improved.

``` r
install.packages("survivoR")
```

``` r
devtools::install_github("doehm/survivoR")
```

# News: survivoR 2.3.0

- Adding complete seasons
  - US45
  - UK03
- New data set `auction_details`
- New features on `survivor_auction`
- Refreshed `challenge_description.` Includes:
  - Name
  - Recurring name
  - Description
  - Reward description
  - Challenge characteristics
  - Refreshed chhllenge_id
- Refreshed `challenge_results.` Includes:
  - New `challenge_id` to link with `challenge_description`
  - New `challenge_types` e.g. Team / Individual when there are multiple
    winning conditions
  - New feature `result_notes` contain info on result winning conditions
- `episode_label` on `episodes` e.g. finale, reunion, etc
- Logicals on `castaways` to filter for
  - `finalists`
  - `winner`
  - `jury`
- `poc` on castaway details simplified

Additional notes: \* The non-US auction versions are missing alternative
item data but will be there in the next release. \* Additional challenge
descriptions and characteristics will be included in the next release.

Any corrections needed, please let me know.

# Confessionals

### Confessionals repo

The following link takes you to a repository of complete
<a href='http://gradientdescending.com/survivor/tables/confessionals.html'>confessional
tables</a>, inlcuding counts and confessional timing for a few seasons.

<a href='http://gradientdescending.com/survivor/tables/confessionals.html'><img src='http://gradientdescending.com/survivor/tables/confessionals/US/43/confessionals.png' align = 'center' height='400' width='auto'></a>

Confessional counts from [myself](https://twitter.com/danoehm), [Carly
Levitz](https://twitter.com/carlylevitz),
[Sam](https://twitter.com/survivorfansam), Grace.

### Confessional timing

Included in the package is a confessional timing app to record the
length of confessionals while watching the episode.

To launch the app, first install the package and run,

``` r
library(survivoR)
launch_confessional_app()
```

<a href='https://github.com/doehm/survivoR/tree/master/inst'><img src='dev/images/conf-app-gif.gif'></a>

To try it out online 👉 [Confessional timing
app](https://danieloehm.shinyapps.io/survivorDash/)

More info [here](https://github.com/doehm/survivoR/tree/master/inst).

# Dataset overview

There are 17 data sets included in the package:

1.  `advantage_details`
2.  `advantage_details`
3.  `boot_mapping`
4.  `castaway_details`
5.  `castaways`
6.  `challenge_results`
7.  `challenge_description`
8.  `confessionals`
9.  `jury_votes`
10. `screen_time`
11. `season_palettes`
12. `season_summary`
13. `survivor_auction`
14. `tribe_colours`
15. `tribe_mapping`
16. `episodes`
17. `vote_history`
18. `auction_details`

See the sections below for more details on the key data sets.

<details>
<summary>
<strong>Season summary</strong>
</summary>

## Season summary

A table containing summary details of each season of Survivor, including
the winner, runner ups and location.

``` r
season_summary
#> # A tibble: 67 × 23
#>    version version_season season_name season n_cast location country tribe_setup
#>    <chr>   <chr>          <chr>        <dbl>  <dbl> <chr>    <chr>   <chr>      
#>  1 AU      AU01           Survivor A…      1     24 Upolu    Samoa   "The 24 co…
#>  2 AU      AU02           Survivor A…      2     24 Upolu    Samoa   "The 24 co…
#>  3 AU      AU03           Survivor A…      3     24 Savusavu Fiji    "The 24 co…
#>  4 AU      AU04           Survivor A…      4     24 Savusavu Fiji    "Two tribe…
#>  5 AU      AU05           Survivor A…      5     24 Savusavu Fiji    "Two tribe…
#>  6 AU      AU06           Survivor A…      6     24 Cloncur… Austra… "The 24 co…
#>  7 AU      AU07           Survivor A…      7     24 Charter… Austra… "Blood v W…
#>  8 AU      AU08           Survivor A…      8     24 Upolu    Samoa   "Castaways…
#>  9 NZ      NZ01           Survivor N…      1     16 San Jua… Nicara… "Two teams…
#> 10 NZ      NZ02           Survivor N…      2     18 Lake Va… Thaila… "Schoolyar…
#> # ℹ 57 more rows
#> # ℹ 15 more variables: full_name <chr>, winner_id <chr>, winner <chr>,
#> #   runner_ups <chr>, final_vote <chr>, timeslot <chr>, premiered <date>,
#> #   ended <date>, filming_started <date>, filming_ended <date>,
#> #   viewers_premiere <dbl>, viewers_finale <dbl>, viewers_reunion <dbl>,
#> #   viewers_mean <dbl>, rank <dbl>
```

</details>
<details>
<summary>
<strong>Castaways</strong>
</summary>

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

- `vote_id`
- `voted_out_id`
- `finalist_id`

``` r
castaways |> 
  filter(season == 45)
#> # A tibble: 18 × 20
#>    version version_season season_name  season full_name     castaway_id castaway
#>    <chr>   <chr>          <chr>         <dbl> <chr>         <chr>       <chr>   
#>  1 US      US45           Survivor: 45     45 Hannah Rose   US0669      Hannah  
#>  2 US      US45           Survivor: 45     45 Brandon Donl… US0665      Brandon 
#>  3 US      US45           Survivor: 45     45 Sabiyah Brod… US0677      Sabiyah 
#>  4 US      US45           Survivor: 45     45 Sean Edwards  US0678      Sean    
#>  5 US      US45           Survivor: 45     45 Brando Meyer  US0664      Brando  
#>  6 US      US45           Survivor: 45     45 J. Maya       US0670      J. Maya 
#>  7 US      US45           Survivor: 45     45 Sifu Alsup    US0679      Sifu    
#>  8 US      US45           Survivor: 45     45 Kaleb Gebrew… US0673      Kaleb   
#>  9 US      US45           Survivor: 45     45 Kellie Nalba… US0675      Kellie  
#> 10 US      US45           Survivor: 45     45 Kendra McQua… US0676      Kendra  
#> 11 US      US45           Survivor: 45     45 Bruce Perrea… US0657      Bruce   
#> 12 US      US45           Survivor: 45     45 Emily Flippen US0668      Emily   
#> 13 US      US45           Survivor: 45     45 Drew Basile   US0667      Drew    
#> 14 US      US45           Survivor: 45     45 Julie Alley   US0672      Julie   
#> 15 US      US45           Survivor: 45     45 Katurah Topps US0674      Katurah 
#> 16 US      US45           Survivor: 45     45 Jake O'Kane   US0671      Jake    
#> 17 US      US45           Survivor: 45     45 Austin Li Co… US0663      Austin  
#> 18 US      US45           Survivor: 45     45 Dee Valladar… US0666      Dee     
#> # ℹ 13 more variables: age <dbl>, city <chr>, state <chr>, episode <dbl>,
#> #   day <dbl>, order <dbl>, result <chr>, jury_status <chr>,
#> #   original_tribe <chr>, result_number <dbl>, jury <lgl>, finalist <lgl>,
#> #   winner <lgl>
```

## Castaway details

A few castaways have changed their name from season to season or have
been referred to by a different name during the season e.g. Amber
Mariano; in season 8 Survivor All-Stars there was Rob C and Rob M. That
information has been retained here in the `castaways` data set.

`castaway_details` contains unique information for each castaway. It
takes the full name from their most current season and their most
verbose short name which is handy for labelling.

It also includes gender, date of birth, occupation, race, ethnicity and
other data. If no source was found to determine a castaways race and
ethnicity, the data is kept as missing rather than making an assumption.

Race, ethnicity, and POC data isonly complete for US. `poc` has been
simplified to be “POC” for where a player has a field for `race` and/or
`ethnicity` for US players as per (Survivor
wiki)\[<https://survivor.fandom.com/wiki>\]. All others have been left
blank rather than making assumptions.

``` r
castaway_details
#> # A tibble: 1,058 × 16
#>    castaway_id full_name full_name_detailed castaway date_of_birth date_of_death
#>    <chr>       <chr>     <chr>              <chr>    <date>        <date>       
#>  1 AU0001      Des Quil… Des Quilty         Des      NA            NA           
#>  2 AU0002      Bianca A… Bianca Anderson    Bianca   NA            NA           
#>  3 AU0003      Evan Jon… Evan Jones         Evan     NA            NA           
#>  4 AU0004      Peter Fi… Peter Fiegehen     Peter    NA            NA           
#>  5 AU0005      Barry Lea Barry Lea          Barry    NA            NA           
#>  6 AU0006      Tegan Ha… Tegan Haining      Tegan    NA            NA           
#>  7 AU0007      Rohan Ma… Rohan MacLauren    Rohan    NA            NA           
#>  8 AU0008      Kat Dumo… Kat Dumont         Katinka  1989-09-21    NA           
#>  9 AU0009      Andrew T… Andrew Torrens     Andrew   NA            NA           
#> 10 AU0010      Craig I'… Craig I'Anson      Craig    NA            NA           
#> # ℹ 1,048 more rows
#> # ℹ 10 more variables: gender <chr>, race <chr>, ethnicity <chr>, poc <chr>,
#> #   personality_type <chr>, lgbt <lgl>, occupation <chr>, three_words <chr>,
#> #   hobbies <chr>, pet_peeves <chr>
```

</details>
<details>
<summary>
<strong>Vote history</strong>
</summary>

## Vote history

This data frame contains a complete history of votes cast across all
seasons of Survivor. This allows you to see who who voted for who at
which Tribal Council. It also includes details on who had individual
immunity as well as who had their votes nullified by a hidden immunity
idol. This details the key events for the season.

There is some information on split votes to help calculate if a player
engaged in a split vote but ultimately hit their target. There are
events which influence the vote e.g. Extra votes, safety without power,
etc. These are recorded here as well.

``` r
vh <- vote_history |> 
  filter(
    season == 45,
    episode == 9
  ) 
vh
#> # A tibble: 9 × 22
#>   version version_season season_name  season episode   day tribe_status tribe   
#>   <chr>   <chr>          <chr>         <dbl>   <dbl> <dbl> <chr>        <chr>   
#> 1 US      US45           Survivor: 45     45       9    17 Merged       Dakuwaqa
#> 2 US      US45           Survivor: 45     45       9    17 Merged       Dakuwaqa
#> 3 US      US45           Survivor: 45     45       9    17 Merged       Dakuwaqa
#> 4 US      US45           Survivor: 45     45       9    17 Merged       Dakuwaqa
#> 5 US      US45           Survivor: 45     45       9    17 Merged       Dakuwaqa
#> 6 US      US45           Survivor: 45     45       9    17 Merged       Dakuwaqa
#> 7 US      US45           Survivor: 45     45       9    17 Merged       Dakuwaqa
#> 8 US      US45           Survivor: 45     45       9    17 Merged       Dakuwaqa
#> 9 US      US45           Survivor: 45     45       9    17 Merged       Dakuwaqa
#> # ℹ 14 more variables: castaway <chr>, immunity <chr>, vote <chr>,
#> #   vote_event <chr>, vote_event_outcome <chr>, split_vote <chr>,
#> #   nullified <lgl>, tie <lgl>, voted_out <chr>, order <dbl>, vote_order <dbl>,
#> #   castaway_id <chr>, vote_id <chr>, voted_out_id <chr>
```

``` r
vh |> 
  count(vote)
#> # A tibble: 3 × 2
#>   vote       n
#>   <chr>  <int>
#> 1 Jake       1
#> 2 Kendra     6
#> 3 <NA>       2
```

</details>
<details>
<summary>
<strong>Challenges</strong>
</summary>

## Challenge results

Note: From v1.1 the `challenge_results` dataset has been improved but
could break existing code. The old table is maintained at
`challenge_results_dep`

There are two tables `challenge_results` and `challenge_description`.

### Challenge results

A tidy data frame of immunity and reward challenge results. The winners
and losers of the challenges are found recorded here.

``` r
challenge_results |> 
  filter(season == 45) |> 
  group_by(castaway) |> 
  summarise(
    won = sum(result == "Won"),
    lost = sum(result == "Lost"),
    total_challenges = n(),
    chosen_for_reward = sum(chosen_for_reward)
  )
#> # A tibble: 18 × 5
#>    castaway   won  lost total_challenges chosen_for_reward
#>    <chr>    <int> <int>            <int>             <int>
#>  1 Austin      10     7               18                 1
#>  2 Brando       5     2                7                 0
#>  3 Brandon      0     3                3                 0
#>  4 Bruce        9     4               13                 0
#>  5 Dee          9     9               18                 2
#>  6 Drew         8     8               16                 0
#>  7 Emily        3    11               14                 0
#>  8 Hannah       0     2                2                 0
#>  9 J. Maya      6     2                8                 0
#> 10 Jake         6    11               18                 2
#> 11 Julie        7     8               17                 1
#> 12 Kaleb        3     5                9                 0
#> 13 Katurah      7    10               18                 2
#> 14 Kellie       6     3               10                 0
#> 15 Kendra       6     4               11                 0
#> 16 Sabiyah      1     4                5                 0
#> 17 Sean         1     5                6                 0
#> 18 Sifu         7     2                9                 0
```

The `challenge_id` is the primary key for the `challenge_description`
data set. The `challange_id` will change as the data or descriptions
change.

## Challenge description

*Note: This data frame is going through a massive revamp. Stay tuned.*

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

- `puzzle`: If the challenge contains a puzzle element.
- `race`: If the challenge is a race between tribes, teams or
  individuals.
- `precision`: If the challenge contains a precision element
  e.g. shooting an arrow, hitting a target, etc.
- `endurance`: If the challenge is an endurance event e.g. last tribe,
  team, individual standing.
- `strength`: If the challenge is largely strength based e.g. Shoulder
  the Load.
- `turn_based`: If the challenge is conducted in a series of rounds
  until a certain amount of points are scored or there is one player
  remaining.
- `balance`: If the challenge contains a balancing element.
- `food`: If the challenge contains a food element e.g. the food
  challenge, biting off chunks of meat.
- `knowledge`: If the challenge contains a knowledge component e.g. Q
  and A about the location.
- `memory`: If the challenge contains a memory element e.g. memorising a
  sequence of items.
- `fire`: If the challenge contains an element of fire making /
  maintaining.
- `water`: If the challenge is held, in part, in the water.

``` r
challenge_description
#> # A tibble: 1,731 × 25
#>    version version_season season_name              season episode challenge_id
#>    <chr>   <chr>          <chr>                     <dbl>   <dbl>        <dbl>
#>  1 AU      AU01           Survivor Australia: 2016      1       1            1
#>  2 AU      AU01           Survivor Australia: 2016      1       1            2
#>  3 AU      AU01           Survivor Australia: 2016      1       2            3
#>  4 AU      AU01           Survivor Australia: 2016      1       3            4
#>  5 AU      AU01           Survivor Australia: 2016      1       3            5
#>  6 AU      AU01           Survivor Australia: 2016      1       4            6
#>  7 AU      AU01           Survivor Australia: 2016      1       5            7
#>  8 AU      AU01           Survivor Australia: 2016      1       5            8
#>  9 AU      AU01           Survivor Australia: 2016      1       6            9
#> 10 AU      AU01           Survivor Australia: 2016      1       7           10
#> # ℹ 1,721 more rows
#> # ℹ 19 more variables: challenge_number <dbl>, challenge_type <chr>,
#> #   name <chr>, recurring_name <chr>, description <chr>, reward <chr>,
#> #   additional_stipulation <chr>, race <lgl>, endurance <lgl>,
#> #   turn_based <lgl>, puzzle <lgl>, precision <lgl>, strength <lgl>,
#> #   balance <lgl>, food <lgl>, knowledge <lgl>, memory <lgl>, fire <lgl>,
#> #   water <lgl>

challenge_description |> 
  summarise_if(is_logical, sum)
#> # A tibble: 1 × 12
#>    race endurance turn_based puzzle precision strength balance  food knowledge
#>   <int>     <int>      <int>  <int>     <int>    <int>   <int> <int>     <int>
#> 1    NA        NA          0     NA        NA       NA      NA    NA        NA
#> # ℹ 3 more variables: memory <int>, fire <int>, water <int>
```

</details>
<details>
<summary>
<strong>Jury votes</strong>
</summary>

## Jury votes

History of jury votes. It is more verbose than it needs to be, however
having a 0-1 column indicating if a vote was placed or not makes it
easier to summarise castaways that received no votes.

``` r
jury_votes |> 
  filter(season == 45)
#> # A tibble: 24 × 9
#>    version version_season season_name season castaway finalist  vote castaway_id
#>    <chr>   <chr>          <chr>        <dbl> <chr>    <chr>    <dbl> <chr>      
#>  1 US      US45           Survivor: …     45 Kaleb    Jake         0 US0673     
#>  2 US      US45           Survivor: …     45 Kellie   Jake         0 US0675     
#>  3 US      US45           Survivor: …     45 Kendra   Jake         0 US0676     
#>  4 US      US45           Survivor: …     45 Bruce    Jake         0 US0657     
#>  5 US      US45           Survivor: …     45 Emily    Jake         0 US0668     
#>  6 US      US45           Survivor: …     45 Drew     Jake         0 US0667     
#>  7 US      US45           Survivor: …     45 Julie    Jake         0 US0672     
#>  8 US      US45           Survivor: …     45 Katurah  Jake         0 US0674     
#>  9 US      US45           Survivor: …     45 Kaleb    Austin       0 US0673     
#> 10 US      US45           Survivor: …     45 Kellie   Austin       0 US0675     
#> # ℹ 14 more rows
#> # ℹ 1 more variable: finalist_id <chr>
```

``` r
jury_votes |> 
  filter(season == 45) |> 
  group_by(finalist) |> 
  summarise(votes = sum(vote))
#> # A tibble: 3 × 2
#>   finalist votes
#>   <chr>    <dbl>
#> 1 Austin       3
#> 2 Dee          5
#> 3 Jake         0
```

</details>
<details>
<summary>
<strong>Advantages</strong>
</summary>

## Advantage Details

This dataset lists the hidden idols and advantages in the game for all
seasons. It details where it was found, if there was a clue to the
advantage, location and other advantage conditions. This maps to the
`advantage_movement` table.

``` r
advantage_details |> 
  filter(season == 45)
#> # A tibble: 10 × 9
#>    version version_season season_name  season advantage_id advantage_type      
#>    <chr>   <chr>          <chr>         <dbl> <chr>        <chr>               
#>  1 US      US45           Survivor: 45     45 US45HI01     Hidden Immunity Idol
#>  2 US      US45           Survivor: 45     45 US45HI02     Hidden Immunity Idol
#>  3 US      US45           Survivor: 45     45 US45SP01     Safety Without Power
#>  4 US      US45           Survivor: 45     45 US45GW01     Goodwill Advantage  
#>  5 US      US45           Survivor: 45     45 US45AM01     Amulet              
#>  6 US      US45           Survivor: 45     45 US45AM02     Amulet              
#>  7 US      US45           Survivor: 45     45 US45AM03     Amulet              
#>  8 US      US45           Survivor: 45     45 US45HI03     Hidden Immunity Idol
#>  9 US      US45           Survivor: 45     45 US45HI04     Hidden Immunity Idol
#> 10 US      US45           Survivor: 45     45 US45CA01     Challenge Advantage 
#> # ℹ 3 more variables: clue_details <chr>, location_found <chr>,
#> #   conditions <chr>
```

## Advantage Movement

The `advantage_movement` table tracks who found the advantage, who they
may have handed it to and who the played it for. Each step is called an
event. The `sequence_id` tracks the logical step of the advantage. For
example in season 41, JD found an Extra Vote advantage. JD gave it to
Shan in good faith who then voted him out keeping the Extra Vote. Shan
gave it to Ricard in good faith who eventually gave it back before Shan
played it for Naseer. That movement is recorded in this table.

``` r
advantage_movement |> 
  filter(advantage_id == "USEV4102")
#> # A tibble: 0 × 15
#> # ℹ 15 variables: version <chr>, version_season <chr>, season_name <chr>,
#> #   season <dbl>, castaway <chr>, castaway_id <chr>, advantage_id <chr>,
#> #   sequence_id <dbl>, day <dbl>, episode <dbl>, event <chr>, played_for <chr>,
#> #   played_for_id <chr>, success <chr>, votes_nullified <dbl>
```

</details>
<details>
<summary>
<strong>Confessionals</strong>
</summary>

## Confessionals

A dataset containing the number of confessionals for each castaway by
season and episode. There are multiple contributors to this data. Where
there are multiple sets of counts for a season the average is taken and
added to the package. The aim is to establish consistency in
confessional counts in the absence of official sources. Given the
subjective nature of the counts and the potential for clerical error no
single source is more valid than another. So it is reasonable to average
across all sources.

Confessional time exists for a few seasons. This is the total cumulative
time for each castaway in seconds. This is a much more accurate
indicator of the ‘edit’.

``` r
confessionals |> 
  filter(season == 45) |> 
  group_by(castaway) |> 
  summarise(
    count = sum(confessional_count),
    time = sum(confessional_time)
    )
#> # A tibble: 18 × 3
#>    castaway count  time
#>    <chr>    <dbl> <dbl>
#>  1 Austin      72  1436
#>  2 Brando      10   147
#>  3 Brandon     12   214
#>  4 Bruce       38   735
#>  5 Dee         67  1102
#>  6 Drew        64  1171
#>  7 Emily       62  1332
#>  8 Hannah       4    44
#>  9 J. Maya     11   210
#> 10 Jake        60  1290
#> 11 Julie       46   814
#> 12 Kaleb       45   692
#> 13 Katurah     66  1169
#> 14 Kellie      29   515
#> 15 Kendra      37   506
#> 16 Sabiyah     22   342
#> 17 Sean        16   325
#> 18 Sifu        11   236
```

The confessional index is available on this data set. The index is a
standardised measure of the number of confessionals the player has
received compared to the others. It is stratified by tribe so it
measures how many confessionals each player gets proportional to even
share within tribe e.g. an index of 1.5 means that player as received
50% more than others in their tribe.

The tribe grouping is important since the tribe that attends tribal
council typical get more screen time, which is fair enough. I don’t
think we should expect even share across everyone in the pre-merge stage
of the game.

The index is cumulative with episode, so the players final index is the
index in their final episode.

``` r
confessionals |> 
  filter(season == 45) |> 
  group_by(castaway) |> 
  slice_max(episode) |> 
  arrange(desc(index_time)) |> 
  select(castaway, episode, confessional_count, confessional_time, index_count, index_time)
#> # A tibble: 18 × 6
#> # Groups:   castaway [18]
#>    castaway episode confessional_count confessional_time index_count index_time
#>    <chr>      <dbl>              <dbl>             <dbl>       <dbl>      <dbl>
#>  1 Emily         11                  8               203       1.09       1.31 
#>  2 Kaleb          7                  7                96       1.43       1.22 
#>  3 Sabiyah        3                  6               112       1.32       1.20 
#>  4 Brandon        2                  6               115       1.13       1.20 
#>  5 Austin        13                 14               214       1.09       1.17 
#>  6 Kellie         8                  6                81       1.11       1.16 
#>  7 Bruce         10                  5               104       1.01       1.12 
#>  8 Drew          12                  9               158       1.15       1.12 
#>  9 Jake          13                 14               250       0.946      1.10 
#> 10 Katurah       13                  8               203       1.04       1.00 
#> 11 Dee           13                 11               173       1.04       0.896
#> 12 Kendra         9                  6                83       1.11       0.895
#> 13 Sean           4                  9               211       0.783      0.884
#> 14 Julie         13                  5                64       0.714      0.665
#> 15 Hannah         1                  4                44       0.828      0.597
#> 16 Brando         5                  5                71       0.648      0.579
#> 17 J. Maya        6                  2                47       0.593      0.574
#> 18 Sifu           7                  1                33       0.486      0.535
```

</details>
<details>
<summary>
<strong>Screen time</strong>
</summary>

## Screen time \[EXPERIMENTAL\]

This dataset contains the estimated screen time for each castaway during
an episode. Please note that this is still in the early days of
development. There is likely to be misclassifcation and other sources of
error. The model will be refined over time.

An individuals’ screen time is calculated, at a high-level, via the
following process:

1.  Frames are sampled from episodes on a 1 second time interval

2.  MTCNN detects the human faces within each frame

3.  VGGFace2 converts each detected face into a 512d vector space

4.  A training set of labelled images (1 for each contestant + 3 for
    Jeff Probst) is processed in the same way to determine where they
    sit in the vector space. TODO: This could be made more accurate by
    increasing the number of training images per contestant.

5.  The Euclidean distance is calculated for the faces detected in the
    frame to each of the contestants in the season (+Jeff). If the
    minimum distance is greater than 1.2 the face is labelled as
    “unknown”. TODO: Review how robust this distance cutoff truly is -
    currently based on manual review of Season 42.

6.  A multi-class SVM is trained on the training set to label faces. For
    any face not identified as “unknown”, the vector embedding is run
    into this model and a label is generated.

7.  All labelled faces are aggregated together, with an assumption of
    1-5 full second of screen time each time a face is seen and
    factoring in time between detection capping at a max of 5 seconds.

<img src='dev/images/cast-detect1.png' align="center"/>

``` r
screen_time |> 
  filter(version_season == "US45") |> 
  group_by(castaway_id) |> 
  summarise(total_mins = sum(screen_time)/60) |> 
  left_join(
    castaway_details |> 
      select(castaway_id, castaway = short_name),
    by = "castaway_id"
  ) |> 
  arrange(desc(total_mins))
#> Error in `select()`:
#> ! Can't subset columns that don't exist.
#> ✖ Column `short_name` doesn't exist.
```

Currently it only includes data for season 42. More seasons will be
added as they are completed.

</details>
<details>
<summary>
<strong>Boot mapping</strong>
</summary>

## Boot mapping

A mapping table to detail who is still alive at each stage of the game.
It is useful for easy filtering to say the final players.

``` r
# filter to season 45 and when there are 6 people left
# 18 people in the season, therefore 12 boots

still_alive <- function(.version, .season, .n_boots) {
  survivoR::boot_mapping |>
    filter(
      version == .version,
      season == .season,
      final_n == 6,
      game_status %in% c("In the game", "Returned")
    )
}

still_alive("US", 45, 6)
#> # A tibble: 6 × 12
#>   version version_season season_name  season episode order final_n castaway_id
#>   <chr>   <chr>          <chr>         <dbl>   <dbl> <dbl>   <dbl> <chr>      
#> 1 US      US45           Survivor: 45     45      12    12       6 US0671     
#> 2 US      US45           Survivor: 45     45      12    12       6 US0674     
#> 3 US      US45           Survivor: 45     45      12    12       6 US0666     
#> 4 US      US45           Survivor: 45     45      12    12       6 US0672     
#> 5 US      US45           Survivor: 45     45      12    12       6 US0663     
#> 6 US      US45           Survivor: 45     45      12    12       6 US0667     
#> # ℹ 4 more variables: castaway <chr>, tribe <chr>, tribe_status <chr>,
#> #   game_status <chr>
```

</details>
<details>
<summary>
<strong>Episodes</strong>
</summary>

## Episodes

Episodes is an episode level table. It contains the episode information
such as episode title, air date, length, IMDb rating and the viewer
information for every episode across all seasons.

``` r
episodes |> 
  filter(season == 45)
#> # A tibble: 13 × 13
#>    version version_season season_name  season episode_number_overall episode
#>    <chr>   <chr>          <chr>         <dbl>                  <dbl>   <dbl>
#>  1 US      US45           Survivor: 45     45                    610       1
#>  2 US      US45           Survivor: 45     45                    611       2
#>  3 US      US45           Survivor: 45     45                    612       3
#>  4 US      US45           Survivor: 45     45                    613       4
#>  5 US      US45           Survivor: 45     45                    614       5
#>  6 US      US45           Survivor: 45     45                    615       6
#>  7 US      US45           Survivor: 45     45                    616       7
#>  8 US      US45           Survivor: 45     45                    617       8
#>  9 US      US45           Survivor: 45     45                    618       9
#> 10 US      US45           Survivor: 45     45                    619      10
#> 11 US      US45           Survivor: 45     45                    620      11
#> 12 US      US45           Survivor: 45     45                    621      12
#> 13 US      US45           Survivor: 45     45                    622      13
#> # ℹ 7 more variables: episode_title <chr>, episode_label <chr>,
#> #   episode_date <date>, episode_length <dbl>, viewers <dbl>,
#> #   imdb_rating <dbl>, n_ratings <dbl>
```

</details>
<details>
<summary>
<strong>Survivor Auction</strong>
</summary>

## Survivor Auction

There are 2 data sets, `survivor_acution` and `auction_details`.
`survivor_auction` simply shows who attended the auction and
`auction_details` holds the details of the auction e.g. who bought what
and at what price.

``` r
auction_details |> 
  filter(season == 45)
#> # A tibble: 11 × 19
#>    version version_season season_name  season  item item_description    category
#>    <chr>   <chr>          <chr>         <dbl> <dbl> <chr>               <chr>   
#>  1 US      US45           Survivor: 45     45     1 Salty pretzels and… Food an…
#>  2 US      US45           Survivor: 45     45     2 French fries, ketc… Food an…
#>  3 US      US45           Survivor: 45     45     3 Cheese platter, de… Food an…
#>  4 US      US45           Survivor: 45     45     4 Chocolate milkshake Food an…
#>  5 US      US45           Survivor: 45     45     5 Two giant fish eyes Bad item
#>  6 US      US45           Survivor: 45     45     5 Two giant fish eyes Bad item
#>  7 US      US45           Survivor: 45     45     6 Bowl of lollies an… Food an…
#>  8 US      US45           Survivor: 45     45     7 Slice of pepperoni… Food an…
#>  9 US      US45           Survivor: 45     45     8 Toothbrush and too… Comfort 
#> 10 US      US45           Survivor: 45     45     9 Chocolate cake      Food an…
#> 11 US      US45           Survivor: 45     45    10 Pbandj sandwich, c… Food an…
#> # ℹ 12 more variables: castaway <chr>, castaway_id <chr>, cost <dbl>,
#> #   covered <lgl>, money_remaining <dbl>, auction_num <dbl>,
#> #   participated <chr>, notes <chr>, alternative_offered <lgl>,
#> #   alternative_accepted <lgl>, other_item <chr>, other_item_category <chr>
```

</details>

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
[dashboard](https://public.tableau.com/app/profile/carly.levitz/viz/SurvivorCBSData-Acknowledgements/Tableofcontents)
showcasing the data and allowing you to drill down into seasons,
castaways, voting history and challenges.

[<img src='dev/images/dash.png' align="center"/>](https://public.tableau.com/app/profile/carly.levitz/viz/SurvivorCBSData-Acknowledgements/Tableofcontents)

## Data viz

This looks at the number of immunity idols won and votes received for
each winner.

[<img src='dev/images/torches_png.png' align="center"/>](https://gradientdescending.com/survivor/torches_png.png)

# Contributors

A big thank you to:

#### Package contributor and maintainers

- [**Carly Levitz**](https://twitter.com/carlylevitz) for ongoing data
  collection and curation

#### Data contributors

- [**Sam**](https://twitter.com/survivorfansam) for contributing to the
  confessional counts
- [**Dario Mavec**](https://github.com/dariomavec) for developing the
  face detection model for estimating total screen time
- **Camilla Bendetti** for collating the personality type data for each
  castaway.
- **Uygar Sozer** for adding the filming start and end dates for each
  season.
- **Holt Skinner** for creating the castaway ID to map people across
  seasons and manage name changes.

# References

Data was sourced from
[Wikipedia](https://en.wikipedia.org/wiki/Survivor_(American_TV_series))
and the [Survivor Wiki](https://survivor.fandom.com/wiki/Main_Page).
Other data, such as the tribe colours, was manually recorded and entered
by myself and contributors.

<!-- Torch graphic in hex: [Fire Torch Vectors by Vecteezy](https://www.vecteezy.com/free-vector/fire-torch) -->
