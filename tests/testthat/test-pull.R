test_that("multiplication works", {
  test <- polars::pl$DataFrame(mtcars)

  expect_equal(
    pull(test, mpg),
    mtcars$mpg
  )

  expect_equal(
    pull(test, "mpg"),
    mtcars$mpg
  )

  expect_equal(
    pull(test, 1),
    mtcars$mpg
  )
})

test_that("error cases work", {
  test <- polars::pl$DataFrame(mtcars)

  expect_snapshot(
    pull(test, dplyr::all_of(c("mpg", "drat"))),
    error = TRUE
  )
  expect_snapshot(
    pull(test, mpg, drat, hp),
    error = TRUE
  )
})
