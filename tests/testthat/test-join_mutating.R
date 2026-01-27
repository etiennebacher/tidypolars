test_that("error if no common variables and and `by` no provided", {
  skip_if_not_installed("withr")
  withr::local_options(list(rlib_message_verbosity = "quiet"))

  test_pl <- polars::pl$DataFrame(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  expect_snapshot(
    left_join(test_pl, polars::as_polars_df(iris)),
    error = TRUE
  )
})

test_that("basic behavior works", {
  skip_if_not_installed("withr")
  withr::local_options(list(rlib_message_verbosity = "quiet"))
  test <- tibble(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- tibble(
    x = c(1, 2, 4),
    y = c(1, 2, 4),
    z2 = c(4, 5, 7)
  )
  test_pl <- as_polars_df(test)
  test2_pl <- as_polars_df(test2)

  expect_is_tidypolars(left_join(test_pl, test2_pl))
  expect_is_tidypolars(right_join(test_pl, test2_pl))
  expect_is_tidypolars(full_join(test_pl, test2_pl))
  expect_is_tidypolars(inner_join(test_pl, test2_pl))

  expect_equal(
    left_join(test_pl, test2_pl),
    left_join(test, test2)
  )

  # TODO? I don't think this is a big deal
  expect_equal(
    right_join(test_pl, test2_pl) |> select(x, y, z, z2),
    right_join(test, test2)
  )

  # TODO? I don't think this is a big deal and not specifying the row order in
  # polars join can improve performance.
  expect_equal(
    full_join(test_pl, test2_pl) |> arrange(x),
    full_join(test, test2)
  )

  expect_equal(
    inner_join(test_pl, test2_pl),
    inner_join(test, test2)
  )
})

test_that("works if join by different variable names", {
  test <- tibble(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- tibble(
    x2 = c(1, 2, 4),
    y2 = c(1, 2, 4),
    z3 = c(4, 5, 7)
  )
  test_pl <- as_polars_df(test)
  test2_pl <- as_polars_df(test2)

  expect_equal(
    left_join(test_pl, test2_pl, join_by(x == x2, y == y2)),
    left_join(test, test2, join_by(x == x2, y == y2))
  )

  expect_equal(
    left_join(test_pl, test2_pl, c("x" = "x2", "y" = "y2")),
    left_join(test, test2, c("x" = "x2", "y" = "y2"))
  )
})

test_that("argument suffix works", {
  test <- tibble(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- tibble(
    x = c(1, 2, 4),
    y = c(1, 2, 4),
    z = c(4, 5, 7)
  )
  test_pl <- as_polars_df(test)
  test2_pl <- as_polars_df(test2)

  expect_equal(
    left_join(test_pl, test2_pl, by = c("x", "y")),
    left_join(test, test2, by = c("x", "y"))
  )

  expect_equal(
    left_join(test_pl, test2_pl, by = c("x", "y"), suffix = c(".hi", ".hello")),
    left_join(test, test2, by = c("x", "y"), suffix = c(".hi", ".hello"))
  )

  expect_both_error(
    left_join(test_pl, test2_pl, by = c("x", "y"), suffix = c(".hi")),
    left_join(test, test2, by = c("x", "y"), suffix = c(".hi"))
  )
  expect_snapshot(
    left_join(test_pl, test2_pl, by = c("x", "y"), suffix = c(".hi")),
    error = TRUE
  )
})

test_that("suffix + join_by works", {
  test <- tibble(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- tibble(
    x = c(1, 2, 4),
    y = c(1, 2, 4),
    z = c(4, 5, 7)
  )
  test_pl <- as_polars_df(test)
  test2_pl <- as_polars_df(test2)

  expect_equal(
    left_join(test_pl, test2_pl, by = join_by(x, y)),
    left_join(test, test2, by = join_by(x, y))
  )
  expect_equal(
    left_join(
      test_pl,
      test2_pl,
      by = join_by(x, y),
      suffix = c(".hi", ".hello")
    ),
    left_join(test, test2, by = join_by(x, y), suffix = c(".hi", ".hello"))
  )
  expect_both_error(
    left_join(test_pl, test2_pl, by = join_by(x, y), suffix = c(".hi")),
    left_join(test, test2, by = join_by(x, y), suffix = c(".hi"))
  )
  expect_snapshot(
    left_join(test_pl, test2_pl, by = join_by(x, y), suffix = c(".hi")),
    error = TRUE
  )
})

test_that("argument relationship works", {
  test <- tibble(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- tibble(
    x = c(1, 2, 4),
    y = c(1, 2, 4),
    z = c(4, 5, 7)
  )
  test_pl <- as_polars_df(test)
  test2_pl <- as_polars_df(test2)

  expect_snapshot(
    left_join(test, test2, by = join_by(x, y), relationship = "foo"),
    error = TRUE
  )

  country <- tibble(
    iso = c("FRA", "DEU"),
    value = 1:2
  )
  country_year <- tibble(
    iso = rep(c("FRA", "DEU"), each = 2),
    year = rep(2019:2020, 2),
    value2 = 3:6
  )
  country_pl <- as_polars_df(country)
  country_year_pl <- as_polars_df(country_year)

  for (i in c(left_join, full_join, inner_join)) {
    expect_both_error(
      do.call(
        i,
        list(
          country_pl,
          country_year_pl,
          join_by(iso),
          relationship = "one-to-one"
        )
      ),
      do.call(
        i,
        list(
          country,
          country_year,
          join_by(iso),
          relationship = "one-to-one"
        )
      )
    )
    expect_snapshot(
      do.call(
        i,
        list(
          country_pl,
          country_year_pl,
          join_by(iso),
          relationship = "one-to-one"
        )
      ),
      error = TRUE
    )
    expect_both_error(
      do.call(
        i,
        list(
          country_pl,
          country_year_pl,
          join_by(iso),
          relationship = "many-to-one"
        )
      ),
      do.call(
        i,
        list(
          country,
          country_year,
          join_by(iso),
          relationship = "many-to-one"
        )
      )
    )
    expect_snapshot(
      do.call(
        i,
        list(
          country_pl,
          country_year_pl,
          join_by(iso),
          relationship = "many-to-one"
        )
      ),
      error = TRUE
    )
  }

  expect_both_error(
    right_join(
      country_pl,
      country_year_pl,
      join_by(iso),
      relationship = "one-to-one"
    ),
    right_join(
      country,
      country_year,
      join_by(iso),
      relationship = "one-to-one"
    )
  )
  expect_snapshot(
    right_join(
      country_pl,
      country_year_pl,
      join_by(iso),
      relationship = "one-to-one"
    ),
    error = TRUE
  )

  # TODO? tidypolars errors here, not tidyverse. This is because tidyverse
  # considers that in a right join with "one-to-many", the "one" is for the
  # first table and the "many" for the second table, while in polars, right-joining
  # "a" and "b" is equivalent to left joining "b" and "a". So in polars, the "one"
  # refers to "b" (the right table) and "many" refers to "a" (the left table).
  expect_snapshot(
    right_join(
      country_pl,
      country_year_pl,
      join_by(iso),
      relationship = "one-to-many"
    ),
    error = TRUE
  )

  expect_equal(
    left_join(
      country,
      country_year,
      join_by(iso),
      relationship = "one-to-many"
    ),
    left_join(
      country_pl,
      country_year_pl,
      join_by(iso),
      relationship = "one-to-many"
    )
  )

  expect_equal(
    left_join(
      country,
      country_year,
      join_by(iso),
      relationship = "many-to-many"
    ),
    left_join(
      country_pl,
      country_year_pl,
      join_by(iso),
      relationship = "many-to-many"
    )
  )
})

test_that("argument na_matches works", {
  test <- tibble(a = c(1, NA, NA, NaN), val = 1:4)
  test2 <- tibble(a = c(1, 2, NA, NaN), val2 = 5:8)
  test_pl <- as_polars_df(test)
  test2_pl <- as_polars_df(test2)

  expect_snapshot(
    left_join(test_pl, test2_pl, na_matches = "foo"),
    error = TRUE
  )

  expect_equal(
    left_join(test_pl, test2_pl, "a"),
    left_join(test, test2, "a")
  )

  # This cannot be compared to dplyr because polars always matches on NaN (this
  # is documented in the description of `na_matches` in ?left_join).
  expect_equal(
    left_join(test_pl, test2_pl, "a", na_matches = "never"),
    pl$DataFrame(
      a = c(1, NA, NA, NaN),
      val = 1:4,
      val2 = c(5L, NA, NA, 8L)
    )
  )

  # when doing full join, the result differs from dplyr because 1) row order is
  # not the same (NA go at the end) and 2) NaN are matched anyway (see above)
  expect_equal(
    full_join(test_pl, test2_pl, "a"),
    pl$DataFrame(
      a = c(1, 2, NA, NA, NaN),
      val = c(1L, NA, 2L, 3L, 4L),
      val2 = c(5L, 6L, 7L, 7L, 8L),
    )
  )

  # See above
  expect_equal(
    full_join(test_pl, test2_pl, "a", na_matches = "never"),
    pl$DataFrame(
      a = c(1, 2, NA, NaN, NA, NA),
      val = c(1L, NA, NA, 4L, 2L, 3L),
      val2 = c(5L, 6L, 7L, 8L, NA, NA),
    )
  )
})

test_that("error if two inputs don't have the same class", {
  skip_if_not_installed("withr")
  withr::local_options(list(rlib_message_verbosity = "quiet"))
  test_pl <- pl$DataFrame(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )

  expect_snapshot(
    left_join(test_pl, iris),
    error = TRUE
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
    expect_equal(
      left_join(test_pl, test2_pl, by = "country", copy = TRUE),
      left_join(test, test2, by = "country", copy = TRUE)
    ),
    "Argument `copy` is not supported by"
  )
  # TODO? I think `keep` should be handled by `coalesce` in polars
  expect_warning(
    left_join(test_pl, test2_pl, by = "country", keep = TRUE),
    "Argument `keep` is not supported by"
  )
  withr::with_options(
    list(tidypolars_unknown_args = "error"),
    expect_snapshot(
      left_join(test_pl, test2_pl, by = "country", keep = TRUE),
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
    left_join(test, test2, by = "country", foo = TRUE),
    error = TRUE
  )
  expect_snapshot(
    left_join(test, test2, by = "country", copy = TRUE, foo = TRUE),
    error = TRUE
  )
})
