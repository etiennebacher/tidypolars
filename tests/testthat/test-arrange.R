test_that("output has custom class", {
  test_pl <- pl$DataFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5)
  )

  expect_is_tidypolars(arrange(test_pl, x1))
})

test_that("basic behavior works", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    arrange(test_pl, x1),
    arrange(test_df, x1)
  )

  expect_equal(
    arrange(test_pl, -x2),
    arrange(test_df, -x2)
  )
})

test_that("using desc() works", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )
  test_pl <- as_polars_df(test_df)
  expect_equal(
    arrange(test_pl, desc(x2)),
    arrange(test_df, -x2)
  )

  expect_equal(
    arrange(test_pl, desc(x2), desc(value)),
    arrange(test_df, -x2, -value)
  )
})

test_that("sorting by multiple variables works", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5)
  )
  test_pl <- as_polars_df(test_df)
  expect_equal(
    arrange(test_pl, x1, -x2),
    arrange(test_df, x1, -x2)
  )
})

test_that("errors with unknown vars", {
  test_pl <- pl$DataFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )

  expect_snapshot(
    arrange(test_pl, foo),
    error = TRUE
  )
  expect_snapshot(
    arrange(test_pl, foo, x1),
    error = TRUE
  )
  expect_snapshot(
    arrange(test_pl, desc(foo)),
    error = TRUE
  )
})

test_that("using .by_group = TRUE on grouped data works", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )
  test_grp <- group_by(test_df, x1)
  test_pl <- as_polars_df(test_df)
  test_grp_pl <- test_pl |>
    group_by(x1)

  expect_equal(
    arrange(test_pl, x2),
    arrange(test_df, x2)
  )

  expect_equal(
    arrange(test_grp_pl, x2, .by_group = TRUE),
    arrange(test_grp, x2, .by_group = TRUE)
  )
})

test_that("returns grouped output if input was grouped", {
  test_pl <- pl$DataFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )
  test_grp <- group_by(test_pl, x1)
  expect_equal(
    arrange(test_grp, x2) |> attr("pl_grps"),
    "x1"
  )

  test_grp <- group_by(test_pl, x1, x2)
  expect_equal(
    arrange(test_grp, value) |> attr("pl_grps"),
    c("x1", "x2")
  )
})

test_that("works with expressions", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)
  expect_equal(
    test_pl |> arrange(-mpg),
    test_df |> arrange(-mpg)
  )
  expect_equal(
    test_pl |> arrange(1 / mpg),
    test_df |> arrange(1 / mpg)
  )
})

test_that("NA are placed last", {
  test_df <- tibble(
    x = c(2, 1, 3, NA),
    g = c("a", "b", "a", "b")
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> arrange(x),
    test_df |> arrange(x)
  )
  expect_equal(
    test_pl |> arrange(g, x),
    test_df |> arrange(g, x)
  )
})

test_that("arrange() works with literals, #295", {
  test_df <- tibble(x = c("a", "b", "c"), grp = c(1, 2, 2))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> arrange(1),
    test_df |> arrange(1)
  )
  expect_equal(
    test_pl |> arrange(c(1, 3, 2)),
    test_df |> arrange(c(1, 3, 2))
  )
  expect_both_error(
    test_pl |> arrange(c(1, 2)),
    test_df |> arrange(c(1, 2))
  )
  expect_both_error(
    test_pl |> group_by(grp) |> arrange(c(1, 2), .by_group = TRUE),
    test_df |> group_by(grp) |> arrange(c(1, 2), .by_group = TRUE)
  )
})
