
<img src='https://cranlogs.r-pkg.org/badges/survivoR'/><img src='https://cranlogs.r-pkg.org/badges/grand-total/survivoR'/><img src='https://www.r-pkg.org/badges/version/survivoR'/>

# survivoR <img src='dev/images/hex-flame-final.png' align="right" height="240" />

69 seasons. 1100 people. 1 package!

survivoR is a collection of data sets detailing events across 69 seasons
of Survivor US, Australia, South Africa, New Zealand and UK. It includes
castaway information, vote history, immunity and reward challenge
winners, jury votes, advantage details and a lot more.

# Installation

Now on CRAN (v2.3.2) or Git (v2.3.3).

If Git \> CRAN I’d suggest install from Git. We are constantly improving
the data sets so the github version is likely to be slightly improved.

``` r
install.packages("survivoR")
```

``` r
devtools::install_github("doehm/survivoR")
```

# News: survivoR 2.3.2

<img src='https://img.shields.io/badge/col-deprecated-red'/>

**`castaway_details`**

- `poc`

<img src='https://img.shields.io/badge/col-new-green'/>

**`castaway_details`**

Race/ethnicity simplified and more consistent with the [Survivor
Wiki](https://survivor.fandom.com/wiki/Main_Page)

- `african` `TRUE` if African-American or African-Canadian as per
  [Survivor Wiki](https://survivor.fandom.com/wiki/Main_Page)
- `asian` `TRUE` if Asian-American or Asian-Canadian as per [Survivor
  Wiki](https://survivor.fandom.com/wiki/Main_Page)
- `latin_american` `TRUE` if Latin-American as per [Survivor
  Wiki](https://survivor.fandom.com/wiki/Main_Page)
- `native_american` `TRUE` if Native-American as per [Survivor
  Wiki](https://survivor.fandom.com/wiki/Main_Page). This categegory has
  since been removed from the Wiki but have kept it here regardless.
- `bipoc` if `any(african, asian, latin_american, native_american)`

**`challenge_description`**

- Suite of new challenge characteristics. Please note these have not
  been refined and will continue to be improved.

**`castaways`**

Logicals to filter for

- `finalists`
- `winner`
- `jury`

Additional notes:

- The non-US auction versions are missing alternative item data but will
  be there in the next release.
- Additional challenge descriptions and characteristics will be included
  in the next release.

Any corrections needed, please let me know.

# [The Sanctuary](https://gradientdescending.com/the-sanctuary/)

[The Sanctuary](https://gradientdescending.com/the-sanctuary/) is the
survivoR package’s companion. It holds interactive tables and charts
detailing the castaways, challenges, vote history, confessionals,
ratings, and more.

[<img src="dev/images/flame.png" style="width:25.0%" />](https://gradientdescending.com/the-sanctuary/)

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

There are 19 data sets included in the package:

1.  `advantage_movement`
2.  `advantage_details`
3.  `boot_mapping`
4.  `castaway_details`
5.  `castaways`
6.  `challenge_results`
7.  `challenge_description`
8.  `challenge_summary`
9.  `confessionals`
10. `jury_votes`
11. `season_summary`
12. `survivor_auction`
13. `tribe_colours`
14. `tribe_mapping`
15. `episodes`
16. `vote_history`
17. `auction_details`
18. `screen_time`
19. `season_palettes`

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
#> # A tibble: 69 × 26
#>    version version_season season_name season location country tribe_setup n_cast
#>    <chr>   <chr>          <chr>        <dbl> <chr>    <chr>   <chr>        <int>
#>  1 US      US01           Survivor: …      1 Pulau T… Malays… Two tribes…     16
#>  2 US      US02           Survivor: …      2 Herbert… Austra… Two tribes…     16
#>  3 US      US03           Survivor: …      3 Shaba N… Kenya   Two tribes…     16
#>  4 US      US04           Survivor: …      4 Nuku Hi… Polyne… Two tribes…     16
#>  5 US      US05           Survivor: …      5 Ko Taru… Thaila… Two tribes…     16
#>  6 US      US06           Survivor: …      6 Rio Neg… Brazil  Two tribes…     16
#>  7 US      US07           Survivor: …      7 Pearl I… Panama  Two tribes…     16
#>  8 US      US08           Survivor: …      8 Pearl I… Panama  Three trib…     18
#>  9 US      US09           Survivor: …      9 Efate, … Vanuatu Two tribes…     18
#> 10 US      US10           Survivor: …     10 Koror, … Palau   A schoolya…     20
#> # ℹ 59 more rows
#> # ℹ 18 more variables: n_tribes <int>, n_finalists <int>, n_jury <int>,
#> #   full_name <chr>, winner_id <chr>, winner <chr>, runner_ups <chr>,
#> #   final_vote <chr>, timeslot <chr>, premiered <date>, ended <date>,
#> #   filming_started <date>, filming_ended <date>, viewers_premiere <dbl>,
#> #   viewers_finale <dbl>, viewers_reunion <dbl>, viewers_mean <dbl>, rank <dbl>
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

`african_american`, `asian_american`, `latin_american`,
`native_american`, `race`, `ethnicity`, and `bipoc` data is complete
only for the US. `bipoc` is `TRUE` when any of the `*_american` fields
are `TRUE`. These fields have been recorded as per the (Survivor
wiki)\[<https://survivor.fandom.com/wiki/Main_Page>\]. Other versions
have been left blank as the data is not complete and the term ‘people of
colour’ is typically only used in the US.

I have deprecated the old field `poc` in order to be more inclusive and
to make using the race/ethnicity fields simpler.

``` r
castaway_details
#> # A tibble: 1,100 × 20
#>    castaway_id full_name full_name_detailed castaway date_of_birth date_of_death
#>    <chr>       <chr>     <chr>              <chr>    <date>        <date>       
#>  1 US0001      Sonja Ch… Sonja Christopher  Sonja    1937-01-28    2024-04-26   
#>  2 US0002      B.B. And… B.B. Andersen      B.B.     1936-01-18    2013-10-29   
#>  3 US0003      Stacey S… Stacey Stillman    Stacey   1972-08-11    NA           
#>  4 US0004      Ramona G… Ramona Gray        Ramona   1971-01-20    NA           
#>  5 US0005      Dirk Been Dirk Been          Dirk     1976-06-15    NA           
#>  6 US0006      Joel Klug Joel Klug          Joel     1972-04-13    NA           
#>  7 US0007      Gretchen… Gretchen Cordy     Gretchen 1962-02-07    NA           
#>  8 US0008      Greg Buis Greg Buis          Greg     1975-12-31    NA           
#>  9 US0009      Jenna Le… Jenna Lewis        Jenna L. 1977-07-16    NA           
#> 10 US0010      Gervase … Gervase Peterson   Gervase  1969-11-02    NA           
#> # ℹ 1,090 more rows
#> # ℹ 14 more variables: gender <chr>, african <lgl>, asian <lgl>,
#> #   latin_american <lgl>, native_american <lgl>, bipoc <lgl>, lgbt <lgl>,
#> #   personality_type <chr>, occupation <chr>, three_words <chr>, hobbies <chr>,
#> #   pet_peeves <chr>, race <chr>, ethnicity <chr>
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

There are 3 tables `challenge_results`, `challenge_description`, and
`challenge_summary`.

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
#>  2 Brando       4     3                7                 0
#>  3 Brandon      0     3                3                 0
#>  4 Bruce        8     5               13                 0
#>  5 Dee          9     9               18                 2
#>  6 Drew         8     8               16                 0
#>  7 Emily        3    11               14                 0
#>  8 Hannah       0     2                2                 0
#>  9 J. Maya      6     2                8                 0
#> 10 Jake         5    12               18                 2
#> 11 Julie        7     8               17                 1
#> 12 Kaleb        3     5                9                 0
#> 13 Katurah      6    11               18                 2
#> 14 Kellie       5     4               10                 0
#> 15 Kendra       5     5               11                 0
#> 16 Sabiyah      1     4                5                 0
#> 17 Sean         1     5                6                 0
#> 18 Sifu         7     2                9                 0
```

The `challenge_id` is the primary key for the `challenge_description`
data set. The `challange_id` will change as the data or descriptions
change.

## Challenge description

*Note: This data frame is going through a massive revamp. Stay tuned.*

This data set contains the name, description, and descriptive features
for each challenge where it is known. Challenges can go by different
names so have included the unique name and the recurring challenge name.
These are taken directly from the [Survivor
Wiki](https://survivor.fandom.com/wiki/Category:Recurring_Challenges).
Sometimes there can be variations made on the challenge but go but the
same name, or the challenge is integrated with a longer obstacle. In
these cases the challenge may share the same recurring challenge name
but have a different challenge name. Even if they share the same names
the description could be different.

The features of each challenge have been determined largely through
string searches of key words that describe the challenge. It may not be
100% accurate due to the different and inconsistent descriptions but in
most part they will provide a good basis for analysis.

If any descriptive features need altering please let me know in the
[issues](https://github.com/doehm/survivoR/issues).

``` r
challenge_description
#> # A tibble: 1,767 × 46
#>    version version_season season_name      season episode challenge_id
#>    <fct>   <chr>          <chr>             <dbl>   <dbl>        <dbl>
#>  1 US      US01           Survivor: Borneo      1       1            1
#>  2 US      US01           Survivor: Borneo      1       2            2
#>  3 US      US01           Survivor: Borneo      1       2            3
#>  4 US      US01           Survivor: Borneo      1       3            4
#>  5 US      US01           Survivor: Borneo      1       3            5
#>  6 US      US01           Survivor: Borneo      1       4            6
#>  7 US      US01           Survivor: Borneo      1       4            7
#>  8 US      US01           Survivor: Borneo      1       5            8
#>  9 US      US01           Survivor: Borneo      1       5            9
#> 10 US      US01           Survivor: Borneo      1       6           10
#> # ℹ 1,757 more rows
#> # ℹ 40 more variables: challenge_number <dbl>, challenge_type <chr>,
#> #   name <chr>, recurring_name <chr>, description <chr>, reward <chr>,
#> #   additional_stipulation <chr>, balance <lgl>, balance_ball <lgl>,
#> #   balance_beam <lgl>, endurance <lgl>, fire <lgl>, food <lgl>,
#> #   knowledge <lgl>, memory <lgl>, mud <lgl>, obstacle_blindfolded <lgl>,
#> #   obstacle_cargo_net <lgl>, obstacle_chopping <lgl>, …

challenge_description |> 
  summarise_if(is_logical, ~sum(.x, na.rm = TRUE)) |> 
  glimpse()
#> Rows: 1
#> Columns: 33
#> $ balance                   <int> 338
#> $ balance_ball              <int> 44
#> $ balance_beam              <int> 142
#> $ endurance                 <int> 420
#> $ fire                      <int> 66
#> $ food                      <int> 24
#> $ knowledge                 <int> 77
#> $ memory                    <int> 28
#> $ mud                       <int> 45
#> $ obstacle_blindfolded      <int> 51
#> $ obstacle_cargo_net        <int> 143
#> $ obstacle_chopping         <int> 33
#> $ obstacle_combination_lock <int> 21
#> $ obstacle_digging          <int> 87
#> $ obstacle_knots            <int> 41
#> $ obstacle_padlocks         <int> 73
#> $ precision                 <int> 283
#> $ precision_catch           <int> 62
#> $ precision_roll_ball       <int> 14
#> $ precision_slingshot       <int> 52
#> $ precision_throw_balls     <int> 70
#> $ precision_throw_coconuts  <int> 22
#> $ precision_throw_rings     <int> 19
#> $ precision_throw_sandbags  <int> 51
#> $ puzzle                    <int> 388
#> $ puzzle_slide              <int> 16
#> $ puzzle_word               <int> 29
#> $ race                      <int> 1262
#> $ strength                  <int> 136
#> $ turn_based                <int> 230
#> $ water                     <int> 347
#> $ water_paddling            <int> 146
#> $ water_swim                <int> 253
```

See the help manual for more detailed descriptions of the features.

### Challenge Summary

The `challenge_summary` table is solving an annoying problem with
`challenge_results` and the way some challenges are constructed. You may
want to count how many individual challenges someone has won, or tribal
immunities, etc. To do so you’ll have to use the `challenge_type`,
`outcome_type`, and `results` fields. There are some challenges which
are combined e.g. `Team / Individual` challenges which makes this not a
straight process to summarise the table.

Hence why `challenge_summary` exisits. The `category` column consists of
the following categories:

- All: All challenge types
- Reward
- Immunity
- Tribal
- Tribal Reward
- Tribal Immunity
- Individual
- Individual Reward
- Individual Immunity
- Team
- Team Reward
- Team Immunity
- Duel

There is obviously overlap with the categories but this structure makes
it simple to summarise the table how you desire e.g.

``` r
challenge_summary |> 
  group_by(category, version_season, castaway) |> 
  summarise(
    n_challenges = n(), 
    n_won = sum(won)
    )
#> `summarise()` has grouped output by 'category', 'version_season'. You can
#> override using the `.groups` argument.
#> # A tibble: 7,486 × 5
#> # Groups:   category, version_season [502]
#>    category version_season castaway n_challenges n_won
#>    <chr>    <chr>          <chr>           <int> <dbl>
#>  1 All      US01           B.B.                3     2
#>  2 All      US01           Colleen            21     8
#>  3 All      US01           Dirk                9     4
#>  4 All      US01           Gervase            18     8
#>  5 All      US01           Greg               14     8
#>  6 All      US01           Gretchen           12     6
#>  7 All      US01           Jenna              16     6
#>  8 All      US01           Joel               11     6
#>  9 All      US01           Kelly              25    10
#> 10 All      US01           Ramona              7     3
#> # ℹ 7,476 more rows
```

See the R docs for more details on the fields. Join to
`challenge_results` with `version_season` and `challenge_id`.

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
#>  1 US      US45           Survivor: …     45 Bruce    Austin       1 US0657     
#>  2 US      US45           Survivor: …     45 Drew     Austin       1 US0667     
#>  3 US      US45           Survivor: …     45 Emily    Austin       0 US0668     
#>  4 US      US45           Survivor: …     45 Julie    Austin       0 US0672     
#>  5 US      US45           Survivor: …     45 Kaleb    Austin       0 US0673     
#>  6 US      US45           Survivor: …     45 Katurah  Austin       0 US0674     
#>  7 US      US45           Survivor: …     45 Kellie   Austin       0 US0675     
#>  8 US      US45           Survivor: …     45 Kendra   Austin       1 US0676     
#>  9 US      US45           Survivor: …     45 Bruce    Dee          0 US0657     
#> 10 US      US45           Survivor: …     45 Drew     Dee          0 US0667     
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
#>    <chr>   <chr>          <chr>         <dbl>        <dbl> <chr>               
#>  1 US      US45           Survivor: 45     45           NA Amulet              
#>  2 US      US45           Survivor: 45     45           NA Amulet              
#>  3 US      US45           Survivor: 45     45           NA Amulet              
#>  4 US      US45           Survivor: 45     45           NA Challenge Advantage 
#>  5 US      US45           Survivor: 45     45           NA Goodwill Advantage  
#>  6 US      US45           Survivor: 45     45           NA Hidden Immunity Idol
#>  7 US      US45           Survivor: 45     45           NA Hidden Immunity Idol
#>  8 US      US45           Survivor: 45     45           NA Hidden Immunity Idol
#>  9 US      US45           Survivor: 45     45           NA Hidden Immunity Idol
#> 10 US      US45           Survivor: 45     45           NA Safety Without Power
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
#> #   season <dbl>, castaway <chr>, castaway_id <chr>, advantage_id <dbl>,
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
#> # A tibble: 22 × 19
#>    version version_season season_name  season  item item_description    category
#>    <chr>   <chr>          <chr>         <dbl> <dbl> <chr>               <chr>   
#>  1 US      US45           Survivor: 45     45     1 Salty Pretzels And… Food an…
#>  2 US      US45           Survivor: 45     45     2 French Fries, Ketc… Food an…
#>  3 US      US45           Survivor: 45     45     3 Cheese Platter, De… Food an…
#>  4 US      US45           Survivor: 45     45     4 Chocolate Milkshake Food an…
#>  5 US      US45           Survivor: 45     45     5 Two Giant Fish Eyes Bad item
#>  6 US      US45           Survivor: 45     45     5 Two Giant Fish Eyes Bad item
#>  7 US      US45           Survivor: 45     45     6 Bowl Of Lollies An… Food an…
#>  8 US      US45           Survivor: 45     45     7 Slice Of Pepperoni… Food an…
#>  9 US      US45           Survivor: 45     45     8 Toothbrush And Too… Comfort 
#> 10 US      US45           Survivor: 45     45     9 Chocolate Cake      Food an…
#> # ℹ 12 more rows
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
issues and I’ll see what I can do.

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
