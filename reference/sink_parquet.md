# Stream output to a parquet file

This function allows to stream a LazyFrame that is larger than RAM
directly to a `.parquet` file without collecting it in the R session,
thus preventing crashes because of too small memory.

## Usage

``` r
sink_parquet(
  .data,
  path,
  ...,
  compression = "zstd",
  compression_level = 3,
  statistics = FALSE,
  row_group_size = NULL,
  data_page_size = NULL,
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

  The compression method. One of :

  - "uncompressed"

  - "zstd" (default): good compression performance

  - "lz4": fast compression / decompression

  - "snappy": more backwards compatibility guarantees when you deal with
    older parquet readers.

  - "gzip", "lzo", "brotli"

- compression_level:

  The level of compression to use (default is 3). Only used if
  `compression` is one of "gzip", "brotli", or "zstd". Higher
  compression means smaller files on disk.

  - "gzip" : min-level = 0, max-level = 10

  - "brotli" : min-level = 0, max-level = 11

  - "zstd" : min-level = 1, max-level = 22.

- statistics:

  Whether to compute and write column statistics (default is `FALSE`).
  This requires more computations.

- row_group_size:

  Size of the row groups in number of rows. If `NULL` (default), the
  chunks of the DataFrame are used. Writing in smaller chunks may reduce
  memory pressure and improve writing speeds.

- data_page_size:

  If `NULL` (default), the limit will be around 1MB.

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
# This is an example workflow where sink_parquet() is not very useful because
# the data would fit in memory. It simply is an example of using it at the
# end of a piped workflow.

# Create files for the CSV input and the Parquet output:
file_csv <- tempfile(fileext = ".csv")
file_parquet <- tempfile(fileext = ".parquet")

# Write some data in a CSV file
fake_data <- do.call("rbind", rep(list(mtcars), 1000))
write.csv(fake_data, file = file_csv, row.names = FALSE)

# In a new R session, we could read this file as a LazyFrame, do some operations,
# and write it to a parquet file without ever collecting it in the R session:
scan_csv_polars(file_csv) |>
  filter(cyl %in% c(4, 6), mpg > 22) |>
  mutate(
    hp_gear_ratio = hp / gear
  ) |>
  sink_parquet(path = file_parquet)


#----------------------------------------------
# Write a LazyFrame to multiple files depending on various strategies.
my_lf <- as_polars_lf(mtcars)

# Split the LazyFrame by key(s) and write each split to a different file:
out_path <- withr::local_tempdir()
sink_parquet(my_lf, partition_by_key(out_path, by = c("am", "cyl")), mkdir = TRUE)
#> Warning: `partition_by_key()` was deprecated in tidypolars 0.16.0.
#> ℹ Please use `partition_by(key = )` instead.
fs::dir_tree(out_path)
#> /tmp/RtmpR169Uc/file1b1353128f76
#> ├── am=0.0
#> │   ├── cyl=4.0
#> │   │   └── 00000000.parquet
#> │   ├── cyl=6.0
#> │   │   └── 00000000.parquet
#> │   └── cyl=8.0
#> │       └── 00000000.parquet
#> └── am=1.0
#>     ├── cyl=4.0
#>     │   └── 00000000.parquet
#>     ├── cyl=6.0
#>     │   └── 00000000.parquet
#>     └── cyl=8.0
#>         └── 00000000.parquet

# Split the LazyFrame by max number of rows per file:
out_path <- withr::local_tempdir()
sink_parquet(my_lf, partition_by_max_size(out_path, max_size = 5), mkdir = TRUE)
#> Warning: `partition_by_max_size()` was deprecated in tidypolars 0.16.0.
#> ℹ Please use `partition_by(max_rows_per_file = )` instead.
fs::dir_tree(out_path) # mtcars has 32 rows so we have 7 output files
#> /tmp/RtmpR169Uc/file1b1334d4fcb1
#> ├── 00000000.parquet
#> ├── 00000001.parquet
#> ├── 00000002.parquet
#> ├── 00000003.parquet
#> ├── 00000004.parquet
#> ├── 00000005.parquet
#> └── 00000006.parquet
```
