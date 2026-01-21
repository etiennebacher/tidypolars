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

## Examples

``` r
library(polars)

# Basic example with a list column
df <- pl$DataFrame(
  id = 1:3,
  values = list(c(1, 2), c(3, 4, 5), 6)
)
df
#> shape: (3, 2)
#> ┌─────┬─────────────────┐
#> │ id  ┆ values          │
#> │ --- ┆ ---             │
#> │ i32 ┆ list[f64]       │
#> ╞═════╪═════════════════╡
#> │ 1   ┆ [1.0, 2.0]      │
#> │ 2   ┆ [3.0, 4.0, 5.0] │
#> │ 3   ┆ [6.0]           │
#> └─────┴─────────────────┘

unnest_longer_polars(df, values)
#> shape: (6, 2)
#> ┌─────┬────────┐
#> │ id  ┆ values │
#> │ --- ┆ ---    │
#> │ i32 ┆ f64    │
#> ╞═════╪════════╡
#> │ 1   ┆ 1.0    │
#> │ 1   ┆ 2.0    │
#> │ 2   ┆ 3.0    │
#> │ 2   ┆ 4.0    │
#> │ 2   ┆ 5.0    │
#> │ 3   ┆ 6.0    │
#> └─────┴────────┘

# With indices
unnest_longer_polars(df, values, indices_to = "idx")
#> shape: (6, 3)
#> ┌─────┬─────┬────────┐
#> │ id  ┆ idx ┆ values │
#> │ --- ┆ --- ┆ ---    │
#> │ i32 ┆ u32 ┆ f64    │
#> ╞═════╪═════╪════════╡
#> │ 1   ┆ 1   ┆ 1.0    │
#> │ 1   ┆ 2   ┆ 2.0    │
#> │ 2   ┆ 1   ┆ 3.0    │
#> │ 2   ┆ 2   ┆ 4.0    │
#> │ 2   ┆ 3   ┆ 5.0    │
#> │ 3   ┆ 1   ┆ 6.0    │
#> └─────┴─────┴────────┘

# Rename the output column
unnest_longer_polars(df, values, values_to = "val")
#> shape: (6, 2)
#> ┌─────┬─────┐
#> │ id  ┆ val │
#> │ --- ┆ --- │
#> │ i32 ┆ f64 │
#> ╞═════╪═════╡
#> │ 1   ┆ 1.0 │
#> │ 1   ┆ 2.0 │
#> │ 2   ┆ 3.0 │
#> │ 2   ┆ 4.0 │
#> │ 2   ┆ 5.0 │
#> │ 3   ┆ 6.0 │
#> └─────┴─────┘

# Multiple columns - list elements must have same length per row
df2 <- pl$DataFrame(
  id = 1:2,
  a = list(c(1, 2), c(3, 4)),
  b = list(c("x", "y"), c("z", "w"))
)
unnest_longer_polars(df2, c(a, b))
#> shape: (4, 3)
#> ┌─────┬─────┬─────┐
#> │ id  ┆ a   ┆ b   │
#> │ --- ┆ --- ┆ --- │
#> │ i32 ┆ f64 ┆ str │
#> ╞═════╪═════╪═════╡
#> │ 1   ┆ 1.0 ┆ x   │
#> │ 1   ┆ 2.0 ┆ y   │
#> │ 2   ┆ 3.0 ┆ z   │
#> │ 2   ┆ 4.0 ┆ w   │
#> └─────┴─────┴─────┘

# Multiple columns with values_to template
unnest_longer_polars(df2, c(a, b), values_to = "{col}_val")
#> shape: (4, 3)
#> ┌─────┬───────┬───────┐
#> │ id  ┆ a_val ┆ b_val │
#> │ --- ┆ ---   ┆ ---   │
#> │ i32 ┆ f64   ┆ str   │
#> ╞═════╪═══════╪═══════╡
#> │ 1   ┆ 1.0   ┆ x     │
#> │ 1   ┆ 2.0   ┆ y     │
#> │ 2   ┆ 3.0   ┆ z     │
#> │ 2   ┆ 4.0   ┆ w     │
#> └─────┴───────┴───────┘

# Multiple columns with indices_to template
unnest_longer_polars(df2, c(a, b), indices_to = "{col}_idx")
#> shape: (4, 5)
#> ┌─────┬───────┬─────┬───────┬─────┐
#> │ id  ┆ a_idx ┆ a   ┆ b_idx ┆ b   │
#> │ --- ┆ ---   ┆ --- ┆ ---   ┆ --- │
#> │ i32 ┆ u32   ┆ f64 ┆ u32   ┆ str │
#> ╞═════╪═══════╪═════╪═══════╪═════╡
#> │ 1   ┆ 1     ┆ 1.0 ┆ 1     ┆ x   │
#> │ 1   ┆ 2     ┆ 2.0 ┆ 2     ┆ y   │
#> │ 2   ┆ 1     ┆ 3.0 ┆ 1     ┆ z   │
#> │ 2   ┆ 2     ┆ 4.0 ┆ 2     ┆ w   │
#> └─────┴───────┴─────┴───────┴─────┘

# keep_empty example
df4 <- pl$DataFrame(
  id = 1:3,
  values = list(c(1, 2), NULL, 3)
)

# By default, NULL/empty values are dropped
unnest_longer_polars(df4, values)
#> shape: (3, 2)
#> ┌─────┬────────┐
#> │ id  ┆ values │
#> │ --- ┆ ---    │
#> │ i32 ┆ f64    │
#> ╞═════╪════════╡
#> │ 1   ┆ 1.0    │
#> │ 1   ┆ 2.0    │
#> │ 3   ┆ 3.0    │
#> └─────┴────────┘

# Use keep_empty = TRUE to keep them as NA
unnest_longer_polars(df4, values, keep_empty = TRUE)
#> shape: (4, 2)
#> ┌─────┬────────┐
#> │ id  ┆ values │
#> │ --- ┆ ---    │
#> │ i32 ┆ f64    │
#> ╞═════╪════════╡
#> │ 1   ┆ 1.0    │
#> │ 1   ┆ 2.0    │
#> │ 2   ┆ null   │
#> │ 3   ┆ 3.0    │
#> └─────┴────────┘
```
