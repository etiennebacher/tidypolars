# Uncount a Data/LazyFrame

This duplicates rows according to a weighting variable (or expression).
This is the opposite of
[`count()`](https://dplyr.tidyverse.org/reference/count.html).

## Usage

``` r
# S3 method for class 'polars_data_frame'
uncount(data, weights, ..., .remove = TRUE, .id = NULL)

# S3 method for class 'polars_lazy_frame'
uncount(data, weights, ..., .remove = TRUE, .id = NULL)
```

## Arguments

- data:

  A Polars Data/LazyFrame

- weights:

  A vector of weights. Evaluated in the context of `data`.

- ...:

  Dots which should be empty.

- .remove:

  If `TRUE`, and weights is the name of a column in data, then this
  column is removed.

- .id:

  Supply a string to create a new variable which gives a unique
  identifier for each created row.

## Examples

``` r
test <- polars::pl$DataFrame(x = c("a", "b"), y = 100:101, n = c(1, 2))
test
#> shape: (2, 3)
#> ┌─────┬─────┬─────┐
#> │ x   ┆ y   ┆ n   │
#> │ --- ┆ --- ┆ --- │
#> │ str ┆ i32 ┆ f64 │
#> ╞═════╪═════╪═════╡
#> │ a   ┆ 100 ┆ 1.0 │
#> │ b   ┆ 101 ┆ 2.0 │
#> └─────┴─────┴─────┘

uncount(test, n)
#> shape: (3, 2)
#> ┌─────┬─────┐
#> │ x   ┆ y   │
#> │ --- ┆ --- │
#> │ str ┆ i32 │
#> ╞═════╪═════╡
#> │ a   ┆ 100 │
#> │ b   ┆ 101 │
#> │ b   ┆ 101 │
#> └─────┴─────┘

uncount(test, n, .id = "id")
#> shape: (3, 3)
#> ┌─────┬─────┬─────┐
#> │ x   ┆ y   ┆ id  │
#> │ --- ┆ --- ┆ --- │
#> │ str ┆ i32 ┆ u32 │
#> ╞═════╪═════╪═════╡
#> │ a   ┆ 100 ┆ 1   │
#> │ b   ┆ 101 ┆ 1   │
#> │ b   ┆ 101 ┆ 2   │
#> └─────┴─────┴─────┘

# using constants
uncount(test, 2)
#> shape: (4, 3)
#> ┌─────┬─────┬─────┐
#> │ x   ┆ y   ┆ n   │
#> │ --- ┆ --- ┆ --- │
#> │ str ┆ i32 ┆ f64 │
#> ╞═════╪═════╪═════╡
#> │ a   ┆ 100 ┆ 1.0 │
#> │ a   ┆ 100 ┆ 1.0 │
#> │ b   ┆ 101 ┆ 2.0 │
#> │ b   ┆ 101 ┆ 2.0 │
#> └─────┴─────┴─────┘

# using expressions
uncount(test, 2 / n)
#> shape: (3, 3)
#> ┌─────┬─────┬─────┐
#> │ x   ┆ y   ┆ n   │
#> │ --- ┆ --- ┆ --- │
#> │ str ┆ i32 ┆ f64 │
#> ╞═════╪═════╪═════╡
#> │ a   ┆ 100 ┆ 1.0 │
#> │ a   ┆ 100 ┆ 1.0 │
#> │ b   ┆ 101 ┆ 2.0 │
#> └─────┴─────┴─────┘
```
