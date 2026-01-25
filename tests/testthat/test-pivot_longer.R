test_that("basic behavior works", {
  relig_income <- as.data.frame(tidyr::relig_income)
  relig_income_pl <- as_polars_df(relig_income)
  out <- relig_income_pl |>
    pivot_longer(!religion, names_to = "income", values_to = "count")

  expect_is_tidypolars(out)

  expect_equal(
    out,
    relig_income |>
      tidyr::pivot_longer(!religion, names_to = "income", values_to = "count") |>
      as.data.frame()
  )
  expect_colnames(out, c("religion", "income", "count"))

  first <- slice_head(out, n = 5)

  expect_equal(
    pull(first, religion),
    rep("Agnostic", 5)
  )

  expect_equal(
    pull(first, income),
    c("<$10k", "$10-20k", "$20-30k", "$30-40k", "$40-50k")
  )

  expect_equal(
    pull(first, count),
    c(27, 34, 60, 81, 76)
  )

  last <- slice_tail(out, n = 5)

  expect_equal(
    pull(last, religion),
    rep("Unaffiliated", 5)
  )

  expect_equal(
    pull(last, income),
    c("$50-75k", "$75-100k", "$100-150k", ">150k", "Don't know/refused")
  )

  expect_equal(
    pull(last, count),
    c(528, 407, 321, 258, 597)
  )
})

test_that("argument names_prefix works", {
  billboard <- as.data.frame(tidyr::billboard)
  billboard_pl <- as_polars_df(billboard)

  expect_equal(
    billboard_pl |>
      pivot_longer(
        cols = starts_with("wk"),
        names_to = "week",
        names_prefix = "wk"
      ) |>
      arrange(artist, track, date.entered, week) |>
      head(3) |>
      pull(week),
    c("1", "10", "11")
  )

  expect_snapshot(
    billboard_pl |>
      pivot_longer(
        cols = starts_with("wk"),
        names_to = "week",
        names_prefix = c("wk", "foo")
      ),
    error = TRUE
  )
})

test_that("unsupported args throw warning", {
  billboard <- as.data.frame(tidyr::billboard)
  billboard_pl <- as_polars_df(billboard)

  expect_warning(
    pivot_longer(billboard_pl, cols_vary = "fastest", names_ptypes = TRUE)
  )
})

test_that("dots must be empty", {
  billboard <- as.data.frame(tidyr::billboard)
  billboard_pl <- as_polars_df(billboard)

  expect_snapshot(
    pivot_longer(billboard_pl, foo = TRUE, cols_vary = "fastest"),
    error = TRUE
  )
})
