### [GENERATED AUTOMATICALLY] Update test-as_tibble.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("as_tibble() works", {
  test_pl <- pl$LazyFrame(
    x1 = c("a", "a", "b"),
    x2 = 1:3,
    .schema_overrides = list(x2 = polars::pl$Int64)
  )

  expect_equal_lazy(
    as_tibble(test_pl),
    tibble(x1 = c("a", "a", "b"), x2 = 1:3)
  )

  expect_equal_lazy(
    as_tibble(test_pl, int64 = "character"),
    tibble(x1 = c("a", "a", "b"), x2 = c("1", "2", "3"))
  )
})

test_that("as_tibble() on grouped input returns grouped tibble", {
  test_df <- tibble(x1 = c("a", "a", "b"), x2 = 1:3)
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> group_by(x1) |> mutate(x3 = x2 + 1) |> as_tibble(),
    test_df |> group_by(x1) |> mutate(x3 = x2 + 1)
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
