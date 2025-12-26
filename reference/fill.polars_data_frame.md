# Fill in missing values with previous or next value

Fills missing values in selected columns using the next or previous
entry. This is useful in the common output format where values are not
repeated, and are only recorded when they change.

## Usage

``` r
# S3 method for class 'polars_data_frame'
fill(data, ..., .by = NULL, .direction = c("down", "up", "downup", "updown"))
```

## Arguments

- data:

  A Polars Data/LazyFrame

- ...:

  Any expression accepted by
  [`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html):
  variable names, column numbers, select helpers, etc.

- .by:

  Optionally, a selection of columns to group by for just this
  operation, functioning as an alternative to
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html).
  The group order is not maintained, use
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) if
  you want more control over it.

- .direction:

  Direction in which to fill missing values. Either "down" (the
  default), "up", "downup" (i.e. first down and then up) or "updown"
  (first up and then down).

## Details

With grouped Data/LazyFrames, fill() will be applied within each group,
meaning that it won't fill across group boundaries.

## Examples

``` r
pl_test <- polars::pl$DataFrame(x = c(NA, 1), y = c(2, NA))

fill(pl_test, everything(), .direction = "down")
#> shape: (2, 2)
#> ┌──────┬─────┐
#> │ x    ┆ y   │
#> │ ---  ┆ --- │
#> │ f64  ┆ f64 │
#> ╞══════╪═════╡
#> │ null ┆ 2.0 │
#> │ 1.0  ┆ 2.0 │
#> └──────┴─────┘
fill(pl_test, everything(), .direction = "up")
#> shape: (2, 2)
#> ┌─────┬──────┐
#> │ x   ┆ y    │
#> │ --- ┆ ---  │
#> │ f64 ┆ f64  │
#> ╞═════╪══════╡
#> │ 1.0 ┆ 2.0  │
#> │ 1.0 ┆ null │
#> └─────┴──────┘

# with grouped data, it doesn't use values from other groups
pl_grouped <- polars::pl$DataFrame(
  grp = rep(c("A", "B"), each = 3),
  x = c(1, NA, NA, NA, 2, NA),
  y = c(3, NA, 4, NA, 3, 1)
) |>
  group_by(grp)

fill(pl_grouped, x, y, .direction = "down")
#> shape: (6, 3)
#> ┌─────┬──────┬──────┐
#> │ grp ┆ x    ┆ y    │
#> │ --- ┆ ---  ┆ ---  │
#> │ str ┆ f64  ┆ f64  │
#> ╞═════╪══════╪══════╡
#> │ A   ┆ 1.0  ┆ 3.0  │
#> │ A   ┆ 1.0  ┆ 3.0  │
#> │ A   ┆ 1.0  ┆ 4.0  │
#> │ B   ┆ null ┆ null │
#> │ B   ┆ 2.0  ┆ 3.0  │
#> │ B   ┆ 2.0  ┆ 1.0  │
#> └─────┴──────┴──────┘
#> Groups [2]: grp
#> Maintain order: FALSE
```
