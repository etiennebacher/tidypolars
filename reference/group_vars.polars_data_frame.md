# Grouping metadata

[`group_vars()`](https://dplyr.tidyverse.org/reference/group_data.html)
returns a character vector with the names of the grouping variables.
[`group_keys()`](https://dplyr.tidyverse.org/reference/group_data.html)
returns a data frame with one row per group.

## Usage

``` r
# S3 method for class 'polars_data_frame'
group_vars(x)

# S3 method for class 'polars_lazy_frame'
group_vars(x)

# S3 method for class 'polars_data_frame'
group_keys(.tbl, ...)

# S3 method for class 'polars_lazy_frame'
group_keys(.tbl, ...)
```

## Arguments

- x, .tbl:

  A Polars Data/LazyFrame

- ...:

  These dots are for future extensions and must be empty.

## Examples

``` r
pl_g <- polars::as_polars_df(mtcars) |>
  group_by(cyl, am)

group_vars(pl_g)
#> [1] "cyl" "am" 

group_keys(pl_g)
#> # A tibble: 6 × 2
#>     cyl    am
#>   <dbl> <dbl>
#> 1     4     0
#> 2     4     1
#> 3     6     0
#> 4     6     1
#> 5     8     0
#> 6     8     1
```
