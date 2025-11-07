# Export data to Parquet file(s)

Export data to Parquet file(s)

## Usage

``` r
write_parquet_polars(
  .data,
  file,
  ...,
  compression = "zstd",
  compression_level = 3,
  statistics = TRUE,
  row_group_size = NULL,
  data_page_size = NULL,
  partition_by = NULL,
  partition_chunk_size_bytes = 4294967296
)
```

## Arguments

- .data:

  A Polars DataFrame.

- file:

  File path to which the result should be written.

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

- partition_by:

  Column(s) to partition by. A partitioned dataset will be written if
  this is specified.

- partition_chunk_size_bytes:

  Approximate size to split DataFrames within a single partition when
  writing. Note this is calculated using the size of the DataFrame in
  memory - the size of the output file may differ depending on the file
  format / compression.

## Value

The input DataFrame.

## Examples

``` r
dest <- tempfile(fileext = ".parquet")
mtcars |>
  as_polars_df() |>
  write_parquet_polars(dest)

nanoparquet::read_parquet(dest)
#> # A data frame: 32 × 11
#>      mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#>    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1  21       6  160    110  3.9   2.62  16.5     0     1     4     4
#>  2  21       6  160    110  3.9   2.88  17.0     0     1     4     4
#>  3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1
#>  4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1
#>  5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2
#>  6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1
#>  7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4
#>  8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2
#>  9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2
#> 10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4
#> # ℹ 22 more rows
```
