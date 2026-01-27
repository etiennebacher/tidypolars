test_that("basic behavior works", {
  test <- tibble(
    origin = c("ALG", "FRA", "GER"),
    year = c(2020, 2020, 2021)
  )
  test2 <- tibble(
    destination = c("USA", "JPN", "BRA"),
    language = c("english", "japanese", "portuguese")
  )
  test_pl <- as_polars_df(test)
  test2_pl <- as_polars_df(test2)

  expect_is_tidypolars(cross_join(test_pl, test2_pl))

  expect_equal(
    cross_join(test_pl, test2_pl),
    cross_join(test, test2)
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
  test_pl <- as_polars_df(test)
  test2_pl <- as_polars_df(test2)

  expect_warning(
    cross_join(test_pl, test2_pl, copy = TRUE),
    "Argument `copy` is not supported by"
  )
  withr::with_options(
    list(tidypolars_unknown_args = "error"),
    expect_snapshot(
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
  test_pl <- as_polars_df(test)
  test2_pl <- as_polars_df(test2)

  expect_both_error(
    cross_join(test_pl, test2_pl, foo = TRUE),
    cross_join(test, test2, foo = TRUE)
  )
  expect_snapshot(
    cross_join(test_pl, test2_pl, foo = TRUE),
    error = TRUE
  )
  expect_both_error(
    suppressWarnings(cross_join(test_pl, test2_pl, copy = TRUE, foo = TRUE)),
    cross_join(test, test2, copy = TRUE, foo = TRUE)
  )
  expect_snapshot(
    cross_join(test_pl, test2_pl, copy = TRUE, foo = TRUE),
    error = TRUE
  )
})
