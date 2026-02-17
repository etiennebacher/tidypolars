test_that("group_by() works without any variable", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> group_by(),
    test_pl
  )
})

test_that("works with ungrouped data", {
  test_df <- tibble(x1 = c("a", "a", "b", "a", "c"))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    group_vars(test_pl),
    group_vars(test_df)
  )

  expect_equal(
    group_keys(test_pl),
    group_keys(test_df),
    ignore_attr = TRUE
  )
})

test_that("works with grouped data", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)
  test_grp <- group_by(test_df, cyl, am)
  test_pl_grp <- group_by(test_pl, cyl, am)

  expect_equal(
    group_vars(test_pl_grp),
    group_vars(test_grp)
  )

  expect_equal(
    group_keys(test_pl_grp),
    group_keys(test_grp)
  )
})

test_that("argument .add works", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> group_by(cyl, am) |> group_by(vs) |> group_vars(),
    test_df |> group_by(cyl, am) |> group_by(vs) |> group_vars()
  )

  expect_equal(
    test_pl |>
      group_by(cyl, am) |>
      group_by(vs, .add = TRUE) |>
      group_vars(),
    test_df |>
      group_by(cyl, am) |>
      group_by(vs, .add = TRUE) |>
      group_vars()
  )

  expect_equal(
    test_pl |>
      group_by(cyl, am) |>
      group_by(cyl, .add = TRUE) |>
      group_vars(),
    test_df |>
      group_by(cyl, am) |>
      group_by(cyl, .add = TRUE) |>
      group_vars()
  )
})
