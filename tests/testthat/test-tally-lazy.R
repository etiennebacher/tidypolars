### [GENERATED AUTOMATICALLY] Update test-tally.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("tally works", {
  test <- polars0::as_polars_lf(mtcars)

  expect_is_tidypolars(tally(test))

  expect_equal_lazy(
    tally(test) |> pull(n),
    32
  )

  expect_equal_lazy(
    test |> group_by(cyl) |> tally() |> pull(n),
    c(11, 7, 14)
  )

  expect_equal_lazy(
    test |> group_by(cyl, am) |> tally() |> pull(n),
    c(3, 8, 4, 3, 12, 2)
  )
})

test_that("arguments name and sort work", {
  test <- polars0::as_polars_lf(mtcars)

  expect_equal_lazy(
    test |>
      group_by(cyl, am) |>
      tally(sort = TRUE, name = "tally") |>
      pull(tally),
    c(12, 8, 4, 3, 3, 2)
  )

  expect_equal_lazy(
    tally(test, name = "tally") |> pull(tally),
    32
  )
})

test_that("tally() drops one grouping level", {
  test <- polars0::as_polars_lf(mtcars)
  expect_equal_lazy(
    test |>
      group_by(cyl) |>
      tally() |>
      group_vars(),
    character(0)
  )
  expect_equal_lazy(
    test |>
      group_by(cyl, am) |>
      tally() |>
      group_vars(),
    "cyl"
  )
})

# TODO: uncomment if add_tally() becomes generic, #202
# test_that("add_tally works", {
#   test <- polars0::as_polars_lf(mtcars)

#   expect_colnames(
#     test |> group_by(cyl) |> add_tally(),
#     c(names(mtcars), "n")
#   )
# })

# test_that("arguments name and sort work", {
#   test <- polars0::as_polars_lf(mtcars)

#   expect_colnames(
#     add_tally(test, cyl, am, sort = TRUE, name = "tally"),
#     c(names(mtcars), "tally")
#   )

#   expect_dim(
#     add_tally(test, cyl, am, sort = TRUE, name = "tally"),
#     c(32, 12)
#   )

#   expect_dim(
#     add_tally(test, name = "tally"),
#     c(32, 12)
#   )
# })

test_that("message if overwriting variable", {
  test <- polars0::as_polars_lf(mtcars)

  test2 <- test |>
    mutate(n = 1)

  test3 <- test2 |>
    mutate(nn = 1)

  expect_message(
    test2 |> group_by(n) |> tally(),
    "Storing counts in `nn`, as `n` already present in input."
  )

  # expect_message(
  #   test2 |> add_tally(cyl),
  #   "Storing tallys in `nn`, as `n` already present in input."
  # )

  # expect_message(
  #   test3 |> add_tally(cyl),
  #   "Storing tallys in `nnn`, as `n` already present in input."
  # )

  # expect_equal_lazy(
  #   test2 |>
  #     add_tally(cyl, name = "n") |>
  #     pull(n),
  #   test |>
  #     add_tally(cyl, name = "n") |>
  #     pull(n)
  # )
})

test_that("tally() explicitly does not support 'wt'", {
  expect_warning(
    mtcars |> as_polars_lf() |> tally(wt = drat),
    "Argument `wt` is not supported by tidypolars"
  )
  withr::with_options(
    list("tidypolars_unknown_args" = "error"),
    {
      expect_error_lazy(
        mtcars |> as_polars_lf() |> tally(wt = drat),
        "Argument `wt` is not supported by tidypolars"
      )
    }
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
