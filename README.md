
<!-- README.md is generate from README.Rmd. Please edit that file -->

# survivoR <img src='inst/images/hex-1.png' align="right" height="240" />

Outwit. Outplay. Outlast.

survivoR is a collection of datasets detailing events across all 40
seasons of the US Survivor, including castaway information, vote
history, immunity and reward challenge winners and jury votes.

# Installation

``` r
devtools::install_github("doehm/survivoR")
```

# Dataset overview

## Castaways

Season and demographic information about each castaway. If demographic
information is missing, it likely means that castaway re-entered the
game at a later stage.

``` r
castaways %>% 
  filter(season == 40)
#> # A tibble: 22 x 15
#>    season_name season castaway nickname age   city  state   day original_tribe
#>    <chr>        <dbl> <chr>    <chr>    <chr> <chr> <chr> <dbl> <chr>         
#>  1 Survivor: ~     40 Natalie~ Natalie  <NA>  <NA>  <NA>      2 Sele          
#>  2 Survivor: ~     40 Amber M~ Amber    40    Pens~ Flor~     3 Dakal         
#>  3 Survivor: ~     40 Danni B~ Danni    43    Shaw~ Kans~     6 Sele          
#>  4 Survivor: ~     40 Ethan Z~ Ethan    45    Hill~ New ~     9 Sele          
#>  5 Survivor: ~     40 Tyson A~ Tyson    <NA>  <NA>  <NA>     11 Dakal         
#>  6 Survivor: ~     40 Rob Mar~ Rob      43    Pens~ Flor~    14 Sele          
#>  7 Survivor: ~     40 Parvati~ Parvati  36    Los ~ Cali~    16 Sele          
#>  8 Survivor: ~     40 Sandra ~ Sandra   44    Rive~ Flor~    16 Dakal         
#>  9 Survivor: ~     40 Yul Kwon Yul      44    Los ~ Cali~    18 Dakal         
#> 10 Survivor: ~     40 Wendell~ Wendell  35    Phil~ Penn~    21 Dakal         
#> # ... with 12 more rows, and 6 more variables: merged_tribe <chr>,
#> #   result <chr>, jury_status <chr>, order <int>, swapped_tribe <chr>,
#> #   swapped_tribe2 <chr>
```

## Vote history

Detailed data on the vote history for each tribal council. See the help
doc for more detailed description.

``` r
vh <- vote_history %>% 
  filter(
    season == 40,
    episode == 10
  )
vh
#> # A tibble: 9 x 11
#>   season_name season episode   day castaway tribe_status vote  voted_out order
#>   <chr>        <dbl>   <dbl> <dbl> <chr>    <chr>        <chr> <chr>     <int>
#> 1 Survivor: ~     40      10    25 Tony     merged       Tyson Tyson        12
#> 2 Survivor: ~     40      10    25 Michele  merged       Tyson Tyson        12
#> 3 Survivor: ~     40      10    25 Sarah    merged       Deni~ Tyson        12
#> 4 Survivor: ~     40      10    25 Sarah    merged       Tyson Tyson        12
#> 5 Survivor: ~     40      10    25 Ben      merged       Tyson Tyson        12
#> 6 Survivor: ~     40      10    25 Nick     merged       Tyson Tyson        12
#> 7 Survivor: ~     40      10    25 Kim      merged       Soph~ Tyson        12
#> 8 Survivor: ~     40      10    25 Sophie   merged       Deni~ Tyson        12
#> 9 Survivor: ~     40      10    25 Tyson    merged       Soph~ Tyson        12
#> # ... with 2 more variables: immunity <chr>, nullified <lgl>
```

``` r
vh %>% 
  count(vote)
#> # A tibble: 3 x 2
#>   vote       n
#>   <chr>  <int>
#> 1 Denise     2
#> 2 Sophie     2
#> 3 Tyson      5
```

## Immunity

A nested tidy data frame of immunity challenge results. Each row is a
tribal council. There may be multiple people or tribes that win immunity
which can be determined by expanding the data set.

``` r
immunity %>% 
  filter(season == 40) %>% 
  unnest(c(immunity))
#> # A tibble: 23 x 8
#>    season_name       season episode title         voted_out   day order immunity
#>    <chr>              <dbl>   <dbl> <chr>         <chr>     <dbl> <int> <chr>   
#>  1 Survivor: Winner~     40       1 Greatest of ~ Natalie       2     1 Dakal   
#>  2 Survivor: Winner~     40       1 Greatest of ~ Amber         3     2 Sele    
#>  3 Survivor: Winner~     40       2 It's Like a ~ Danni         6     3 Dakal   
#>  4 Survivor: Winner~     40       3 Out for Blood Ethan         9     4 Dakal   
#>  5 Survivor: Winner~     40       4 I Like Reven~ Tyson        11     5 Sele    
#>  6 Survivor: Winner~     40       5 The Buddy Sy~ Rob          14     6 Sele    
#>  7 Survivor: Winner~     40       5 The Buddy Sy~ Rob          14     6 Dakal   
#>  8 Survivor: Winner~     40       6 Quick on the~ Parvati      16     7 Yara    
#>  9 Survivor: Winner~     40       6 Quick on the~ Sandra       16     8 Yara    
#> 10 Survivor: Winner~     40       7 We're in the~ Yul          18     9 Yara    
#> # ... with 13 more rows
```

## Rewards

A nested data frame of reward challenge results. Each row is a reward
challenge. Typically in the merge, if a single person win a reward they
are allowed to bring others along with them. The first castaway in the
expanded list is likely to be the winner and the susequent players those
they brought along with them.

``` r
rewards %>% 
  filter(season == 40) %>% 
  unnest(c(reward))
#> # A tibble: 29 x 6
#>    season_name            season episode title                        day reward
#>    <chr>                   <dbl>   <dbl> <chr>                      <dbl> <chr> 
#>  1 Survivor: Winners at ~     40       1 Greatest of the Greats         2 Dakal 
#>  2 Survivor: Winners at ~     40       1 Greatest of the Greats         3 <NA>  
#>  3 Survivor: Winners at ~     40       2 It's Like a Survivor Econ~     6 Dakal 
#>  4 Survivor: Winners at ~     40       3 Out for Blood                  9 Dakal 
#>  5 Survivor: Winners at ~     40       4 I Like Revenge                11 Sele  
#>  6 Survivor: Winners at ~     40       5 The Buddy System on Stero~    14 <NA>  
#>  7 Survivor: Winners at ~     40       6 Quick on the Draw             16 Yara  
#>  8 Survivor: Winners at ~     40       7 We're in the Majors           18 Yara  
#>  9 Survivor: Winners at ~     40       7 We're in the Majors           18 Sele  
#> 10 Survivor: Winners at ~     40       8 This is Where the Battle ~    21 Tyson 
#> # ... with 19 more rows
```

## Jury votes

History of jury votes. It is more verbose than it needs to be, however
having a 0-1 column indicating if a vote was placed or not makes it
easier to summarise castaways that received no votes.

``` r
jury_votes %>% 
  filter(season == 40)
#> # A tibble: 48 x 5
#>    season_name              season castaway finalist  vote
#>    <chr>                     <dbl> <chr>    <chr>    <dbl>
#>  1 Survivor: Winners at War     40 Sarah    Michele      0
#>  2 Survivor: Winners at War     40 Sarah    Natalie      0
#>  3 Survivor: Winners at War     40 Sarah    Tony         1
#>  4 Survivor: Winners at War     40 Ben      Michele      0
#>  5 Survivor: Winners at War     40 Ben      Natalie      0
#>  6 Survivor: Winners at War     40 Ben      Tony         1
#>  7 Survivor: Winners at War     40 Denise   Michele      0
#>  8 Survivor: Winners at War     40 Denise   Natalie      0
#>  9 Survivor: Winners at War     40 Denise   Tony         1
#> 10 Survivor: Winners at War     40 Nick     Michele      0
#> # ... with 38 more rows
```

``` r
jury_votes %>% 
  filter(season == 40) %>% 
  group_by(finalist) %>% 
  summarise(votes = sum(vote))
#> `summarise()` ungrouping output (override with `.groups` argument)
#> # A tibble: 3 x 2
#>   finalist votes
#>   <chr>    <dbl>
#> 1 Michele      0
#> 2 Natalie      4
#> 3 Tony        12
```

# Issues

Given the variable nature of the game of Survivor and changing of the
rules, there are bound to be edges cases where the data is not quite
right. Please log an issue and I will correct the datasets.

# References

Data was almost entirely sourced from Wikipedia. Other data was manually
recorded and entered by myself
