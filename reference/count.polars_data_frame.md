# Count the observations in each group

Count the observations in each group

## Usage

``` r
# S3 method for class 'polars_data_frame'
count(x, ..., wt = NULL, sort = FALSE, name = "n")

# S3 method for class 'polars_data_frame'
tally(x, wt = NULL, sort = FALSE, name = "n")

# S3 method for class 'polars_lazy_frame'
count(x, ..., wt = NULL, sort = FALSE, name = "n")

# S3 method for class 'polars_lazy_frame'
tally(x, wt = NULL, sort = FALSE, name = "n")

# S3 method for class 'polars_data_frame'
add_count(x, ..., wt = NULL, sort = FALSE, name = "n")

# S3 method for class 'polars_lazy_frame'
add_count(x, ..., wt = NULL, sort = FALSE, name = "n")
```

## Arguments

- x:

  A Polars Data/LazyFrame

- ...:

  Any expression accepted by
  [`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html):
  variable names, column numbers, select helpers, etc.

- wt:

  Not supported by tidypolars.

- sort:

  If `TRUE`, will show the largest groups at the top.

- name:

  Name of the new column.

## Examples

``` r
test <- polars::as_polars_df(mtcars)

# grouping variables must be specified in count() and add_count()
count(test, cyl)
#> shape: (3, 2)
#> ┌─────┬─────┐
#> │ cyl ┆ n   │
#> │ --- ┆ --- │
#> │ f64 ┆ u32 │
#> ╞═════╪═════╡
#> │ 4.0 ┆ 11  │
#> │ 6.0 ┆ 7   │
#> │ 8.0 ┆ 14  │
#> └─────┴─────┘
count(test, cyl, am)
#> shape: (6, 3)
#> ┌─────┬─────┬─────┐
#> │ cyl ┆ am  ┆ n   │
#> │ --- ┆ --- ┆ --- │
#> │ f64 ┆ f64 ┆ u32 │
#> ╞═════╪═════╪═════╡
#> │ 4.0 ┆ 0.0 ┆ 3   │
#> │ 4.0 ┆ 1.0 ┆ 8   │
#> │ 6.0 ┆ 0.0 ┆ 4   │
#> │ 6.0 ┆ 1.0 ┆ 3   │
#> │ 8.0 ┆ 0.0 ┆ 12  │
#> │ 8.0 ┆ 1.0 ┆ 2   │
#> └─────┴─────┴─────┘
count(test, cyl, am, sort = TRUE, name = "count")
#> shape: (6, 3)
#> ┌─────┬─────┬───────┐
#> │ cyl ┆ am  ┆ count │
#> │ --- ┆ --- ┆ ---   │
#> │ f64 ┆ f64 ┆ u32   │
#> ╞═════╪═════╪═══════╡
#> │ 8.0 ┆ 0.0 ┆ 12    │
#> │ 4.0 ┆ 1.0 ┆ 8     │
#> │ 6.0 ┆ 0.0 ┆ 4     │
#> │ 4.0 ┆ 0.0 ┆ 3     │
#> │ 6.0 ┆ 1.0 ┆ 3     │
#> │ 8.0 ┆ 1.0 ┆ 2     │
#> └─────┴─────┴───────┘

add_count(test, cyl, am, sort = TRUE, name = "count")
#> shape: (32, 12)
#> ┌──────┬─────┬───────┬───────┬───┬─────┬──────┬──────┬───────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ am  ┆ gear ┆ carb ┆ count │
#> │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ ---  ┆ ---  ┆ ---   │
#> │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64  ┆ f64  ┆ u32   │
#> ╞══════╪═════╪═══════╪═══════╪═══╪═════╪══════╪══════╪═══════╡
#> │ 18.7 ┆ 8.0 ┆ 360.0 ┆ 175.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 2.0  ┆ 12    │
#> │ 14.3 ┆ 8.0 ┆ 360.0 ┆ 245.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 4.0  ┆ 12    │
#> │ 16.4 ┆ 8.0 ┆ 275.8 ┆ 180.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 3.0  ┆ 12    │
#> │ 17.3 ┆ 8.0 ┆ 275.8 ┆ 180.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 3.0  ┆ 12    │
#> │ 15.2 ┆ 8.0 ┆ 275.8 ┆ 180.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 3.0  ┆ 12    │
#> │ …    ┆ …   ┆ …     ┆ …     ┆ … ┆ …   ┆ …    ┆ …    ┆ …     │
#> │ 22.8 ┆ 4.0 ┆ 140.8 ┆ 95.0  ┆ … ┆ 0.0 ┆ 4.0  ┆ 2.0  ┆ 3     │
#> │ 21.5 ┆ 4.0 ┆ 120.1 ┆ 97.0  ┆ … ┆ 0.0 ┆ 3.0  ┆ 1.0  ┆ 3     │
#> │ 19.7 ┆ 6.0 ┆ 145.0 ┆ 175.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 6.0  ┆ 3     │
#> │ 15.8 ┆ 8.0 ┆ 351.0 ┆ 264.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 4.0  ┆ 2     │
#> │ 15.0 ┆ 8.0 ┆ 301.0 ┆ 335.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 8.0  ┆ 2     │
#> └──────┴─────┴───────┴───────┴───┴─────┴──────┴──────┴───────┘

# tally() directly uses grouping variables of the input
test |>
  group_by(cyl) |>
  tally()
#> shape: (3, 2)
#> ┌─────┬─────┐
#> │ cyl ┆ n   │
#> │ --- ┆ --- │
#> │ f64 ┆ u32 │
#> ╞═════╪═════╡
#> │ 4.0 ┆ 11  │
#> │ 6.0 ┆ 7   │
#> │ 8.0 ┆ 14  │
#> └─────┴─────┘

test |>
  group_by(cyl, am) |>
  tally(sort = TRUE, name = "count")
#> shape: (6, 3)
#> ┌─────┬─────┬───────┐
#> │ cyl ┆ am  ┆ count │
#> │ --- ┆ --- ┆ ---   │
#> │ f64 ┆ f64 ┆ u32   │
#> ╞═════╪═════╪═══════╡
#> │ 8.0 ┆ 0.0 ┆ 12    │
#> │ 4.0 ┆ 1.0 ┆ 8     │
#> │ 6.0 ┆ 0.0 ┆ 4     │
#> │ 6.0 ┆ 1.0 ┆ 3     │
#> │ 4.0 ┆ 0.0 ┆ 3     │
#> │ 8.0 ┆ 1.0 ┆ 2     │
#> └─────┴─────┴───────┘
#> Groups [3]: cyl
#> Maintain order: FALSE
```
