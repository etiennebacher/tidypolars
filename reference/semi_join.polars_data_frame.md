# Filtering joins

Filtering joins filter rows from `x` based on the presence or absence of
matches in `y`:

- [`semi_join()`](https://dplyr.tidyverse.org/reference/filter-joins.html)
  return all rows from `x` with a match in `y`.

- [`anti_join()`](https://dplyr.tidyverse.org/reference/filter-joins.html)
  return all rows from `x` without a match in `y`.

## Usage

``` r
# S3 method for class 'polars_data_frame'
semi_join(x, y, by = NULL, ..., na_matches = "na")

# S3 method for class 'polars_data_frame'
anti_join(x, y, by = NULL, ..., na_matches = "na")

# S3 method for class 'polars_lazy_frame'
semi_join(x, y, by = NULL, ..., na_matches = "na")

# S3 method for class 'polars_lazy_frame'
anti_join(x, y, by = NULL, ..., na_matches = "na")
```

## Arguments

- x, y:

  Two Polars Data/LazyFrames

- by:

  Variables to join by. If `NULL` (default), `*_join()` will perform a
  natural join, using all variables in common across `x` and `y`. A
  message lists the variables so that you can check they're correct;
  suppress the message by supplying `by` explicitly.

  `by` can take a character vector, like `c("x", "y")` if `x` and `y`
  are in both datasets. To join on variables that don't have the same
  name, use equalities in the character vector, like
  `c("x1" = "x2", "y")`. If you use a character vector, the join can
  only be done using strict equality.

  `by` can also be a specification created by
  [`dplyr::join_by()`](https://dplyr.tidyverse.org/reference/join_by.html).
  Contrary to the input as character vector shown above,
  [`join_by()`](https://dplyr.tidyverse.org/reference/join_by.html) uses
  unquoted column names, e.g `join_by(x1 == x2, y)`.

  Finally,
  [`inner_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html)
  also supports inequality joins, e.g. `join_by(x1 >= x2)`, and the
  helpers
  [`between()`](https://dplyr.tidyverse.org/reference/between.html),
  `overlaps()`, and [`within()`](https://rdrr.io/r/base/with.html). See
  the documentation of
  [`dplyr::join_by()`](https://dplyr.tidyverse.org/reference/join_by.html)
  for more information. Other join types will likely support inequality
  joins in the future.

- ...:

  Dots which should be empty.

- na_matches:

  Should two `NA` values match?

  - `"na"`, the default, treats two `NA` values as equal.

  - `"never"` treats two `NA` values as different and will never match
    them together or to any other values.

  Note that when joining Polars Data/LazyFrames, `NaN` are always
  considered equal, no matter the value of `na_matches`. This differs
  from the original `dplyr` implementation.

## Unknown arguments

Arguments that are supported by the original implementation in the
tidyverse but are not listed above will throw a warning by default if
they are specified. To change this behavior to error instead, use
`options(tidypolars_unknown_args = "error")`.

## Examples

``` r
test <- polars::pl$DataFrame(
  x = c(1, 2, 3),
  y = c(1, 2, 3),
  z = c(1, 2, 3)
)

test2 <- polars::pl$DataFrame(
  x = c(1, 2, 4),
  y = c(1, 2, 4),
  z2 = c(1, 2, 4)
)

test
#> shape: (3, 3)
#> ┌─────┬─────┬─────┐
#> │ x   ┆ y   ┆ z   │
#> │ --- ┆ --- ┆ --- │
#> │ f64 ┆ f64 ┆ f64 │
#> ╞═════╪═════╪═════╡
#> │ 1.0 ┆ 1.0 ┆ 1.0 │
#> │ 2.0 ┆ 2.0 ┆ 2.0 │
#> │ 3.0 ┆ 3.0 ┆ 3.0 │
#> └─────┴─────┴─────┘

test2
#> shape: (3, 3)
#> ┌─────┬─────┬─────┐
#> │ x   ┆ y   ┆ z2  │
#> │ --- ┆ --- ┆ --- │
#> │ f64 ┆ f64 ┆ f64 │
#> ╞═════╪═════╪═════╡
#> │ 1.0 ┆ 1.0 ┆ 1.0 │
#> │ 2.0 ┆ 2.0 ┆ 2.0 │
#> │ 4.0 ┆ 4.0 ┆ 4.0 │
#> └─────┴─────┴─────┘

# only keep the rows of `test` that have matching keys in `test2`
semi_join(test, test2, by = c("x", "y"))
#> shape: (2, 3)
#> ┌─────┬─────┬─────┐
#> │ x   ┆ y   ┆ z   │
#> │ --- ┆ --- ┆ --- │
#> │ f64 ┆ f64 ┆ f64 │
#> ╞═════╪═════╪═════╡
#> │ 1.0 ┆ 1.0 ┆ 1.0 │
#> │ 2.0 ┆ 2.0 ┆ 2.0 │
#> └─────┴─────┴─────┘

# only keep the rows of `test` that don't have matching keys in `test2`
anti_join(test, test2, by = c("x", "y"))
#> shape: (1, 3)
#> ┌─────┬─────┬─────┐
#> │ x   ┆ y   ┆ z   │
#> │ --- ┆ --- ┆ --- │
#> │ f64 ┆ f64 ┆ f64 │
#> ╞═════╪═════╪═════╡
#> │ 3.0 ┆ 3.0 ┆ 3.0 │
#> └─────┴─────┴─────┘
```
