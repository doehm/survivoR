
<img src='https://cranlogs.r-pkg.org/badges/survivoR'/><img src='https://cranlogs.r-pkg.org/badges/grand-total/survivoR'/><img src='https://www.r-pkg.org/badges/version/survivoR'/>

# survivoR <img src='dev/images/hex-flame-final.png' align="right" height="240" />

72 seasons. 1361 people. 1 package!

survivoR is a collection of data sets detailing events across 72 seasons
of Survivor US, Australia, South Africa, New Zealand and UK. It includes
castaway information, vote history, immunity and reward challenge
winners, jury votes, advantage details and a lot more.

For analysis and updates you can follow me on Bluesky
[@danoehm.bsky.social](https://bsky.app/profile/danoehm.bsky.social) or
Threads [@\_survivordb](https://www.threads.net/@_survivordb)

For those that aren’t R users you can get the data on [Google
Sheets](https://docs.google.com/spreadsheets/d/1Xhod9FdVFr69hrX7No40WZAz0ZmhO_5x6WghxawuSno/edit?gid=1849373991#gid=1849373991)
as well.

Or [download as an
xlsx](https://github.com/doehm/survivoR/raw/refs/heads/master/dev/xlsx/survivoR.xlsx).

You can also access the data in [JSON
format](https://github.com/doehm/survivoR/tree/master/dev/json) to feed
directly into applications

# Installation

Install from CRAN (**v2.3.5**) or Git (**v2.3.6**).

If Git \> CRAN I’d suggest install from Git. We are constantly improving
the data sets so the github version is likely to be slightly improved.

``` r
install.packages("survivoR")
```

``` r
devtools::install_github("doehm/survivoR")
```

# News: survivoR 2.3.5

<img src='https://img.shields.io/badge/col-new-green'/>

- Adding complete US47 data
- Adding new `castaway_scores` dataset
- Adding new `add_*` functions:
  - `add_alive()`: Adds a logical flag if the castaway is alive at the
    start or end of an episode
  - `add_bipoc()`: Adds a BIPOC to the data frame. If any African
    American (or Canadian), Asian American, Latin American, or Native
    American is `TRUE` then BIPOC is `TRUE`.
  - `add_castaway()`: Adds castaway to a data frame. Input data frame
    must have `castaway_id`.
  - `add_demogs()`: Add demographics that includes age, gender,
    race/ethnicity, and LGBTQIA+ status to a data frame with
    castaway_id.
  - `add_finalist()`: Adds a winner flag to the dataset.
  - `add_full_name()`: Adds full name to the data frame. Useful for
    plotting and making tables.
  - `add_gender()`: Adds gender to a data frame
  - `add_jury()`: Adds a jury member flag to the data set.
  - `add_lgbt()`: Adds the LGBTQIA+ flag to the data frame.
  - `add_result()`: Adds the `result` and `place` to the data frame.
  - `add_tribe()`: Adds tribe to a data frame for a specified stage of
    the game e.g. `original`, `swapped`, `swapped_2`, etc.
  - `add_tribe_colour()`: Add tribe colour to the data frame. Useful for
    preparing the data for plotting with ggplot2.
  - `add_winner()`: Adds a winner flag to the data set.
- Adding new `filter_*` functions:
  - `filter_alive()`: Filters a given dataset to those that are still
    alive in the game at the start or end of a user specified episode.
  - `filter_final_n()`: Filters to the final `n` players e.g. the final
    5.
  - `filter_finalist()`: Filters a dataset to the finalists of a given
    season.
  - `filter_jury()`: Filters a dataset to the jury members of a given
    season.
  - `filter_new_era()`: Filters a dataset to all New Era seasons.
  - `filter_us()`: Filter a dataset to a specified set of US season or
    list of seasons. A shorthand version of `filter_vs()` for the US
    seasons.
  - `filter_vs()`: Filters a data set to a specified version season or
    list of version seasons.
  - `filter_winner()`: Filters a data set to the winners of a given
    season.

# [The Sanctuary](https://gradientdescending.com/the-sanctuary/)

[The Sanctuary](https://gradientdescending.com/the-sanctuary/) is the
survivoR package’s companion. It holds interactive tables and charts
detailing the castaways, challenges, vote history, confessionals,
ratings, and more. Confessional counts from
[myself](https://twitter.com/danoehm), [Carly
Levitz](https://twitter.com/carlylevitz),
[Sam](https://twitter.com/survivorfansam), Grace.

[<img src='dev/images/flame.png' height="240"/>](https://gradientdescending.com/the-sanctuary/)

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
#> # A tibble: 72 × 26
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
#> # ℹ 42 more rows
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
#> # A tibble: 18 × 26
#>    version version_season season full_name      castaway_id castaway   age city 
#>    <chr>   <chr>           <dbl> <chr>          <chr>       <chr>    <dbl> <chr>
#>  1 US      US45               45 Hannah Rose    US0669      Hannah      33 Balt…
#>  2 US      US45               45 Brandon Donlon US0665      Brandon     25 Sick…
#>  3 US      US45               45 Sabiyah Brode… US0677      Sabiyah     27 Jack…
#>  4 US      US45               45 Sean Edwards   US0678      Sean        34 Prov…
#>  5 US      US45               45 Brando Meyer   US0664      Brando      23 Seat…
#>  6 US      US45               45 J. Maya        US0670      J. Maya     24 Los …
#>  7 US      US45               45 Sifu Alsup     US0679      Sifu        30 O'Fa…
#>  8 US      US45               45 Kaleb Gebrewo… US0673      Kaleb       29 Vanc…
#>  9 US      US45               45 Kellie Nalban… US0675      Kellie      30 New …
#> 10 US      US45               45 Kendra McQuar… US0676      Kendra      30 Stea…
#> 11 US      US45               45 Bruce Perreau… US0657      Bruce       46 Warw…
#> 12 US      US45               45 Emily Flippen  US0668      Emily       28 Laur…
#> 13 US      US45               45 Drew Basile    US0667      Drew        23 Phil…
#> 14 US      US45               45 Julie Alley    US0672      Julie       49 Bren…
#> 15 US      US45               45 Katurah Topps  US0674      Katurah     34 Broo…
#> 16 US      US45               45 Jake O'Kane    US0671      Jake        26 Bost…
#> 17 US      US45               45 Austin Li Coon US0663      Austin      26 Chic…
#> 18 US      US45               45 Dee Valladares US0666      Dee         26 Miami
#> # ℹ 18 more variables: state <chr>, episode <dbl>, day <dbl>, order <dbl>,
#> #   result <chr>, place <dbl>, jury_status <chr>, original_tribe <chr>,
#> #   jury <lgl>, finalist <lgl>, winner <lgl>, acknowledge <lgl>,
#> #   ack_look <lgl>, ack_speak <lgl>, ack_gesture <lgl>, ack_smile <lgl>,
#> #   ack_quote <chr>, ack_score <dbl>
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
#> # A tibble: 1,160 × 21
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
#> 11 US0011      Colleen … Colleen Haskell    Colleen  1976-12-06    NA           
#> 12 US0012      Sean Ken… Sean Kenniff       Sean     1969-11-27    NA           
#> 13 US0013      Susan Ha… Susan Hawk         Sue      1961-08-17    NA           
#> 14 US0014      Rudy Boe… Rudy Boesch        Rudy     1928-01-20    2019-11-01   
#> 15 US0015      Kelly Wi… Kelly Wiglesworth  Kelly    1977-06-24    NA           
#> 16 US0016      Richard … Richard Hatch      Richard  1961-04-08    NA           
#> 17 US0017      Debb Eat… Debb Eaton         Debb     1955-06-11    NA           
#> 18 US0018      Kel Glea… Kel Gleason        Kel      1968-01-05    NA           
#> 19 US0019      Maralyn … Maralyn Hershey    Maralyn  1949-01-24    NA           
#> 20 US0020      Mitchell… Mitchell Olson     Mitchell 1977-03-17    NA           
#> 21 US0021      Kimmi Ka… Kimmi Kappenberg   Kimmi    1972-11-11    NA           
#> 22 US0022      Michael … Michael Skupin     Michael  1962-01-29    NA           
#> 23 US0023      Jeff Var… Jeff Varner        Jeff     1966-04-16    NA           
#> 24 US0024      Alicia C… Alicia Calaway     Alicia   1968-05-01    NA           
#> 25 US0025      Jerri Ma… Jerri Manthey      Jerri    1970-09-05    NA           
#> 26 US0026      Nick Bro… Nick Brown         Nick     1977-04-02    NA           
#> 27 US0027      Amber Ma… Amber Mariano      Amber    1978-08-11    NA           
#> 28 US0028      Rodger B… Rodger Bingham     Rodger   1947-07-05    NA           
#> 29 US0029      Elisabet… Elisabeth Filarski Elisabe… 1977-05-28    NA           
#> 30 US0030      Keith Fa… Keith Famie        Keith    1960-02-11    NA           
#> # ℹ 1,130 more rows
#> # ℹ 15 more variables: gender <chr>, african <lgl>, asian <lgl>,
#> #   latin_american <lgl>, native_american <lgl>, bipoc <lgl>, lgbt <lgl>,
#> #   personality_type <chr>, occupation <chr>, collar <chr>, three_words <chr>,
#> #   hobbies <chr>, pet_peeves <chr>, race <chr>, ethnicity <chr>
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
#> # A tibble: 1,361 × 31
#>    version version_season season castaway_id castaway  score_chal_all
#>    <chr>   <chr>           <dbl> <chr>       <chr>              <dbl>
#>  1 US      US01                1 US0001      Sonja              -0.5 
#>  2 US      US01                1 US0002      B.B.                0.5 
#>  3 US      US01                1 US0003      Stacey             -0.5 
#>  4 US      US01                1 US0004      Ramona             -0.5 
#>  5 US      US01                1 US0005      Dirk               -0.5 
#>  6 US      US01                1 US0006      Joel                0.5 
#>  7 US      US01                1 US0007      Gretchen            0.4 
#>  8 US      US01                1 US0008      Greg                2.18
#>  9 US      US01                1 US0009      Jenna              -0.07
#> 10 US      US01                1 US0010      Gervase             1.64
#> 11 US      US01                1 US0011      Colleen             1.14
#> 12 US      US01                1 US0012      Sean               -1.26
#> 13 US      US01                1 US0013      Sue                -2.51
#> 14 US      US01                1 US0014      Rudy               -1.84
#> 15 US      US01                1 US0015      Kelly               2.16
#> 16 US      US01                1 US0016      Richard            -1.84
#> 17 US      US02                2 US0017      Debb               -0.5 
#> 18 US      US02                2 US0018      Kel                 0.5 
#> 19 US      US02                2 US0019      Maralyn             0.5 
#> 20 US      US02                2 US0020      Mitchell           -0.5 
#> 21 US      US02                2 US0021      Kimmi               0.5 
#> 22 US      US02                2 US0022      Michael             1   
#> 23 US      US02                2 US0023      Jeff                0.9 
#> 24 US      US02                2 US0024      Alicia              0.68
#> 25 US      US02                2 US0025      Jerri               0.3 
#> 26 US      US02                2 US0026      Nick                1.16
#> 27 US      US02                2 US0027      Amber              -2.17
#> 28 US      US02                2 US0028      Rodger             -0.57
#> 29 US      US02                2 US0029      Elisabeth          -1.07
#> 30 US      US02                2 US0030      Keith              -1.41
#> # ℹ 1,331 more rows
#> # ℹ 25 more variables: score_chal_immunity <dbl>, score_chal_reward <dbl>,
#> #   score_chal_tribal <dbl>, score_chal_tribal_immunity <dbl>,
#> #   score_chal_tribal_reward <dbl>, score_chal_individual <dbl>,
#> #   score_chal_individual_immunity <dbl>, score_chal_individual_reward <dbl>,
#> #   score_chal_team <dbl>, score_chal_team_reward <dbl>,
#> #   score_chal_team_immunity <dbl>, score_chal_duel <dbl>, …
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
#> # A tibble: 9 × 23
#>   version version_season season episode   day tribe_status tribe    castaway
#>   <chr>   <chr>           <dbl>   <dbl> <dbl> <chr>        <chr>    <chr>   
#> 1 US      US45               45       9    17 Merged       Dakuwaqa Bruce   
#> 2 US      US45               45       9    17 Merged       Dakuwaqa Jake    
#> 3 US      US45               45       9    17 Merged       Dakuwaqa Katurah 
#> 4 US      US45               45       9    17 Merged       Dakuwaqa Dee     
#> 5 US      US45               45       9    17 Merged       Dakuwaqa Julie   
#> 6 US      US45               45       9    17 Merged       Dakuwaqa Kendra  
#> 7 US      US45               45       9    17 Merged       Dakuwaqa Emily   
#> 8 US      US45               45       9    17 Merged       Dakuwaqa Austin  
#> 9 US      US45               45       9    17 Merged       Dakuwaqa Drew    
#> # ℹ 15 more variables: immunity <chr>, vote <chr>, vote_event <chr>,
#> #   vote_event_outcome <chr>, split_vote <chr>, nullified <lgl>, tie <lgl>,
#> #   voted_out <chr>, order <dbl>, vote_order <dbl>, castaway_id <chr>,
#> #   vote_id <chr>, voted_out_id <chr>, sog_id <dbl>, challenge_id <dbl>
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
#> # A tibble: 1,857 × 46
#>    version version_season season_name                season episode challenge_id
#>    <fct>   <chr>          <chr>                       <dbl>   <dbl>        <dbl>
#>  1 US      US01           Survivor: Borneo                1       1            1
#>  2 US      US01           Survivor: Borneo                1       2            2
#>  3 US      US01           Survivor: Borneo                1       2            3
#>  4 US      US01           Survivor: Borneo                1       3            4
#>  5 US      US01           Survivor: Borneo                1       3            5
#>  6 US      US01           Survivor: Borneo                1       4            6
#>  7 US      US01           Survivor: Borneo                1       4            7
#>  8 US      US01           Survivor: Borneo                1       5            8
#>  9 US      US01           Survivor: Borneo                1       5            9
#> 10 US      US01           Survivor: Borneo                1       6           10
#> 11 US      US01           Survivor: Borneo                1       6           11
#> 12 US      US01           Survivor: Borneo                1       7           12
#> 13 US      US01           Survivor: Borneo                1       8           13
#> 14 US      US01           Survivor: Borneo                1       8           14
#> 15 US      US01           Survivor: Borneo                1       9           15
#> 16 US      US01           Survivor: Borneo                1       9           16
#> 17 US      US01           Survivor: Borneo                1      10           17
#> 18 US      US01           Survivor: Borneo                1      10           18
#> 19 US      US01           Survivor: Borneo                1      11           19
#> 20 US      US01           Survivor: Borneo                1      11           20
#> 21 US      US01           Survivor: Borneo                1      11           21
#> 22 US      US01           Survivor: Borneo                1      12           22
#> 23 US      US01           Survivor: Borneo                1      12           23
#> 24 US      US01           Survivor: Borneo                1      13           24
#> 25 US      US01           Survivor: Borneo                1      13           25
#> 26 US      US02           Survivor: The Australian …      2       1            1
#> 27 US      US02           Survivor: The Australian …      2       2            2
#> 28 US      US02           Survivor: The Australian …      2       2            3
#> 29 US      US02           Survivor: The Australian …      2       3            4
#> 30 US      US02           Survivor: The Australian …      2       3            5
#> # ℹ 1,827 more rows
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
#> $ balance                   <int> 355
#> $ balance_ball              <int> 46
#> $ balance_beam              <int> 154
#> $ endurance                 <int> 447
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
#> $ precision                 <int> 300
#> $ precision_catch           <int> 63
#> $ precision_roll_ball       <int> 13
#> $ precision_slingshot       <int> 54
#> $ precision_throw_balls     <int> 78
#> $ precision_throw_coconuts  <int> 23
#> $ precision_throw_rings     <int> 19
#> $ precision_throw_sandbags  <int> 63
#> $ puzzle                    <int> 407
#> $ puzzle_slide              <int> 17
#> $ puzzle_word               <int> 29
#> $ race                      <int> 1327
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
#> # A tibble: 11,667 × 7
#>    category version_season castaway_id castaway      n_challenges n_won score
#>    <chr>    <chr>          <chr>       <chr>                <int> <dbl> <dbl>
#>  1 All      AU01           AU0001      Des                      2     0    -3
#>  2 All      AU01           AU0002      Bianca                   3     2    -3
#>  3 All      AU01           AU0003      Evan                     5     1    -8
#>  4 All      AU01           AU0004      Peter                    6     5    -6
#>  5 All      AU01           AU0005      Barry                    9     5   -11
#>  6 All      AU01           AU0006      Tegan                   11     7   -13
#>  7 All      AU01           AU0007      Rohan                   14     5   -18
#>  8 All      AU01           AU0008      Kat                     15     5   -19
#>  9 All      AU01           AU0009      Andrew                  17     7   -19
#> 10 All      AU01           AU0010      Craig                   18     7   -20
#> 11 All      AU01           AU0011      Phoebe                  21     5   -25
#> 12 All      AU01           AU0012      Conner                  22     8   -23
#> 13 All      AU01           AU0013      Kate                    23     7   -25
#> 14 All      AU01           AU0014      Nick                    24    17   -16
#> 15 All      AU01           AU0015      Kylie                   25    19   -15
#> 16 All      AU01           AU0016      Sue                     26     7   -28
#> 17 All      AU01           AU0017      Jennah-Louise           27    18   -18
#> 18 All      AU01           AU0018      Brooke                  29    20   -18
#> 19 All      AU01           AU0019      Sam                     32    18   -21
#> 20 All      AU01           AU0020      Matt                    33    18   -22
#> 21 All      AU01           AU0021      Flick                   34    18   -23
#> 22 All      AU01           AU0022      El                      35    16   -26
#> 23 All      AU01           AU0023      Lee                     35    17   -25
#> 24 All      AU01           AU0024      Kristie                 35     6   -36
#> 25 All      AU02           AU0025      Joan                     3     1    -2
#> 26 All      AU02           AU0026      Adam                     5     3    -2
#> 27 All      AU02           AU0027      Kate                     7     4    -3
#> 28 All      AU02           AU0028      Tarzan                   9     5    -4
#> 29 All      AU02           AU0029      Aimee                   10     5    -5
#> 30 All      AU02           AU0030      Sam                     12     5    -7
#> # ℹ 11,637 more rows
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
#> 11 US      US45           Survivor: …     45 Emily    Dee          1 US0668     
#> 12 US      US45           Survivor: …     45 Julie    Dee          1 US0672     
#> 13 US      US45           Survivor: …     45 Kaleb    Dee          1 US0673     
#> 14 US      US45           Survivor: …     45 Katurah  Dee          1 US0674     
#> 15 US      US45           Survivor: …     45 Kellie   Dee          1 US0675     
#> 16 US      US45           Survivor: …     45 Kendra   Dee          0 US0676     
#> 17 US      US45           Survivor: …     45 Bruce    Jake         0 US0657     
#> 18 US      US45           Survivor: …     45 Drew     Jake         0 US0667     
#> 19 US      US45           Survivor: …     45 Emily    Jake         0 US0668     
#> 20 US      US45           Survivor: …     45 Julie    Jake         0 US0672     
#> 21 US      US45           Survivor: …     45 Kaleb    Jake         0 US0673     
#> 22 US      US45           Survivor: …     45 Katurah  Jake         0 US0674     
#> 23 US      US45           Survivor: …     45 Kellie   Jake         0 US0675     
#> 24 US      US45           Survivor: …     45 Kendra   Jake         0 US0676     
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
#>  1 US      US45           Survivor: 45     45            1 Hidden Immunity Idol
#>  2 US      US45           Survivor: 45     45            2 Hidden Immunity Idol
#>  3 US      US45           Survivor: 45     45            3 Safety without Power
#>  4 US      US45           Survivor: 45     45            4 Goodwill Advantage  
#>  5 US      US45           Survivor: 45     45            5 Amulet              
#>  6 US      US45           Survivor: 45     45            6 Amulet              
#>  7 US      US45           Survivor: 45     45            7 Amulet              
#>  8 US      US45           Survivor: 45     45            8 Hidden Immunity Idol
#>  9 US      US45           Survivor: 45     45            9 Hidden Immunity Idol
#> 10 US      US45           Survivor: 45     45           10 Challenge Advantage 
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
#> # A tibble: 0 × 16
#> # ℹ 16 variables: version <chr>, version_season <chr>, season_name <chr>,
#> #   season <dbl>, castaway <chr>, castaway_id <chr>, advantage_id <dbl>,
#> #   sequence_id <dbl>, day <dbl>, episode <dbl>, event <chr>, played_for <chr>,
#> #   played_for_id <chr>, success <chr>, votes_nullified <dbl>, sog_id <dbl>
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
#> Error in `arrange()`:
#> ℹ In argument: `..1 = index_time`.
#> Caused by error:
#> ! object 'index_time' not found
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
#> # A tibble: 6 × 13
#>   version version_season season episode order n_boots final_n sog_id castaway_id
#>   <chr>   <chr>           <dbl>   <dbl> <dbl>   <dbl>   <dbl>  <dbl> <chr>      
#> 1 US      US45               45      12    12      12       6     13 US0671     
#> 2 US      US45               45      12    12      12       6     13 US0674     
#> 3 US      US45               45      12    12      12       6     13 US0666     
#> 4 US      US45               45      12    12      12       6     13 US0672     
#> 5 US      US45               45      12    12      12       6     13 US0663     
#> 6 US      US45               45      12    12      12       6     13 US0667     
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
#>    version version_season season episode_number_overall episode episode_title   
#>    <chr>   <chr>           <dbl>                  <dbl>   <dbl> <chr>           
#>  1 US      US45               45                    610       1 We Can Do Hard …
#>  2 US      US45               45                    611       2 Brought a Bazoo…
#>  3 US      US45               45                    612       3 No Man Left Beh…
#>  4 US      US45               45                    613       4 Music to My Ears
#>  5 US      US45               45                    614       5 I Don't Want to…
#>  6 US      US45               45                    615       6 I'm Not Batman,…
#>  7 US      US45               45                    616       7 The Thorn In My…
#>  8 US      US45               45                    617       8 Following a Dea…
#>  9 US      US45               45                    618       9 Sword of Damocl…
#> 10 US      US45               45                    619      10 How Am I the Mo…
#> 11 US      US45               45                    620      11 This Game Rips …
#> 12 US      US45               45                    621      12 The Ex-Girlfrie…
#> 13 US      US45               45                    622      13 Living the Surv…
#> # ℹ 7 more variables: episode_label <chr>, episode_date <date>,
#> #   episode_length <dbl>, viewers <dbl>, imdb_rating <dbl>, n_ratings <dbl>,
#> #   episode_summary <chr>
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
#> 11 US      US45           Survivor: 45     45    10 Pbandj Sandwich, C… Food an…
#> # ℹ 12 more variables: castaway <chr>, castaway_id <chr>, cost <dbl>,
#> #   covered <lgl>, money_remaining <dbl>, auction_num <dbl>,
#> #   participated <chr>, notes <chr>, alternative_offered <lgl>,
#> #   alternative_accepted <lgl>, other_item <chr>, other_item_category <chr>
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
#> # A tibble: 10 × 12
#>    version season version_season episode sog_id castaway_id castaway reward     
#>    <chr>    <dbl> <chr>            <dbl>  <dbl> <chr>       <chr>    <chr>      
#>  1 US          45 US45                 2      2 US0657      Bruce    <NA>       
#>  2 US          45 US45                 2      2 US0665      Brandon  Lost vote  
#>  3 US          45 US45                 2      2 US0667      Drew     Safety Wit…
#>  4 US          45 US45                 5      5 US0663      Austin   Amulet     
#>  5 US          45 US45                 5      5 US0675      Kellie   Amulet     
#>  6 US          45 US45                 5      5 US0670      J. Maya  Amulet     
#>  7 US          45 US45                 9     10 US0663      Austin   Regained v…
#>  8 US          45 US45                 9     10 US0668      Emily    Lost vote  
#>  9 US          45 US45                 9     10 US0674      Katurah  Lost vote  
#> 10 US          45 US45                11     12 US0668      Emily    <NA>       
#> # ℹ 4 more variables: lost_vote <lgl>, game_played <chr>, chose_to_play <lgl>,
#> #   event <chr>
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
