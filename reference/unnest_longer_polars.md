# Unnest a list-column into rows

`unnest_longer_polars()` turns each element of a list-column into a row.
This is the equivalent of
[`tidyr::unnest_longer()`](https://tidyr.tidyverse.org/reference/unnest_longer.html).

## Usage

``` r
unnest_longer_polars(
  data,
  col,
  ...,
  values_to = NULL,
  indices_to = NULL,
  keep_empty = FALSE
)
```

## Arguments

- data:

  A Polars DataFrame or LazyFrame.

- col:

  \<[`tidy-select`](https://tidyr.tidyverse.org/reference/tidyr_tidy_select.html)\>
  Column(s) to unnest. Can be bare column names, character strings, or
  tidyselect expressions. When selecting multiple columns, the list
  elements in each row must have the same length across all selected
  columns.

- ...:

  These dots are for future extensions and must be empty.

- values_to:

  A string giving the column name to store the unnested values in. If
  `NULL` (the default), the original column name is used. When multiple
  columns are selected, this can be a glue string containing `"{col}"`
  to provide a template for the column names (e.g.,
  `values_to = "{col}_val"`).

- indices_to:

  A string giving the column name to store the index of the values. If
  `NULL` (the default), no index column is created. When multiple
  columns are selected, this can be a glue string containing `"{col}"`
  to create separate index columns for each unnested column (e.g.,
  `indices_to = "{col}_idx"`).

- keep_empty:

  If `TRUE`, empty values (NULL or empty lists) are kept as `NA` in the
  output. If `FALSE` (the default), empty values are dropped.

## Value

A Polars DataFrame or LazyFrame with the list-column(s) unnested into
rows.

## Details

When multiple columns are selected, the corresponding list elements from
each row are expanded together. This requires that all selected columns
have lists of the same length in each row.

The `indices_to` parameter creates an integer column with the position
(1-indexed) of each element within the original list. Named elements in
the list are not currently supported for index names (they will use
integer positions).

When using `"{col}"` templates with multiple columns, the template is
applied to each column name to generate the output column names.

## See also

[`tidyr::unnest_longer()`](https://tidyr.tidyverse.org/reference/unnest_longer.html)
for the tidyr equivalent.
