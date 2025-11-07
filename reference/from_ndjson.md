# Import data from NDJSON file(s)

`read_ndjson_polars()` imports the data as a Polars DataFrame.

`scan_ndjson_polars()` imports the data as a Polars LazyFrame.

## Usage

``` r
read_ndjson_polars(
  source,
  ...,
  infer_schema_length = 100,
  batch_size = NULL,
  n_rows = NULL,
  low_memory = FALSE,
  rechunk = FALSE,
  row_index_name = NULL,
  row_index_offset = 0,
  ignore_errors = FALSE,
  reuse_downloaded
)

scan_ndjson_polars(
  source,
  ...,
  infer_schema_length = 100,
  batch_size = NULL,
  n_rows = NULL,
  low_memory = FALSE,
  rechunk = FALSE,
  row_index_name = NULL,
  row_index_offset = 0,
  ignore_errors = FALSE,
  reuse_downloaded
)
```

## Arguments

- source:

  Path(s) to a file or directory. When needing to authenticate for
  scanning cloud locations, see the `storage_options` parameter.

- ...:

  These dots are for future extensions and must be empty.

- infer_schema_length:

  The maximum number of rows to scan for schema inference. If `NULL`,
  the full data may be scanned (this is slow). Set
  `infer_schema = FALSE` to read all columns as `pl$String`.

- batch_size:

  Number of rows to read in each batch.

- n_rows:

  Stop reading from the source after reading `n_rows`.

- low_memory:

  Reduce memory pressure at the expense of performance.

- rechunk:

  Reallocate to contiguous memory when all chunks/files are parsed.

- row_index_name:

  If not `NULL`, this will insert a row index column with the given
  name.

- row_index_offset:

  Offset to start the row index column (only used if the name is set by
  `row_index_name`).

- ignore_errors:

  Keep reading the file even if some lines yield errors. You can also
  use `infer_schema = FALSE` to read all columns as UTF8 to check which
  values might cause an issue.

- reuse_downloaded:

  **\[deprecated\]** Deprecated with no replacement.

## Value

The scan function returns a LazyFrame, the read function returns a
DataFrame.

## Examples

``` r
### Read or scan a single NDJSON file ------------------------

# Setup: create a NDJSON file
dest <- withr::local_tempfile(fileext = ".json")
jsonlite::stream_out(mtcars, file(dest), verbose = FALSE)

# Import this file as a DataFrame for eager evaluation
read_ndjson_polars(dest) |>
  arrange(mpg)
#> shape: (32, 12)
#> ┌──────┬─────┬───────┬─────┬───┬─────┬──────┬──────┬─────────────────────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp  ┆ … ┆ am  ┆ gear ┆ carb ┆ _row                │
#> │ ---  ┆ --- ┆ ---   ┆ --- ┆   ┆ --- ┆ ---  ┆ ---  ┆ ---                 │
#> │ f64  ┆ i64 ┆ f64   ┆ i64 ┆   ┆ i64 ┆ i64  ┆ i64  ┆ str                 │
#> ╞══════╪═════╪═══════╪═════╪═══╪═════╪══════╪══════╪═════════════════════╡
#> │ 10.4 ┆ 8   ┆ 472.0 ┆ 205 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Cadillac Fleetwood  │
#> │ 10.4 ┆ 8   ┆ 460.0 ┆ 215 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Lincoln Continental │
#> │ 13.3 ┆ 8   ┆ 350.0 ┆ 245 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Camaro Z28          │
#> │ 14.3 ┆ 8   ┆ 360.0 ┆ 245 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Duster 360          │
#> │ 14.7 ┆ 8   ┆ 440.0 ┆ 230 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Chrysler Imperial   │
#> │ …    ┆ …   ┆ …     ┆ …   ┆ … ┆ …   ┆ …    ┆ …    ┆ …                   │
#> │ 27.3 ┆ 4   ┆ 79.0  ┆ 66  ┆ … ┆ 1   ┆ 4    ┆ 1    ┆ Fiat X1-9           │
#> │ 30.4 ┆ 4   ┆ 75.7  ┆ 52  ┆ … ┆ 1   ┆ 4    ┆ 2    ┆ Honda Civic         │
#> │ 30.4 ┆ 4   ┆ 95.1  ┆ 113 ┆ … ┆ 1   ┆ 5    ┆ 2    ┆ Lotus Europa        │
#> │ 32.4 ┆ 4   ┆ 78.7  ┆ 66  ┆ … ┆ 1   ┆ 4    ┆ 1    ┆ Fiat 128            │
#> │ 33.9 ┆ 4   ┆ 71.1  ┆ 65  ┆ … ┆ 1   ┆ 4    ┆ 1    ┆ Toyota Corolla      │
#> └──────┴─────┴───────┴─────┴───┴─────┴──────┴──────┴─────────────────────┘

# Import this file as a LazyFrame for lazy evaluation
scan_ndjson_polars(dest) |>
  arrange(mpg) |>
  compute()
#> shape: (32, 12)
#> ┌──────┬─────┬───────┬─────┬───┬─────┬──────┬──────┬─────────────────────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp  ┆ … ┆ am  ┆ gear ┆ carb ┆ _row                │
#> │ ---  ┆ --- ┆ ---   ┆ --- ┆   ┆ --- ┆ ---  ┆ ---  ┆ ---                 │
#> │ f64  ┆ i64 ┆ f64   ┆ i64 ┆   ┆ i64 ┆ i64  ┆ i64  ┆ str                 │
#> ╞══════╪═════╪═══════╪═════╪═══╪═════╪══════╪══════╪═════════════════════╡
#> │ 10.4 ┆ 8   ┆ 472.0 ┆ 205 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Cadillac Fleetwood  │
#> │ 10.4 ┆ 8   ┆ 460.0 ┆ 215 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Lincoln Continental │
#> │ 13.3 ┆ 8   ┆ 350.0 ┆ 245 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Camaro Z28          │
#> │ 14.3 ┆ 8   ┆ 360.0 ┆ 245 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Duster 360          │
#> │ 14.7 ┆ 8   ┆ 440.0 ┆ 230 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Chrysler Imperial   │
#> │ …    ┆ …   ┆ …     ┆ …   ┆ … ┆ …   ┆ …    ┆ …    ┆ …                   │
#> │ 27.3 ┆ 4   ┆ 79.0  ┆ 66  ┆ … ┆ 1   ┆ 4    ┆ 1    ┆ Fiat X1-9           │
#> │ 30.4 ┆ 4   ┆ 75.7  ┆ 52  ┆ … ┆ 1   ┆ 4    ┆ 2    ┆ Honda Civic         │
#> │ 30.4 ┆ 4   ┆ 95.1  ┆ 113 ┆ … ┆ 1   ┆ 5    ┆ 2    ┆ Lotus Europa        │
#> │ 32.4 ┆ 4   ┆ 78.7  ┆ 66  ┆ … ┆ 1   ┆ 4    ┆ 1    ┆ Fiat 128            │
#> │ 33.9 ┆ 4   ┆ 71.1  ┆ 65  ┆ … ┆ 1   ┆ 4    ┆ 1    ┆ Toyota Corolla      │
#> └──────┴─────┴───────┴─────┴───┴─────┴──────┴──────┴─────────────────────┘


### Read or scan several all NDJSON files in a folder ------------------------

# Setup: create a folder "output" that contains two NDJSON files
dest_folder <- withr::local_tempdir(tmpdir = "output")
dir.create(dest_folder, showWarnings = FALSE)
dest1 <- file.path(dest_folder, "output_1.json")
dest2 <- file.path(dest_folder, "output_2.json")

jsonlite::stream_out(mtcars[1:16, ], file(dest1), verbose = FALSE)
jsonlite::stream_out(mtcars[17:32, ], file(dest2), verbose = FALSE)
list.files(dest_folder)
#> [1] "output_1.json" "output_2.json"

# Import all files as a LazyFrame
scan_ndjson_polars(dest_folder) |>
  arrange(mpg) |>
  compute()
#> shape: (32, 12)
#> ┌──────┬─────┬───────┬─────┬───┬─────┬──────┬──────┬─────────────────────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp  ┆ … ┆ am  ┆ gear ┆ carb ┆ _row                │
#> │ ---  ┆ --- ┆ ---   ┆ --- ┆   ┆ --- ┆ ---  ┆ ---  ┆ ---                 │
#> │ f64  ┆ i64 ┆ f64   ┆ i64 ┆   ┆ i64 ┆ i64  ┆ i64  ┆ str                 │
#> ╞══════╪═════╪═══════╪═════╪═══╪═════╪══════╪══════╪═════════════════════╡
#> │ 10.4 ┆ 8   ┆ 472.0 ┆ 205 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Cadillac Fleetwood  │
#> │ 10.4 ┆ 8   ┆ 460.0 ┆ 215 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Lincoln Continental │
#> │ 13.3 ┆ 8   ┆ 350.0 ┆ 245 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Camaro Z28          │
#> │ 14.3 ┆ 8   ┆ 360.0 ┆ 245 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Duster 360          │
#> │ 14.7 ┆ 8   ┆ 440.0 ┆ 230 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Chrysler Imperial   │
#> │ …    ┆ …   ┆ …     ┆ …   ┆ … ┆ …   ┆ …    ┆ …    ┆ …                   │
#> │ 27.3 ┆ 4   ┆ 79.0  ┆ 66  ┆ … ┆ 1   ┆ 4    ┆ 1    ┆ Fiat X1-9           │
#> │ 30.4 ┆ 4   ┆ 75.7  ┆ 52  ┆ … ┆ 1   ┆ 4    ┆ 2    ┆ Honda Civic         │
#> │ 30.4 ┆ 4   ┆ 95.1  ┆ 113 ┆ … ┆ 1   ┆ 5    ┆ 2    ┆ Lotus Europa        │
#> │ 32.4 ┆ 4   ┆ 78.7  ┆ 66  ┆ … ┆ 1   ┆ 4    ┆ 1    ┆ Fiat 128            │
#> │ 33.9 ┆ 4   ┆ 71.1  ┆ 65  ┆ … ┆ 1   ┆ 4    ┆ 1    ┆ Toyota Corolla      │
#> └──────┴─────┴───────┴─────┴───┴─────┴──────┴──────┴─────────────────────┘


### Read or scan all NDJSON files that match a glob pattern ------------------------

# Setup: create a folder "output_glob" that contains three NDJSON files,
# two of which follow the pattern "output_XXX.json"
dest_folder <- withr::local_tempdir(tmpdir = "output_glob")
dir.create(dest_folder, showWarnings = FALSE)
dest1 <- file.path(dest_folder, "output_1.json")
dest2 <- file.path(dest_folder, "output_2.json")
dest3 <- file.path(dest_folder, "other_output.json")

jsonlite::stream_out(mtcars[1:16, ], file(dest1), verbose = FALSE)
jsonlite::stream_out(mtcars[17:32, ], file(dest2), verbose = FALSE)
jsonlite::stream_out(iris, file(dest3), verbose = FALSE)
list.files(dest_folder)
#> [1] "other_output.json" "output_1.json"     "output_2.json"    

# Import only the files whose name match "output_XXX.json" as a LazyFrame
scan_ndjson_polars(paste0(dest_folder, "/output_*.json")) |>
  arrange(mpg) |>
  compute()
#> shape: (32, 12)
#> ┌──────┬─────┬───────┬─────┬───┬─────┬──────┬──────┬─────────────────────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp  ┆ … ┆ am  ┆ gear ┆ carb ┆ _row                │
#> │ ---  ┆ --- ┆ ---   ┆ --- ┆   ┆ --- ┆ ---  ┆ ---  ┆ ---                 │
#> │ f64  ┆ i64 ┆ f64   ┆ i64 ┆   ┆ i64 ┆ i64  ┆ i64  ┆ str                 │
#> ╞══════╪═════╪═══════╪═════╪═══╪═════╪══════╪══════╪═════════════════════╡
#> │ 10.4 ┆ 8   ┆ 472.0 ┆ 205 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Cadillac Fleetwood  │
#> │ 10.4 ┆ 8   ┆ 460.0 ┆ 215 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Lincoln Continental │
#> │ 13.3 ┆ 8   ┆ 350.0 ┆ 245 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Camaro Z28          │
#> │ 14.3 ┆ 8   ┆ 360.0 ┆ 245 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Duster 360          │
#> │ 14.7 ┆ 8   ┆ 440.0 ┆ 230 ┆ … ┆ 0   ┆ 3    ┆ 4    ┆ Chrysler Imperial   │
#> │ …    ┆ …   ┆ …     ┆ …   ┆ … ┆ …   ┆ …    ┆ …    ┆ …                   │
#> │ 27.3 ┆ 4   ┆ 79.0  ┆ 66  ┆ … ┆ 1   ┆ 4    ┆ 1    ┆ Fiat X1-9           │
#> │ 30.4 ┆ 4   ┆ 75.7  ┆ 52  ┆ … ┆ 1   ┆ 4    ┆ 2    ┆ Honda Civic         │
#> │ 30.4 ┆ 4   ┆ 95.1  ┆ 113 ┆ … ┆ 1   ┆ 5    ┆ 2    ┆ Lotus Europa        │
#> │ 32.4 ┆ 4   ┆ 78.7  ┆ 66  ┆ … ┆ 1   ┆ 4    ┆ 1    ┆ Fiat 128            │
#> │ 33.9 ┆ 4   ┆ 71.1  ┆ 65  ┆ … ┆ 1   ┆ 4    ┆ 1    ┆ Toyota Corolla      │
#> └──────┴─────┴───────┴─────┴───┴─────┴──────┴──────┴─────────────────────┘
```
