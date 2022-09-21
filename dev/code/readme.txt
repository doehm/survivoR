# Changes for v2.0

For v2.0 all Non US seasons of Survivor will be added to the package. This has the potential to break current analysis scripts. When these seasons are added there will be multiple season 1, 2, etc. This means any join or filter on `season` is going either going to error out or create duplicate rows. It is recommended that all joins and filters on season are either replaced with `version_season` or include `version`.

You can try it out using `import_non_us_data()`. This imports all versions currently available. After importing you need to restart R and load the library again. BIG WARNING! This is still largely in development and far from complete. Use with caution.

Example:

  ```{r, eval = FALSE}
import_non_us_data()
#>
#> Non US data loaded
#> 1. Restart session
#> 2. Run library(survivoR)
```

The data is collated and stored in a list. The following code returns all season 1's available in the data set. You can see how joins will fail when directly joined on state alone.

```{r, eval = FALSE}
castaways |>
  filter(season == 1) |>
  distinct(version_season, castaway_id) |>
  count(version_season)
#> # A tibble: 2 × 2
#>   version_season     n
#>   <chr>          <int>
#> 1 AU01              24
#> 2 US01              16
```

To filter to just the US version we need to add in `version == "US"`

```{r, eval = FALSE}
castaways |>
  filter(
    version == "US",
    season == 1
    ) |>
  distinct(version_season, castaway_id) |>
  count(version_season)
#> # A tibble: 1 × 2
#>   version_season     n
#>   <chr>          <int>
#> 1 US01              16
```

To return to just using the US data by default run `remove_non_us_data`.

```{r, eval = FALSE}
remove_non_us_data()
#>
#> Non US data removed
#> 1. Restart session
#> 2. Run library(survivoR)
```

Restart R and load the library
