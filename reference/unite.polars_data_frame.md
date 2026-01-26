# Unite multiple columns into one by pasting strings together

Unite multiple columns into one by pasting strings together

## Usage

``` r
# S3 method for class 'polars_data_frame'
unite(data, col, ..., sep = "_", remove = TRUE, na.rm = FALSE)

# S3 method for class 'polars_lazy_frame'
unite(data, col, ..., sep = "_", remove = TRUE, na.rm = FALSE)
```

## Arguments

- data:

  A Polars Data/LazyFrame

- col:

  The name of the new column, as a string or symbol.

- ...:

  Any expression accepted by
  [`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html):
  variable names, column numbers, select helpers, etc.

- sep:

  Separator to use between values.

- remove:

  If `TRUE`, remove input columns from the output Data/LazyFrame.

- na.rm:

  If `TRUE`, missing values will be replaced with an empty string prior
  to uniting each value.

## Examples

``` r
test <- polars::pl$DataFrame(
  year = 2009:2011,
  month = 10:12,
  day = c(11L, 22L, 28L),
  name_day = c("Monday", "Thursday", "Wednesday")
)

# By default, united columns are dropped
unite(test, col = "full_date", year, month, day, sep = "-")
#> shape: (3, 2)
#> ┌────────────┬───────────┐
#> │ full_date  ┆ name_day  │
#> │ ---        ┆ ---       │
#> │ str        ┆ str       │
#> ╞════════════╪═══════════╡
#> │ 2009-10-11 ┆ Monday    │
#> │ 2010-11-22 ┆ Thursday  │
#> │ 2011-12-28 ┆ Wednesday │
#> └────────────┴───────────┘
unite(test, col = "full_date", year, month, day, sep = "-", remove = FALSE)
#> shape: (3, 5)
#> ┌────────────┬──────┬───────┬─────┬───────────┐
#> │ full_date  ┆ year ┆ month ┆ day ┆ name_day  │
#> │ ---        ┆ ---  ┆ ---   ┆ --- ┆ ---       │
#> │ str        ┆ i32  ┆ i32   ┆ i32 ┆ str       │
#> ╞════════════╪══════╪═══════╪═════╪═══════════╡
#> │ 2009-10-11 ┆ 2009 ┆ 10    ┆ 11  ┆ Monday    │
#> │ 2010-11-22 ┆ 2010 ┆ 11    ┆ 22  ┆ Thursday  │
#> │ 2011-12-28 ┆ 2011 ┆ 12    ┆ 28  ┆ Wednesday │
#> └────────────┴──────┴───────┴─────┴───────────┘

test2 <- polars::pl$DataFrame(
  name = c("John", "Jack", "Thomas"),
  middlename = c("T.", NA, "F."),
  surname = c("Smith", "Thompson", "Jones")
)

# By default, NA values are kept in the character output
unite(test2, col = "full_name", everything(), sep = " ")
#> shape: (3, 1)
#> ┌─────────────────┐
#> │ full_name       │
#> │ ---             │
#> │ str             │
#> ╞═════════════════╡
#> │ John T. Smith   │
#> │ Jack Thompson   │
#> │ Thomas F. Jones │
#> └─────────────────┘
unite(test2, col = "full_name", everything(), sep = " ", na.rm = TRUE)
#> shape: (3, 1)
#> ┌─────────────────┐
#> │ full_name       │
#> │ ---             │
#> │ str             │
#> ╞═════════════════╡
#> │ John T. Smith   │
#> │ Jack Thompson   │
#> │ Thomas F. Jones │
#> └─────────────────┘
```
