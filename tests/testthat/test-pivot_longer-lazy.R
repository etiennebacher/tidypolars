### [GENERATED AUTOMATICALLY] Update test-pivot_longer.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  pl_relig_income <- as_polars_lf(tidyr::relig_income)
  out <- pl_relig_income |>
    pivot_longer(!religion, names_to = "income", values_to = "count")

  expect_is_tidypolars(out)

  expect_dim(out, c(180, 3))
  expect_colnames(out, c("religion", "income", "count"))

  first <- slice_head(out, n = 5)

  expect_equal_lazy(
    pull(first, religion),
    rep("Agnostic", 5)
  )

  expect_equal_lazy(
    pull(first, income),
    c("<$10k", "$10-20k", "$20-30k", "$30-40k", "$40-50k")
  )

  expect_equal_lazy(
    pull(first, count),
    c(27, 34, 60, 81, 76)
  )

  last <- slice_tail(out, n = 5)

  expect_equal_lazy(
    pull(last, religion),
    rep("Unaffiliated", 5)
  )

  expect_equal_lazy(
    pull(last, income),
    c("$50-75k", "$75-100k", "$100-150k", ">150k", "Don't know/refused")
  )

  expect_equal_lazy(
    pull(last, count),
    c(528, 407, 321, 258, 597)
  )
})

test_that("argument names_prefix works", {
  pl_billboard <- as_polars_lf(tidyr::billboard)

  expect_equal_lazy(
    pl_billboard |>
      pivot_longer(
        cols = starts_with("wk"),
        names_to = "week",
        names_prefix = "wk"
      ) |>
      arrange(artist, track, date.entered, week) |>
      head(3) |>
      pull(week),
    # polars and dplyr sort strings differently: for polars, "10" comes before "2"
    c("1", "10", "11")
  )

  expect_snapshot_lazy(
    pl_billboard |>
      pivot_longer(
        cols = starts_with("wk"),
        names_to = "week",
        names_prefix = c("wk", "foo")
      ),
    error = TRUE
  )
})

test_that("unsupported args throw warning", {
  pl_billboard <- as_polars_lf(tidyr::billboard)

  expect_warning(
    pivot_longer(pl_billboard, cols_vary = "fastest", names_ptypes = TRUE)
  )
})

test_that("dots must be empty", {
  pl_billboard <- as_polars_lf(tidyr::billboard)

  # Also gets the message from rlang because check_dots_used() is called before
  # dispatching the generic
  expect_snapshot_lazy(
    pivot_longer(pl_billboard, foo = TRUE, cols_vary = "fastest"),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
