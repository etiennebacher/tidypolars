test_that("basic behavior with common column names", {
  test_pl <- pl$DataFrame(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2_pl <- polars::pl$DataFrame(
    x = c(1, 2, 4),
    y = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )

  expect_is_tidypolars(semi_join(test_pl, test2_pl, join_by(x, y)))
  expect_is_tidypolars(anti_join(test_pl, test2_pl, join_by(x, y)))

  expect_equal(
    semi_join(test_pl, test2_pl, by = c("x", "y")),
    pl$DataFrame(
      x = c(1, 2),
      y = c(1, 2),
      z = c(1, 2)
    )
  )

  expect_equal(
    anti_join(test_pl, test2_pl, by = c("x", "y")),
    pl$DataFrame(
      x = 3,
      y = 3,
      z = 3
    )
  )
})

test_that("basic behavior with different column names", {
  test_pl <- pl$DataFrame(
    x = c(1, 2, 3),
    y1 = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2_pl <- polars::pl$DataFrame(
    x = c(1, 2, 4),
    y2 = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )

  expect_equal(
    semi_join(test_pl, test2_pl, by = c("x", "y1" = "y2")),
    pl$DataFrame(
      x = c(1, 2),
      y1 = c(1, 2),
      z = c(1, 2)
    )
  )

  expect_equal(
    anti_join(test_pl, test2_pl, by = c("x", "y1" = "y2")),
    pl$DataFrame(
      x = 3,
      y1 = 3,
      z = 3
    )
  )
})

test_that("join_by() with strict equality", {
  test_pl <- pl$DataFrame(
    x = c(1, 2, 3),
    y1 = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2_pl <- polars::pl$DataFrame(
    x = c(1, 2, 4),
    y2 = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )

  expect_equal(
    semi_join(test_pl, test2_pl, by = join_by(x, y1 == y2)),
    pl$DataFrame(
      x = c(1, 2),
      y1 = c(1, 2),
      z = c(1, 2)
    )
  )

  expect_equal(
    anti_join(test_pl, test2_pl, by = join_by(x, y1 == y2)),
    pl$DataFrame(
      x = 3,
      y1 = 3,
      z = 3
    )
  )
})

test_that("join_by() doesn't work with inequality", {
  test_pl <- pl$DataFrame(
    x = c(1, 2, 3),
    y1 = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2_pl <- polars::pl$DataFrame(
    x = c(1, 2, 4),
    y2 = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )

  expect_snapshot(
    semi_join(test_pl, test2_pl, by = join_by(x, y1 > y2)),
    error = TRUE
  )
  expect_snapshot(
    anti_join(test_pl, test2_pl, by = join_by(x, y1 > y2)),
    error = TRUE
  )
})

test_that("fallback on dplyr error if wrong join_by specification", {
  test_pl <- pl$DataFrame(
    x = c(1, 2, 3),
    y1 = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2_pl <- polars::pl$DataFrame(
    x = c(1, 2, 4),
    y2 = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )
  expect_snapshot(
    semi_join(test_pl, test2_pl, by = join_by(x, y1 = y2)),
    error = TRUE
  )
  expect_snapshot(
    anti_join(test_pl, test2_pl, by = join_by(x, y1 = y2)),
    error = TRUE
  )
})

test_that("argument na_matches works", {
  pdf1 <- pl$DataFrame(a = c(1, NA, NA, NaN), val = 1:4)
  pdf2 <- pl$DataFrame(a = c(1, 2, NA, NaN), val2 = 5:8)

  expect_equal(
    semi_join(pdf1, pdf2, "a") |> pull(a),
    c(1, NA, NA, NaN)
  )

  expect_equal(
    semi_join(pdf1, pdf2, "a", na_matches = "never") |> pull(a),
    c(1, NaN)
  )
})

test_that("unsupported args throw warning", {
  test_pl <- pl$DataFrame(
    country = c("ALG", "FRA", "GER"),
    year = c(2020, 2020, 2021)
  )
  test2_pl <- polars::pl$DataFrame(
    country = c("USA", "JPN", "BRA"),
    language = c("english", "japanese", "portuguese")
  )
  expect_warning(
    semi_join(test_pl, test2_pl, by = "country", copy = TRUE),
    "Argument `copy` is not supported by tidypolars"
  )
  withr::with_options(
    list(tidypolars_unknown_args = "error"),
    expect_snapshot(
      semi_join(test_pl, test2_pl, by = "country", copy = TRUE),
      error = TRUE
    )
  )
})

test_that("dots must be empty", {
  test_pl <- pl$DataFrame(
    country = c("ALG", "FRA", "GER"),
    year = c(2020, 2020, 2021)
  )
  test2_pl <- polars::pl$DataFrame(
    country = c("USA", "JPN", "BRA"),
    language = c("english", "japanese", "portuguese")
  )
  expect_snapshot(
    semi_join(test_pl, test2_pl, foo = TRUE),
    error = TRUE
  )
  expect_snapshot(
    semi_join(test_pl, test2_pl, copy = TRUE, foo = TRUE),
    error = TRUE
  )
})
