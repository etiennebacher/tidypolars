test_that("works with ungrouped data", {
  test <- pl$DataFrame(
    x1 = c("a", "a", "b", "a", "c")
  )

  expect_equal(
    group_vars(test),
    character(0)
  )

  expect_equal(
    group_keys(test),
    data.frame()
  )
})

test_that("works with grouped data", {
  test2 <- pl$DataFrame(mtcars) |>
    group_by(cyl, am)

  expect_equal(
    group_vars(test2),
    c("cyl", "am")
  )

  expect_equal(
    group_keys(test2),
    data.frame(cyl = rep(c(4, 6, 8), each = 2L), am = rep(c(0, 1), 3))
  )
})

test_that("argument .add works", {
  expect_equal(
    pl$DataFrame(mtcars) |>
      group_by(cyl, am) |>
      group_by(vs) |>
      group_vars(),
    "vs"
  )

  expect_equal(
    pl$DataFrame(mtcars) |>
      group_by(cyl, am) |>
      group_by(vs, .add = TRUE) |>
      group_vars(),
    c("cyl", "am", "vs")
  )

  expect_equal(
    pl$DataFrame(mtcars) |>
      group_by(cyl, am) |>
      group_by(cyl, .add = TRUE) |>
      group_vars(),
    c("cyl", "am")
  )
})
