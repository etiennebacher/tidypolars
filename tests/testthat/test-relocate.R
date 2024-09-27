test_that("basic behavior works", {
  test <- polars::pl$DataFrame(mtcars)

  expect_is_tidypolars(relocate(test))
  expect_is_tidypolars(relocate(test, hp, .before = cyl))

  expect_colnames(
    test |> relocate(hp, vs, .before = cyl),
    c("mpg", "hp", "vs", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "carb")
  )

  expect_equal(
    relocate(test),
    test
  )
})

test_that("moved to first positions if no .before or .after", {
  test <- polars::pl$DataFrame(mtcars)

  expect_colnames(
    test |> relocate(hp, vs),
    c("hp", "vs", "mpg", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "carb")
  )
})

test_that(".before and .after can be quoted or unquoted", {
  test <- polars::pl$DataFrame(mtcars)

  expect_colnames(
    test |> relocate(hp, vs, .after = "gear"),
    c("mpg", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "hp", "vs", "carb")
  )
})


test_that("select helpers are also available", {
  test <- polars::pl$DataFrame(mtcars)

  expect_colnames(
    test |> relocate(matches("[aeiouy]")),
    c("cyl", "disp", "drat", "qsec", "am", "gear", "carb", "mpg", "hp", "wt", "vs")
  )

  expect_colnames(
    test |> relocate(hp, vs, .after = last_col()),
    c("mpg", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "carb", "hp", "vs")
  )

  expect_colnames(
    test |> relocate(hp, vs, .before = last_col()),
    c("mpg", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "hp", "vs", "carb")
  )
})

test_that("error cases work", {
  test <- polars::pl$DataFrame(mtcars)

  expect_snapshot(
    test |> relocate(mpg, .before = cyl, .after = drat),
    error = TRUE
  )
  expect_snapshot(
    test |> relocate(mpg, .before = foo),
    error = TRUE
  )
  expect_snapshot(
    test |> relocate(mpg, .after = foo),
    error = TRUE
  )
})
