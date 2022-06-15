
<!-- README.md is generate from README.Rmd. Please edit that file -->

<img src='https://cranlogs.r-pkg.org/badges/survivoR'/><img src='https://cranlogs.r-pkg.org/badges/grand-total/survivoR'/><img src='https://www.r-pkg.org/badges/version/survivoR'/>

# survivoR <img src='dev/images/hex-torch.png' align="right" height="240" />

624 episodes. 42 seasons. 1 package!

survivoR is a collection of data sets detailing events across all 41
seasons of the US Survivor, including castaway information, vote
history, immunity and reward challenge winners and jury votes.

# Installation

Now on CRAN (v1.0.1).

``` r
install.packages("survivoR")
```

Or install from Git for the latest (v1.0.3). We are constantly improving
the data sets and the github version is likely to be slightly improved.

``` r
devtools::install_github("doehm/survivoR")
```

# News

survivoR v1.0.3

-   Season 42 episode 1 to 11 added
-   3 new data sets
    -   `advantage_movement`
    -   `advantage_details`
    -   `boot_mapping`
-   Updates to `challenge_results`
-   New fields on `vote_history`
    -   `tribe`
    -   `vote_event`
    -   `split_vote`
    -   `tie`
-   New fields on `viewers`
    -   `imdb_rating`
-   `version` and `version_season` now on all data sets in prep for
    non-US seasons
-   Removed fields from `castaways`
    -   `swapped_tribe`
    -   `swapped_tribe_2`
    -   `merged_tribe`
    -   `total_vote_received`
    -   `immunity_idols_won`

# Australian Survivor: Blood Vs Water

For episode by episode updates [follow me](https://twitter.com/danoehm)
on
<svg aria-hidden="true" role="img" viewBox="0 0 512 512" style="height:1em;width:1em;vertical-align:-0.125em;margin-left:auto;margin-right:auto;font-size:inherit;fill:currentColor;overflow:visible;position:relative;"><path d="M459.37 151.716c.325 4.548.325 9.097.325 13.645 0 138.72-105.583 298.558-298.558 298.558-59.452 0-114.68-17.219-161.137-47.106 8.447.974 16.568 1.299 25.34 1.299 49.055 0 94.213-16.568 130.274-44.832-46.132-.975-84.792-31.188-98.112-72.772 6.498.974 12.995 1.624 19.818 1.624 9.421 0 18.843-1.3 27.614-3.573-48.081-9.747-84.143-51.98-84.143-102.985v-1.299c13.969 7.797 30.214 12.67 47.431 13.319-28.264-18.843-46.781-51.005-46.781-87.391 0-19.492 5.197-37.36 14.294-52.954 51.655 63.675 129.3 105.258 216.365 109.807-1.624-7.797-2.599-15.918-2.599-24.04 0-57.828 46.782-104.934 104.934-104.934 30.213 0 57.502 12.67 76.67 33.137 23.715-4.548 46.456-13.32 66.599-25.34-7.798 24.366-24.366 44.833-46.132 57.827 21.117-2.273 41.584-8.122 60.426-16.243-14.292 20.791-32.161 39.308-52.628 54.253z"/></svg>.

<a href='https://gradientdescending.com/survivor/AU/07/confessionals.html'><img height='50' width='auto' src="https://gradientdescending.com/survivor/AU/07/confessionals.png" align = 'center'>    Confessional
counts</a>

# Survivor: 42

Dev version v1.0.3 includes episodes 1 to 13.

<a href='https://gradientdescending.com/survivor/US/42/infographic.png'><img src='https://gradientdescending.com/survivor/US/42/infographic.png' align = 'center' height='50' width='auto'>    Infographic</a>

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
#> # A tibble: 42 × 22
#>    version version_season season_name        season location country tribe_setup
#>    <chr>   <chr>          <chr>               <dbl> <chr>    <chr>   <chr>      
#>  1 US      US01           Survivor: Borneo        1 Pulau T… Malays… Two tribes…
#>  2 US      US02           Survivor: The Aus…      2 Herbert… Austra… Two tribes…
#>  3 US      US03           Survivor: Africa        3 Shaba N… Kenya   Two tribes…
#>  4 US      US04           Survivor: Marques…      4 Nuku Hi… Polyne… Two tribes…
#>  5 US      US05           Survivor: Thailand      5 Ko Taru… Thaila… Two tribes…
#>  6 US      US06           Survivor: The Ama…      6 Rio Neg… Brazil  Two tribes…
#>  7 US      US07           Survivor: Pearl I…      7 Pearl I… Panama  Two tribes…
#>  8 US      US08           Survivor: All-Sta…      8 Pearl I… Panama  Three trib…
#>  9 US      US09           Survivor: Vanuatu       9 Efate, … Vanuatu Two tribes…
#> 10 US      US10           Survivor: Palau        10 Koror, … Palau   A schoolya…
#> # … with 32 more rows, and 15 more variables: full_name <chr>, winner_id <chr>,
#> #   winner <chr>, runner_ups <chr>, final_vote <chr>, timeslot <chr>,
#> #   premiered <date>, ended <date>, filming_started <date>,
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
  filter(season == 41)
#> # A tibble: 18 × 17
#>    version version_season season_name  season full_name     castaway_id castaway
#>    <chr>   <chr>          <chr>         <dbl> <chr>         <chr>       <chr>   
#>  1 US      US41           Survivor: 41     41 Erika Casupa… US0594      Erika   
#>  2 US      US41           Survivor: 41     41 Deshawn Radd… US0601      Deshawn 
#>  3 US      US41           Survivor: 41     41 Xander Hasti… US0597      Xander  
#>  4 US      US41           Survivor: 41     41 Heather Aldr… US0593      Heather 
#>  5 US      US41           Survivor: 41     41 Ricard Foye   US0596      Ricard  
#>  6 US      US41           Survivor: 41     41 Danny McCray  US0599      Danny   
#>  7 US      US41           Survivor: 41     41 Liana Wallace US0608      Liana   
#>  8 US      US41           Survivor: 41     41 Shantel Smith US0606      Shan    
#>  9 US      US41           Survivor: 41     41 Evvie Jagoda  US0598      Evvie   
#> 10 US      US41           Survivor: 41     41 Naseer Mutta… US0600      Naseer  
#> 11 US      US41           Survivor: 41     41 Tiffany Seely US0604      Tiffany 
#> 12 US      US41           Survivor: 41     41 Sydney Segal  US0605      Sydney  
#> 13 US      US41           Survivor: 41     41 Genie Chen    US0595      Genie   
#> 14 US      US41           Survivor: 41     41 Jairus Robin… US0603      JD      
#> 15 US      US41           Survivor: 41     41 Brad Reese    US0602      Brad    
#> 16 US      US41           Survivor: 41     41 David Voce    US0607      Voce    
#> 17 US      US41           Survivor: 41     41 Sara Wilson   US0592      Sara    
#> 18 US      US41           Survivor: 41     41 Eric Abraham  US0591      Abraham 
#> # … with 10 more variables: age <dbl>, city <chr>, state <chr>,
#> #   personality_type <chr>, episode <dbl>, day <dbl>, order <dbl>,
#> #   result <chr>, jury_status <chr>, original_tribe <chr>
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
#> # A tibble: 626 × 11
#>    castaway_id full_name     short_name date_of_birth date_of_death gender race 
#>    <chr>       <chr>         <chr>      <date>        <date>        <chr>  <chr>
#>  1 US0001      Sonja Christ… Sonja      1937-01-28    NA            Female <NA> 
#>  2 US0002      B.B. Andersen B.B.       1936-01-18    2013-10-29    Male   <NA> 
#>  3 US0003      Stacey Still… Stacey     1972-08-11    NA            Female <NA> 
#>  4 US0004      Ramona Gray   Ramona     1971-01-20    NA            Female Black
#>  5 US0005      Dirk Been     Dirk       1976-06-15    NA            Male   <NA> 
#>  6 US0006      Joel Klug     Joel       1972-04-13    NA            Male   <NA> 
#>  7 US0007      Gretchen Cor… Gretchen   1962-02-07    NA            Female <NA> 
#>  8 US0008      Greg Buis     Greg       1975-12-31    NA            Male   <NA> 
#>  9 US0009      Jenna Lewis   Jenna L.   1977-07-16    NA            Female <NA> 
#> 10 US0010      Gervase Pete… Gervase    1969-11-02    NA            Male   Black
#> # … with 616 more rows, and 4 more variables: ethnicity <chr>, poc <chr>,
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
    season == 41,
    episode == 9
  ) 
vh
#> # A tibble: 17 × 21
#>    version version_season season_name  season episode   day tribe_status tribe  
#>    <chr>   <chr>          <chr>         <dbl>   <dbl> <dbl> <chr>        <chr>  
#>  1 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#>  2 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#>  3 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#>  4 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#>  5 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#>  6 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#>  7 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#>  8 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#>  9 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#> 10 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#> 11 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#> 12 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#> 13 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#> 14 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#> 15 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#> 16 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#> 17 US      US41           Survivor: 41     41       9    17 Merged       Via Ka…
#> # … with 13 more variables: castaway <chr>, immunity <chr>, vote <chr>,
#> #   vote_event <chr>, split_vote <chr>, nullified <lgl>, tie <lgl>,
#> #   voted_out <chr>, order <dbl>, vote_order <dbl>, castaway_id <chr>,
#> #   vote_id <chr>, voted_out_id <chr>
```

``` r
vh |> 
  count(vote)
#> # A tibble: 5 × 2
#>   vote        n
#>   <chr>   <int>
#> 1 Evvie       3
#> 2 Heather     2
#> 3 Liana       2
#> 4 Naseer      8
#> 5 <NA>        2
```

Events in the game such as fire challenges, rock draws, steal-a-vote
advantages or countbacks in the early days often mean a vote wasn’t
placed for an individual. Rather a challenge may be won, lost, no vote
cast but attended Tribal Council, etc. These events are recorded in the
<code>vote</code> field. I have included a function
<code>clean_votes</code> for when only need the votes cast for
individuals. If the input data frame has the <code>vote</code> column it
can simply be piped.

``` r
vh |> 
  clean_votes() |> 
  count(vote)
#> # A tibble: 4 × 2
#>   vote        n
#>   <chr>   <int>
#> 1 Evvie       3
#> 2 Heather     2
#> 3 Liana       2
#> 4 Naseer      8
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
  filter(season == 41)
#> # A tibble: 21 × 13
#>    version version_season season_name  season episode   day order episode_title 
#>    <chr>   <chr>          <chr>         <dbl>   <dbl> <dbl> <dbl> <chr>         
#>  1 US      US41           Survivor: 41     41       1     3     0 A New Era     
#>  2 US      US41           Survivor: 41     41       1     3     0 A New Era     
#>  3 US      US41           Survivor: 41     41       2     5     2 Juggling Chai…
#>  4 US      US41           Survivor: 41     41       3     7     3 My Million Do…
#>  5 US      US41           Survivor: 41     41       4     9     4 They Hate Me …
#>  6 US      US41           Survivor: 41     41       4     9     4 They Hate Me …
#>  7 US      US41           Survivor: 41     41       5    11     5 The Strategis…
#>  8 US      US41           Survivor: 41     41       6    13     5 Ready to Play…
#>  9 US      US41           Survivor: 41     41       7    14     6 There's Gonna…
#> 10 US      US41           Survivor: 41     41       7    14     6 There's Gonna…
#> # … with 11 more rows, and 5 more variables: challenge_name <chr>,
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
#> # A tibble: 886 × 14
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
#> # … with 876 more rows, and 7 more variables: turn_based <lgl>, balance <lgl>,
#> #   food <lgl>, knowledge <lgl>, memory <lgl>, fire <lgl>, water <lgl>

challenge_description |> 
  summarise_if(is_logical, sum)
#> # A tibble: 1 × 12
#>   puzzle  race precision endurance strength turn_based balance  food knowledge
#>    <int> <int>     <int>     <int>    <int>      <int>   <int> <int>     <int>
#> 1    238   721       184       115       50        132     143    23        55
#> # … with 3 more variables: memory <int>, fire <int>, water <int>
```

## Jury votes

History of jury votes. It is more verbose than it needs to be, however
having a 0-1 column indicating if a vote was placed or not makes it
easier to summarise castaways that received no votes.

``` r
jury_votes |> 
  filter(season == 41)
#> # A tibble: 24 × 9
#>    version version_season season_name season castaway finalist  vote castaway_id
#>    <chr>   <chr>          <chr>        <dbl> <chr>    <chr>    <dbl> <chr>      
#>  1 US      US41           Survivor: …     41 Heather  Deshawn      0 US0593     
#>  2 US      US41           Survivor: …     41 Ricard   Deshawn      0 US0596     
#>  3 US      US41           Survivor: …     41 Danny    Deshawn      1 US0599     
#>  4 US      US41           Survivor: …     41 Liana    Deshawn      0 US0608     
#>  5 US      US41           Survivor: …     41 Shan     Deshawn      0 US0606     
#>  6 US      US41           Survivor: …     41 Evvie    Deshawn      0 US0598     
#>  7 US      US41           Survivor: …     41 Naseer   Deshawn      0 US0600     
#>  8 US      US41           Survivor: …     41 Tiffany  Deshawn      0 US0604     
#>  9 US      US41           Survivor: …     41 Heather  Erika        1 US0593     
#> 10 US      US41           Survivor: …     41 Ricard   Erika        1 US0596     
#> # … with 14 more rows, and 1 more variable: finalist_id <chr>
```

``` r
jury_votes |> 
  filter(season == 41) |> 
  group_by(finalist) |> 
  summarise(votes = sum(vote))
#> # A tibble: 3 × 2
#>   finalist votes
#>   <chr>    <dbl>
#> 1 Deshawn      1
#> 2 Erika        7
#> 3 Xander       0
```

## Advantages

### Advantage Details

This dataset lists the hidden idols and advantages in the game for all
seasons. It details where it was found, if there was a clue to the
advantage, location and other advantage conditions. This maps to the
`advantage_movement` table.

``` r
advantage_details |> 
  filter(season == 41)
#> # A tibble: 9 × 9
#>   version version_season season_name  season advantage_id advantage_type      
#>   <chr>   <chr>          <chr>         <dbl> <chr>        <chr>               
#> 1 US      US41           Survivor: 41     41 USEV4101     Extra vote          
#> 2 US      US41           Survivor: 41     41 USEV4102     Extra vote          
#> 3 US      US41           Survivor: 41     41 USEV4103     Extra vote          
#> 4 US      US41           Survivor: 41     41 USHI4101     Hidden immunity idol
#> 5 US      US41           Survivor: 41     41 USHI4102     Hidden immunity idol
#> 6 US      US41           Survivor: 41     41 USHI4103     Hidden immunity idol
#> 7 US      US41           Survivor: 41     41 USHI4104     Hidden immunity idol
#> 8 US      US41           Survivor: 41     41 USKP4101     Knowledge is power  
#> 9 US      US41           Survivor: 41     41 USVS4101     Steal a vote        
#> # … with 3 more variables: clue_details <chr>, location_found <chr>,
#> #   conditions <chr>
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
#>   version version_season season_name  season castaway castaway_id advantage_id
#>   <chr>   <chr>          <chr>         <dbl> <chr>    <chr>       <chr>       
#> 1 US      US41           Survivor: 41     41 JD       US0603      USEV4102    
#> 2 US      US41           Survivor: 41     41 Shan     US0606      USEV4102    
#> 3 US      US41           Survivor: 41     41 Ricard   US0596      USEV4102    
#> 4 US      US41           Survivor: 41     41 Shan     US0606      USEV4102    
#> 5 US      US41           Survivor: 41     41 Shan     US0606      USEV4102    
#> # … with 8 more variables: sequence_id <dbl>, day <dbl>, episode <dbl>,
#> #   event <chr>, played_for <chr>, played_for_id <chr>, success <chr>,
#> #   votes_nullified <dbl>
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
  filter(season == 41) |> 
  group_by(castaway) |> 
  summarise(n_confessionals = sum(confessional_count))
#> # A tibble: 18 × 2
#>    castaway n_confessionals
#>    <chr>              <dbl>
#>  1 Abraham                2
#>  2 Brad                  14
#>  3 Danny                 29
#>  4 Deshawn               56
#>  5 Erika                 39
#>  6 Evvie                 35
#>  7 Genie                 11
#>  8 Heather               13
#>  9 JD                    22
#> 10 Liana                 34
#> 11 Naseer                11
#> 12 Ricard                36
#> 13 Sara                   4
#> 14 Shan                  51
#> 15 Sydney                15
#> 16 Tiffany               25
#> 17 Voce                   6
#> 18 Xander                56
```

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
  filter(season == 41)
#> # A tibble: 154 × 10
#>    version version_season season_name  season episode   day castaway_id castaway
#>    <chr>   <chr>          <chr>         <dbl>   <dbl> <dbl> <chr>       <chr>   
#>  1 US      US41           Survivor: 41     41       1     3 US0591      Abraham 
#>  2 US      US41           Survivor: 41     41       1     3 US0592      Sara    
#>  3 US      US41           Survivor: 41     41       1     3 US0593      Heather 
#>  4 US      US41           Survivor: 41     41       1     3 US0594      Erika   
#>  5 US      US41           Survivor: 41     41       1     3 US0595      Genie   
#>  6 US      US41           Survivor: 41     41       1     3 US0596      Ricard  
#>  7 US      US41           Survivor: 41     41       1     3 US0597      Xander  
#>  8 US      US41           Survivor: 41     41       1     3 US0598      Evvie   
#>  9 US      US41           Survivor: 41     41       1     3 US0599      Danny   
#> 10 US      US41           Survivor: 41     41       1     3 US0600      Naseer  
#> # … with 144 more rows, and 2 more variables: tribe <chr>, tribe_status <chr>
```

## Boot Mapping

A mapping table for easily filtering to the set of castaways that are
still in the game after a specified number of boots. How this differs
from the tribe mapping is that rather than being focused on an episode,
it is focused on the boot which is often more useful. This table can be
used to calculate how many people participated in certain challenges
once mapped to `challenge_results`.

When someone quits the game or is medically evacuated it is considered a
boot. This table tracks multiple boots per episode.

``` r
# filter to season 41 and when there are 6 people left
# 18 people in the season, therefore 12 boots

boot_mapping |> 
  filter(
    season == 41,
    order == 12
    )
#> # A tibble: 6 × 11
#>   version version_season season_name  season episode order castaway castaway_id
#>   <chr>   <chr>          <chr>         <dbl>   <dbl> <dbl> <chr>    <chr>      
#> 1 US      US41           Survivor: 41     41      12    12 Heather  US0593     
#> 2 US      US41           Survivor: 41     41      12    12 Erika    US0594     
#> 3 US      US41           Survivor: 41     41      12    12 Ricard   US0596     
#> 4 US      US41           Survivor: 41     41      12    12 Xander   US0597     
#> 5 US      US41           Survivor: 41     41      12    12 Danny    US0599     
#> 6 US      US41           Survivor: 41     41      12    12 Deshawn  US0601     
#> # … with 3 more variables: tribe <chr>, tribe_status <chr>, in_the_game <lgl>
```

## Viewers

A data frame containing the viewer information for every episode across
all seasons. It also includes the rating and viewer share information
for viewers aged 18 to 49 years of age.

``` r
viewers |> 
  filter(season == 41)
#> # A tibble: 14 × 12
#>    version version_season season_name  season episode_number_overall episode
#>    <chr>   <chr>          <chr>         <dbl>                  <dbl>   <dbl>
#>  1 US      US41           Survivor: 41     41                    597       1
#>  2 US      US41           Survivor: 41     41                    598       2
#>  3 US      US41           Survivor: 41     41                    599       3
#>  4 US      US41           Survivor: 41     41                    600       4
#>  5 US      US41           Survivor: 41     41                    601       5
#>  6 US      US41           Survivor: 41     41                    602       6
#>  7 US      US41           Survivor: 41     41                    603       7
#>  8 US      US41           Survivor: 41     41                    604       8
#>  9 US      US41           Survivor: 41     41                    605       9
#> 10 US      US41           Survivor: 41     41                    606      10
#> 11 US      US41           Survivor: 41     41                    607      11
#> 12 US      US41           Survivor: 41     41                    608      12
#> 13 US      US41           Survivor: 41     41                    609      13
#> 14 US      US41           Survivor: 41     41                    610      14
#> # … with 6 more variables: episode_title <chr>, episode_date <date>,
#> #   viewers <dbl>, rating_18_49 <dbl>, share_18_49 <dbl>, imdb_rating <dbl>
```

## Tribe colours

This data frame contains the tribe names and colours for each season,
including the RGB values. These colours can be joined with the other
data frames to customise colours for plots. Another option is to add
tribal colours to ggplots with the scale functions.

``` r
tribe_colours
#> # A tibble: 150 × 7
#>    version version_season season_name     season tribe tribe_colour tribe_status
#>    <chr>   <chr>          <chr>            <dbl> <chr> <chr>        <chr>       
#>  1 US      US01           Survivor: Born…      1 Pago… #FFFF05      Original    
#>  2 US      US01           Survivor: Born…      1 Ratt… #7CFC00      Merged      
#>  3 US      US01           Survivor: Born…      1 Tagi  #FF9900      Original    
#>  4 US      US02           Survivor: The …      2 Barr… #FF6600      Merged      
#>  5 US      US02           Survivor: The …      2 Kucha #32CCFF      Original    
#>  6 US      US02           Survivor: The …      2 Ogak… #A7FC00      Original    
#>  7 US      US03           Survivor: Afri…      3 Boran #FFD700      Original    
#>  8 US      US03           Survivor: Afri…      3 Moto… #00A693      Merged      
#>  9 US      US03           Survivor: Afri…      3 Samb… #E41A2A      Original    
#> 10 US      US04           Survivor: Marq…      4 Mara… #DFFF00      Original    
#> # … with 140 more rows
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

-   **Carly Levitz** for providing
    -   Data corrections across all data sets.
    -   Gender, race and ethnicity data.
    -   Advantage datasets
-   **Camilla Bendetti** for collating the personality type data for
    each castaway.
-   **Uygar Sozer** for adding the filming start and end dates for each
    season.
-   **Holt Skinner** for creating the castaway ID to map people across
    seasons and manage name changes.
-   **Kosta Psaltis** for sharing the race data for validation

# References

Data was almost entirely sourced from
[Wikipedia](https://en.wikipedia.org/wiki/Survivor_(American_TV_series)).
Other data, such as the tribe colours, was manually recorded and entered
by myself and contributors.

Torch graphic in hex: [Fire Torch Vectors by
Vecteezy](https://www.vecteezy.com/free-vector/fire-torch)
