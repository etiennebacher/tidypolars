# Separate a character column into multiple columns based on a substring

Currently, splitting a column on a regular expression or position is not
possible.

## Usage

``` r
# S3 method for class 'polars_data_frame'
separate(data, col, into, sep = " ", remove = TRUE, ...)

# S3 method for class 'polars_lazy_frame'
separate(data, col, into, sep = " ", remove = TRUE, ...)
```

## Arguments

- data:

  A Polars Data/LazyFrame

- col:

  Column to split

- into:

  Character vector containing the names of new variables to create. Use
  `NA` to omit the variable in the output.

- sep:

  String that is used to split the column. Regular expressions are not
  supported yet.

- remove:

  If `TRUE`, remove input column from output data frame.

- ...:

  Dots which should be empty.

## Examples

``` r
test <- polars::pl$DataFrame(
  x = c(NA, "x.y", "x.z", "y.z")
)
separate(test, x, into = c("foo", "foo2"), sep = ".")
#> shape: (4, 2)
#> ┌──────┬──────┐
#> │ foo  ┆ foo2 │
#> │ ---  ┆ ---  │
#> │ str  ┆ str  │
#> ╞══════╪══════╡
#> │ null ┆ null │
#> │ x    ┆ y    │
#> │ x    ┆ z    │
#> │ y    ┆ z    │
#> └──────┴──────┘
```
