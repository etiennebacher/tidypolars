### [GENERATED AUTOMATICALLY] Update test-join_crossing.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test <- tibble(
    origin = c("ALG", "FRA", "GER"),
    year = c(2020, 2020, 2021)
  )
  test2 <- tibble(
    destination = c("USA", "JPN", "BRA"),
    language = c("english", "japanese", "portuguese")
  )
  test_pl <- as_polars_lf(test)
  test2_pl <- as_polars_lf(test2)

  expect_is_tidypolars(cross_join(test_pl, test2_pl))

  expect_equal_lazy(
    cross_join(test_pl, test2_pl),
    tidyr::crossing(test, test2) |> as.data.frame()
  )

  expect_equal_lazy(
    cross_join(test_pl, test2_pl) |>
      pull(origin),
    rep(c("ALG", "FRA", "GER"), each = 3)
  )
})

test_that("unsupported args throw warning", {
  test <- tibble(
    country = c("ALG", "FRA", "GER"),
    year = c(2020, 2020, 2021)
  )
  test2 <- tibble(
    country = c("USA", "JPN", "BRA"),
    language = c("english", "japanese", "portuguese")
  )
  test_pl <- as_polars_lf(test)
  test2_pl <- as_polars_lf(test2)

  expect_warning(
    cross_join(test_pl, test2_pl, copy = TRUE),
    "Argument `copy` is not supported by"
  )
  withr::with_options(
    list(tidypolars_unknown_args = "error"),
    expect_snapshot_lazy(
      cross_join(test_pl, test2_pl, copy = TRUE),
      error = TRUE
    )
  )
})

test_that("dots must be empty", {
  test <- tibble(
    country = c("ALG", "FRA", "GER"),
    year = c(2020, 2020, 2021)
  )
  test2 <- tibble(
    country = c("USA", "JPN", "BRA"),
    language = c("english", "japanese", "portuguese")
  )
  test_pl <- as_polars_lf(test)
  test2_pl <- as_polars_lf(test2)

  expect_snapshot_lazy(
    cross_join(test_pl, test2_pl, foo = TRUE),
    error = TRUE
  )
  expect_snapshot_lazy(
    cross_join(test_pl, test2_pl, copy = TRUE, foo = TRUE),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
