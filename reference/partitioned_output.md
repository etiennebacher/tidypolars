# Helper functions to export a LazyFrame as a partitioned output

**\[experimental\]** More details and examples in the documentation of
`sink_*()` functions.

## Usage

``` r
partition_by_key(
  base_path,
  ...,
  by,
  include_key = TRUE,
  per_partition_sort_by = NULL
)

partition_by_max_size(base_path, ..., max_size, per_partition_sort_by = NULL)
```

## Arguments

- base_path:

  The base path for the output files. Use the `mkdir` option of the
  `sink_*` methods to ensure directories in the path are created.

- ...:

  These dots are for future extensions and must be empty.

- by:

  Something can be coerced to a list of Polars expressions. Used to
  partition by.

- include_key:

  If `TRUE` (default), include the key columns in the output files.

- per_partition_sort_by:

  Something can be coerced to a list of Polars expressions, or `NULL`
  (default). Used to sort over within each partition. Note that this
  might increase the memory consumption needed for each partition.

- max_size:

  An integer-ish value indicating the maximum number of rows in each of
  the generated files.
