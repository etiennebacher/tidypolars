test_that("output has custom class", {
  test <- pl$DataFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )

  expect_is_tidypolars(arrange(test, x1))
})

test_that("basic behavior works", {
  test <- pl$DataFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )
  expect_equal(
    arrange(test, x1) |> pull(x1),
    c("a", "a", "a", "b", "c")
  )

  expect_equal(
    arrange(test, -x1) |> pull(x1),
    c("c", "b", "a", "a", "a")
  )
})

test_that("using desc() works", {
  test <- pl$DataFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )
  expect_equal(
    arrange(test, desc(x1)),
    arrange(test, -x1)
  )

  expect_equal(
    arrange(test, desc(x1), desc(x2)),
    arrange(test, -x1, -x2)
  )
})

test_that("sorting by multiple variables works", {
  test <- pl$DataFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )
  expect_equal(
    arrange(test, x1, -x2) |>
      select(starts_with("x")) |>
      as.data.frame(),
    data.frame(
      x1 = c("a", "a", "a", "b", "c"),
      x2 = c(3, 2, 1, 5, 1)
    )
  )
})

test_that("errors with unknown vars", {
  test <- pl$DataFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )

  expect_snapshot(
    arrange(test, foo),
    error = TRUE
  )
  expect_snapshot(
    arrange(test, foo, x1),
    error = TRUE
  )
  expect_snapshot(
    arrange(test, desc(foo)),
    error = TRUE
  )
})

test_that("using .by_group = TRUE on grouped data works", {
  test <- pl$DataFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )
  test_grp <- group_by(test, x1)

  expect_equal(
    arrange(test_grp, x2),
    arrange(test, x2)
  )

  expect_equal(
    arrange(test_grp, x2, .by_group = TRUE) |>
      pull(x2),
    c(1, 2, 3, 5, 1)
  )
})

test_that("returns grouped output if input was grouped", {
  test <- pl$DataFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )
  test_grp <- group_by(test, x1)
  expect_equal(
    arrange(test_grp, x2) |> attr("pl_grps"),
    "x1"
  )

  test_grp <- group_by(test, x1, x2)
  expect_equal(
    arrange(test_grp, value) |> attr("pl_grps"),
    c("x1", "x2")
  )
})

test_that("works with expressions", {
  test <- as_polars_df(mtcars)
  expect_equal(
    test |> arrange(-mpg) |> pull(mpg),
    test |> arrange(1 / mpg) |> pull(mpg)
  )
})

test_that("NA are placed last", {
  test <- pl$DataFrame(
    x = c(2, 1, 3, NA),
    g = c("a", "b", "a", "b")
  )
  expect_equal(
    test |> arrange(x),
    data.frame(x = c(1, 2, 3, NA), g = c("b", "a", "a", "b"))
  )
  expect_equal(
    test |> arrange(g, x),
    data.frame(x = c(2, 3, 1, NA), g = rep(c("a", "b"), each = 2))
  )
})
