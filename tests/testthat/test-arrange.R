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

patrick::with_parameters_test_that(
  "using desc() works with different column types",
  {
    test_df <- tibble(x = x)
    test_pl <- as_polars_df(test_df)

    expect_equal(
      arrange(test_pl, desc(x)),
      arrange(test_df, desc(x))
    )
  },
  x = list(
    c(2, 1, 3),
    c(2L, 1L, 3L),
    c(TRUE, FALSE, TRUE),
    c("b", "a", "c"),
    as.Date(c("2020-01-02", "2020-01-01", "2020-01-03")),
    as.POSIXct(
      c("2020-01-02", "2020-01-01", "2020-01-03"),
      tz = "UTC"
    )
  )
)

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

  expect_equal(
    arrange(test_pl, desc(x1), desc(x2)),
    arrange(test_df, desc(x1), desc(x2))
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

test_that("does not modify its input, #374", {
  test_df <- tibble(mpg = c(1, 2, 3))
  test_pl <- as_polars_df(test_df)

  invisible(arrange(test_df, mpg))
  invisible(arrange(test_pl, mpg))

  expect_equal(
    test_pl |> mutate(z = -mpg),
    test_df |> mutate(z = -mpg)
  )
})

patrick::with_parameters_test_that(
  "unary minus matches dplyr with different column types",
  {
    test_df <- tibble(x = x)
    test_pl <- as_polars_df(test_df)

    expect_equal_or_both_error(
      arrange(test_pl, -x),
      arrange(test_df, -x)
    )
  },
  x = list(
    c(2, 1, 3),
    c(2L, 1L, 3L),
    c(TRUE, FALSE, TRUE),
    as.difftime(c(7200, 3600, 10800), units = "secs"),
    c("b", "a", "c"),
    as.Date(c("2020-01-02", "2020-01-01", "2020-01-03")),
    as.POSIXct(
      c("2020-01-02", "2020-01-01", "2020-01-03"),
      tz = "UTC"
    )
  )
)

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
