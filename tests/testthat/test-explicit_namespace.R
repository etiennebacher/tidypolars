test_that("using base namespace works", {
  test <- polars::pl$DataFrame(x = 1:3)

  expect_equal(
    test |> mutate(y = sum(x)),
    test |> mutate(y = base::sum(x))
  )
})

test_that("using other package namespace works", {
  test <- polars::pl$DataFrame(x = 1:3)

  expect_equal(
    test |> mutate(y = first(x)),
    test |> mutate(y = dplyr::first(x))
  )

  expect_equal(
    test |> summarize(y = first(x)),
    test |> summarize(y = dplyr::first(x))
  )

  expect_equal(
    test |> filter(x == first(x)),
    test |> filter(x == dplyr::first(x))
  )
})

test_that("error message when function exists but has no translation", {
  test <- polars::pl$DataFrame(x = 1:3)
  expect_snapshot(
    test |> mutate(y = data.table::shift(x)),
    error = TRUE
  )

  suppressPackageStartupMessages(library("data.table"))
  expect_snapshot(
    test |> mutate(y = year(x)),
    error = TRUE
  )
  detach("package:data.table", unload = TRUE)
})

test_that("error message when function doesn't exist in environment", {
  test <- polars::pl$DataFrame(x = 1:3)

  expect_snapshot(
    test |> mutate(y = foobar(x)),
    error = TRUE
  )
})
