### [GENERATED AUTOMATICALLY] Update test-join_crossing.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test <- polars::pl$LazyFrame(
    origin = c("ALG", "FRA", "GER"),
    year = c(2020, 2020, 2021)
  )

  test2 <- polars::pl$LazyFrame(
    destination = c("USA", "JPN", "BRA"),
    language = c("english", "japanese", "portuguese")
  )

  expect_is_tidypolars(cross_join(test, test2))

  expect_dim(
    cross_join(test, test2),
    c(9, 4)
  )

  expect_equal_lazy(
    cross_join(test, test2) |>
      pull(origin),
    rep(c("ALG", "FRA", "GER"), each = 3)
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)