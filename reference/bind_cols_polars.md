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
#> │ o   ┆ 4   ┆ f   ┆ 3   │
#> │ z   ┆ 34  ┆ b   ┆ 38  │
#> │ d   ┆ 35  ┆ s   ┆ 68  │
#> │ f   ┆ 89  ┆ n   ┆ 65  │
#> │ i   ┆ 86  ┆ a   ┆ 6   │
#> │ …   ┆ …   ┆ …   ┆ …   │
#> │ l   ┆ 17  ┆ k   ┆ 41  │
#> │ q   ┆ 52  ┆ j   ┆ 42  │
#> │ w   ┆ 56  ┆ w   ┆ 66  │
#> │ s   ┆ 97  ┆ y   ┆ 26  │
#> │ h   ┆ 1   ┆ g   ┆ 60  │
#> └─────┴─────┴─────┴─────┘
bind_cols_polars(list(p1, p2))
#> shape: (20, 4)
#> ┌─────┬─────┬─────┬─────┐
#> │ x   ┆ y   ┆ z   ┆ w   │
#> │ --- ┆ --- ┆ --- ┆ --- │
#> │ str ┆ i32 ┆ str ┆ i32 │
#> ╞═════╪═════╪═════╪═════╡
#> │ o   ┆ 4   ┆ f   ┆ 3   │
#> │ z   ┆ 34  ┆ b   ┆ 38  │
#> │ d   ┆ 35  ┆ s   ┆ 68  │
#> │ f   ┆ 89  ┆ n   ┆ 65  │
#> │ i   ┆ 86  ┆ a   ┆ 6   │
#> │ …   ┆ …   ┆ …   ┆ …   │
#> │ l   ┆ 17  ┆ k   ┆ 41  │
#> │ q   ┆ 52  ┆ j   ┆ 42  │
#> │ w   ┆ 56  ┆ w   ┆ 66  │
#> │ s   ┆ 97  ┆ y   ┆ 26  │
#> │ h   ┆ 1   ┆ g   ┆ 60  │
#> └─────┴─────┴─────┴─────┘
```
