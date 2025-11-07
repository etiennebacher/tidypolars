# Select columns from a Data/LazyFrame

Select columns from a Data/LazyFrame

## Usage

``` r
# S3 method for class 'polars_data_frame'
select(.data, ...)

# S3 method for class 'polars_lazy_frame'
select(.data, ...)
```

## Arguments

- .data:

  A Polars Data/LazyFrame

- ...:

  Any expression accepted by
  [`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html):
  variable names, column numbers, select helpers, etc. Renaming is also
  possible.

## Examples

``` r
pl_iris <- polars::as_polars_df(iris)

select(pl_iris, c("Sepal.Length", "Sepal.Width"))
#> shape: (150, 2)
#> ┌──────────────┬─────────────┐
#> │ Sepal.Length ┆ Sepal.Width │
#> │ ---          ┆ ---         │
#> │ f64          ┆ f64         │
#> ╞══════════════╪═════════════╡
#> │ 5.1          ┆ 3.5         │
#> │ 4.9          ┆ 3.0         │
#> │ 4.7          ┆ 3.2         │
#> │ 4.6          ┆ 3.1         │
#> │ 5.0          ┆ 3.6         │
#> │ …            ┆ …           │
#> │ 6.7          ┆ 3.0         │
#> │ 6.3          ┆ 2.5         │
#> │ 6.5          ┆ 3.0         │
#> │ 6.2          ┆ 3.4         │
#> │ 5.9          ┆ 3.0         │
#> └──────────────┴─────────────┘
select(pl_iris, Sepal.Length, Sepal.Width)
#> shape: (150, 2)
#> ┌──────────────┬─────────────┐
#> │ Sepal.Length ┆ Sepal.Width │
#> │ ---          ┆ ---         │
#> │ f64          ┆ f64         │
#> ╞══════════════╪═════════════╡
#> │ 5.1          ┆ 3.5         │
#> │ 4.9          ┆ 3.0         │
#> │ 4.7          ┆ 3.2         │
#> │ 4.6          ┆ 3.1         │
#> │ 5.0          ┆ 3.6         │
#> │ …            ┆ …           │
#> │ 6.7          ┆ 3.0         │
#> │ 6.3          ┆ 2.5         │
#> │ 6.5          ┆ 3.0         │
#> │ 6.2          ┆ 3.4         │
#> │ 5.9          ┆ 3.0         │
#> └──────────────┴─────────────┘
select(pl_iris, 1:3)
#> shape: (150, 3)
#> ┌──────────────┬─────────────┬──────────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length │
#> │ ---          ┆ ---         ┆ ---          │
#> │ f64          ┆ f64         ┆ f64          │
#> ╞══════════════╪═════════════╪══════════════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          │
#> │ 4.9          ┆ 3.0         ┆ 1.4          │
#> │ 4.7          ┆ 3.2         ┆ 1.3          │
#> │ 4.6          ┆ 3.1         ┆ 1.5          │
#> │ 5.0          ┆ 3.6         ┆ 1.4          │
#> │ …            ┆ …           ┆ …            │
#> │ 6.7          ┆ 3.0         ┆ 5.2          │
#> │ 6.3          ┆ 2.5         ┆ 5.0          │
#> │ 6.5          ┆ 3.0         ┆ 5.2          │
#> │ 6.2          ┆ 3.4         ┆ 5.4          │
#> │ 5.9          ┆ 3.0         ┆ 5.1          │
#> └──────────────┴─────────────┴──────────────┘
select(pl_iris, starts_with("Sepal"))
#> shape: (150, 2)
#> ┌──────────────┬─────────────┐
#> │ Sepal.Length ┆ Sepal.Width │
#> │ ---          ┆ ---         │
#> │ f64          ┆ f64         │
#> ╞══════════════╪═════════════╡
#> │ 5.1          ┆ 3.5         │
#> │ 4.9          ┆ 3.0         │
#> │ 4.7          ┆ 3.2         │
#> │ 4.6          ┆ 3.1         │
#> │ 5.0          ┆ 3.6         │
#> │ …            ┆ …           │
#> │ 6.7          ┆ 3.0         │
#> │ 6.3          ┆ 2.5         │
#> │ 6.5          ┆ 3.0         │
#> │ 6.2          ┆ 3.4         │
#> │ 5.9          ┆ 3.0         │
#> └──────────────┴─────────────┘
select(pl_iris, -ends_with("Length"))
#> shape: (150, 3)
#> ┌─────────────┬─────────────┬───────────┐
#> │ Sepal.Width ┆ Petal.Width ┆ Species   │
#> │ ---         ┆ ---         ┆ ---       │
#> │ f64         ┆ f64         ┆ cat       │
#> ╞═════════════╪═════════════╪═══════════╡
#> │ 3.5         ┆ 0.2         ┆ setosa    │
#> │ 3.0         ┆ 0.2         ┆ setosa    │
#> │ 3.2         ┆ 0.2         ┆ setosa    │
#> │ 3.1         ┆ 0.2         ┆ setosa    │
#> │ 3.6         ┆ 0.2         ┆ setosa    │
#> │ …           ┆ …           ┆ …         │
#> │ 3.0         ┆ 2.3         ┆ virginica │
#> │ 2.5         ┆ 1.9         ┆ virginica │
#> │ 3.0         ┆ 2.0         ┆ virginica │
#> │ 3.4         ┆ 2.3         ┆ virginica │
#> │ 3.0         ┆ 1.8         ┆ virginica │
#> └─────────────┴─────────────┴───────────┘

# Renaming while selecting is also possible
select(pl_iris, foo1 = Sepal.Length, Sepal.Width)
#> shape: (150, 2)
#> ┌──────┬─────────────┐
#> │ foo1 ┆ Sepal.Width │
#> │ ---  ┆ ---         │
#> │ f64  ┆ f64         │
#> ╞══════╪═════════════╡
#> │ 5.1  ┆ 3.5         │
#> │ 4.9  ┆ 3.0         │
#> │ 4.7  ┆ 3.2         │
#> │ 4.6  ┆ 3.1         │
#> │ 5.0  ┆ 3.6         │
#> │ …    ┆ …           │
#> │ 6.7  ┆ 3.0         │
#> │ 6.3  ┆ 2.5         │
#> │ 6.5  ┆ 3.0         │
#> │ 6.2  ┆ 3.4         │
#> │ 5.9  ┆ 3.0         │
#> └──────┴─────────────┘
```
