# Helper functions to export data as a partitioned output

**\[experimental\]**

Partitioning schemes are used to write multiple files with `sink_*()`
and `write_*_polars()` functions.

- `partition_by()`: Configuration for writing to multiple output files.
  Supports partitioning by key, file size limits, or both.

The following functions are deprecated and will be removed in a future
release:

- **\[deprecated\]** `partition_by_key()`: use `partition_by(key = ...)`
  instead.

- **\[deprecated\]** `partition_by_max_size()`: use
  `partition_by(max_rows_per_file = ...)` instead.

## Usage

``` r
partition_by(
  base_path,
  ...,
  key = NULL,
  include_key = NULL,
  max_rows_per_file = NULL,
  approximate_bytes_per_file = NULL
)

partition_by_key(base_path, ..., by, include_key = TRUE)

partition_by_max_size(base_path, ..., max_size)
```

## Arguments

- base_path:

  The base path for the output files. Use the `mkdir` option of the
  `sink_*` or `write_*_polars()` functions to ensure directories in the
  path are created.

- ...:

  These dots are for future extensions and must be empty.

- key:

  Something can be coerced to a list of Polars expressions. Used to
  partition by.

- include_key:

  A bool indicating whether to include the key columns in the output
  files. Can only be used if `key` is specified, otherwise should be
  `NULL`.

- max_rows_per_file:

  An integer-ish value indicating the maximum size in rows of each of
  the generated files.

- approximate_bytes_per_file:

  An integer-ish value indicating approximate number of bytes to write
  to each file, or `NULL`. This is measured as the estimated size of the
  DataFrame in memory. Defaults to approximately 4GB when `key` is
  specified without `max_rows_per_file`, otherwise unlimited.

- by:

  **\[deprecated\]** Something can be coerced to a list of Polars
  expressions. Used to partition by. Use the `key` property of
  `partition_by()` instead.

- max_size:

  **\[deprecated\]** An integer-ish value indicating the maximum size in
  rows of each of the generated files. Use the `max_rows_per_file`
  property of `partition_by()` instead.
