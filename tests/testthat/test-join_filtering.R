test_that("basic behavior with common column names", {
  test <- polars::pl$DataFrame(
    x = c(1, 2, 3),
    y = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- polars::pl$DataFrame(
    x = c(1, 2, 4),
    y = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )

  expect_is_tidypolars(semi_join(test, test2, join_by(x, y)))
  expect_is_tidypolars(anti_join(test, test2, join_by(x, y)))

  expect_equal(
    semi_join(test, test2, by = c("x", "y")),
    pl$DataFrame(
      x = c(1, 2), y = c(1, 2), z = c(1, 2)
    )
  )

  expect_equal(
    anti_join(test, test2, by = c("x", "y")),
    pl$DataFrame(
      x = 3, y = 3, z = 3
    )
  )
})


test_that("basic behavior with different column names", {
  test <- polars::pl$DataFrame(
    x = c(1, 2, 3),
    y1 = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- polars::pl$DataFrame(
    x = c(1, 2, 4),
    y2 = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )

  expect_equal(
    semi_join(test, test2, by = c("x", "y1" = "y2")),
    pl$DataFrame(
      x = c(1, 2), y1 = c(1, 2), z = c(1, 2)
    )
  )

  expect_equal(
    anti_join(test, test2, by = c("x", "y1" = "y2")),
    pl$DataFrame(
      x = 3, y1 = 3, z = 3
    )
  )
})

test_that("join_by() with strict equality", {
  test <- polars::pl$DataFrame(
    x = c(1, 2, 3),
    y1 = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- polars::pl$DataFrame(
    x = c(1, 2, 4),
    y2 = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )

  expect_equal(
    semi_join(test, test2, by = join_by(x, y1 == y2)),
    pl$DataFrame(
      x = c(1, 2), y1 = c(1, 2), z = c(1, 2)
    )
  )

  expect_equal(
    anti_join(test, test2, by = join_by(x, y1 == y2)),
    pl$DataFrame(
      x = 3, y1 = 3, z = 3
    )
  )
})

test_that("join_by() doesn't work with inequality", {
  test <- polars::pl$DataFrame(
    x = c(1, 2, 3),
    y1 = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- polars::pl$DataFrame(
    x = c(1, 2, 4),
    y2 = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )

  expect_error(
    semi_join(test, test2, by = join_by(x, y1 > y2)),
    "doesn't support inequality conditions"
  )

  expect_error(
    anti_join(test, test2, by = join_by(x, y1 > y2)),
    "doesn't support inequality conditions"
  )
})

test_that("fallback on dplyr error if wrong join_by specification", {
  test <- polars::pl$DataFrame(
    x = c(1, 2, 3),
    y1 = c(1, 2, 3),
    z = c(1, 2, 3)
  )
  test2 <- polars::pl$DataFrame(
    x = c(1, 2, 4),
    y2 = c(1, 2, 4),
    z2 = c(1, 2, 4)
  )

  expect_error(
    semi_join(test, test2, by = join_by(x, y1 = y2)),
    "Can't name join expressions"
  )

  expect_error(
    anti_join(test, test2, by = join_by(x, y1 = y2)),
    "Can't name join expressions"
  )
})

test_that("argument na_matches works", {
  pdf1 <- pl$DataFrame(a = c(1, NA, NA, NaN), val = 1:4)
  pdf2 <- pl$DataFrame(a = c(1, 2, NA, NaN), val2 = 5:8)

  expect_equal(
    semi_join(pdf1, pdf2, "a") |>
      pull(a),
    c(1, NA, NA, NaN)
  )

  expect_equal(
    semi_join(pdf1, pdf2, "a", na_matches = "never") |>
      pull(a),
    c(1, NaN)
  )
})
