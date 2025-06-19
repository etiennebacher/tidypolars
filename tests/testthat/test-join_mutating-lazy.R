### [GENERATED AUTOMATICALLY] Update test-join_mutating.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("error if no common variables and and `by` no provided", {
  skip_if_not_installed("withr")
  withr::local_options(list(rlib_message_verbosity = "quiet"))

  test <- neopolars::pl$LazyFrame(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  expect_snapshot_lazy(
    left_join(test, neopolars::as_polars_lf(iris)),
    error = TRUE
  )
})

test_that("basic behavior works", {
  skip_if_not_installed("withr")
  withr::local_options(list(rlib_message_verbosity = "quiet"))
  test <- neopolars::pl$LazyFrame(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- neopolars::pl$LazyFrame(
    x = c(1, 2, 4),
    y = c(1, 2, 4),
    z2 = c(4, 5, 7)
  )

  expect_is_tidypolars(left_join(test, test2))
  expect_is_tidypolars(right_join(test, test2))
  expect_is_tidypolars(full_join(test, test2))
  expect_is_tidypolars(inner_join(test, test2))

  expect_equal_lazy(
    left_join(test, test2),
    pl$LazyFrame(
      x = 1:3,
      y = 1:3,
      z = 1:3,
      z2 = c(4, 5, NA)
    )
  )

  expect_equal_lazy(
    right_join(test, test2),
    pl$LazyFrame(
      x = c(1, 2, 4),
      y = c(1, 2, 4),
      z2 = c(4, 5, 7),
      z = c(1, 2, NA)
    )
  )

  expect_equal_lazy(
    full_join(test, test2),
    pl$LazyFrame(
      x = c(1, 2, 4, 3),
      y = c(1, 2, 4, 3),
      z = c(1, 2, NA, 3),
      z2 = c(4, 5, 7, NA)
    )
  )

  expect_equal_lazy(
    inner_join(test, test2),
    pl$LazyFrame(
      x = c(1, 2),
      y = c(1, 2),
      z = c(1, 2),
      z2 = c(4, 5)
    )
  )
})

test_that("works if join by different variable names", {
  test <- neopolars::pl$LazyFrame(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- neopolars::pl$LazyFrame(
    x2 = c(1, 2, 4),
    y2 = c(1, 2, 4),
    z3 = c(4, 5, 7)
  )

  expect_equal_lazy(
    left_join(test, test2, join_by(x == x2, y == y2)),
    pl$LazyFrame(
      x = 1:3,
      y = 1:3,
      z = 1:3,
      z3 = c(4, 5, NA)
    )
  )

  expect_equal_lazy(
    left_join(test, test2, c("x" = "x2", "y" = "y2")),
    pl$LazyFrame(
      x = 1:3,
      y = 1:3,
      z = 1:3,
      z3 = c(4, 5, NA)
    )
  )
})

test_that("argument suffix works", {
  test <- neopolars::pl$LazyFrame(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- neopolars::pl$LazyFrame(
    x = c(1, 2, 4),
    y = c(1, 2, 4),
    z = c(4, 5, 7)
  )

  expect_colnames(
    left_join(test, test2, by = c("x", "y")),
    c("x", "y", "z.x", "z.y")
  )

  expect_colnames(
    left_join(test, test2, by = c("x", "y"), suffix = c(".hi", ".hello")),
    c("x", "y", "z.hi", "z.hello")
  )

  expect_snapshot_lazy(
    left_join(test, test2, by = c("x", "y"), suffix = c(".hi")),
    error = TRUE
  )
})

test_that("suffix + join_by works", {
  test <- neopolars::pl$LazyFrame(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- neopolars::pl$LazyFrame(
    x = c(1, 2, 4),
    y = c(1, 2, 4),
    z = c(4, 5, 7)
  )
  expect_colnames(
    left_join(test, test2, by = join_by(x, y)),
    c("x", "y", "z.x", "z.y")
  )

  expect_colnames(
    left_join(test, test2, by = join_by(x, y), suffix = c(".hi", ".hello")),
    c("x", "y", "z.hi", "z.hello")
  )

  expect_snapshot_lazy(
    left_join(test, test2, by = join_by(x, y), suffix = c(".hi")),
    error = TRUE
  )
})

test_that("argument relationship works", {
  test <- neopolars::pl$LazyFrame(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- neopolars::pl$LazyFrame(
    x = c(1, 2, 4),
    y = c(1, 2, 4),
    z = c(4, 5, 7)
  )

  expect_snapshot_lazy(
    left_join(test, test2, by = join_by(x, y), relationship = "foo"),
    error = TRUE
  )

  country <- neopolars::pl$LazyFrame(
    iso = c("FRA", "DEU"),
    value = 1:2
  )

  country_year <- neopolars::pl$LazyFrame(
    iso = rep(c("FRA", "DEU"), each = 2),
    year = rep(2019:2020, 2),
    value2 = 3:6
  )

  for (i in c(left_join, full_join, inner_join)) {
    expect_snapshot_lazy(
      do.call(
        i,
        list(country, country_year, join_by(iso), relationship = "one-to-one")
      ),
      error = TRUE
    )
    expect_snapshot_lazy(
      do.call(
        i,
        list(country, country_year, join_by(iso), relationship = "many-to-one")
      ),
      error = TRUE
    )
  }

  expect_snapshot_lazy(
    right_join(
      country,
      country_year,
      join_by(iso),
      relationship = "one-to-one"
    ),
    error = TRUE
  )

  expect_snapshot_lazy(
    right_join(
      country,
      country_year,
      join_by(iso),
      relationship = "one-to-many"
    ),
    error = TRUE
  )

  expect_equal_lazy(
    left_join(
      country,
      country_year,
      join_by(iso),
      relationship = "one-to-many"
    ),
    data.frame(
      iso = rep(c("FRA", "DEU"), each = 2),
      value = c(1, 1, 2, 2),
      year = rep(2019:2020, 2),
      value2 = 3:6
    )
  )

  expect_equal_lazy(
    left_join(
      country,
      country_year,
      join_by(iso),
      relationship = "many-to-many"
    ),
    data.frame(
      iso = rep(c("FRA", "DEU"), each = 2),
      value = c(1, 1, 2, 2),
      year = rep(2019:2020, 2),
      value2 = 3:6
    )
  )
})

test_that("argument na_matches works", {
  pdf1 <- pl$LazyFrame(a = c(1, NA, NA, NaN), val = 1:4)
  pdf2 <- pl$LazyFrame(a = c(1, 2, NA, NaN), val2 = 5:8)

  expect_snapshot_lazy(
    left_join(pdf1, pdf2, na_matches = "foo"),
    error = TRUE
  )

  expect_equal_lazy(
    left_join(pdf1, pdf2, "a") |>
      pull(val2),
    c(5, 7, 7, 8)
  )

  expect_equal_lazy(
    left_join(pdf1, pdf2, "a", na_matches = "never") |>
      pull(val2),
    c(5, NA, NA, 8)
  )

  # when doing full join, the result differs from dplyr because 1) row order is
  # not the same (NA go at the end) and 2) NaN are matched anyway
  expect_equal_lazy(
    full_join(pdf1, pdf2, "a") |>
      pull(a),
    c(1, 2, NA, NA, NaN)
  )

  expect_equal_lazy(
    full_join(pdf1, pdf2, "a", na_matches = "never") |>
      pull(a),
    c(1, 2, NA, NaN, NA, NA)
  )
})

test_that("error if two inputs don't have the same class", {
  skip_if_not_installed("withr")
  withr::local_options(list(rlib_message_verbosity = "quiet"))
  test <- neopolars::pl$LazyFrame(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- neopolars::pl$LazyFrame(
    x = c(1, 2, 4),
    y = c(1, 2, 4),
    z = c(4, 5, 7)
  )

  expect_snapshot_lazy(
    left_join(test, iris),
    error = TRUE
  )

  expect_equal_lazy(
    test2 |>
      mutate(foo = 1) |> # adds class "tidypolars"
      left_join(test2) |>
      select(-foo),
    test2 |>
      left_join(test2)
  )
})

test_that("unsupported args throw warning", {
  test <- neopolars::pl$LazyFrame(
    country = c("ALG", "FRA", "GER"),
    year = c(2020, 2020, 2021)
  )
  test2 <- neopolars::pl$LazyFrame(
    country = c("USA", "JPN", "BRA"),
    language = c("english", "japanese", "portuguese")
  )
  expect_warning(
    left_join(test, test2, by = "country", copy = TRUE),
    "Argument `copy` is not supported by tidypolars"
  )
  expect_warning(
    left_join(test, test2, by = "country", keep = TRUE),
    "Argument `keep` is not supported by tidypolars"
  )
  withr::with_options(
    list(tidypolars_unknown_args = "error"),
    expect_snapshot_lazy(
      left_join(test, test2, by = "country", keep = TRUE),
      error = TRUE
    )
  )
})

test_that("dots must be empty", {
  test <- neopolars::pl$LazyFrame(
    country = c("ALG", "FRA", "GER"),
    year = c(2020, 2020, 2021)
  )
  test2 <- neopolars::pl$LazyFrame(
    country = c("USA", "JPN", "BRA"),
    language = c("english", "japanese", "portuguese")
  )
  expect_snapshot_lazy(
    left_join(test, test2, by = "country", foo = TRUE),
    error = TRUE
  )
  expect_snapshot_lazy(
    left_join(test, test2, by = "country", copy = TRUE, foo = TRUE),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
