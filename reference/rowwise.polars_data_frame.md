# Group input by rows

\[EXPERIMENTAL\]

[`rowwise()`](https://dplyr.tidyverse.org/reference/rowwise.html) allows
you to compute on a Data/LazyFrame a row-at-a-time. This is most useful
when a vectorised function doesn't exist.
[`rowwise()`](https://dplyr.tidyverse.org/reference/rowwise.html)
produces another type of grouped data, and therefore can be removed with
[`ungroup()`](https://dplyr.tidyverse.org/reference/group_by.html).

## Usage

``` r
# S3 method for class 'polars_data_frame'
rowwise(data, ...)

# S3 method for class 'polars_lazy_frame'
rowwise(data, ...)
```

## Arguments

- data:

  A Polars Data/LazyFrame

- ...:

  Any expression accepted by
  [`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html):
  variable names, column numbers, select helpers, etc.

## Value

A Polars Data/LazyFrame.

## Examples

``` r
df <- polars::pl$DataFrame(x = c(1, 3, 4), y = c(2, 1, 5), z = c(2, 3, 1))

# Compute the mean of x, y, z in each row
df |>
 rowwise() |>
 mutate(m = mean(c(x, y, z)))
#> shape: (3, 4)
#> ┌─────┬─────┬─────┬──────────┐
#> │ x   ┆ y   ┆ z   ┆ m        │
#> │ --- ┆ --- ┆ --- ┆ ---      │
#> │ f64 ┆ f64 ┆ f64 ┆ f64      │
#> ╞═════╪═════╪═════╪══════════╡
#> │ 1.0 ┆ 2.0 ┆ 2.0 ┆ 1.666667 │
#> │ 3.0 ┆ 1.0 ┆ 3.0 ┆ 2.333333 │
#> │ 4.0 ┆ 5.0 ┆ 1.0 ┆ 3.333333 │
#> └─────┴─────┴─────┴──────────┘
#> 
#> Rowwise: TRUE

# Compute the min and max of x and y in each row
df |>
 rowwise() |>
 mutate(min = min(c(x, y)), max = max(c(x, y)))
#> shape: (3, 5)
#> ┌─────┬─────┬─────┬─────┬─────┐
#> │ x   ┆ y   ┆ z   ┆ min ┆ max │
#> │ --- ┆ --- ┆ --- ┆ --- ┆ --- │
#> │ f64 ┆ f64 ┆ f64 ┆ f64 ┆ f64 │
#> ╞═════╪═════╪═════╪═════╪═════╡
#> │ 1.0 ┆ 2.0 ┆ 2.0 ┆ 1.0 ┆ 2.0 │
#> │ 3.0 ┆ 1.0 ┆ 3.0 ┆ 1.0 ┆ 3.0 │
#> │ 4.0 ┆ 5.0 ┆ 1.0 ┆ 4.0 ┆ 5.0 │
#> └─────┴─────┴─────┴─────┴─────┘
#> 
#> Rowwise: TRUE
```
