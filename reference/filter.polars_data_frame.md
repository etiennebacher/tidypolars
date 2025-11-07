# Keep rows that match a condition

This function is used to subset a data frame, retaining all rows that
satisfy your conditions. To be retained, the row must produce a value of
TRUE for all conditions. Note that when a condition evaluates to NA the
row will be dropped, unlike base subsetting with `[`.

## Usage

``` r
# S3 method for class 'polars_data_frame'
filter(.data, ..., .by = NULL)

# S3 method for class 'polars_lazy_frame'
filter(.data, ..., .by = NULL)
```

## Arguments

- .data:

  A Polars Data/LazyFrame

- ...:

  Expressions that return a logical value, and are defined in terms of
  the variables in the data. If multiple expressions are included, they
  will be combined with the & operator. Only rows for which all
  conditions evaluate to `TRUE` are kept.

- .by:

  Optionally, a selection of columns to group by for just this
  operation, functioning as an alternative to
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html).
  The group order is not maintained, use
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) if
  you want more control over it.

## Examples

``` r
pl_iris <- polars::as_polars_df(iris)

filter(pl_iris, Sepal.Length < 5, Species == "setosa")
#> shape: (20, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬─────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---     │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat     │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═════════╡
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa  │
#> │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ setosa  │
#> │ 4.6          ┆ 3.4         ┆ 1.4          ┆ 0.3         ┆ setosa  │
#> │ 4.4          ┆ 2.9         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …       │
#> │ 4.4          ┆ 3.0         ┆ 1.3          ┆ 0.2         ┆ setosa  │
#> │ 4.5          ┆ 2.3         ┆ 1.3          ┆ 0.3         ┆ setosa  │
#> │ 4.4          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa  │
#> │ 4.8          ┆ 3.0         ┆ 1.4          ┆ 0.3         ┆ setosa  │
#> │ 4.6          ┆ 3.2         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> └──────────────┴─────────────┴──────────────┴─────────────┴─────────┘

filter(pl_iris, Sepal.Length < Sepal.Width + Petal.Length)
#> shape: (115, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat       │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╡
#> │ 5.4          ┆ 3.9         ┆ 1.7          ┆ 0.4         ┆ setosa    │
#> │ 4.6          ┆ 3.4         ┆ 1.4          ┆ 0.3         ┆ setosa    │
#> │ 4.8          ┆ 3.4         ┆ 1.6          ┆ 0.2         ┆ setosa    │
#> │ 5.7          ┆ 4.4         ┆ 1.5          ┆ 0.4         ┆ setosa    │
#> │ 5.1          ┆ 3.8         ┆ 1.5          ┆ 0.3         ┆ setosa    │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …         │
#> │ 6.7          ┆ 3.0         ┆ 5.2          ┆ 2.3         ┆ virginica │
#> │ 6.3          ┆ 2.5         ┆ 5.0          ┆ 1.9         ┆ virginica │
#> │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica │
#> │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica │
#> │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica │
#> └──────────────┴─────────────┴──────────────┴─────────────┴───────────┘

filter(pl_iris, Species == "setosa" | is.na(Species))
#> shape: (50, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬─────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---     │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat     │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═════════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa  │
#> │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ setosa  │
#> │ 5.0          ┆ 3.6         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …       │
#> │ 4.8          ┆ 3.0         ┆ 1.4          ┆ 0.3         ┆ setosa  │
#> │ 5.1          ┆ 3.8         ┆ 1.6          ┆ 0.2         ┆ setosa  │
#> │ 4.6          ┆ 3.2         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> │ 5.3          ┆ 3.7         ┆ 1.5          ┆ 0.2         ┆ setosa  │
#> │ 5.0          ┆ 3.3         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> └──────────────┴─────────────┴──────────────┴─────────────┴─────────┘

iris2 <- iris
iris2$Species <- as.character(iris2$Species)
iris2 |>
  as_polars_df() |>
  filter(Species %in% c("setosa", "virginica"))
#> shape: (100, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ str       │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ setosa    │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa    │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa    │
#> │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ setosa    │
#> │ 5.0          ┆ 3.6         ┆ 1.4          ┆ 0.2         ┆ setosa    │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …         │
#> │ 6.7          ┆ 3.0         ┆ 5.2          ┆ 2.3         ┆ virginica │
#> │ 6.3          ┆ 2.5         ┆ 5.0          ┆ 1.9         ┆ virginica │
#> │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica │
#> │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica │
#> │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica │
#> └──────────────┴─────────────┴──────────────┴─────────────┴───────────┘

# filter by group
pl_iris |>
  group_by(Species) |>
  filter(Sepal.Length == max(Sepal.Length)) |>
  ungroup()
#> shape: (3, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬────────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species    │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---        │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat        │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪════════════╡
#> │ 5.8          ┆ 4.0         ┆ 1.2          ┆ 0.2         ┆ setosa     │
#> │ 7.0          ┆ 3.2         ┆ 4.7          ┆ 1.4         ┆ versicolor │
#> │ 7.9          ┆ 3.8         ┆ 6.4          ┆ 2.0         ┆ virginica  │
#> └──────────────┴─────────────┴──────────────┴─────────────┴────────────┘

# an alternative syntax for grouping is to use `.by`
pl_iris |>
  filter(Sepal.Length == max(Sepal.Length), .by = Species)
#> shape: (3, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬────────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species    │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---        │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat        │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪════════════╡
#> │ 5.8          ┆ 4.0         ┆ 1.2          ┆ 0.2         ┆ setosa     │
#> │ 7.0          ┆ 3.2         ┆ 4.7          ┆ 1.4         ┆ versicolor │
#> │ 7.9          ┆ 3.8         ┆ 6.4          ┆ 2.0         ┆ virginica  │
#> └──────────────┴─────────────┴──────────────┴─────────────┴────────────┘
```
