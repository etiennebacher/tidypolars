patrick::with_parameters_test_that(
  "IPC and parquet can do a write-read roundtrip",
  {
    for_all(
      tests = 20,
      dat = data_frame_of(any_atomic(any_na = TRUE)),
      property = function(dat) {
        dat_pl <- as_polars_df(dat)
        dest <- tempfile(fileext = paste0(".", file_format))
        fn_read <- paste0("read_", file_format, "_polars")
        fn_write <- paste0("write_", file_format, "_polars")

        do.call(fn_write, list(.data = dat_pl, file = dest))

        out <- do.call(
          fn_read,
          args = list(source = dest)
        )

        expect_equal(
          out |> as.data.frame(),
          dat_pl |> as.data.frame()
        )
      }
    )
  },
  file_format = c("ipc", "parquet")
)

# Can't distinguish integers from floats
test_that("CSV can do a write-read roundtrip", {
  for_all(
    tests = 20,
    dat = data_frame_of(logical_(), date_(), character_()),
    property = function(dat) {
      dat_pl <- as_polars_df(dat)
      dest <- tempfile(fileext = ".csv")
      write_csv_polars(dat_pl, dest)
      out <- read_csv_polars(source = dest, try_parse_dates = TRUE)

      expect_equal(
        out |> as.data.frame(),
        dat_pl |> as.data.frame()
      )
    }
  )
})

# Doesn't work with dates
test_that("NDJSON can do a write-read roundtrip", {
  for_all(
    tests = 20,
    dat = data_frame_of(logical_(), character_()),
    property = function(dat) {
      dat_pl <- as_polars_df(dat)
      dest <- tempfile(fileext = ".ndjson")
      write_ndjson_polars(dat_pl, dest)
      out <- read_ndjson_polars(source = dest)

      expect_equal(
        out |> as.data.frame(),
        dat_pl |> as.data.frame()
      )
    }
  )
})

test_that("deprecated arguments in scan/read_csv_polars", {
  dat_pl <- as_polars_df(mtcars)
  dest <- tempfile(fileext = ".csv")
  x <- write_csv_polars(dat_pl, dest)

  expect_snapshot({
    new_dat <- scan_csv_polars(dest, dtypes = list(drat = pl$Float32))
  })
  expect_snapshot({
    x <- scan_csv_polars(dest, reuse_downloaded = TRUE)
  })
  expect_true(new_dat$collect_schema()[["drat"]]$eq(pl$Float32))

  expect_snapshot({
    new_dat <- read_csv_polars(dest, dtypes = list(drat = pl$Float32))
  })
  expect_snapshot({
    x <- read_csv_polars(dest, reuse_downloaded = TRUE)
  })
  expect_true(new_dat$collect_schema()[["drat"]]$eq(pl$Float32))
})

test_that("deprecated arguments in scan/read_ipc_polars", {
  dat_pl <- as_polars_df(mtcars)
  dest <- tempfile(fileext = ".arrow")
  x <- write_ipc_polars(dat_pl, dest)

  expect_snapshot({
    new_dat <- scan_ipc_polars(dest, memory_map = TRUE)
  })
  expect_snapshot({
    new_dat <- read_ipc_polars(dest, memory_map = TRUE)
  })
})

test_that("deprecated arguments in scan/read_ndjson_polars", {
  dat_pl <- as_polars_df(mtcars)
  dest <- tempfile(fileext = ".ndjson")
  x <- write_ndjson_polars(dat_pl, dest)

  expect_snapshot({
    new_dat <- scan_ndjson_polars(dest, reuse_downloaded = TRUE)
  })
  expect_snapshot({
    new_dat <- read_ndjson_polars(dest, reuse_downloaded = TRUE)
  })
})
