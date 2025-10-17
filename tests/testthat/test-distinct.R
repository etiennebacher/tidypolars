test_that("distinct() works", {
  pl_test <- pl$DataFrame(
    iso_o = rep(c("AA", "AB", "AC"), each = 2),
    iso_d = rep(c("BA", "BB", "BC"), each = 2),
    value = 1:6
  )

  expect_is_tidypolars(distinct(pl_test))

  expect_dim(
    distinct(pl_test),
    c(6, 3)
  )

  expect_dim(
    distinct(pl_test, iso_o),
    c(3, 1)
  )

  expect_equal(
    distinct(pl_test, iso_o, .keep_all = TRUE) |>
      pull(value),
    c(1, 3, 5)
  )
})

test_that("argument keep works", {
  pl_test <- pl$DataFrame(
    iso_o = rep(c("AA", "AB", "AC"), each = 2),
    iso_d = rep(c("BA", "BB", "BC"), each = 2),
    value = 1:6
  )

  expect_equal(
    distinct(pl_test, iso_o, keep = "last", .keep_all = TRUE) |>
      pull(value),
    c(2, 4, 6)
  )

  expect_dim(
    distinct(pl_test, iso_o, keep = "none"),
    c(0, 1)
  )
})

test_that("duplicated_rows() works", {
  pl_test <- pl$DataFrame(
    iso_o = c(rep(c("AA", "AB"), each = 2), "AC", "DC"),
    iso_d = rep(c("BA", "BB", "BC"), each = 2),
    value = c(2, 2, 3, 4, 5, 6)
  )

  expect_dim(
    duplicated_rows(pl_test),
    c(2, 3)
  )

  expect_dim(
    duplicated_rows(pl_test, iso_o, iso_d),
    c(4, 3)
  )

  expect_dim(
    duplicated_rows(pl_test, iso_d),
    c(6, 3)
  )
})

test_that("argument .keep_all works", {
  test <- data.frame(
    iso_o = rep(c("AA", "AB", "AC"), each = 2),
    iso_d = rep(c("BA", "BB", "BC"), each = 2),
    value = 1:6
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test |> distinct(iso_o, iso_d),
    test_pl |> distinct(iso_o, iso_d)
  )

  expect_equal(
    test |> distinct(iso_o, iso_d, .keep_all = TRUE),
    test_pl |> distinct(iso_o, iso_d, .keep_all = TRUE)
  )
})
