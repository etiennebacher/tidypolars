# Helper functions to export data as a partitioned output

**\[experimental\]**

Partitioning schemes are used to write multiple files with `sink_*()`
and `write_*_polars()` functions. `partition_by()` allows to configure
the the writing process to multiple output files. It supports
partitioning by key, file size limits, or both.

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
