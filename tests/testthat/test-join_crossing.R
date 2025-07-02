test_that("basic behavior works", {
  test <- polars::pl$DataFrame(
    origin = c("ALG", "FRA", "GER"),
    year = c(2020, 2020, 2021)
  )

  test2 <- polars::pl$DataFrame(
    destination = c("USA", "JPN", "BRA"),
    language = c("english", "japanese", "portuguese")
  )

  expect_is_tidypolars(cross_join(test, test2))

  expect_dim(
    cross_join(test, test2),
    c(9, 4)
  )

  expect_equal(
    cross_join(test, test2) |>
      pull(origin),
    rep(c("ALG", "FRA", "GER"), each = 3)
  )
})

test_that("unsupported args throw warning", {
  test <- polars::pl$DataFrame(
    country = c("ALG", "FRA", "GER"),
    year = c(2020, 2020, 2021)
  )
  test2 <- polars::pl$DataFrame(
    country = c("USA", "JPN", "BRA"),
    language = c("english", "japanese", "portuguese")
  )
  expect_warning(
    cross_join(test, test2, copy = TRUE),
    "Argument `copy` is not supported by"
  )
  withr::with_options(
    list(tidypolars_unknown_args = "error"),
    expect_snapshot(
      cross_join(test, test2, copy = TRUE),
      error = TRUE
    )
  )
})

test_that("dots must be empty", {
  test <- polars::pl$DataFrame(
    country = c("ALG", "FRA", "GER"),
    year = c(2020, 2020, 2021)
  )
  test2 <- polars::pl$DataFrame(
    country = c("USA", "JPN", "BRA"),
    language = c("english", "japanese", "portuguese")
  )
  expect_snapshot(
    cross_join(test, test2, foo = TRUE),
    error = TRUE
  )
  expect_snapshot(
    cross_join(test, test2, copy = TRUE, foo = TRUE),
    error = TRUE
  )
})
