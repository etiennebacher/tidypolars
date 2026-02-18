test_that("basic behavior works", {
  test_df <- tibble(
    country = c("France", "France", "UK", "UK", "Spain"),
    year = c(2020, 2021, 2019, 2020, 2022),
    value = c(1, 2, 3, 4, 5)
  )
  test_pl <- as_polars_df(test_df)

  expect_is_tidypolars(complete(test_pl, country, year))

  expect_equal(
    complete(test_pl, country, year),
    complete(test_df, country, year)
  )

  expect_equal(
    complete(test_pl, country, year),
    complete(test_df, country, year)
  )

  expect_equal(
    complete(test_pl, country, year, fill = list(value = 99)),
    complete(test_df, country, year, fill = list(value = 99))
  )

  # I would rather not force an implicit sort in complete()
  expect_equal(
    complete(test_pl, country) |> arrange(country),
    complete(test_df, country)
  )
})

test_that("works on grouped data", {
  test_df <- tibble(
    g = c("a", "b", "a"),
    a = c(1L, 1L, 2L),
    b = c("a", "a", "b"),
    c = c(4, 5, 6)
  )
  test_pl <- as_polars_df(test_df)
  test_grp <- group_by(test_df, g)
  test_pl_grp <- group_by(test_pl, g)

  expect_equal(
    complete(test_pl_grp, a, b) |> arrange(g),
    complete(test_grp, a, b)
  )

  expect_equal(
    attr(complete(test_pl_grp, a, b), "pl_grps"),
    "g"
  )
})

test_that("argument 'explicit' works", {
  test_df <- tibble(
    g = c("a", "b", "a"),
    a = c(1L, 1L, 2L),
    b = c("a", NA, "b"),
    c = c(4, 5, NA)
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> complete(g, a, fill = list(b = "foo", c = 1), explicit = FALSE),
    test_df |> complete(g, a, fill = list(b = "foo", c = 1), explicit = FALSE)
  )

  expect_equal(
    test_pl |>
      group_by(g, maintain_order = TRUE) |>
      complete(a, b, fill = list(c = 1), explicit = FALSE),
    test_df |>
      group_by(g) |>
      complete(a, b, fill = list(c = 1), explicit = FALSE)
  )
})

test_that("can use named arguments", {
  test_df <- tibble(
    group = c(1:2, 1, 2),
    item_id = c(1:2, 2, 3),
    item_name = c("a", "a", "b", "b"),
    value1 = c(1, NA, 3, 4),
    value2 = 4:7
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |>
      complete(group, value1 = c(1, 2, 3, 4)) |>
      arrange(group, value1),
    test_df |> complete(group, value1 = c(1, 2, 3, 4))
  )

  expect_equal(
    test_pl |> complete(value1 = c(1, 2, 3, 4)) |> arrange(value1),
    test_df |> complete(value1 = c(1, 2, 3, 4))
  )

  expect_equal(
    test_pl |>
      complete(value1 = c(1, 2, 3, 4), group) |>
      arrange(value1, group),
    test_df |> complete(value1 = c(1, 2, 3, 4), group)
  )
  expect_equal(
    test_pl |>
      group_by(item_id) |>
      complete(value1 = c(1, 2, 3, 4), group) |>
      arrange(item_id, value1, group),
    test_df |> group_by(item_id) |> complete(value1 = c(1, 2, 3, 4), group)
  )

  test_df <- tibble(a = 1:2, b = 3:4, c = 5:6)
  test_pl <- as_polars_df(test_df)
  expect_equal(
    test_pl |> complete(a, b = 1:4, c) |> arrange(a, b, c),
    test_df |> complete(a, b = 1:4, c)
  )
})
