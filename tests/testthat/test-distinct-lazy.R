### [GENERATED AUTOMATICALLY] Update test-distinct.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("distinct() works", {
  test_df <- tibble(
    iso_o = rep(c("AA", "AB", "AC"), each = 2),
    iso_d = rep(c("BA", "BB", "BC"), each = 2),
    value = 1:6
  )
  test_pl <- as_polars_lf(test_df)

  expect_is_tidypolars(distinct(test_pl))

  expect_equal_lazy(
    distinct(test_pl),
    distinct(test_df)
  )

  expect_equal_lazy(
    distinct(test_pl, iso_o),
    distinct(test_df, iso_o)
  )

  expect_equal_lazy(
    distinct(test_pl, iso_o, .keep_all = TRUE),
    distinct(test_df, iso_o, .keep_all = TRUE)
  )
})

test_that("argument keep works", {
  # tidypolars-specific argument `keep` not available in dplyr
  test_df <- tibble(
    iso_o = rep(c("AA", "AB", "AC"), each = 2),
    iso_d = rep(c("BA", "BB", "BC"), each = 2),
    value = 1:6
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    distinct(test_pl, iso_o, keep = "last", .keep_all = TRUE) |> pull(value),
    c(2, 4, 6)
  )

  expect_equal_lazy(
    distinct(test_pl, iso_o, keep = "none"),
    tibble(iso_o = character(0))
  )
})

test_that("duplicated_rows() works", {
  test_df <- tibble(
    iso_o = c(rep(c("AA", "AB"), each = 2), "AC", "DC"),
    iso_d = rep(c("BA", "BB", "BC"), each = 2),
    value = c(2, 2, 3, 4, 5, 6)
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    duplicated_rows(test_pl),
    test_df[duplicated(test_df) | duplicated(test_df, fromLast = TRUE), ]
  )

  expect_equal_lazy(
    duplicated_rows(test_pl, iso_o, iso_d),
    test_df[
      duplicated(test_df[, c("iso_o", "iso_d")]) |
        duplicated(test_df[, c("iso_o", "iso_d")], fromLast = TRUE),
    ]
  )

  expect_equal_lazy(
    duplicated_rows(test_pl, iso_d),
    test_df[
      duplicated(test_df[, "iso_d", drop = FALSE]) |
        duplicated(test_df[, "iso_d", drop = FALSE], fromLast = TRUE),
    ]
  )
})

test_that("argument .keep_all works", {
  test_df <- tibble(
    iso_o = rep(c("AA", "AB", "AC"), each = 2),
    iso_d = rep(c("BA", "BB", "BC"), each = 2),
    value = 1:6
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    distinct(test_pl, iso_o, iso_d),
    distinct(test_df, iso_o, iso_d)
  )

  expect_equal_lazy(
    distinct(test_pl, iso_o, iso_d, .keep_all = TRUE),
    distinct(test_df, iso_o, iso_d, .keep_all = TRUE)
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
