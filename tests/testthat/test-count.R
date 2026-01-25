test_that("count works", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_is_tidypolars(count(test_pl))

  expect_equal(
    count(test_pl),
    count(test)
  )

  expect_equal(
    count(test_pl, cyl),
    count(test, cyl)
  )

  expect_equal(
    count(test_pl, cyl, am),
    count(test, cyl, am)
  )
})

test_that("arguments name and sort work", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_equal(
    count(test_pl, cyl, am, sort = TRUE, name = "count"),
    count(test, cyl, am, sort = TRUE, name = "count")
  )

  expect_equal(
    count(test_pl, name = "count"),
    count(test, name = "count")
  )
})

test_that("count works on grouped data", {
  test <- as_tibble(mtcars)
  test_g <- group_by(test, am)
  test_pl <- as_polars_df(test)
  test_g_pl <- group_by(test_pl, am)

  expect_equal(
    count(test_g_pl),
    count(test_g)
  )

  expect_equal(
    count(test_g_pl, cyl),
    count(test_g, cyl)
  )
})

test_that("add_count works", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_equal(
    add_count(test_pl, cyl),
    add_count(test, cyl)
  )
})

test_that("arguments name and sort work", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_equal(
    add_count(test_pl, cyl, am, sort = TRUE, name = "count"),
    add_count(test, cyl, am, sort = TRUE, name = "count")
  )

  expect_equal(
    add_count(test_pl, cyl, am, sort = TRUE, name = "count"),
    add_count(test, cyl, am, sort = TRUE, name = "count")
  )

  expect_equal(
    add_count(test_pl, name = "count"),
    add_count(test, name = "count")
  )
})

test_that("add_count works on grouped data", {
  test <- as_tibble(mtcars)
  test_g <- group_by(test, am)
  test_pl <- as_polars_df(test)
  test_g_pl <- group_by(test_pl, am, maintain_order = TRUE)

  expect_equal(
    add_count(test_g_pl, cyl, am),
    add_count(test_g, cyl, am)
  )
  expect_equal(
    count(test_g_pl, cyl, am),
    count(test_g, cyl, am)
  )

  expect_equal(
    attr(count(test_g_pl), "pl_grps"),
    "am"
  )
  expect_equal(
    attr(add_count(test_g_pl), "pl_grps"),
    "am"
  )
  expect_true(attr(count(test_g_pl), "maintain_grp_order"))
  expect_true(attr(add_count(test_g_pl), "maintain_grp_order"))
})

test_that("message if overwriting variable", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_df(test)

  expect_message(
    expect_equal(
      test_pl |>
        mutate(n = 1) |>
        count(n),
      test |>
        mutate(n = 1) |>
        count(n) |>
        suppressMessages()
    ),
    "Storing counts in `nn`, as `n` already present in input."
  )

  expect_message(
    expect_equal(
      test_pl |>
        mutate(n = 1) |>
        add_count(n),
      test |>
        mutate(n = 1) |>
        add_count(n) |>
        suppressMessages()
    ),
    "Storing counts in `nn`, as `n` already present in input."
  )

  expect_message(
    expect_equal(
      test_pl |>
        mutate(n = 1, nn = 1) |>
        count(n, nn),
      test |>
        mutate(n = 1, nn = 1) |>
        count(n, nn) |>
        suppressMessages()
    ),
    "Storing counts in `nnn`, as `n` already present in input."
  )

  expect_message(
    expect_equal(
      test_pl |>
        mutate(n = 1, nn = 1) |>
        add_count(cyl),
      test |>
        mutate(n = 1, nn = 1) |>
        add_count(cyl) |>
        suppressMessages()
    ),
    "Storing counts in `nnn`, as `n` already present in input."
  )
})

test_that("count() on grouping variables", {
  df <- tibble(year = c(1, 1, 2, 2), vals = 1:4)
  df_pl <- as_polars_df(df)

  out <- df |>
    group_by(year) |>
    count(year)
  out_pl <- df_pl |>
    group_by(year) |>
    count(year)

  expect_equal(out_pl, out)
  expect_equal(group_vars(out_pl), "year")
  expect_false(attr(out_pl, "maintain_grp_order"))

  df2 <- tibble(
    year = c(1, 1, 2, 2),
    state = c("a", "a", "a", "b"),
    vals = 1:4
  )
  df2_pl <- as_polars_df(df2)

  out2 <- df2 |>
    group_by(year, state) |>
    count(year)
  out2_pl <- df2_pl |>
    group_by(year, state) |>
    count(year)

  expect_equal(out2_pl, out2)
  expect_equal(group_vars(out2_pl), c("year", "state"))
  expect_false(attr(out2_pl, "maintain_grp_order"))
})

test_that("count() and add_count() explicitly do not support 'wt'", {
  test_pl <- as_polars_df(mtcars)

  expect_warning(
    test_pl |> count(wt = drat),
    "Argument `wt` is not supported by tidypolars"
  )
  expect_warning(
    test_pl |> add_count(wt = drat),
    "Argument `wt` is not supported by tidypolars"
  )
  withr::with_options(
    list("tidypolars_unknown_args" = "error"),
    {
      expect_error(
        test_pl |> count(wt = drat),
        "Argument `wt` is not supported by tidypolars"
      )
      expect_error(
        test_pl |> add_count(wt = drat),
        "Argument `wt` is not supported by tidypolars"
      )
    }
  )
})

test_that("count() doesn't support named expressions, #233", {
  expect_snapshot(
    iris |>
      as_polars_df() |>
      count(is_present = !is.na(Sepal.Length)),
    error = TRUE
  )
})
