# Fetch `n` rows of a LazyFrame

**\[deprecated\]**

Use [`head()`](https://rdrr.io/r/utils/head.html) before
[`collect()`](https://dplyr.tidyverse.org/reference/compute.html) to
only get a subset of the data.

## Usage

``` r
fetch(
  .data,
  n_rows = 500,
  type_coercion = TRUE,
  predicate_pushdown = TRUE,
  projection_pushdown = TRUE,
  simplify_expression = TRUE,
  slice_pushdown = TRUE,
  comm_subplan_elim = TRUE,
  comm_subexpr_elim = TRUE,
  cluster_with_columns = TRUE,
  no_optimization = FALSE,
  engine = c("auto", "in-memory", "streaming"),
  streaming = FALSE
)
```

## Arguments

- .data:

  A Polars LazyFrame

- n_rows:

  Number of rows to fetch.

- type_coercion:

  Coerce types such that operations succeed and run on minimal required
  memory (default is `TRUE`).

- predicate_pushdown:

  Applies filters as early as possible at scan level (default is
  `TRUE`).

- projection_pushdown:

  Select only the columns that are needed at the scan level (default is
  `TRUE`).

- simplify_expression:

  Various optimizations, such as constant folding and replacing
  expensive operations with faster alternatives (default is `TRUE`).

- slice_pushdown:

  Only load the required slice from the scan. Don't materialize sliced
  outputs level. Don't materialize sliced outputs (default is `TRUE`).

- comm_subplan_elim:

  Cache branching subplans that occur on self-joins or unions (default
  is `TRUE`).

- comm_subexpr_elim:

  Cache common subexpressions (default is `TRUE`).

- cluster_with_columns:

  Combine sequential independent calls to `$with_columns()`.

- no_optimization:

  Sets the following optimizations to `FALSE`: `predicate_pushdown`,
  `projection_pushdown`, `slice_pushdown`, `simplify_expression`.
  Default is `FALSE`.

- engine:

  The engine name to use for processing the query. One of the
  followings:

  - `"auto"` (default): Select the engine automatically. The
    `"in-memory"` engine will be selected for most cases.

  - `"in-memory"`: Use the in-memory engine.

  - `"streaming"`: Use the streaming engine, usually faster and can
    handle larger-than-memory data.

- streaming:

  **\[deprecated\]** Deprecated, use `engine` instead.

## Details

The parameter `n_rows` indicates how many rows from the LazyFrame should
be used at the beginning of the query, but it doesn't guarantee that
`n_rows` will be returned. For example, if the query contains a filter
or join operations with other datasets, then the final number of rows
can be lower than `n_rows`. On the other hand, appending some rows
during the query can lead to an output that has more rows than `n_rows`.

## See also

[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
for applying a lazy query on the full data.
