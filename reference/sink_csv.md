# Stream output to a CSV file

This function allows to stream a LazyFrame that is larger than RAM
directly to a `.csv` file without collecting it in the R session, thus
preventing crashes because of too small memory.

## Usage

``` r
sink_csv(
  .data,
  path,
  ...,
  include_bom = FALSE,
  include_header = TRUE,
  separator = ",",
  line_terminator = "\n",
  quote_char = "\"",
  batch_size = 1024,
  datetime_format = NULL,
  date_format = NULL,
  time_format = NULL,
  float_precision = NULL,
  null_value = "",
  quote_style = "necessary",
  maintain_order = TRUE,
  type_coercion = TRUE,
  predicate_pushdown = TRUE,
  projection_pushdown = TRUE,
  simplify_expression = TRUE,
  slice_pushdown = TRUE,
  no_optimization = FALSE,
  mkdir = FALSE,
  quote,
  null_values
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

- include_bom:

  Whether to include UTF-8 BOM (byte order mark) in the CSV output.

- include_header:

  Whether to include header in the CSV output.

- separator:

  Separate CSV fields with this symbol.

- line_terminator:

  String used to end each row.

- quote_char:

  Byte to use as quoting character.

- batch_size:

  Number of rows that will be processed per thread.

- datetime_format, date_format, time_format:

  A format string used to format date and time values. See `?strptime()`
  for accepted values. If no format specified, the default
  fractional-second precision is inferred from the maximum time unit
  found in the `Datetime` cols (if any).

- float_precision:

  Number of decimal places to write, applied to both `Float32` and
  `Float64` datatypes.

- null_value:

  A string representing null values (defaulting to the empty string).

- quote_style:

  Determines the quoting strategy used:

  - `"necessary"` (default): This puts quotes around fields only when
    necessary. They are necessary when fields contain a quote, delimiter
    or record terminator. Quotes are also necessary when writing an
    empty record (which is indistinguishable from a record with one
    empty field).

  - `"always"`: This puts quotes around every field.

  - `"non_numeric"`: This puts quotes around all fields that are
    non-numeric. Namely, when writing a field that does not parse as a
    valid float or integer, then quotes will be used even if they aren't
    strictly necessary.

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

- quote:

  **\[deprecated\]** Deprecated, use `quote_char` instead.

- null_values:

  **\[deprecated\]** Deprecated, use `null_value` instead.

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
# This is an example workflow where sink_csv() is not very useful because
# the data would fit in memory. It simply is an example of using it at the
# end of a piped workflow.

# Create files for the CSV input and output:
file_csv <- tempfile(fileext = ".csv")
file_csv2 <- tempfile(fileext = ".csv")

# Write some data in a CSV file
fake_data <- do.call("rbind", rep(list(mtcars), 1000))
write.csv(fake_data, file = file_csv, row.names = FALSE)

# In a new R session, we could read this file as a LazyFrame, do some operations,
# and write it to another CSV file without ever collecting it in the R session:
scan_csv_polars(file_csv) |>
  filter(cyl %in% c(4, 6), mpg > 22) |>
  mutate(
    hp_gear_ratio = hp / gear
  ) |>
  sink_csv(path = file_csv2)


#----------------------------------------------
# Write a LazyFrame to multiple files depending on various strategies.
my_lf <- as_polars_lf(mtcars)

# Split the LazyFrame by key(s) and write each split to a different file:
out_path <- withr::local_tempdir()
sink_csv(my_lf, partition_by_key(out_path, by = c("am", "cyl")), mkdir = TRUE)
fs::dir_tree(out_path)
#> /tmp/RtmpomTOOL/file1d6b67e371fd
#> ├── am=0.0
#> │   ├── cyl=4.0
#> │   │   └── 0.csv
#> │   ├── cyl=6.0
#> │   │   └── 0.csv
#> │   └── cyl=8.0
#> │       └── 0.csv
#> └── am=1.0
#>     ├── cyl=4.0
#>     │   └── 0.csv
#>     ├── cyl=6.0
#>     │   └── 0.csv
#>     └── cyl=8.0
#>         └── 0.csv

# Split the LazyFrame by max number of rows per file:
out_path <- withr::local_tempdir()
sink_csv(my_lf, partition_by_max_size(out_path, max_size = 5), mkdir = TRUE)
fs::dir_tree(out_path) # mtcars has 32 rows so we have 7 output files
#> /tmp/RtmpomTOOL/file1d6b7f6961c
#> ├── 00000000.csv
#> ├── 00000001.csv
#> ├── 00000002.csv
#> ├── 00000003.csv
#> ├── 00000004.csv
#> ├── 00000005.csv
#> └── 00000006.csv
```
