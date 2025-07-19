### [GENERATED AUTOMATICALLY] Update test-group_metadata.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("group_by() works without any variable", {
  expect_equal_lazy(
    as_polars_lf(mtcars) |> group_by(),
    as_polars_lf(mtcars)
  )
})

test_that("works with ungrouped data", {
  test <- pl$LazyFrame(
    x1 = c("a", "a", "b", "a", "c")
  )

  expect_equal_lazy(
    group_vars(test),
    character(0)
  )

  expect_equal_lazy(
    group_keys(test),
    tibble()
  )
})

test_that("works with grouped data", {
  test2 <- as_polars_lf(mtcars) |>
    group_by(cyl, am)

  expect_equal_lazy(
    group_vars(test2),
    c("cyl", "am")
  )

  expect_equal_lazy(
    group_keys(test2),
    tibble(cyl = rep(c(4, 6, 8), each = 2L), am = rep(c(0, 1), 3))
  )
})

test_that("argument .add works", {
  expect_equal_lazy(
    as_polars_lf(mtcars) |>
      group_by(cyl, am) |>
      group_by(vs) |>
      group_vars(),
    "vs"
  )

  expect_equal_lazy(
    as_polars_lf(mtcars) |>
      group_by(cyl, am) |>
      group_by(vs, .add = TRUE) |>
      group_vars(),
    c("cyl", "am", "vs")
  )

  expect_equal_lazy(
    as_polars_lf(mtcars) |>
      group_by(cyl, am) |>
      group_by(cyl, .add = TRUE) |>
      group_vars(),
    c("cyl", "am")
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
