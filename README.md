
<img src='https://cranlogs.r-pkg.org/badges/survivoR'/><img src='https://cranlogs.r-pkg.org/badges/grand-total/survivoR'/><img src='https://www.r-pkg.org/badges/version/survivoR'/>

# survivoR <img src='dev/images/hex.png' align="right" height="240" />

987 episodes. 977 people. 1 package!

survivoR is a collection of data sets detailing events across 62 seasons
of Survivor US, Survivor Australia, Survivor South Africa and Survivor
New Zealand. It includes castaway information, vote history, immunity
and reward challenge winners, jury votes, advantage details and heaps
more!

# Installation

Now on CRAN (<img src='https://www.r-pkg.org/badges/version/survivoR'/>)
or Git (v2.1).

If Git \> CRAN I’d suggest install from Git. We are constantly improving
the data sets so the github version is likely to be slightly improved.

``` r
install.packages("survivoR")
```

``` r
devtools::install_github("doehm/survivoR")
```

# News: survivoR 2.0.8

- Adding complete AU08 data
- New features
  - `final_n` on `boot_mapping`
  - `n_cast` on `season_summary`
  - `index_count` and `index_time` on `confessionals`
- New `challenge_id` on `challenge_results`

# Confessionals

<a href='http://gradientdescending.com/survivor/tables/confessionals.html'><img src='http://gradientdescending.com/survivor/tables/confessionals/US/43/confessionals.png' align = 'center' height='50' width='auto'> Confessional
tables</a>

Confessional counts from [myself](https://twitter.com/danoehm), [Carly
Levitz](https://twitter.com/carlylevitz),
[Sam](https://twitter.com/survivorfansam), Grace.

I’ve created an app to record confessional times that you can run
[here](https://github.com/doehm/survivoR/tree/master/inst/confessionalDash)

# Dataset overview

## Season summary

A table containing summary details of each season of Survivor, including
the winner, runner ups and location.

``` r
season_summary
#> # A tibble: 62 × 23
#>    version versi…¹ seaso…² season n_cast locat…³ country tribe…⁴ full_…⁵ winne…⁶
#>    <chr>   <chr>   <chr>    <dbl>  <dbl> <chr>   <chr>   <chr>   <chr>   <chr>  
#>  1 AU      AU01    Surviv…      1     24 Upolu   Samoa   "The 2… Kristi… AU0024 
#>  2 AU      AU02    Surviv…      2     24 Upolu   Samoa   "The 2… Jerich… AU0048 
#>  3 AU      AU03    Surviv…      3     24 Savusa… Fiji    "The 2… Shane … AU0071 
#>  4 AU      AU04    Surviv…      4     24 Savusa… Fiji    "Two t… Pia Mi… AU0094 
#>  5 AU      AU05    Surviv…      5     24 Savusa… Fiji    "Two t… David … AU0086 
#>  6 AU      AU06    Surviv…      6     24 Cloncu… Austra… "The 2… Hayley… AU0119 
#>  7 AU      AU07    Surviv…      7     24 Charte… Austra… "Blood… Mark W… AU0031 
#>  8 AU      AU08    Surviv…      8     24 Upolu   Samoa   "Casta… Liz Pa… AU0145 
#>  9 NZ      NZ01    Surviv…      1     16 San Ju… Nicara… "Two t… Avi Du… NZ0016 
#> 10 SA      SA01    Surviv…      1     14 Pearl … Panama  "The 1… Vaness… SA0010 
#> # … with 52 more rows, 13 more variables: winner <chr>, runner_ups <chr>,
#> #   final_vote <chr>, timeslot <chr>, premiered <date>, ended <date>,
#> #   filming_started <date>, filming_ended <date>, viewers_premiere <dbl>,
#> #   viewers_finale <dbl>, viewers_reunion <dbl>, viewers_mean <dbl>,
#> #   rank <dbl>, and abbreviated variable names ¹​version_season, ²​season_name,
#> #   ³​location, ⁴​tribe_setup, ⁵​full_name, ⁶​winner_id
```

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
  filter(season == 42)
#> # A tibble: 18 × 17
#>    version version_se…¹ seaso…² season full_…³ casta…⁴ casta…⁵   age city  state
#>    <chr>   <chr>        <chr>    <dbl> <chr>   <chr>   <chr>   <dbl> <chr> <chr>
#>  1 US      US42         Surviv…     42 Jackso… US0613  Jackson    47 Hous… Texas
#>  2 US      US42         Surviv…     42 Zach W… US0626  Zach       21 St. … Miss…
#>  3 US      US42         Surviv…     42 Marya … US0618  Marya      47 Nobl… Indi…
#>  4 US      US42         Surviv…     42 Jenny … US0614  Jenny      43 Broo… New …
#>  5 US      US42         Surviv…     42 Swati … US0624  Swati      19 Palo… Cali…
#>  6 US      US42         Surviv…     42 Daniel… US0610  Daniel     30 New … Conn…
#>  7 US      US42         Surviv…     42 Lydia … US0617  Lydia      22 Sant… Cali…
#>  8 US      US42         Surviv…     42 Chanel… US0609  Chanel…    28 New … New …
#>  9 US      US42         Surviv…     42 Rocksr… US0622  Rocksr…    43 Las … Neva…
#> 10 US      US42         Surviv…     42 Tori M… US0625  Tori       24 Roge… Ariz…
#> 11 US      US42         Surviv…     42 Hai Gi… US0612  Hai        29 New … Loui…
#> 12 US      US42         Surviv…     42 Drea W… US0611  Drea       34 Mont… Queb…
#> 13 US      US42         Surviv…     42 Omar Z… US0621  Omar       31 Whit… Onta…
#> 14 US      US42         Surviv…     42 Lindsa… US0616  Lindsay    30 Asbu… New …
#> 15 US      US42         Surviv…     42 Jonath… US0615  Jonath…    28 Gulf… Alab…
#> 16 US      US42         Surviv…     42 Romeo … US0623  Romeo      37 Norw… Cali…
#> 17 US      US42         Surviv…     42 Mike T… US0620  Mike       57 Hobo… New …
#> 18 US      US42         Surviv…     42 Maryan… US0619  Maryan…    24 Ajax  Onta…
#> # … with 7 more variables: episode <dbl>, day <dbl>, order <dbl>, result <chr>,
#> #   jury_status <chr>, original_tribe <chr>, result_number <dbl>, and
#> #   abbreviated variable names ¹​version_season, ²​season_name, ³​full_name,
#> #   ⁴​castaway_id, ⁵​castaway
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
#> # A tibble: 977 × 16
#>    castaway…¹ full_…² full_…³ casta…⁴ date_of_…⁵ date_of_…⁶ gender race  ethni…⁷
#>    <chr>      <chr>   <chr>   <chr>   <date>     <date>     <chr>  <chr> <chr>  
#>  1 AU0001     Des Qu… Des Qu… Des     NA         NA         Male   <NA>  <NA>   
#>  2 AU0002     Bianca… Bianca… Bianca  NA         NA         Female <NA>  <NA>   
#>  3 AU0003     Evan J… Evan J… Evan    NA         NA         Male   <NA>  <NA>   
#>  4 AU0004     Peter … Peter … Peter   NA         NA         Male   <NA>  <NA>   
#>  5 AU0005     Barry … Barry … Barry   NA         NA         Male   <NA>  Aborig…
#>  6 AU0006     Tegan … Tegan … Tegan   NA         NA         Female <NA>  <NA>   
#>  7 AU0007     Rohan … Rohan … Rohan   NA         NA         Male   <NA>  <NA>   
#>  8 AU0008     Kat Du… Kat Du… Katinka 1989-09-21 NA         Female <NA>  <NA>   
#>  9 AU0009     Andrew… Andrew… Andrew  NA         NA         Male   <NA>  <NA>   
#> 10 AU0010     Craig … Craig … Craig   NA         NA         Male   <NA>  <NA>   
#> # … with 967 more rows, 7 more variables: poc <chr>, personality_type <chr>,
#> #   lgbt <lgl>, occupation <chr>, three_words <chr>, hobbies <chr>,
#> #   pet_peeves <chr>, and abbreviated variable names ¹​castaway_id, ²​full_name,
#> #   ³​full_name_detailed, ⁴​castaway, ⁵​date_of_birth, ⁶​date_of_death, ⁷​ethnicity
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
    season == 42,
    episode == 9
  ) 
vh
#> # A tibble: 10 × 22
#>    version version_…¹ seaso…² season episode   day tribe…³ tribe casta…⁴ immun…⁵
#>    <chr>   <chr>      <chr>    <dbl>   <dbl> <dbl> <chr>   <chr> <chr>   <chr>  
#>  1 US      US42       Surviv…     42       9    17 Merged  Kula… Hai     Indivi…
#>  2 US      US42       Surviv…     42       9    17 Merged  Kula… Mike    <NA>   
#>  3 US      US42       Surviv…     42       9    17 Merged  Kula… Omar    <NA>   
#>  4 US      US42       Surviv…     42       9    17 Merged  Kula… Rocksr… <NA>   
#>  5 US      US42       Surviv…     42       9    17 Merged  Kula… Romeo   <NA>   
#>  6 US      US42       Surviv…     42       9    17 Merged  Kula… Drea    Hidden 
#>  7 US      US42       Surviv…     42       9    17 Merged  Kula… Jonath… Indivi…
#>  8 US      US42       Surviv…     42       9    17 Merged  Kula… Lindsay <NA>   
#>  9 US      US42       Surviv…     42       9    17 Merged  Kula… Maryan… Hidden 
#> 10 US      US42       Surviv…     42       9    17 Merged  Kula… Tori    <NA>   
#> # … with 12 more variables: vote <chr>, vote_event <chr>,
#> #   vote_event_outcome <chr>, split_vote <chr>, nullified <lgl>, tie <lgl>,
#> #   voted_out <chr>, order <dbl>, vote_order <dbl>, castaway_id <chr>,
#> #   vote_id <chr>, voted_out_id <chr>, and abbreviated variable names
#> #   ¹​version_season, ²​season_name, ³​tribe_status, ⁴​castaway, ⁵​immunity
```

``` r
vh |> 
  count(vote)
#> # A tibble: 4 × 2
#>   vote         n
#>   <chr>    <int>
#> 1 Rocksroy     4
#> 2 Romeo        1
#> 3 Tori         4
#> 4 <NA>         1
```

## Challenges

Note: From v1.1 the `challenge_results` dataset has been improved but
could break existing code. The old table is maintained at
`challenge_results_dep`

There are two tables `challenge_results` and `challenge_description`.

### Challenge results

A tidy data frame of immunity and reward challenge results. The winners
and losers of the challenges are found recorded here.

``` r
challenge_results |> 
  filter(season == 42) |> 
  group_by(castaway) |> 
  summarise(
    won = sum(result == "Won"),
    Lost = sum(result == "Lost"),
    total_challenges = n(),
    chose_for_reward = sum(chosen_for_reward)
  )
#> # A tibble: 18 × 5
#>    castaway   won  Lost total_challenges chose_for_reward
#>    <chr>    <int> <int>            <int>            <int>
#>  1 Chanelle     4     7               11                0
#>  2 Daniel       3     4                7                0
#>  3 Drea         5    11               16                0
#>  4 Hai          5    10               15                0
#>  5 Jackson      0     1                1                0
#>  6 Jenny        2     2                4                0
#>  7 Jonathan    10    10               20                1
#>  8 Lindsay      9    10               19                1
#>  9 Lydia        4     5                9                0
#> 10 Marya        1     2                3                0
#> 11 Maryanne     7    13               20                1
#> 12 Mike         5    15               20                2
#> 13 Omar         6    12               18                1
#> 14 Rocksroy     5     8               13                0
#> 15 Romeo        5    15               20                1
#> 16 Swati        3     3                6                0
#> 17 Tori         9     4               13                0
#> 18 Zach         1     1                2                0
```

The `challenge_id` is the primary key for the `challenge_description`
data set. The `challange_id` will change as the data or descriptions
change.

TODO: Each challenge must have an ID and link to challenge description

### Challenge description

Note: This data frame is going through a massive revamp. Stay tuned.

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
- `strength`: If the challenge is largerly strength based e.g. Shoulder
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
#> # A tibble: 1,396 × 14
#>    challeng…¹ chall…² puzzle race  preci…³ endur…⁴ stren…⁵ turn_…⁶ balance food 
#>    <chr>      <chr>   <lgl>  <lgl> <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>
#>  1 AU0101IM00 Throw … TRUE   TRUE  FALSE   FALSE   TRUE    FALSE   FALSE   FALSE
#>  2 AU0102IR01 Sacrif… FALSE  TRUE  FALSE   FALSE   FALSE   FALSE   FALSE   FALSE
#>  3 AU0103IM02 Caught… FALSE  TRUE  FALSE   FALSE   FALSE   FALSE   FALSE   FALSE
#>  4 AU0103RD02 Supply… TRUE   TRUE  FALSE   FALSE   FALSE   FALSE   FALSE   FALSE
#>  5 AU0104IM03 Crab P… FALSE  TRUE  FALSE   FALSE   FALSE   FALSE   FALSE   FALSE
#>  6 AU0105IM04 Nutsli… FALSE  TRUE  TRUE    FALSE   FALSE   FALSE   FALSE   FALSE
#>  7 AU0105RD04 Build … FALSE  TRUE  FALSE   FALSE   FALSE   FALSE   FALSE   FALSE
#>  8 AU0106IM04 Breako… FALSE  TRUE  FALSE   FALSE   FALSE   FALSE   FALSE   FALSE
#>  9 AU0107IM05 Pull Y… FALSE  FALSE FALSE   TRUE    TRUE    FALSE   FALSE   FALSE
#> 10 AU0107RD05 Barrel… FALSE  TRUE  FALSE   FALSE   FALSE   FALSE   FALSE   FALSE
#> # … with 1,386 more rows, 4 more variables: knowledge <lgl>, memory <lgl>,
#> #   fire <lgl>, water <lgl>, and abbreviated variable names ¹​challenge_id,
#> #   ²​challenge_name, ³​precision, ⁴​endurance, ⁵​strength, ⁶​turn_based

challenge_description |> 
  summarise_if(is_logical, sum)
#> # A tibble: 1 × 12
#>   puzzle  race precision endurance strength turn_…¹ balance  food knowl…² memory
#>    <int> <int>     <int>     <int>    <int>   <int>   <int> <int>   <int>  <int>
#> 1     NA    NA        NA        NA       NA      NA      NA    NA      NA     NA
#> # … with 2 more variables: fire <int>, water <int>, and abbreviated variable
#> #   names ¹​turn_based, ²​knowledge
```

## Jury votes

History of jury votes. It is more verbose than it needs to be, however
having a 0-1 column indicating if a vote was placed or not makes it
easier to summarise castaways that received no votes.

``` r
jury_votes |> 
  filter(season == 42)
#> # A tibble: 24 × 9
#>    version version_season season_…¹ season casta…² final…³  vote casta…⁴ final…⁵
#>    <chr>   <chr>          <chr>      <dbl> <chr>   <chr>   <dbl> <chr>   <chr>  
#>  1 US      US42           Survivor…     42 Jonath… Romeo       0 US0615  US0623 
#>  2 US      US42           Survivor…     42 Lindsay Romeo       0 US0616  US0623 
#>  3 US      US42           Survivor…     42 Omar    Romeo       0 US0621  US0623 
#>  4 US      US42           Survivor…     42 Drea    Romeo       0 US0611  US0623 
#>  5 US      US42           Survivor…     42 Hai     Romeo       0 US0612  US0623 
#>  6 US      US42           Survivor…     42 Tori    Romeo       0 US0625  US0623 
#>  7 US      US42           Survivor…     42 Rocksr… Romeo       0 US0622  US0623 
#>  8 US      US42           Survivor…     42 Chanel… Romeo       0 US0609  US0623 
#>  9 US      US42           Survivor…     42 Jonath… Mike        1 US0615  US0620 
#> 10 US      US42           Survivor…     42 Lindsay Mike        0 US0616  US0620 
#> # … with 14 more rows, and abbreviated variable names ¹​season_name, ²​castaway,
#> #   ³​finalist, ⁴​castaway_id, ⁵​finalist_id
```

``` r
jury_votes |> 
  filter(season == 42) |> 
  group_by(finalist) |> 
  summarise(votes = sum(vote))
#> # A tibble: 3 × 2
#>   finalist votes
#>   <chr>    <dbl>
#> 1 Maryanne     7
#> 2 Mike         1
#> 3 Romeo        0
```

## Advantages

### Advantage Details

This dataset lists the hidden idols and advantages in the game for all
seasons. It details where it was found, if there was a clue to the
advantage, location and other advantage conditions. This maps to the
`advantage_movement` table.

``` r
advantage_details |> 
  filter(season == 42)
#> # A tibble: 11 × 9
#>    version version_season seaso…¹ season advan…² advan…³ clue_…⁴ locat…⁵ condi…⁶
#>    <chr>   <chr>          <chr>    <dbl> <chr>   <chr>   <chr>   <chr>   <chr>  
#>  1 US      US42           Surviv…     42 USAM42… Amulet  No clu… Found … Amulet…
#>  2 US      US42           Surviv…     42 USAM42… Amulet  No clu… Found … Amulet…
#>  3 US      US42           Surviv…     42 USAM42… Amulet  No clu… Found … Amulet…
#>  4 US      US42           Surviv…     42 USEV42… Extra … No clu… Shipwh… <NA>   
#>  5 US      US42           Surviv…     42 USEV42… Extra … No clu… Shipwh… <NA>   
#>  6 US      US42           Surviv…     42 USHI42… Hidden… Found … Found … Beware…
#>  7 US      US42           Surviv…     42 USHI42… Hidden… Found … Found … Beware…
#>  8 US      US42           Surviv…     42 USHI42… Hidden… Found … Found … Beware…
#>  9 US      US42           Surviv…     42 USKP42… Knowle… Found … Found … Knowle…
#> 10 US      US42           Surviv…     42 USHI42… Hidden… Found … Found … Valid …
#> 11 US      US42           Surviv…     42 USIN42… Idol n… Found … Found … <NA>   
#> # … with abbreviated variable names ¹​season_name, ²​advantage_id,
#> #   ³​advantage_type, ⁴​clue_details, ⁵​location_found, ⁶​conditions
```

### Advantage Movement

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
#> # A tibble: 5 × 15
#>   version version…¹ seaso…² season casta…³ casta…⁴ advan…⁵ seque…⁶   day episode
#>   <chr>   <chr>     <chr>    <dbl> <chr>   <chr>   <chr>     <dbl> <dbl>   <dbl>
#> 1 US      US41      Surviv…     41 JD      US0603  USEV41…       1     2       1
#> 2 US      US41      Surviv…     41 Shan    US0606  USEV41…       2     9       4
#> 3 US      US41      Surviv…     41 Ricard  US0596  USEV41…       3     9       4
#> 4 US      US41      Surviv…     41 Shan    US0606  USEV41…       4    11       5
#> 5 US      US41      Surviv…     41 Shan    US0606  USEV41…       5    17       9
#> # … with 5 more variables: event <chr>, played_for <chr>, played_for_id <chr>,
#> #   success <chr>, votes_nullified <dbl>, and abbreviated variable names
#> #   ¹​version_season, ²​season_name, ³​castaway, ⁴​castaway_id, ⁵​advantage_id,
#> #   ⁶​sequence_id
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
  filter(season == 42) |> 
  group_by(castaway) |> 
  summarise(n_confessionals = sum(confessional_count))
#> # A tibble: 18 × 2
#>    castaway n_confessionals
#>    <chr>              <dbl>
#>  1 Chanelle              18
#>  2 Daniel                15
#>  3 Drea                  34
#>  4 Hai                   37
#>  5 Jackson                2
#>  6 Jenny                  6
#>  7 Jonathan              31
#>  8 Lindsay               45
#>  9 Lydia                 14
#> 10 Marya                  6
#> 11 Maryanne              43
#> 12 Mike                  58
#> 13 Omar                  41
#> 14 Rocksroy              21
#> 15 Romeo                 33
#> 16 Swati                  7
#> 17 Tori                  18
#> 18 Zach                   7
```

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
  filter(version_season == "US42") |> 
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

## Tribe mapping

A mapping for castaways to tribes for each day (day being the day of the
tribal council). This is useful for observing who is on what tribe
throughout the game. Each season by day holds a complete list of
castaways still in the game and which tribe they are on. Moving through
each day you can observe the changes in the tribe. For example the first
day (usual day 2) has all castaways mapped to their original tribe. The
next day has the same minus the castaway just voted out. This is useful
for observing the changes in tribe make either due to castaways being
voted off the island, tribe swaps, who is on Redemption Island and Edge
of Extinction.

``` r
tribe_mapping |> 
  filter(season == 42)
#> # A tibble: 177 × 10
#>    version version_…¹ seaso…² season episode   day casta…³ casta…⁴ tribe tribe…⁵
#>    <chr>   <chr>      <chr>    <dbl>   <dbl> <dbl> <chr>   <chr>   <chr> <chr>  
#>  1 US      US42       Surviv…     42       1     2 US0609  Chanel… Vati  Origin…
#>  2 US      US42       Surviv…     42       1     2 US0610  Daniel  Vati  Origin…
#>  3 US      US42       Surviv…     42       1     2 US0611  Drea    Ika   Origin…
#>  4 US      US42       Surviv…     42       1     2 US0612  Hai     Vati  Origin…
#>  5 US      US42       Surviv…     42       1     2 US0613  Jackson Taku  Origin…
#>  6 US      US42       Surviv…     42       1     2 US0614  Jenny   Vati  Origin…
#>  7 US      US42       Surviv…     42       1     2 US0615  Jonath… Taku  Origin…
#>  8 US      US42       Surviv…     42       1     2 US0616  Lindsay Taku  Origin…
#>  9 US      US42       Surviv…     42       1     2 US0617  Lydia   Vati  Origin…
#> 10 US      US42       Surviv…     42       1     2 US0618  Marya   Taku  Origin…
#> # … with 167 more rows, and abbreviated variable names ¹​version_season,
#> #   ²​season_name, ³​castaway_id, ⁴​castaway, ⁵​tribe_status
```

## Boot Mapping

A mapping table for easily filtering to the set of castaways that are
still in the game after a specified number of boots. How this differs
from the tribe mapping is that rather than being focused on an episode,
it is focused on the boot which is often more useful. This is useful for
filtering to who is still alive in the game for a given episode and
number of boots. When someone quits the game or is medically evacuated
it is considered a boot. This table tracks multiple boots per episode.

``` r
# filter to season 42 and when there are 6 people left
# 18 people in the season, therefore 12 boots

still_alive <- function(.version, .season, .n_boots) {
  survivoR::boot_mapping |>
    filter(
      version == .version,
      season == .season,
      order == .n_boots,
      game_status %in% c("In the game", "Returned")
    )
}

still_alive("US", 42, 12)
#> # A tibble: 6 × 12
#>   version version_s…¹ seaso…² season episode order final_n casta…³ casta…⁴ tribe
#>   <chr>   <chr>       <chr>    <dbl>   <dbl> <dbl>   <dbl> <chr>   <chr>   <chr>
#> 1 US      US42        Surviv…     42      12    12       6 US0615  Jonath… Kula…
#> 2 US      US42        Surviv…     42      12    12       6 US0616  Lindsay Kula…
#> 3 US      US42        Surviv…     42      12    12       6 US0619  Maryan… Kula…
#> 4 US      US42        Surviv…     42      12    12       6 US0620  Mike    Kula…
#> 5 US      US42        Surviv…     42      12    12       6 US0621  Omar    Kula…
#> 6 US      US42        Surviv…     42      12    12       6 US0623  Romeo   Kula…
#> # … with 2 more variables: tribe_status <chr>, game_status <chr>, and
#> #   abbreviated variable names ¹​version_season, ²​season_name, ³​castaway_id,
#> #   ⁴​castaway
```

## Viewers

A data frame containing the viewer information for every episode across
all seasons. It also includes the rating and viewer share information
for viewers aged 18 to 49 years of age.

``` r
viewers |> 
  filter(season == 42)
#> # A tibble: 13 × 13
#>    version version_s…¹ seaso…² season episo…³ episode episo…⁴ episo…⁵ episode_…⁶
#>    <chr>   <chr>       <chr>    <dbl>   <dbl>   <dbl> <chr>   <chr>   <date>    
#>  1 US      US42        Surviv…     42     571       1 Feels … Ep 1    2022-03-09
#>  2 US      US42        Surviv…     42     572       2 Good a… Ep 2    2022-03-16
#>  3 US      US42        Surviv…     42     573       3 Go for… Ep 3    2022-03-23
#>  4 US      US42        Surviv…     42     574       4 Vibe o… Ep 4    2022-03-30
#>  5 US      US42        Surviv…     42     575       5 I'm Su… Ep 5    2022-04-06
#>  6 US      US42        Surviv…     42     576       6 You Ca… Ep 6    2022-04-13
#>  7 US      US42        Surviv…     42     577       7 The De… Ep 7    2022-04-13
#>  8 US      US42        Surviv…     42     578       8 You Be… Ep 8    2022-04-20
#>  9 US      US42        Surviv…     42     579       9 Game o… Ep 9    2022-04-27
#> 10 US      US42        Surviv…     42     580      10 Tell a… Ep 10   2022-05-04
#> 11 US      US42        Surviv…     42     581      11 Battle… Ep 11   2022-05-11
#> 12 US      US42        Surviv…     42     582      12 Caterp… Ep 12   2022-05-18
#> 13 US      US42        Surviv…     42     583      13 It Com… Finale  2022-05-25
#> # … with 4 more variables: episode_length <dbl>, viewers <dbl>,
#> #   imdb_rating <dbl>, n_ratings <dbl>, and abbreviated variable names
#> #   ¹​version_season, ²​season_name, ³​episode_number_overall, ⁴​episode_title,
#> #   ⁵​episode_label, ⁶​episode_date
```

## Tribe colours

This data frame contains the tribe names and colours for each season,
including the RGB values. These colours can be joined with the other
data frames to customise colours for plots. Another option is to add
tribal colours to ggplots with the scale functions.

``` r
tribe_colours
#> # A tibble: 230 × 7
#>    version version_season season_name               season tribe tribe…¹ tribe…²
#>    <chr>   <chr>          <chr>                      <dbl> <chr> <chr>   <chr>  
#>  1 AU      AU01           Survivor Australia: 2016       1 Agan… #FF0000 Origin…
#>  2 AU      AU01           Survivor Australia: 2016       1 Saan… #0000FF Origin…
#>  3 AU      AU01           Survivor Australia: 2016       1 Vavau #FFFF00 Origin…
#>  4 AU      AU01           Survivor Australia: 2016       1 Fia … #000000 Merged 
#>  5 AU      AU02           Survivor Australia: 2017       2 Sama… #A51A84 Origin…
#>  6 AU      AU02           Survivor Australia: 2017       2 Asaga #00A19C Origin…
#>  7 AU      AU02           Survivor Australia: 2017       2 Asat… #000000 Merged 
#>  8 AU      AU03           Survivor Australia: Cham…      3 Cham… #0000FF Origin…
#>  9 AU      AU03           Survivor Australia: Cham…      3 Cont… #FF0000 Origin…
#> 10 AU      AU03           Survivor Australia: Cham…      3 Koro… #000000 Merged 
#> # … with 220 more rows, and abbreviated variable names ¹​tribe_colour,
#> #   ²​tribe_status
```

<img src='dev/images/tribe-colours.png' align="center"/>

# Scale functions

Included are ggplot2 scale functions of the form
<code>scale_fill_survivor()</code> and <code>scale_fill_tribes()</code>
to add season and tribe colours to ggplot. The
<code>scale_fill_survivor()</code> scales uses a colour palette
extracted from the season logo and <code>scale_fill_tribes()</code>
scales uses the tribal colours of the specified season as a colour
palette.

All that is required for the ‘survivor’ palettes is the desired season
as input. If not season is provided it will default to season 40.

<img src='dev/images/season-40-logo.png' align="center"/>

``` r
castaways |> 
  distinct(season, castaway_id) |> 
  left_join(
    castaway_details |> 
      select(castaway_id, personality_type),
    by = "castaway_id"
  ) |> 
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
<code>scale_fill_tribes(season, tribe = tribe)</code> (for now) where
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

#### Package contributor and maintainers

- [**Carly Levitz**](https://twitter.com/carlylevitz) for ongoing data
  collection and curation

#### Data contributors

- [**Dario Mavec**](https://github.com/dariomavec) for developing the
  face detection model for estimating total screen time
- [**Sam**](https://twitter.com/survivorfansam) for contributing to the
  counfessional counts
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

Hex graphic by CBS
