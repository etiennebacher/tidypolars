# Import data from IPC file(s)

`read_ipc_polars()` imports the data as a Polars DataFrame.

`scan_ipc_polars()` imports the data as a Polars LazyFrame.

## Usage

``` r
read_ipc_polars(
  source,
  ...,
  n_rows = NULL,
  row_index_name = NULL,
  row_index_offset = 0L,
  rechunk = FALSE,
  cache = TRUE,
  include_file_paths = NULL,
  memory_map
)

scan_ipc_polars(
  source,
  ...,
  n_rows = NULL,
  row_index_name = NULL,
  row_index_offset = 0L,
  rechunk = FALSE,
  cache = TRUE,
  include_file_paths = NULL,
  memory_map
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

- rechunk:

  Reallocate to contiguous memory when all chunks/files are parsed.

- cache:

  Cache the result after reading.

- include_file_paths:

  Include the path of the source file(s) as a column with this name.

- memory_map:

  **\[deprecated\]** Deprecated with no replacement.

## Value

The scan function returns a LazyFrame, the read function returns a
DataFrame.

## Examples

``` r
### Read or scan a single IPC file ------------------------

# Setup: create an IPC file
dest <- withr::local_tempfile(fileext = ".ipc")
arrow::write_ipc_file(mtcars, file(dest))

# Import this file as a DataFrame for eager evaluation
read_ipc_polars(dest) |>
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
scan_ipc_polars(dest) |>
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


### Read or scan several all IPC files in a folder ------------------------

# Setup: create a folder "output" that contains two IPC files
dest_folder <- withr::local_tempdir(tmpdir = "output")
dir.create(dest_folder, showWarnings = FALSE)
dest1 <- file.path(dest_folder, "output_1.ipc")
dest2 <- file.path(dest_folder, "output_2.ipc")

arrow::write_ipc_file(mtcars[1:16, ], dest1)
arrow::write_ipc_file(mtcars[17:32, ], dest2)
list.files(dest_folder)
#> [1] "output_1.ipc" "output_2.ipc"

# Import all files as a LazyFrame
scan_ipc_polars(dest_folder) |>
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


### Read or scan all IPC files that match a glob pattern ------------------------

# Setup: create a folder "output_glob" that contains three IPC files,
# two of which follow the pattern "output_XXX.ipc"
dest_folder <- withr::local_tempdir(tmpdir = "output_glob")
dir.create(dest_folder, showWarnings = FALSE)
dest1 <- file.path(dest_folder, "output_1.ipc")
dest2 <- file.path(dest_folder, "output_2.ipc")
dest3 <- file.path(dest_folder, "other_output.ipc")

arrow::write_ipc_file(mtcars[1:16, ], dest1)
arrow::write_ipc_file(mtcars[17:32, ], dest2)
arrow::write_ipc_file(iris, dest3)
list.files(dest_folder)
#> [1] "other_output.ipc" "output_1.ipc"     "output_2.ipc"    

# Import only the files whose name match "output_XXX.ipc" as a LazyFrame
scan_ipc_polars(paste0(dest_folder, "/output_*.ipc")) |>
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
