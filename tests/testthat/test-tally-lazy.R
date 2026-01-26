### [GENERATED AUTOMATICALLY] Update test-tally.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("tally works", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)

  expect_is_tidypolars(tally(test_pl))

  expect_equal_lazy(
    tally(test_pl),
    tally(test)
  )

  expect_equal_lazy(
    test_pl |> group_by(cyl) |> tally() |> arrange(cyl),
    test |> group_by(cyl) |> tally() |> arrange(cyl)
  )

  expect_equal_lazy(
    test_pl |> group_by(cyl, am) |> tally() |> arrange(cyl, am),
    test |> group_by(cyl, am) |> tally() |> arrange(cyl, am)
  )
})

test_that("arguments name and sort work", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |>
      group_by(cyl, am) |>
      tally(sort = TRUE, name = "tally"),
    test |>
      group_by(cyl, am) |>
      tally(sort = TRUE, name = "tally")
  )

  expect_equal_lazy(
    tally(test_pl, name = "tally"),
    tally(test, name = "tally")
  )
})

test_that("tally() drops one grouping level", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> group_by(cyl) |> tally() |> group_vars(),
    test |> group_by(cyl) |> tally() |> group_vars()
  )

  expect_equal_lazy(
    test_pl |> group_by(cyl, am) |> tally() |> group_vars(),
    test |> group_by(cyl, am) |> tally() |> group_vars()
  )
})

# TODO: uncomment if add_tally() becomes generic, #202
# test_that("add_tally works", {
#   test <- polars::as_polars_lf(mtcars)

#   expect_colnames(
#     test |> group_by(cyl) |> add_tally(),
#     c(names(mtcars), "n")
#   )
# })

# test_that("arguments name and sort work", {
#   test <- polars::as_polars_lf(mtcars)

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
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)

  test2 <- test |> mutate(n = 1)
  test2_pl <- test_pl |> mutate(n = 1)

  test3 <- test2 |> mutate(nn = 1)
  test3_pl <- test2_pl |> mutate(nn = 1)

  expect_message(
    test2_pl |> group_by(n) |> tally(),
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
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)

  expect_warning(
    test_pl |> tally(wt = drat),
    "Argument `wt` is not supported by tidypolars"
  )
  withr::with_options(
    list("tidypolars_unknown_args" = "error"),
    {
      expect_error_lazy(
        test_pl |> tally(wt = drat),
        "Argument `wt` is not supported by tidypolars"
      )
    }
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
