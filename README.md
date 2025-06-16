
<img src='https://cranlogs.r-pkg.org/badges/survivoR'/><img src='https://cranlogs.r-pkg.org/badges/grand-total/survivoR'/><img src='https://www.r-pkg.org/badges/version/survivoR'/>

# survivoR <img src='dev/images/hex-flame-final.png' align="right" height="240" />

74 seasons. 1403 people. 1 package!

survivoR is a collection of data sets detailing events across 74 seasons
of Survivor US, Australia, South Africa, New Zealand and UK. It includes
castaway information, vote history, immunity and reward challenge
winners, jury votes, advantage details and a lot more.

For analysis and updates you can follow me on Bluesky
[@danoehm.bsky.social](https://bsky.app/profile/danoehm.bsky.social)

For those that aren’t R users you can get the data on [Google
Sheets](https://docs.google.com/spreadsheets/d/1Xhod9FdVFr69hrX7No40WZAz0ZmhO_5x6WghxawuSno/edit?gid=1849373991#gid=1849373991)
as wel, or [download as an
xlsx](https://github.com/doehm/survivoR/raw/refs/heads/master/dev/xlsx/survivoR.xlsx).

You can also access the data in [JSON
format](https://github.com/doehm/survivoR/tree/master/dev/json) to feed
directly into applications

# Installation

Install from CRAN (**v2.3.6**) or Git (**v2.3.6**).

If Git \> CRAN I’d suggest install from Git. We are constantly improving
the data sets so the github version is likely to be slightly improved.

``` r
install.packages("survivoR")
```

``` r
devtools::install_github("doehm/survivoR")
```

# News: survivoR 2.3.6

<img src='https://img.shields.io/badge/col-new-green'/>

- Adding complete US48 data
- Huge update to `castaway_scores`
- new `boot_order` data set
- `season_name` has been deprecated from all tables other than
  `season_summary`
- Season 50 cast added

# [SURVIVOR STATS DB](https://survivorstatsdb.com)

[SURVIVOR STATS DB](https://survivorstatsdb.com) is the survivoR
package’s companion. It holds interactive tables and charts detailing
the castaways, challenges, vote history, confessionals, ratings, and
more.

[<img style='border-radius: 50%;' src='dev/images/flame.png' height="240"/>](https://survivorstatsdb.com)

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
5.  `castaway_scores`
6.  `castaways`
7.  `challenge_results`
8.  `challenge_description`
9.  `challenge_summary`
10. `confessionals`
11. `jury_votes`
12. `season_summary`
13. `tribe_colours`
14. `tribe_mapping`
15. `episodes`
16. `vote_history`
17. `survivor_auction`
18. `auction_details`
19. `screen_time`
20. `season_palettes`
21. `journeys`

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
#> # A tibble: 74 × 26
#>    version version_season season_name season location country tribe_setup n_cast
#>    <chr>   <chr>          <chr>        <dbl> <chr>    <chr>   <chr>        <int>
#>  1 US      US01           Survivor: …      1 Pulau T… Malays… "Two tribe…     16
#>  2 US      US02           Survivor: …      2 Herbert… Austra… "Two tribe…     16
#>  3 US      US03           Survivor: …      3 Shaba N… Kenya   "Two tribe…     16
#>  4 US      US04           Survivor: …      4 Nuku Hi… France  "Two tribe…     16
#>  5 US      US05           Survivor: …      5 Ko Taru… Thaila… "Two tribe…     16
#>  6 US      US06           Survivor: …      6 Rio Neg… Brazil  "Two tribe…     16
#>  7 US      US07           Survivor: …      7 Pearl I… Panama  "Two tribe…     16
#>  8 US      US08           Survivor: …      8 Pearl I… Panama  "Three tri…     18
#>  9 US      US09           Survivor: …      9 Efate, … Vanuatu "Two tribe…     18
#> 10 US      US10           Survivor: …     10 Koror, … Palau   "A schooly…     20
#> 11 US      US11           Survivor: …     11 Laguna … Guatem… "Two tribe…     18
#> 12 US      US12           Survivor: …     12 Pearl I… Panama  "Four trib…     16
#> 13 US      US13           Survivor: …     13 Aitutak… Islands "Four trib…     20
#> 14 US      US14           Survivor: …     14 Macuata… Fiji    "Two tribe…     19
#> 15 US      US15           Survivor: …     15 Zhelin,… China   "Two tribe…     16
#> 16 US      US16           Survivor: …     16 Koror, … Palau   "Two tribe…     20
#> 17 US      US17           Survivor: …     17 Wonga-W… Gabon   "A schooly…     18
#> 18 US      US18           Survivor: …     18 Jalapao… Brazil  "Two tribe…     16
#> 19 US      US19           Survivor: …     19 Upolu, … Samoa   "Two tribe…     20
#> 20 US      US20           Survivor: …     20 Upolu, … Samoa   "Two tribe…     20
#> 21 US      US21           Survivor: …     21 San Jua… Nicara… "Two tribe…     20
#> 22 US      US22           Survivor: …     22 San Jua… Nicara… "Two tribe…     18
#> 23 US      US23           Survivor: …     23 San Jua… Nicara… "Upolu, Sa…     18
#> 24 US      US24           Survivor: …     24 San Jua… Nicara… "Two tribe…     18
#> 25 US      US25           Survivor: …     25 Caramoa… Philip… "Three tri…     18
#> 26 US      US26           Survivor: …     26 Caramoa… Philip… "Two tribe…     20
#> 27 US      US27           Survivor: …     27 Palaui … Philip… "Two tribe…     20
#> 28 US      US28           Survivor: …     28 Palaui … Philip… "Three tri…     18
#> 29 US      US29           Survivor: …     29 San Jua… Nicara… "Nine pair…     18
#> 30 US      US30           Survivor: …     30 San Jua… Nicara… "Three tri…     18
#> # ℹ 44 more rows
#> # ℹ 18 more variables: n_tribes <int>, n_finalists <int>, n_jury <int>,
#> #   full_name <chr>, winner_id <chr>, winner <chr>, runner_ups <chr>,
#> #   final_vote <chr>, timeslot <chr>, premiered <date>, ended <date>,
#> #   filming_started <date>, filming_ended <date>, viewers_reunion <dbl>,
#> #   viewers_premiere <dbl>, viewers_finale <dbl>, viewers_mean <dbl>,
#> #   rank <dbl>
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
#> Error in eval(expr, envir, enclos): object 'season' not found
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

I have included a `collar` field is experimental and derived from a
language model. I suggest caution with it’s use as many occupations may
not fit neatly into a classification.

``` r
castaway_details
#> # A tibble: 1,160 × 22
#>    castaway_id full_name     full_name_detailed castaway last_name date_of_birth
#>    <chr>       <chr>         <chr>              <chr>    <chr>     <date>       
#>  1 US0001      Sonja Christ… Sonja Christopher  Sonja    Christop… 1937-01-28   
#>  2 US0002      B.B. Andersen B.B. Andersen      B.B.     Andersen  1936-01-18   
#>  3 US0003      Stacey Still… Stacey Stillman    Stacey   Stillman  1972-08-11   
#>  4 US0004      Ramona Gray   Ramona Gray        Ramona   Gray      1971-01-20   
#>  5 US0005      Dirk Been     Dirk Been          Dirk     Been      1976-06-15   
#>  6 US0006      Joel Klug     Joel Klug          Joel     Klug      1972-04-13   
#>  7 US0007      Gretchen Cor… Gretchen Cordy     Gretchen Cordy     1962-02-07   
#>  8 US0008      Greg Buis     Greg Buis          Greg     Buis      1975-12-31   
#>  9 US0009      Jenna Lewis   Jenna Lewis        Jenna L. Lewis     1977-07-16   
#> 10 US0010      Gervase Pete… Gervase Peterson   Gervase  Peterson  1969-11-02   
#> 11 US0011      Colleen Hask… Colleen Haskell    Colleen  Haskell   1976-12-06   
#> 12 US0012      Sean Kenniff  Sean Kenniff       Sean     Kenniff   1969-11-27   
#> 13 US0013      Susan Hawk    Susan Hawk         Sue      Hawk      1961-08-17   
#> 14 US0014      Rudy Boesch   Rudy Boesch        Rudy     Boesch    1928-01-20   
#> 15 US0015      Kelly Wigles… Kelly Wiglesworth  Kelly    Wigleswo… 1977-06-24   
#> 16 US0016      Richard Hatch Richard Hatch      Richard  Hatch     1961-04-08   
#> 17 US0017      Debb Eaton    Debb Eaton         Debb     Eaton     1955-06-11   
#> 18 US0018      Kel Gleason   Kel Gleason        Kel      Gleason   1968-01-05   
#> 19 US0019      Maralyn Hers… Maralyn Hershey    Maralyn  Hershey   1949-01-24   
#> 20 US0020      Mitchell Ols… Mitchell Olson     Mitchell Olson     1977-03-17   
#> 21 US0021      Kimmi Kappen… Kimmi Kappenberg   Kimmi    Kappenbe… 1972-11-11   
#> 22 US0022      Michael Skup… Michael Skupin     Michael  Skupin    1962-01-29   
#> 23 US0023      Jeff Varner   Jeff Varner        Jeff     Varner    1966-04-16   
#> 24 US0024      Alicia Calaw… Alicia Calaway     Alicia   Calaway   1968-05-01   
#> 25 US0025      Jerri Manthey Jerri Manthey      Jerri    Manthey   1970-09-05   
#> 26 US0026      Nick Brown    Nick Brown         Nick     Brown     1977-04-02   
#> 27 US0027      Amber Mariano Amber Mariano      Amber    Mariano   1978-08-11   
#> 28 US0028      Rodger Bingh… Rodger Bingham     Rodger   Bingham   1947-07-05   
#> 29 US0029      Elisabeth Fi… Elisabeth Filarski Elisabe… Filarski  1977-05-28   
#> 30 US0030      Keith Famie   Keith Famie        Keith    Famie     1960-02-11   
#> # ℹ 1,130 more rows
#> # ℹ 16 more variables: date_of_death <date>, gender <chr>, african <lgl>,
#> #   asian <lgl>, latin_american <lgl>, native_american <lgl>, bipoc <lgl>,
#> #   lgbt <lgl>, personality_type <chr>, occupation <chr>, collar <chr>,
#> #   three_words <chr>, hobbies <chr>, pet_peeves <chr>, race <chr>,
#> #   ethnicity <chr>
```

## Castaway scores

I have created a measure for challenge success, vote history or tribal
council success and advantage success. For more details please see
follow the links:

[Challenge score
methodology](https://gradientdescending.com/the-sanctuary/full-challenges-list-all.html#details)

[Vote history
mothodology](https://gradientdescending.com/the-sanctuary/full-vote-list.html#details)

``` r
castaway_scores
#> # A tibble: 875 × 52
#>    version version_season season castaway castaway_id score_overall score_result
#>    <chr>   <chr>           <dbl> <chr>    <chr>               <dbl>        <dbl>
#>  1 US      US01                1 Sonja    US0001             0.0535       0     
#>  2 US      US01                1 B.B.     US0002             0.0897       0.0714
#>  3 US      US01                1 Stacey   US0003             0.133        0.143 
#>  4 US      US01                1 Ramona   US0004             0.215        0.214 
#>  5 US      US01                1 Dirk     US0005             0.277        0.286 
#>  6 US      US01                1 Joel     US0006             0.334        0.357 
#>  7 US      US01                1 Gretchen US0007             0.519        0.429 
#>  8 US      US01                1 Greg     US0008             0.510        0.5   
#>  9 US      US01                1 Jenna    US0009             0.465        0.571 
#> 10 US      US01                1 Gervase  US0010             0.527        0.643 
#> 11 US      US01                1 Colleen  US0011             0.548        0.714 
#> 12 US      US01                1 Sean     US0012             0.484        0.786 
#> 13 US      US01                1 Sue      US0013             0.503        0.857 
#> 14 US      US01                1 Rudy     US0014             0.511        0.929 
#> 15 US      US01                1 Kelly    US0015             0.786        1     
#> 16 US      US01                1 Richard  US0016             0.647        1     
#> 17 US      US02                2 Debb     US0017             0.0535       0     
#> 18 US      US02                2 Kel      US0018             0.0881       0.0714
#> 19 US      US02                2 Maralyn  US0019             0.227        0.143 
#> 20 US      US02                2 Mitchell US0020             0.264        0.214 
#> 21 US      US02                2 Kimmi    US0021             0.284        0.286 
#> 22 US      US02                2 Michael  US0022             0.431        0.357 
#> 23 US      US02                2 Jeff     US0023             0.479        0.429 
#> 24 US      US02                2 Alicia   US0024             0.481        0.5   
#> 25 US      US02                2 Jerri    US0025             0.518        0.571 
#> 26 US      US02                2 Nick     US0026             0.527        0.643 
#> 27 US      US02                2 Amber    US0027             0.440        0.714 
#> 28 US      US02                2 Rodger   US0028             0.459        0.786 
#> 29 US      US02                2 Elisabe… US0029             0.480        0.857 
#> 30 US      US02                2 Keith    US0030             0.546        0.929 
#> # ℹ 845 more rows
#> # ℹ 45 more variables: score_jury <dbl>, score_vote <dbl>, score_adv <dbl>,
#> #   score_inf <dbl>, r_score_chal_all <dbl>, r_score_chal_immunity <dbl>,
#> #   r_score_chal_reward <dbl>, r_score_chal_tribal <dbl>,
#> #   r_score_chal_tribal_immunity <dbl>, r_score_chal_tribal_reward <dbl>,
#> #   r_score_chal_individual <dbl>, r_score_chal_individual_immunity <dbl>,
#> #   r_score_chal_individual_reward <dbl>, r_score_chal_team <dbl>, …
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
#> Error in eval(expr, envir, enclos): object 'episode' not found
vh
#> Error in eval(expr, envir, enclos): object 'vh' not found
```

``` r
vh |> 
  count(vote)
#> Error in eval(expr, envir, enclos): object 'vh' not found
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
#> Error in eval(expr, envir, enclos): object 'season' not found
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
#> # A tibble: 1,864 × 45
#>    version version_season season episode challenge_id challenge_number
#>    <fct>   <chr>           <dbl>   <dbl>        <dbl>            <dbl>
#>  1 US      US01                1       1            1                1
#>  2 US      US01                1       2            2                1
#>  3 US      US01                1       2            3                2
#>  4 US      US01                1       3            4                1
#>  5 US      US01                1       3            5                2
#>  6 US      US01                1       4            6                1
#>  7 US      US01                1       4            7                2
#>  8 US      US01                1       5            8                1
#>  9 US      US01                1       5            9                2
#> 10 US      US01                1       6           10                1
#> 11 US      US01                1       6           11                2
#> 12 US      US01                1       7           12                1
#> 13 US      US01                1       8           13                1
#> 14 US      US01                1       8           14                2
#> 15 US      US01                1       9           15                1
#> 16 US      US01                1       9           16                2
#> 17 US      US01                1      10           17                1
#> 18 US      US01                1      10           18                2
#> 19 US      US01                1      11           19                1
#> 20 US      US01                1      11           20                2
#> 21 US      US01                1      11           21                3
#> 22 US      US01                1      12           22                1
#> 23 US      US01                1      12           23                2
#> 24 US      US01                1      13           24                1
#> 25 US      US01                1      13           25                2
#> 26 US      US02                2       1            1                1
#> 27 US      US02                2       2            2                1
#> 28 US      US02                2       2            3                2
#> 29 US      US02                2       3            4                1
#> 30 US      US02                2       3            5                2
#> # ℹ 1,834 more rows
#> # ℹ 39 more variables: challenge_type <chr>, name <chr>, recurring_name <chr>,
#> #   description <chr>, reward <chr>, additional_stipulation <chr>,
#> #   balance <lgl>, balance_ball <lgl>, balance_beam <lgl>, endurance <lgl>,
#> #   fire <lgl>, food <lgl>, knowledge <lgl>, memory <lgl>, mud <lgl>,
#> #   obstacle_blindfolded <lgl>, obstacle_cargo_net <lgl>,
#> #   obstacle_chopping <lgl>, obstacle_combination_lock <lgl>, …

challenge_description |> 
  summarise_if(is_logical, ~sum(.x, na.rm = TRUE)) |> 
  glimpse()
#> Rows: 1
#> Columns: 33
#> $ balance                   <int> 356
#> $ balance_ball              <int> 46
#> $ balance_beam              <int> 154
#> $ endurance                 <int> 449
#> $ fire                      <int> 68
#> $ food                      <int> 24
#> $ knowledge                 <int> 77
#> $ memory                    <int> 29
#> $ mud                       <int> 49
#> $ obstacle_blindfolded      <int> 52
#> $ obstacle_cargo_net        <int> 149
#> $ obstacle_chopping         <int> 32
#> $ obstacle_combination_lock <int> 22
#> $ obstacle_digging          <int> 96
#> $ obstacle_knots            <int> 40
#> $ obstacle_padlocks         <int> 74
#> $ precision                 <int> 301
#> $ precision_catch           <int> 64
#> $ precision_roll_ball       <int> 13
#> $ precision_slingshot       <int> 54
#> $ precision_throw_balls     <int> 79
#> $ precision_throw_coconuts  <int> 23
#> $ precision_throw_rings     <int> 20
#> $ precision_throw_sandbags  <int> 63
#> $ puzzle                    <int> 408
#> $ puzzle_slide              <int> 17
#> $ puzzle_word               <int> 29
#> $ race                      <int> 1331
#> $ strength                  <int> 131
#> $ turn_based                <int> 237
#> $ water                     <int> 357
#> $ water_paddling            <int> 149
#> $ water_swim                <int> 262
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
#> # A tibble: 11,667 × 5
#> # Groups:   category, version_season [756]
#>    category version_season castaway      n_challenges n_won
#>    <chr>    <chr>          <chr>                <int> <dbl>
#>  1 All      AU01           Andrew                  17     7
#>  2 All      AU01           Barry                    9     5
#>  3 All      AU01           Bianca                   3     2
#>  4 All      AU01           Brooke                  29    20
#>  5 All      AU01           Conner                  22     8
#>  6 All      AU01           Craig                   18     7
#>  7 All      AU01           Des                      2     0
#>  8 All      AU01           El                      35    16
#>  9 All      AU01           Evan                     5     1
#> 10 All      AU01           Flick                   34    18
#> 11 All      AU01           Jennah-Louise           27    18
#> 12 All      AU01           Kat                     15     5
#> 13 All      AU01           Kate                    23     7
#> 14 All      AU01           Kristie                 35     6
#> 15 All      AU01           Kylie                   25    19
#> 16 All      AU01           Lee                     35    17
#> 17 All      AU01           Matt                    33    18
#> 18 All      AU01           Nick                    24    17
#> 19 All      AU01           Peter                    6     5
#> 20 All      AU01           Phoebe                  21     5
#> 21 All      AU01           Rohan                   14     5
#> 22 All      AU01           Sam                     32    18
#> 23 All      AU01           Sue                     26     7
#> 24 All      AU01           Tegan                   11     7
#> 25 All      AU02           AK                      21    12
#> 26 All      AU02           Adam                     5     3
#> 27 All      AU02           Aimee                   10     5
#> 28 All      AU02           Anneliese               28    13
#> 29 All      AU02           Ben                     22    11
#> 30 All      AU02           Henry                   29    15
#> # ℹ 11,637 more rows
```

How to add the challenge scores to challenge summary.

``` r

challenge_summary |>
  group_by(category, version_season, castaway_id, castaway) |>
  summarise(
    n_challenges = n_distinct(challenge_id),
    n_won = sum(won),
    .groups = "drop"
  ) |>
  left_join(
    castaway_scores |>
      select(version_season, castaway_id, starts_with("score_chal")) |>
      pivot_longer(c(-version_season, -castaway_id), names_to = "category", values_to = "score") |>
      mutate(
        category = str_remove(category, "score_chal_"),
        category = str_replace_all(category, "_", " "),
        category = str_to_title(category)
      ) |>
      select(category, version_season, castaway_id, score),
    join_by(category, version_season, castaway_id)
  )
#> Error in `pivot_longer()`:
#> ! `cols` must select at least one column.
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
#> Error in eval(expr, envir, enclos): object 'season' not found
```

``` r
jury_votes |> 
  filter(season == 45) |> 
  group_by(finalist) |> 
  summarise(votes = sum(vote))
#> Error in eval(expr, envir, enclos): object 'season' not found
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
#> Error in eval(expr, envir, enclos): object 'season' not found
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
#> Error in eval(expr, envir, enclos): object 'advantage_id' not found
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
#> Error in eval(expr, envir, enclos): object 'season' not found
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
#> Error in eval(expr, envir, enclos): object 'season' not found
```

</details>
<details>
<summary>
<strong>Screen time</strong>
</summary>

## Screen time \[EXPERIMENTAL\]

This dataset contains the estimated screen time for each castaway during
an episode. Please note that this is still in the early days of
development. There is likely to be misclassification and other sources
of error. The model will be refined over time.

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
#> Error in eval(expr, envir, enclos): object 'version_season' not found
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
#> Error in still_alive("US", 45, 6): object 'season' not found
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
#> Error in eval(expr, envir, enclos): object 'season' not found
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
#> Error in eval(expr, envir, enclos): object 'season' not found
```

</details>
<details>
<summary>
<strong>Journeys</strong>
</summary>

## Journeys

Details on Journeys in the New Era including the advantage they won and
if they lost their vote.

``` r
journeys |> 
  filter(season == 45)
#> Error in eval(expr, envir, enclos): object 'season' not found
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
- [**Matt
  Stiles**](https://github.com/stiles/survivor-voteoffs?tab=readme-ov-file)
  for collecting and contributing the acknowledgment features on the
  `castaways` data frame.
- **Camilla Bendetti** for collating the personality type data for each
  castaway.
- **Uygar Sozer** for adding the filming start and end dates for each
  season.
- **Holt Skinner** for creating the castaway ID to map people across
  seasons and manage name changes.
- **Kosta Psaltis** for the original race data.

# References

Data was sourced from
[Wikipedia](https://en.wikipedia.org/wiki/Survivor_(American_TV_series))
and the [Survivor Wiki](https://survivor.fandom.com/wiki/Main_Page).
Other data, such as the tribe colours, was manually recorded and entered
by myself and contributors.

<!-- Torch graphic in hex: [Fire Torch Vectors by Vecteezy](https://www.vecteezy.com/free-vector/fire-torch) -->
