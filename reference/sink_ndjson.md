# Stream output to a NDJSON file

This writes the output of a query directly to a NDJSON file without
collecting it in the R session first. This is useful if the output of
the query is still larger than RAM as it would crash the R session if it
was collected into R.

## Usage

``` r
sink_ndjson(
  .data,
  path,
  ...,
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
# This is an example workflow where sink_ndjson() is not very useful because
# the data would fit in memory. It simply is an example of using it at the
# end of a piped workflow.

# Create files for the NDJSON input and output:
file_ndjson <- tempfile(fileext = ".ndjson")
file_ndjson2 <- tempfile(fileext = ".ndjson")

# Write some data in a CSV file
fake_data <- do.call("rbind", rep(list(mtcars), 1000))
jsonlite::stream_out(fake_data, file(file_ndjson), verbose = FALSE)

# In a new R session, we could read this file as a LazyFrame, do some operations,
# and write it to another NDJSON file without ever collecting it in the R session:
scan_ndjson_polars(file_ndjson) |>
  filter(cyl %in% c(4, 6), mpg > 22) |>
  mutate(
    hp_gear_ratio = hp / gear
  ) |>
  sink_ndjson(path = file_ndjson2)


#----------------------------------------------
# Write a LazyFrame to multiple files depending on various strategies.
my_lf <- as_polars_lf(mtcars)

# Split the LazyFrame by key(s) and write each split to a different file:
out_path <- withr::local_tempdir()
sink_ndjson(my_lf, partition_by_key(out_path, by = c("am", "cyl")), mkdir = TRUE)
#> Warning: `partition_by_key()` was deprecated in tidypolars 0.16.0.
#> ℹ Please use `partition_by(key = )` instead.
fs::dir_tree(out_path)
#> /tmp/RtmpDBqBv5/file194911c00bf4
#> ├── am=0.0
#> │   ├── cyl=4.0
#> │   │   └── 00000000.jsonl
#> │   ├── cyl=6.0
#> │   │   └── 00000000.jsonl
#> │   └── cyl=8.0
#> │       └── 00000000.jsonl
#> └── am=1.0
#>     ├── cyl=4.0
#>     │   └── 00000000.jsonl
#>     ├── cyl=6.0
#>     │   └── 00000000.jsonl
#>     └── cyl=8.0
#>         └── 00000000.jsonl

# Split the LazyFrame by max number of rows per file:
out_path <- withr::local_tempdir()
sink_ndjson(my_lf, partition_by_max_size(out_path, max_size = 5), mkdir = TRUE)
#> Warning: `partition_by_max_size()` was deprecated in tidypolars 0.16.0.
#> ℹ Please use `partition_by(max_rows_per_file = )` instead.
fs::dir_tree(out_path) # mtcars has 32 rows so we have 7 output files
#> /tmp/RtmpDBqBv5/file1949525f2d34
#> ├── 00000000.jsonl
#> ├── 00000001.jsonl
#> ├── 00000002.jsonl
#> ├── 00000003.jsonl
#> ├── 00000004.jsonl
#> ├── 00000005.jsonl
#> └── 00000006.jsonl
```
