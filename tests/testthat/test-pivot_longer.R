test_that("basic behavior works", {
  test_df <- as.data.frame(tidyr::relig_income)
  test_pl <- as_polars_df(test_df)

  expect_is_tidypolars(
    test_pl |> pivot_longer(!religion, names_to = "income", values_to = "count")
  )

  expect_equal(
    test_pl |>
      pivot_longer(!religion, names_to = "income", values_to = "count"),
    test_df |> pivot_longer(!religion, names_to = "income", values_to = "count")
  )
})

test_that("argument names_prefix works", {
  test_df <- as_tibble(tidyr::billboard)
  test_pl <- as_polars_df(test_df)

  # All of the differences are just due to differences in sorting (and
  # .locale = "en" doesn't solve it)
  expect_equal(
    test_pl |>
      pivot_longer(
        cols = starts_with("wk"),
        names_to = "week",
        names_prefix = "wk"
      ) |>
      mutate(week = as.numeric(week)) |>
      arrange(artist, track, date.entered, week, value),
    test_df |>
      pivot_longer(
        cols = starts_with("wk"),
        names_to = "week",
        names_prefix = "wk"
      ) |>
      mutate(week = as.numeric(week)) |>
      arrange(artist, track, date.entered, week, value)
  )

  # This only warns in tidyr
  expect_snapshot(
    test_pl |>
      pivot_longer(
        cols = starts_with("wk"),
        names_to = "week",
        names_prefix = c("wk", "foo")
      ),
    error = TRUE
  )
})

test_that("row order is preserved", {
  test_df <- data.frame(id = c(2L, 1L), a = c("a2", "a1"), b = c("b2", "b1"))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> pivot_longer(c(a, b)),
    test_df |> pivot_longer(c(a, b))
  )
})

test_that("no index column: output is in row-major order", {
  test_df <- data.frame(a = c("a1", "a2"), b = c("b1", "b2"))
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> pivot_longer(c(a, b)),
    test_df |> pivot_longer(c(a, b))
  )
})

test_that("repeated index values keep the original row order", {
  test_df <- data.frame(id = c(1L, 1L, 2L), a = 1:3, b = 4:6)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> pivot_longer(c(a, b)),
    test_df |> pivot_longer(c(a, b))
  )
})

test_that("selected columns keep their tidy-select order", {
  test_df <- data.frame(
    id = c(2L, 1L),
    a = c("a2", "a1"),
    b = c("b2", "b1"),
    c = c("c2", "c1")
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> pivot_longer(c(c, a, b)),
    test_df |> pivot_longer(c(c, a, b))
  )
})

test_that("unsupported args throw warning", {
  test_df <- as.data.frame(tidyr::billboard)
  test_pl <- as_polars_df(test_df)

  expect_warning(
    pivot_longer(test_pl, cols_vary = "fastest", names_ptypes = TRUE)
  )
})

test_that("dots must be empty", {
  test_df <- as.data.frame(tidyr::billboard)
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    pivot_longer(test_pl, foo = TRUE),
    pivot_longer(test_df, foo = TRUE)
  )
  expect_snapshot(
    pivot_longer(test_pl, foo = TRUE),
    error = TRUE
  )
})
