# Grouping metadata

[`group_vars()`](https://dplyr.tidyverse.org/reference/group_data.html)
returns a character vector with the names of the grouping variables.
[`group_keys()`](https://dplyr.tidyverse.org/reference/group_data.html)
returns a data frame with one row per group.

## Usage

``` r
# S3 method for class 'polars_data_frame'
group_split(.tbl, ..., .keep = TRUE)
```

## Arguments

- .tbl:

  A Polars Data/LazyFrame

- ...:

  If `.tbl` is not grouped, variables to group by. If `.tbl` is already
  grouped, this is ignored.

- .keep:

  Should the grouping columns be kept?

## Examples

``` r
pl_g <- polars::as_polars_df(iris) |>
  group_by(Species)

group_split(pl_g)
#> [[1]]
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
#> 
#> [[2]]
#> shape: (50, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬────────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species    │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---        │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat        │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪════════════╡
#> │ 7.0          ┆ 3.2         ┆ 4.7          ┆ 1.4         ┆ versicolor │
#> │ 6.4          ┆ 3.2         ┆ 4.5          ┆ 1.5         ┆ versicolor │
#> │ 6.9          ┆ 3.1         ┆ 4.9          ┆ 1.5         ┆ versicolor │
#> │ 5.5          ┆ 2.3         ┆ 4.0          ┆ 1.3         ┆ versicolor │
#> │ 6.5          ┆ 2.8         ┆ 4.6          ┆ 1.5         ┆ versicolor │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …          │
#> │ 5.7          ┆ 3.0         ┆ 4.2          ┆ 1.2         ┆ versicolor │
#> │ 5.7          ┆ 2.9         ┆ 4.2          ┆ 1.3         ┆ versicolor │
#> │ 6.2          ┆ 2.9         ┆ 4.3          ┆ 1.3         ┆ versicolor │
#> │ 5.1          ┆ 2.5         ┆ 3.0          ┆ 1.1         ┆ versicolor │
#> │ 5.7          ┆ 2.8         ┆ 4.1          ┆ 1.3         ┆ versicolor │
#> └──────────────┴─────────────┴──────────────┴─────────────┴────────────┘
#> 
#> [[3]]
#> shape: (50, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat       │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╡
#> │ 6.3          ┆ 3.3         ┆ 6.0          ┆ 2.5         ┆ virginica │
#> │ 5.8          ┆ 2.7         ┆ 5.1          ┆ 1.9         ┆ virginica │
#> │ 7.1          ┆ 3.0         ┆ 5.9          ┆ 2.1         ┆ virginica │
#> │ 6.3          ┆ 2.9         ┆ 5.6          ┆ 1.8         ┆ virginica │
#> │ 6.5          ┆ 3.0         ┆ 5.8          ┆ 2.2         ┆ virginica │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …         │
#> │ 6.7          ┆ 3.0         ┆ 5.2          ┆ 2.3         ┆ virginica │
#> │ 6.3          ┆ 2.5         ┆ 5.0          ┆ 1.9         ┆ virginica │
#> │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica │
#> │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica │
#> │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica │
#> └──────────────┴─────────────┴──────────────┴─────────────┴───────────┘
#> 
```
