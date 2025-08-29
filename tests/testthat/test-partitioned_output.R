remove_temp_path <- function(x) {
  x[1] <- "<scrubbed>"
  x
}

test_that("partition_by_key() works", {
  skip_if_not_installed("fs")

  my_lf <- as_polars_lf(mtcars)

  out_path <- withr::local_tempdir()
  sink_csv(my_lf, partition_by_key(out_path, by = c("am", "cyl")), mkdir = TRUE)
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  sink_ipc(my_lf, partition_by_key(out_path, by = c("am", "cyl")), mkdir = TRUE)
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  sink_ndjson(
    my_lf,
    partition_by_key(out_path, by = c("am", "cyl")),
    mkdir = TRUE
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  sink_parquet(
    my_lf,
    partition_by_key(out_path, by = c("am", "cyl")),
    mkdir = TRUE
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)
})

test_that("partition_by_max_size() works", {
  skip_if_not_installed("fs")

  my_lf <- as_polars_lf(mtcars)

  out_path <- withr::local_tempdir()
  sink_csv(my_lf, partition_by_max_size(out_path, max_size = 5), mkdir = TRUE)
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  sink_ipc(my_lf, partition_by_max_size(out_path, max_size = 5), mkdir = TRUE)
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  sink_ndjson(
    my_lf,
    partition_by_max_size(out_path, max_size = 5),
    mkdir = TRUE
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)

  out_path <- withr::local_tempdir()
  sink_parquet(
    my_lf,
    partition_by_max_size(out_path, max_size = 5),
    mkdir = TRUE
  )
  expect_snapshot(fs::dir_tree(out_path), transform = remove_temp_path)
})

rm(remove_temp_path)
