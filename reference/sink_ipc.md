# Stream output to an IPC file

This function allows to stream a LazyFrame that is larger than RAM
directly to an IPC file without collecting it in the R session, thus
preventing crashes because of too small memory.

## Usage

``` r
sink_ipc(
  .data,
  path,
  ...,
  compression = "zstd",
  compat_level = "newest",
  maintain_order = TRUE,
  type_coercion = TRUE,
  predicate_pushdown = TRUE,
  projection_pushdown = TRUE,
  simplify_expression = TRUE,
  slice_pushdown = TRUE,
  no_optimization = FALSE,
  mkdir = FALSE
)
```

## Arguments

- .data:

  A Polars LazyFrame.

- path:

  Output file. Can also be a `partition_*()` function to export the
  output to multiple files (see Details section below).

- ...:

  Ignored.

- compression:

  `NULL` or a character of the compression method, `"uncompressed"` or
  "lz4" or "zstd". `NULL` is equivalent to `"uncompressed"`. Choose
  "zstd" for good compression performance. Choose "lz4" for fast
  compression/decompression.

- compat_level:

  Determines the compatibility level when exporting Polars' internal
  data structures. When specifying a new compatibility level, Polars
  exports its internal data structures that might not be interpretable
  by other Arrow implementations. The level can be specified as the name
  (e.g., `"newest"`) or as a scalar integer (currently, 0 or 1 is
  supported).

  - `"newest"` (default): Use the highest level, currently same as 1
    (Low compatibility).

  - `"oldest"`: Same as 0 (High compatibility).

- maintain_order:

  Whether maintain the order the data was processed (default is `TRUE`).
  Setting this to `FALSE` will be slightly faster.

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

- no_optimization:

  Sets the following optimizations to `FALSE`: `predicate_pushdown`,
  `projection_pushdown`, `slice_pushdown`, `simplify_expression`.
  Default is `FALSE`.

- mkdir:

  Recursively create all the directories in the path.

## Value

The input LazyFrame.

## Details

### Partitioned output

It is possible to export data to multiple files based on various
parameters, such as the values of some variables, or such that each file
has a maximum number of rows. See
[`partition_by()`](https://tidypolars.etiennebacher.com/reference/partitioned_output.md)
for more details.

## Examples

``` r
# This is an example workflow where sink_ipc() is not very useful because
# the data would fit in memory. It simply is an example of using it at the
# end of a piped workflow.

# Create files for the IPC input and output:
file_ipc <- tempfile(fileext = ".ipc")
file_ipc2 <- tempfile(fileext = ".ipc")

# Write some data in an IPC file
fake_data <- do.call("rbind", rep(list(mtcars), 1000))
arrow::write_ipc_file(fake_data, file_ipc)

# In a new R session, we could read this file as a LazyFrame, do some operations,
# and write it to another IPC file without ever collecting it in the R session:
scan_ipc_polars(file_ipc) |>
  filter(cyl %in% c(4, 6), mpg > 22) |>
  mutate(
    hp_gear_ratio = hp / gear
  ) |>
  sink_ipc(path = file_ipc2)


#----------------------------------------------
# Write a LazyFrame to multiple files depending on various strategies.
my_lf <- as_polars_lf(mtcars)

# Split the LazyFrame by key(s) and write each split to a different file:
out_path <- withr::local_tempdir()
sink_ipc(my_lf, partition_by_key(out_path, by = c("am", "cyl")), mkdir = TRUE)
#> Warning: `partition_by_key()` was deprecated in tidypolars 0.16.0.
#> ℹ Please use `partition_by(key = )` instead.
fs::dir_tree(out_path)
#> /tmp/Rtmpx1jwA5/file1b942a5ce7eb
#> ├── am=0.0
#> │   ├── cyl=4.0
#> │   │   └── 00000000.ipc
#> │   ├── cyl=6.0
#> │   │   └── 00000000.ipc
#> │   └── cyl=8.0
#> │       └── 00000000.ipc
#> └── am=1.0
#>     ├── cyl=4.0
#>     │   └── 00000000.ipc
#>     ├── cyl=6.0
#>     │   └── 00000000.ipc
#>     └── cyl=8.0
#>         └── 00000000.ipc

# Split the LazyFrame by max number of rows per file:
out_path <- withr::local_tempdir()
sink_ipc(my_lf, partition_by_max_size(out_path, max_size = 5), mkdir = TRUE)
#> Warning: `partition_by_max_size()` was deprecated in tidypolars 0.16.0.
#> ℹ Please use `partition_by(max_rows_per_file = )` instead.
fs::dir_tree(out_path) # mtcars has 32 rows so we have 7 output files
#> /tmp/Rtmpx1jwA5/file1b945652f1f9
#> ├── 00000000.ipc
#> ├── 00000001.ipc
#> ├── 00000002.ipc
#> ├── 00000003.ipc
#> ├── 00000004.ipc
#> ├── 00000005.ipc
#> └── 00000006.ipc
```
