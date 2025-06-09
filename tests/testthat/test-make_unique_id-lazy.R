### [GENERATED AUTOMATICALLY] Update test-make_unique_id.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test <- as_polars_lf(mtcars)

  expect_is_tidypolars(make_unique_id(test, am, gear))

  expect_equal_lazy(
    make_unique_id(test, am, gear) |>
      slice_head(n = 3) |>
      pull(hash) |>
      unique() |>
      length(),
    1
  )

  expect_colnames(
    make_unique_id(test, am, gear),
    c(names(test), "hash")
  )

  expect_colnames(
    make_unique_id(test, am, gear, new_col = "foo"),
    c(names(test), "foo")
  )

  expect_equal_lazy(
    make_unique_id(test) |>
      pull(hash) |>
      unique() |>
      length(),
    32
  )
})

test_that("can't overwrite existing column", {
  mtcars2 <- mtcars
  mtcars2$hash <- 1
  test2 <- as_polars_lf(mtcars2)

  expect_snapshot_lazy(
    make_unique_id(test2, am, gear),
    error = TRUE
  )
  expect_snapshot_lazy(
    make_unique_id(mtcars),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
