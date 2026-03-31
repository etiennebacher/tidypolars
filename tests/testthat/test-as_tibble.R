test_that("as_tibble() works", {
  test_pl <- pl$DataFrame(
    x1 = c("a", "a", "b"),
    x2 = 1:3,
    .schema_overrides = list(x2 = polars::pl$Int64)
  )

  expect_equal(
    as_tibble(test_pl),
    tibble(x1 = c("a", "a", "b"), x2 = 1:3)
  )

  expect_equal(
    as_tibble(test_pl, int64 = "character"),
    tibble(x1 = c("a", "a", "b"), x2 = c("1", "2", "3"))
  )
})

test_that("as_tibble() on grouped input returns grouped tibble", {
  test_df <- tibble(x1 = c("a", "a", "b"), x2 = 1:3)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> group_by(x1) |> mutate(x3 = x2 + 1) |> as_tibble(),
    test_df |> group_by(x1) |> mutate(x3 = x2 + 1)
  )
})
