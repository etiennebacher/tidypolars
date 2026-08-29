test_that("basic behavior works", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)

  expect_is_tidypolars(rename(test_pl, miles_per_gallon = "mpg"))

  expect_equal(
    rename(test_pl, miles_per_gallon = "mpg", n_cyl = "cyl"),
    rename(test_df, miles_per_gallon = "mpg", n_cyl = "cyl")
  )

  expect_equal(
    rename(test_pl, miles_per_gallon = mpg, n_cyl = "cyl"),
    rename(test_df, miles_per_gallon = mpg, n_cyl = "cyl")
  )
})

test_that("rename_with works with builtin function", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    rename_with(test_pl, toupper, c(mpg, cyl)),
    rename_with(test_df, toupper, c(mpg, cyl))
  )

  expect_equal(
    rename_with(test_pl, toupper),
    rename_with(test_df, toupper)
  )

  expect_equal(
    rename_with(test_pl, toupper, contains("p")),
    rename_with(test_df, toupper, contains("p"))
  )
})

test_that("rename_with works with custom function", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  fn <- \(x) tolower(gsub(".", "_", x, fixed = TRUE))

  expect_equal(
    rename_with(test_pl, fn),
    rename_with(test_df, fn)
  )

  fn2 <- function(x) tolower(gsub(".", "_", x, fixed = TRUE))

  expect_is_tidypolars(rename_with(test_pl, fn2))

  expect_equal(
    rename_with(test_pl, fn2),
    rename_with(test_df, fn2)
  )
})

test_that("rename() preserves groups", {
  test_df <- tibble(
    g = c("a", "a", "b", "b"),
    h = c(1, 2, 1, 2),
    x = 1:4
  )
  test_pl <- as_polars_df(test_df) |>
    group_by(g, h, maintain_order = TRUE)
  test_df <- group_by(test_df, g, h)

  expect_equal(
    rename(test_pl, g2 = g),
    rename(test_df, g2 = g)
  )
  expect_equal(
    rename(test_pl, g2 = g, h2 = h),
    rename(test_df, g2 = g, h2 = h)
  )
  expect_equal(
    rename(test_pl, x2 = x),
    rename(test_df, x2 = x)
  )

  expect_equal(
    rename(test_pl, g2 = g) |> summarize(mean = mean(x)),
    rename(test_df, g2 = g) |> summarize(mean = mean(x))
  )
})

test_that("rename_with() preserves groups", {
  test_df <- tibble(
    g = c("a", "a", "b", "b"),
    h = c(1, 2, 1, 2),
    x = 1:4
  )
  test_pl <- as_polars_df(test_df) |>
    group_by(g, h, maintain_order = TRUE)
  test_df <- group_by(test_df, g, h)

  expect_equal(
    rename_with(test_pl, toupper, g),
    rename_with(test_df, toupper, g)
  )
  expect_equal(
    rename_with(test_pl, toupper, c(g, h)),
    rename_with(test_df, toupper, c(g, h))
  )
  expect_equal(
    rename_with(test_pl, toupper, x),
    rename_with(test_df, toupper, x)
  )

  expect_equal(
    rename_with(test_pl, toupper, g) |> summarize(mean = mean(x)),
    rename_with(test_df, toupper, g) |> summarize(mean = mean(x))
  )
})
