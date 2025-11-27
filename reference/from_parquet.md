# Import data from Parquet file(s)

`read_parquet_polars()` imports the data as a Polars DataFrame.

`scan_parquet_polars()` imports the data as a Polars LazyFrame.

## Usage

``` r
read_parquet_polars(
  source,
  ...,
  n_rows = NULL,
  row_index_name = NULL,
  row_index_offset = 0L,
  parallel = "auto",
  hive_partitioning = NULL,
  hive_schema = NULL,
  try_parse_hive_dates = TRUE,
  glob = TRUE,
  rechunk = TRUE,
  low_memory = FALSE,
  storage_options = NULL,
  use_statistics = TRUE,
  cache = TRUE,
  include_file_paths = NULL
)

scan_parquet_polars(
  source,
  ...,
  n_rows = NULL,
  row_index_name = NULL,
  row_index_offset = 0L,
  parallel = "auto",
  hive_partitioning = NULL,
  hive_schema = NULL,
  try_parse_hive_dates = TRUE,
  glob = TRUE,
  rechunk = FALSE,
  low_memory = FALSE,
  storage_options = NULL,
  use_statistics = TRUE,
  cache = TRUE,
  include_file_paths = NULL
)
```

## Arguments

- source:

  Path(s) to a file or directory. When needing to authenticate for
  scanning cloud locations, see the `storage_options` parameter.

- ...:

  These dots are for future extensions and must be empty.

- n_rows:

  Stop reading from the source after reading `n_rows`.

- row_index_name:

  If not `NULL`, this will insert a row index column with the given
  name.

- row_index_offset:

  Offset to start the row index column (only used if the name is set by
  `row_index_name`).

- parallel:

  This determines the direction and strategy of parallelism.

  - `"auto"` (default): Will try to determine the optimal direction.

  - `"prefiltered"`: **\[experimental\]** Strategy first evaluates the
    pushed-down predicates in parallel and determines a mask of which
    rows to read. Then, it parallelizes over both the columns and the
    row groups while filtering out rows that do not need to be read.
    This can provide significant speedups for large files (i.e. many
    row-groups) with a predicate that filters clustered rows or filters
    heavily. In other cases, prefiltered may slow down the scan compared
    other strategies. Falls back to `"auto"` if no predicate is given.

  - `"columns"`, `"row_groups"`: Use the specified direction.

  - `"none"`: No parallelism.

- hive_partitioning:

  Infer statistics and schema from Hive partitioned sources and use them
  to prune reads. If `NULL` (default), it is automatically enabled when
  a single directory is passed, and otherwise disabled.

- hive_schema:

  **\[experimental\]** A list containing the column names and data types
  of the columns by which the data is partitioned, e.g.
  `list(a = pl$String, b = pl$Float32)`. If `NULL` (default), the schema
  of the Hive partitions is inferred.

- try_parse_hive_dates:

  Whether to try parsing hive values as date / datetime types.

- glob:

  Expand path given via globbing rules.

- rechunk:

  Reallocate to contiguous memory when all chunks/files are parsed.

- low_memory:

  Reduce memory pressure at the expense of performance

- storage_options:

  Named vector containing options that indicate how to connect to a
  cloud provider. The cloud providers currently supported are AWS, GCP,
  and Azure. See supported keys here:

  - [aws](https://docs.rs/object_store/latest/object_store/aws/enum.AmazonS3ConfigKey.html)

  - [gcp](https://docs.rs/object_store/latest/object_store/gcp/enum.GoogleConfigKey.html)

  - [azure](https://docs.rs/object_store/latest/object_store/azure/enum.AzureConfigKey.html)

  - Hugging Face (`hf://`): Accepts an API key under the token parameter
    `c(token = YOUR_TOKEN)` or by setting the `HF_TOKEN` environment
    variable.

  If `storage_options` is not provided, Polars will try to infer the
  information from environment variables.

- use_statistics:

  Use statistics in the parquet to determine if pages can be skipped
  from reading.

- cache:

  Cache the result after reading.

- include_file_paths:

  Include the path of the source file(s) as a column with this name.

## Value

The scan function returns a LazyFrame, the read function returns a
DataFrame.

## Examples

``` r
### Read or scan a single Parquet file ------------------------

# Setup: create a Parquet file
dest <- withr::local_tempfile(fileext = ".parquet")
dat <- as_polars_df(mtcars)
write_parquet_polars(dat, dest)

# Import this file as a DataFrame for eager evaluation
read_parquet_polars(dest) |>
  arrange(mpg)
#> shape: (32, 11)
#> ┌──────┬─────┬───────┬───────┬───┬─────┬─────┬──────┬──────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ vs  ┆ am  ┆ gear ┆ carb │
#> │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ --- ┆ ---  ┆ ---  │
#> │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64 ┆ f64  ┆ f64  │
#> ╞══════╪═════╪═══════╪═══════╪═══╪═════╪═════╪══════╪══════╡
#> │ 10.4 ┆ 8.0 ┆ 472.0 ┆ 205.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 10.4 ┆ 8.0 ┆ 460.0 ┆ 215.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 13.3 ┆ 8.0 ┆ 350.0 ┆ 245.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 14.3 ┆ 8.0 ┆ 360.0 ┆ 245.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 14.7 ┆ 8.0 ┆ 440.0 ┆ 230.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ …    ┆ …   ┆ …     ┆ …     ┆ … ┆ …   ┆ …   ┆ …    ┆ …    │
#> │ 27.3 ┆ 4.0 ┆ 79.0  ┆ 66.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> │ 30.4 ┆ 4.0 ┆ 75.7  ┆ 52.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 2.0  │
#> │ 30.4 ┆ 4.0 ┆ 95.1  ┆ 113.0 ┆ … ┆ 1.0 ┆ 1.0 ┆ 5.0  ┆ 2.0  │
#> │ 32.4 ┆ 4.0 ┆ 78.7  ┆ 66.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> │ 33.9 ┆ 4.0 ┆ 71.1  ┆ 65.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> └──────┴─────┴───────┴───────┴───┴─────┴─────┴──────┴──────┘

# Import this file as a LazyFrame for lazy evaluation
scan_parquet_polars(dest) |>
  arrange(mpg) |>
  compute()
#> shape: (32, 11)
#> ┌──────┬─────┬───────┬───────┬───┬─────┬─────┬──────┬──────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ vs  ┆ am  ┆ gear ┆ carb │
#> │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ --- ┆ ---  ┆ ---  │
#> │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64 ┆ f64  ┆ f64  │
#> ╞══════╪═════╪═══════╪═══════╪═══╪═════╪═════╪══════╪══════╡
#> │ 10.4 ┆ 8.0 ┆ 472.0 ┆ 205.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 10.4 ┆ 8.0 ┆ 460.0 ┆ 215.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 13.3 ┆ 8.0 ┆ 350.0 ┆ 245.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 14.3 ┆ 8.0 ┆ 360.0 ┆ 245.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 14.7 ┆ 8.0 ┆ 440.0 ┆ 230.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ …    ┆ …   ┆ …     ┆ …     ┆ … ┆ …   ┆ …   ┆ …    ┆ …    │
#> │ 27.3 ┆ 4.0 ┆ 79.0  ┆ 66.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> │ 30.4 ┆ 4.0 ┆ 75.7  ┆ 52.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 2.0  │
#> │ 30.4 ┆ 4.0 ┆ 95.1  ┆ 113.0 ┆ … ┆ 1.0 ┆ 1.0 ┆ 5.0  ┆ 2.0  │
#> │ 32.4 ┆ 4.0 ┆ 78.7  ┆ 66.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> │ 33.9 ┆ 4.0 ┆ 71.1  ┆ 65.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> └──────┴─────┴───────┴───────┴───┴─────┴─────┴──────┴──────┘


### Read or scan several all Parquet files in a folder ------------------------

# Setup: create a folder "output" that contains two Parquet files
dest_folder <- withr::local_tempdir(tmpdir = "output")
dir.create(dest_folder, showWarnings = FALSE)
dest1 <- file.path(dest_folder, "output_1.parquet")
dest2 <- file.path(dest_folder, "output_2.parquet")

write_parquet_polars(as_polars_df(mtcars[1:16, ]), dest1)
write_parquet_polars(as_polars_df(mtcars[17:32, ]), dest2)
list.files(dest_folder)
#> [1] "output_1.parquet" "output_2.parquet"

# Import all files as a LazyFrame
scan_parquet_polars(dest_folder) |>
  arrange(mpg) |>
  compute()
#> shape: (32, 11)
#> ┌──────┬─────┬───────┬───────┬───┬─────┬─────┬──────┬──────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ vs  ┆ am  ┆ gear ┆ carb │
#> │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ --- ┆ ---  ┆ ---  │
#> │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64 ┆ f64  ┆ f64  │
#> ╞══════╪═════╪═══════╪═══════╪═══╪═════╪═════╪══════╪══════╡
#> │ 10.4 ┆ 8.0 ┆ 472.0 ┆ 205.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 10.4 ┆ 8.0 ┆ 460.0 ┆ 215.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 13.3 ┆ 8.0 ┆ 350.0 ┆ 245.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 14.3 ┆ 8.0 ┆ 360.0 ┆ 245.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 14.7 ┆ 8.0 ┆ 440.0 ┆ 230.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ …    ┆ …   ┆ …     ┆ …     ┆ … ┆ …   ┆ …   ┆ …    ┆ …    │
#> │ 27.3 ┆ 4.0 ┆ 79.0  ┆ 66.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> │ 30.4 ┆ 4.0 ┆ 75.7  ┆ 52.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 2.0  │
#> │ 30.4 ┆ 4.0 ┆ 95.1  ┆ 113.0 ┆ … ┆ 1.0 ┆ 1.0 ┆ 5.0  ┆ 2.0  │
#> │ 32.4 ┆ 4.0 ┆ 78.7  ┆ 66.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> │ 33.9 ┆ 4.0 ┆ 71.1  ┆ 65.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> └──────┴─────┴───────┴───────┴───┴─────┴─────┴──────┴──────┘

# Include the file path to know where each row comes from
scan_parquet_polars(dest_folder, include_file_paths = "file_path") |>
  arrange(mpg) |>
  compute()
#> shape: (32, 12)
#> ┌──────┬─────┬───────┬───────┬───┬─────┬──────┬──────┬─────────────────────────────────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ am  ┆ gear ┆ carb ┆ file_path                       │
#> │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ ---  ┆ ---  ┆ ---                             │
#> │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64  ┆ f64  ┆ str                             │
#> ╞══════╪═════╪═══════╪═══════╪═══╪═════╪══════╪══════╪═════════════════════════════════╡
#> │ 10.4 ┆ 8.0 ┆ 472.0 ┆ 205.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 4.0  ┆ output/file14fa6117ce76/output… │
#> │ 10.4 ┆ 8.0 ┆ 460.0 ┆ 215.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 4.0  ┆ output/file14fa6117ce76/output… │
#> │ 13.3 ┆ 8.0 ┆ 350.0 ┆ 245.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 4.0  ┆ output/file14fa6117ce76/output… │
#> │ 14.3 ┆ 8.0 ┆ 360.0 ┆ 245.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 4.0  ┆ output/file14fa6117ce76/output… │
#> │ 14.7 ┆ 8.0 ┆ 440.0 ┆ 230.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 4.0  ┆ output/file14fa6117ce76/output… │
#> │ …    ┆ …   ┆ …     ┆ …     ┆ … ┆ …   ┆ …    ┆ …    ┆ …                               │
#> │ 27.3 ┆ 4.0 ┆ 79.0  ┆ 66.0  ┆ … ┆ 1.0 ┆ 4.0  ┆ 1.0  ┆ output/file14fa6117ce76/output… │
#> │ 30.4 ┆ 4.0 ┆ 75.7  ┆ 52.0  ┆ … ┆ 1.0 ┆ 4.0  ┆ 2.0  ┆ output/file14fa6117ce76/output… │
#> │ 30.4 ┆ 4.0 ┆ 95.1  ┆ 113.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 2.0  ┆ output/file14fa6117ce76/output… │
#> │ 32.4 ┆ 4.0 ┆ 78.7  ┆ 66.0  ┆ … ┆ 1.0 ┆ 4.0  ┆ 1.0  ┆ output/file14fa6117ce76/output… │
#> │ 33.9 ┆ 4.0 ┆ 71.1  ┆ 65.0  ┆ … ┆ 1.0 ┆ 4.0  ┆ 1.0  ┆ output/file14fa6117ce76/output… │
#> └──────┴─────┴───────┴───────┴───┴─────┴──────┴──────┴─────────────────────────────────┘


### Read or scan all Parquet files that match a glob pattern ------------------------

# Setup: create a folder "output_glob" that contains three Parquet files,
# two of which follow the pattern "output_XXX.parquet"
dest_folder <- withr::local_tempdir(tmpdir = "output_glob")
dir.create(dest_folder, showWarnings = FALSE)
dest1 <- file.path(dest_folder, "output_1.parquet")
dest2 <- file.path(dest_folder, "output_2.parquet")
dest3 <- file.path(dest_folder, "other_output.parquet")

write_parquet_polars(as_polars_df(mtcars[1:16, ]), dest1)
write_parquet_polars(as_polars_df(mtcars[17:32, ]), dest2)
write_parquet_polars(as_polars_df(iris), dest3)
list.files(dest_folder)
#> [1] "other_output.parquet" "output_1.parquet"     "output_2.parquet"    

# Import only the files whose name match "output_XXX.parquet" as a LazyFrame
scan_parquet_polars(paste0(dest_folder, "/output_*.parquet")) |>
  arrange(mpg) |>
  compute()
#> shape: (32, 11)
#> ┌──────┬─────┬───────┬───────┬───┬─────┬─────┬──────┬──────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ vs  ┆ am  ┆ gear ┆ carb │
#> │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ --- ┆ ---  ┆ ---  │
#> │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64 ┆ f64  ┆ f64  │
#> ╞══════╪═════╪═══════╪═══════╪═══╪═════╪═════╪══════╪══════╡
#> │ 10.4 ┆ 8.0 ┆ 472.0 ┆ 205.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 10.4 ┆ 8.0 ┆ 460.0 ┆ 215.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 13.3 ┆ 8.0 ┆ 350.0 ┆ 245.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 14.3 ┆ 8.0 ┆ 360.0 ┆ 245.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ 14.7 ┆ 8.0 ┆ 440.0 ┆ 230.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> │ …    ┆ …   ┆ …     ┆ …     ┆ … ┆ …   ┆ …   ┆ …    ┆ …    │
#> │ 27.3 ┆ 4.0 ┆ 79.0  ┆ 66.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> │ 30.4 ┆ 4.0 ┆ 75.7  ┆ 52.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 2.0  │
#> │ 30.4 ┆ 4.0 ┆ 95.1  ┆ 113.0 ┆ … ┆ 1.0 ┆ 1.0 ┆ 5.0  ┆ 2.0  │
#> │ 32.4 ┆ 4.0 ┆ 78.7  ┆ 66.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> │ 33.9 ┆ 4.0 ┆ 71.1  ┆ 65.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> └──────┴─────┴───────┴───────┴───┴─────┴─────┴──────┴──────┘
```
