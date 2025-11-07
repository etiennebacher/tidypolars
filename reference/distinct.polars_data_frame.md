# Remove or keep only duplicated rows in a Data/LazyFrame

By default, duplicates are looked for in all variables. It is possible
to specify a subset of variables where duplicates should be looked for.
It is also possible to keep either the first occurrence, the last
occurence or remove all duplicates.

## Usage

``` r
# S3 method for class 'polars_data_frame'
distinct(.data, ..., .keep_all = FALSE, keep = "first", maintain_order = TRUE)

# S3 method for class 'polars_lazy_frame'
distinct(.data, ..., .keep_all = FALSE, keep = "first", maintain_order = TRUE)

duplicated_rows(.data, ...)
```

## Arguments

- .data:

  A Polars Data/LazyFrame

- ...:

  Any expression accepted by
  [`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html):
  variable names, column numbers, select helpers, etc.

- .keep_all:

  If TRUE, keep all variables in .data after duplicated rows are
  removed.

- keep:

  Either "first" (keep the first occurrence of the duplicated row),
  "last" (last occurrence) or "none" (remove all ofccurences of
  duplicated rows).

- maintain_order:

  Maintain row order. This is the default but it can slow down the
  process with large datasets and it prevents the use of streaming.

## Examples

``` r
pl_test <- polars::pl$DataFrame(
  iso_o = c(rep(c("AA", "AB"), each = 2), "AC", "DC"),
  iso_d = rep(c("BA", "BB", "BC"), each = 2),
  value = c(2, 2, 3, 4, 5, 6)
)

distinct(pl_test)
#> shape: (5, 3)
#> ┌───────┬───────┬───────┐
#> │ iso_o ┆ iso_d ┆ value │
#> │ ---   ┆ ---   ┆ ---   │
#> │ str   ┆ str   ┆ f64   │
#> ╞═══════╪═══════╪═══════╡
#> │ AA    ┆ BA    ┆ 2.0   │
#> │ AB    ┆ BB    ┆ 3.0   │
#> │ AB    ┆ BB    ┆ 4.0   │
#> │ AC    ┆ BC    ┆ 5.0   │
#> │ DC    ┆ BC    ┆ 6.0   │
#> └───────┴───────┴───────┘
distinct(pl_test, iso_o)
#> shape: (4, 1)
#> ┌───────┐
#> │ iso_o │
#> │ ---   │
#> │ str   │
#> ╞═══════╡
#> │ AA    │
#> │ AB    │
#> │ AC    │
#> │ DC    │
#> └───────┘

duplicated_rows(pl_test)
#> shape: (2, 3)
#> ┌───────┬───────┬───────┐
#> │ iso_o ┆ iso_d ┆ value │
#> │ ---   ┆ ---   ┆ ---   │
#> │ str   ┆ str   ┆ f64   │
#> ╞═══════╪═══════╪═══════╡
#> │ AA    ┆ BA    ┆ 2.0   │
#> │ AA    ┆ BA    ┆ 2.0   │
#> └───────┴───────┴───────┘
duplicated_rows(pl_test, iso_o, iso_d)
#> shape: (4, 3)
#> ┌───────┬───────┬───────┐
#> │ iso_o ┆ iso_d ┆ value │
#> │ ---   ┆ ---   ┆ ---   │
#> │ str   ┆ str   ┆ f64   │
#> ╞═══════╪═══════╪═══════╡
#> │ AA    ┆ BA    ┆ 2.0   │
#> │ AA    ┆ BA    ┆ 2.0   │
#> │ AB    ┆ BB    ┆ 3.0   │
#> │ AB    ┆ BB    ┆ 4.0   │
#> └───────┴───────┴───────┘
```
