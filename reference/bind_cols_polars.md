# Append multiple Data/LazyFrames next to each other

Append multiple Data/LazyFrames next to each other

## Usage

``` r
bind_cols_polars(..., .name_repair = "unique")
```

## Arguments

- ...:

  Polars DataFrames or LazyFrames to combine. Each argument can either
  be a Data/LazyFrame, or a list of Data/LazyFrames. Columns are matched
  by name. All Data/LazyFrames must have the same number of rows and
  there mustn't be duplicated column names.

- .name_repair:

  Can be `"unique"`, `"universal"`, `"check_unique"`, `"minimal"`. See
  [`vctrs::vec_as_names()`](https://vctrs.r-lib.org/reference/vec_as_names.html)
  for the explanations for each value.

## Examples

``` r
p1 <- polars::pl$DataFrame(
  x = sample(letters, 20),
  y = sample(1:100, 20)
)
p2 <- polars::pl$DataFrame(
  z = sample(letters, 20),
  w = sample(1:100, 20)
)

bind_cols_polars(p1, p2)
#> shape: (20, 4)
#> ┌─────┬─────┬─────┬─────┐
#> │ x   ┆ y   ┆ z   ┆ w   │
#> │ --- ┆ --- ┆ --- ┆ --- │
#> │ str ┆ i32 ┆ str ┆ i32 │
#> ╞═════╪═════╪═════╪═════╡
#> │ d   ┆ 86  ┆ a   ┆ 6   │
#> │ f   ┆ 43  ┆ y   ┆ 22  │
#> │ i   ┆ 7   ┆ o   ┆ 19  │
#> │ e   ┆ 32  ┆ r   ┆ 2   │
#> │ w   ┆ 53  ┆ e   ┆ 64  │
#> │ …   ┆ …   ┆ …   ┆ …   │
#> │ y   ┆ 1   ┆ x   ┆ 60  │
#> │ z   ┆ 95  ┆ f   ┆ 14  │
#> │ n   ┆ 90  ┆ d   ┆ 5   │
#> │ c   ┆ 51  ┆ n   ┆ 76  │
#> │ a   ┆ 46  ┆ t   ┆ 17  │
#> └─────┴─────┴─────┴─────┘
bind_cols_polars(list(p1, p2))
#> shape: (20, 4)
#> ┌─────┬─────┬─────┬─────┐
#> │ x   ┆ y   ┆ z   ┆ w   │
#> │ --- ┆ --- ┆ --- ┆ --- │
#> │ str ┆ i32 ┆ str ┆ i32 │
#> ╞═════╪═════╪═════╪═════╡
#> │ d   ┆ 86  ┆ a   ┆ 6   │
#> │ f   ┆ 43  ┆ y   ┆ 22  │
#> │ i   ┆ 7   ┆ o   ┆ 19  │
#> │ e   ┆ 32  ┆ r   ┆ 2   │
#> │ w   ┆ 53  ┆ e   ┆ 64  │
#> │ …   ┆ …   ┆ …   ┆ …   │
#> │ y   ┆ 1   ┆ x   ┆ 60  │
#> │ z   ┆ 95  ┆ f   ┆ 14  │
#> │ n   ┆ 90  ┆ d   ┆ 5   │
#> │ c   ┆ 51  ┆ n   ┆ 76  │
#> │ a   ┆ 46  ┆ t   ┆ 17  │
#> └─────┴─────┴─────┴─────┘
```
