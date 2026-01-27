### [GENERATED AUTOMATICALLY] Update test-arrange.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("output has custom class", {
  test <- pl$LazyFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5)
  )

  expect_is_tidypolars(arrange(test, x1))
})

test_that("basic behavior works", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    arrange(test_pl, x1),
    arrange(test, x1)
  )

  expect_equal_lazy(
    arrange(test_pl, -x2),
    arrange(test, -x2)
  )
})

test_that("using desc() works", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )
  expect_equal_lazy(
    arrange(test, desc(x2)),
    arrange(test, -x2)
  )

  expect_equal_lazy(
    arrange(test, desc(x2), desc(value)),
    arrange(test, -x2, -value)
  )
})

test_that("sorting by multiple variables works", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5)
  )
  test_pl <- as_polars_lf(test)
  expect_equal_lazy(
    arrange(test_pl, x1, -x2),
    arrange(test, x1, -x2)
  )
})

test_that("errors with unknown vars", {
  test <- pl$LazyFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )

  expect_snapshot_lazy(
    arrange(test, foo),
    error = TRUE
  )
  expect_snapshot_lazy(
    arrange(test, foo, x1),
    error = TRUE
  )
  expect_snapshot_lazy(
    arrange(test, desc(foo)),
    error = TRUE
  )
})

test_that("using .by_group = TRUE on grouped data works", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )
  test_grp <- group_by(test, x1)
  test_pl <- as_polars_lf(test)
  test_grp_pl <- test_pl |>
    group_by(x1)

  expect_equal_lazy(
    arrange(test_pl, x2),
    arrange(test_grp_pl, x2)
  )

  expect_equal_lazy(
    arrange(test_grp_pl, x2, .by_group = TRUE),
    arrange(test_grp, x2, .by_group = TRUE)
  )
})

test_that("returns grouped output if input was grouped", {
  test <- pl$LazyFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )
  test_grp <- group_by(test, x1)
  expect_equal_lazy(
    arrange(test_grp, x2) |> attr("pl_grps"),
    "x1"
  )

  test_grp <- group_by(test, x1, x2)
  expect_equal_lazy(
    arrange(test_grp, value) |> attr("pl_grps"),
    c("x1", "x2")
  )
})

test_that("works with expressions", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)
  expect_equal_lazy(
    test_pl |> arrange(-mpg),
    test |> arrange(-mpg)
  )
  expect_equal_lazy(
    test_pl |> arrange(1 / mpg),
    test |> arrange(1 / mpg)
  )
})

test_that("NA are placed last", {
  test <- tibble(
    x = c(2, 1, 3, NA),
    g = c("a", "b", "a", "b")
  )
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> arrange(x),
    test |> arrange(x)
  )
  expect_equal_lazy(
    test_pl |> arrange(g, x),
    test |> arrange(g, x)
  )
})

test_that("arrange() works with literals, #295", {
  test <- tibble(x = c("a", "b", "c"), grp = c(1, 2, 2))
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> arrange(1),
    test |> arrange(1)
  )
  expect_equal_lazy(
    test_pl |> arrange(c(1, 3, 2)),
    test |> arrange(c(1, 3, 2))
  )
  expect_both_error(
    test_pl |> arrange(c(1, 2)),
    test |> arrange(c(1, 2))
  )
  expect_both_error(
    test_pl |> group_by(grp) |> arrange(c(1, 2), .by_group = TRUE),
    test |> group_by(grp) |> arrange(c(1, 2), .by_group = TRUE)
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
