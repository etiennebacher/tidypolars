test_that("basic behavior works", {
  test <- as.data.frame(tidyr::relig_income)
  test_pl <- as_polars_df(test)

  expect_is_tidypolars(
    test_pl |> pivot_longer(!religion, names_to = "income", values_to = "count")
  )

  expect_equal(
    test_pl |>
      pivot_longer(!religion, names_to = "income", values_to = "count"),
    test |> pivot_longer(!religion, names_to = "income", values_to = "count")
  )
})

test_that("argument names_prefix works", {
  test <- as_tibble(tidyr::billboard)
  test_pl <- as_polars_df(test)

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
    test |>
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

test_that("unsupported args throw warning", {
  test <- as.data.frame(tidyr::billboard)
  test_pl <- as_polars_df(test)

  expect_warning(
    pivot_longer(test_pl, cols_vary = "fastest", names_ptypes = TRUE)
  )
})

test_that("dots must be empty", {
  test <- as.data.frame(tidyr::billboard)
  test_pl <- as_polars_df(test)

  expect_both_error(
    pivot_longer(test_pl, foo = TRUE),
    pivot_longer(test, foo = TRUE)
  )
  expect_snapshot(
    pivot_longer(test_pl, foo = TRUE),
    error = TRUE
  )
})
