remove_temp_path <- function(x) {
  x[1] <- "<scrubbed>"
  x
}

test_that("partition_by() + key works", {
  skip_if_not_installed("fs")

  my_lf <- as_polars_lf(mtcars)

  out_path <- withr::local_tempdir()
  sink_csv(my_lf, partition_by(out_path, key = c("am", "cyl")), mkdir = TRUE)
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  sink_ipc(my_lf, partition_by(out_path, key = c("am", "cyl")), mkdir = TRUE)
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  sink_ndjson(
    my_lf,
    partition_by(out_path, key = c("am", "cyl")),
    mkdir = TRUE
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  sink_parquet(
    my_lf,
    partition_by(out_path, key = c("am", "cyl")),
    mkdir = TRUE
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)
})

test_that("partition_by() + key + include_key works", {
  skip_if_not_installed("fs")
  my_lf <- as_polars_lf(mtcars)
  keys <- c("am", "cyl")

  # include_key = TRUE
  out_path <- withr::local_tempdir()
  sink_csv(
    my_lf,
    partition_by(out_path, key = keys, include_key = TRUE),
    mkdir = TRUE
  )
  first_file <- read_csv_polars(fs::path(
    out_path,
    "am=0.0",
    "cyl=4.0",
    "00000000.csv"
  ))
  expect_true(all(keys %in% names(first_file)))

  # include_key = FALSE
  out_path <- withr::local_tempdir()
  sink_csv(
    my_lf,
    partition_by(out_path, key = keys, include_key = FALSE),
    mkdir = TRUE
  )
  first_file <- read_csv_polars(fs::path(
    out_path,
    "am=0.0",
    "cyl=4.0",
    "00000000.csv"
  ))
  expect_false(any(keys %in% names(first_file)))

  # include_key is specified but there are no keys
  expect_snapshot(
    sink_csv(
      my_lf,
      partition_by(out_path, max_rows_per_file = 1, include_key = FALSE),
      mkdir = TRUE
    ),
    error = TRUE
  )
})

test_that("partition_by() + max_rows_per_file works", {
  skip_if_not_installed("fs")

  my_lf <- as_polars_lf(mtcars)

  out_path <- withr::local_tempdir()
  sink_csv(my_lf, partition_by(out_path, max_rows_per_file = 5), mkdir = TRUE)
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  sink_ipc(my_lf, partition_by(out_path, max_rows_per_file = 5), mkdir = TRUE)
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  sink_ndjson(
    my_lf,
    partition_by(out_path, max_rows_per_file = 5),
    mkdir = TRUE
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  sink_parquet(
    my_lf,
    partition_by(out_path, max_rows_per_file = 5),
    mkdir = TRUE
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)
})

test_that("partition_by_key() is deprecated", {
  skip_if_not_installed("fs")

  my_lf <- as_polars_lf(mtcars)

  out_path <- withr::local_tempdir()
  expect_warning(
    sink_csv(
      my_lf,
      partition_by_key(out_path, by = c("am", "cyl")),
      mkdir = TRUE
    ),
    "deprecated"
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  expect_warning(
    sink_ipc(
      my_lf,
      partition_by_key(out_path, by = c("am", "cyl")),
      mkdir = TRUE
    ),
    "deprecated"
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  expect_warning(
    sink_ndjson(
      my_lf,
      partition_by_key(out_path, by = c("am", "cyl")),
      mkdir = TRUE
    ),
    "deprecated"
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  expect_warning(
    sink_parquet(
      my_lf,
      partition_by_key(out_path, by = c("am", "cyl")),
      mkdir = TRUE
    ),
    "deprecated"
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)
})

test_that("partition_by_max_size() is deprecated", {
  skip_if_not_installed("fs")

  my_lf <- as_polars_lf(mtcars)

  out_path <- withr::local_tempdir()
  expect_warning(
    sink_csv(
      my_lf,
      partition_by_max_size(out_path, max_size = 5),
      mkdir = TRUE
    ),
    "deprecated"
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  expect_warning(
    sink_ipc(
      my_lf,
      partition_by_max_size(out_path, max_size = 5),
      mkdir = TRUE
    ),
    "deprecated"
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  expect_warning(
    sink_ndjson(
      my_lf,
      partition_by_max_size(out_path, max_size = 5),
      mkdir = TRUE
    ),
    "deprecated"
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  expect_warning(
    sink_parquet(
      my_lf,
      partition_by_max_size(out_path, max_size = 5),
      mkdir = TRUE
    ),
    "deprecated"
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)
})

rm(remove_temp_path)
