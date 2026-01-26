# Replace NAs with specified values

Replace NAs with specified values

## Usage

``` r
# S3 method for class 'polars_data_frame'
replace_na(data, replace, ...)

# S3 method for class 'polars_lazy_frame'
replace_na(data, replace, ...)
```

## Arguments

- data:

  A Polars Data/LazyFrame

- replace:

  Either a scalar that will be used to replace `NA` in all columns, or a
  named list with the column name and the value that will be used to
  replace `NA` in it.

- ...:

  Dots which should be empty.

## Examples

``` r
pl_test <- polars::pl$DataFrame(x = c(NA, 1), y = c(2, NA))

replace_na(pl_test, list(x = 0, y = 999))
#> shape: (2, 2)
#> ┌─────┬───────┐
#> │ x   ┆ y     │
#> │ --- ┆ ---   │
#> │ f64 ┆ f64   │
#> ╞═════╪═══════╡
#> │ 0.0 ┆ 2.0   │
#> │ 1.0 ┆ 999.0 │
#> └─────┴───────┘
```
