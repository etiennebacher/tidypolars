# Create a column with unique id per row values

**\[deprecated\]**

The underlying Polars function isn't guaranteed to give the same results
across different versions. Therefore, this function will be removed and
has no replacement in `tidypolars`.

## Usage

``` r
make_unique_id(.data, ..., new_col = "hash")
```

## Arguments

- .data:

  A Polars Data/LazyFrame

- ...:

  Any expression accepted by
  [`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html):
  variable names, column numbers, select helpers, etc.

- new_col:

  Name of the new column
