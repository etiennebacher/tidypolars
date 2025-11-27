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

It is possible to export a LazyFrame to multiple files, also called
*partitioned output*. A partition can be determined in several ways:

- by key(s): split by the values of keys. The amount of files that can
  be written is not limited. However, when writing beyond a certain
  amount of files, the data for the remaining partitions is buffered
  before writing to the file.

- by maximum number of rows: if the number of rows in a file reaches the
  maximum number of rows, the file is closed and a new file is opened.

These partitioning schemes can be used with the functions
[`partition_by_key()`](https://tidypolars.etiennebacher.com/reference/partitioned_output.md)
and
[`partition_by_max_size()`](https://tidypolars.etiennebacher.com/reference/partitioned_output.md).
See Examples below.

Writing a partitioned output usually requires setting `mkdir = TRUE` to
automatically create the required subfolders.

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
fs::dir_tree(out_path)
#> /var/folders/p6/nlmq3k8146990kpkxl73mq340000gn/T//RtmpFuoM5S/file14fa751cfc50
#> ├── am=0.0
#> │   ├── cyl=4.0
#> │   │   └── 0.parquet
#> │   ├── cyl=6.0
#> │   │   └── 0.parquet
#> │   └── cyl=8.0
#> │       └── 0.parquet
#> └── am=1.0
#>     ├── cyl=4.0
#>     │   └── 0.parquet
#>     ├── cyl=6.0
#>     │   └── 0.parquet
#>     └── cyl=8.0
#>         └── 0.parquet

# Split the LazyFrame by max number of rows per file:
out_path <- withr::local_tempdir()
sink_parquet(my_lf, partition_by_max_size(out_path, max_size = 5), mkdir = TRUE)
fs::dir_tree(out_path) # mtcars has 32 rows so we have 7 output files
#> /var/folders/p6/nlmq3k8146990kpkxl73mq340000gn/T//RtmpFuoM5S/file14fa41f92441
#> ├── 00000000.parquet
#> ├── 00000001.parquet
#> ├── 00000002.parquet
#> ├── 00000003.parquet
#> ├── 00000004.parquet
#> ├── 00000005.parquet
#> └── 00000006.parquet
```
