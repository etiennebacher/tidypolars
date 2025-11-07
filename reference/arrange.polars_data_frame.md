# Order rows using column values

Order rows using column values

## Usage

``` r
# S3 method for class 'polars_data_frame'
arrange(.data, ..., .by_group = FALSE)
```

## Arguments

- .data:

  A Polars Data/LazyFrame

- ...:

  Variables, or functions of variables. Use
  [`desc()`](https://dplyr.tidyverse.org/reference/desc.html) to sort a
  variable in descending order.

- .by_group:

  If `TRUE`, will sort data within groups.

## Examples

``` r
pl_test <- polars::pl$DataFrame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  value = sample(1:5)
)

arrange(pl_test, x1)
#> shape: (5, 3)
#> ┌─────┬─────┬───────┐
#> │ x1  ┆ x2  ┆ value │
#> │ --- ┆ --- ┆ ---   │
#> │ str ┆ f64 ┆ i32   │
#> ╞═════╪═════╪═══════╡
#> │ a   ┆ 2.0 ┆ 4     │
#> │ a   ┆ 1.0 ┆ 3     │
#> │ a   ┆ 3.0 ┆ 2     │
#> │ b   ┆ 5.0 ┆ 1     │
#> │ c   ┆ 1.0 ┆ 5     │
#> └─────┴─────┴───────┘
arrange(pl_test, x1, -x2)
#> shape: (5, 3)
#> ┌─────┬─────┬───────┐
#> │ x1  ┆ x2  ┆ value │
#> │ --- ┆ --- ┆ ---   │
#> │ str ┆ f64 ┆ i32   │
#> ╞═════╪═════╪═══════╡
#> │ a   ┆ 3.0 ┆ 2     │
#> │ a   ┆ 2.0 ┆ 4     │
#> │ a   ┆ 1.0 ┆ 3     │
#> │ b   ┆ 5.0 ┆ 1     │
#> │ c   ┆ 1.0 ┆ 5     │
#> └─────┴─────┴───────┘

# if the data is grouped, you need to specify `.by_group = TRUE` to sort by
# the groups first
pl_test |>
  group_by(x1) |>
  arrange(-x2, .by_group = TRUE)
#> shape: (5, 3)
#> ┌─────┬─────┬───────┐
#> │ x1  ┆ x2  ┆ value │
#> │ --- ┆ --- ┆ ---   │
#> │ str ┆ f64 ┆ i32   │
#> ╞═════╪═════╪═══════╡
#> │ a   ┆ 3.0 ┆ 2     │
#> │ a   ┆ 2.0 ┆ 4     │
#> │ a   ┆ 1.0 ┆ 3     │
#> │ b   ┆ 5.0 ┆ 1     │
#> │ c   ┆ 1.0 ┆ 5     │
#> └─────┴─────┴───────┘
#> Groups [3]: x1
#> Maintain order: FALSE
```
