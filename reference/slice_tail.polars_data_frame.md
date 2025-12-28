# Subset rows of a Data/LazyFrame

Subset rows of a Data/LazyFrame

## Usage

``` r
# S3 method for class 'polars_data_frame'
slice_tail(.data, ..., n, by = NULL)

# S3 method for class 'polars_lazy_frame'
slice_tail(.data, ..., n, by = NULL)

# S3 method for class 'polars_data_frame'
slice_head(.data, ..., n, by = NULL)

# S3 method for class 'polars_lazy_frame'
slice_head(.data, ..., n, by = NULL)

# S3 method for class 'polars_data_frame'
slice_sample(.data, ..., n = NULL, prop = NULL, by = NULL, replace = FALSE)
```

## Arguments

- .data:

  A Polars Data/LazyFrame

- ...:

  Dots which should be empty.

- n:

  The number of rows to select from the start or the end of the data.
  Cannot be used with `prop`.

- by:

  Optionally, a selection of columns to group by for just this
  operation, functioning as an alternative to
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html).
  The group order is not maintained, use
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) if
  you want more control over it.

- prop:

  Proportion of rows to select. Cannot be used with `n`.

- replace:

  Perform the sampling with replacement (`TRUE`) or without (`FALSE`).

## Unknown arguments

Arguments that are supported by the original implementation in the
tidyverse but are not listed above will throw a warning by default if
they are specified. To change this behavior to error instead, use
`options(tidypolars_unknown_args = "error")`.

## Examples

``` r
pl_test <- polars::as_polars_df(iris)
slice_head(pl_test, n = 3)
#> shape: (3, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬─────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---     │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat     │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═════════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa  │
#> └──────────────┴─────────────┴──────────────┴─────────────┴─────────┘
slice_tail(pl_test, n = 3)
#> shape: (3, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat       │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╡
#> │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica │
#> │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica │
#> │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica │
#> └──────────────┴─────────────┴──────────────┴─────────────┴───────────┘
slice_sample(pl_test, n = 5)
#> shape: (5, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬────────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species    │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---        │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat        │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪════════════╡
#> │ 5.5          ┆ 2.5         ┆ 4.0          ┆ 1.3         ┆ versicolor │
#> │ 4.8          ┆ 3.0         ┆ 1.4          ┆ 0.1         ┆ setosa     │
#> │ 6.2          ┆ 2.9         ┆ 4.3          ┆ 1.3         ┆ versicolor │
#> │ 6.3          ┆ 2.8         ┆ 5.1          ┆ 1.5         ┆ virginica  │
#> │ 4.9          ┆ 3.1         ┆ 1.5          ┆ 0.1         ┆ setosa     │
#> └──────────────┴─────────────┴──────────────┴─────────────┴────────────┘
slice_sample(pl_test, prop = 0.1)
#> shape: (15, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬────────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species    │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---        │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat        │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪════════════╡
#> │ 5.2          ┆ 2.7         ┆ 3.9          ┆ 1.4         ┆ versicolor │
#> │ 4.6          ┆ 3.2         ┆ 1.4          ┆ 0.2         ┆ setosa     │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa     │
#> │ 5.8          ┆ 2.7         ┆ 4.1          ┆ 1.0         ┆ versicolor │
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ setosa     │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …          │
#> │ 6.1          ┆ 2.8         ┆ 4.0          ┆ 1.3         ┆ versicolor │
#> │ 6.8          ┆ 3.0         ┆ 5.5          ┆ 2.1         ┆ virginica  │
#> │ 7.7          ┆ 2.8         ┆ 6.7          ┆ 2.0         ┆ virginica  │
#> │ 7.7          ┆ 3.8         ┆ 6.7          ┆ 2.2         ┆ virginica  │
#> │ 7.1          ┆ 3.0         ┆ 5.9          ┆ 2.1         ┆ virginica  │
#> └──────────────┴─────────────┴──────────────┴─────────────┴────────────┘
```
