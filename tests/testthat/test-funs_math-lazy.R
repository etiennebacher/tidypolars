### [GENERATED AUTOMATICALLY] Update test-funs_math.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("mathematical functions work", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample(11:15),
    value_trigo = seq(0, 0.4, 0.1),
    value_mix = -2:2,
  )
  test_pl <- as_polars_lf(test)

  for (i in c(
    "abs",
    "acos",
    "acosh",
    "asin",
    "asinh",
    "atan",
    "atanh",
    "ceiling",
    "cos",
    "cosh",
    "cummax",
    "cummin",
    "cumprod",
    "cumsum",
    "exp",
    "first",
    "floor",
    "last",
    "log",
    "log10",
    "rank",
    "sign",
    "sin",
    "sinh",
    "sort",
    "sqrt",
    "tan",
    "tanh"
  )) {
    if (
      i %in%
        c(
          "acos",
          "asin",
          "atan",
          "atanh",
          "ceiling",
          "cos",
          "floor",
          "sin",
          "tan"
        )
    ) {
      variable <- "value_trigo"
    } else if (i %in% c("abs", "mean")) {
      variable <- "value_mix"
    } else {
      variable <- "value"
    }

    pol <- paste0("mutate(test_pl, foo =", i, "(", variable, "))") |>
      str2lang() |>
      eval()

    res <- paste0("mutate(test, foo =", i, "(", variable, "))") |>
      str2lang() |>
      eval()

    expect_equal_lazy(pol, res, info = i)
  }
})

test_that("mathematical functions work with NA", {
  test <- tibble(
    value_with_NA = c(11, 12, NA, 14, 15),
    value_trigo_with_NA = c(0, 0.1, NA, 0.3, 0.4),
    value_mix_with_NA = c(-2, -1, NA, 1, 2)
  )
  test_pl <- as_polars_lf(test)

  for (i in c(
    "abs",
    "acos",
    "acosh",
    "asin",
    "asinh",
    "atan",
    "atanh",
    "ceiling",
    "cos",
    "cosh",
    "cummax",
    "cummin",
    "cumprod",
    "cumsum",
    "exp",
    "first",
    "floor",
    "last",
    "log",
    "log10",
    # "rank", inconsistent behavior between R and Polars with NA
    "sign",
    "sin",
    "sinh",
    # "sort", inconsistent behavior between R and Polars with NA
    "sqrt",
    "tan",
    "tanh"
  )) {
    if (
      i %in%
        c(
          "acos",
          "asin",
          "atan",
          "atanh",
          "ceiling",
          "cos",
          "floor",
          "sin",
          "tan"
        )
    ) {
      variable <- "value_trigo_with_NA"
    } else if (i %in% c("abs", "mean")) {
      variable <- "value_mix_with_NA"
    } else {
      variable <- "value_with_NA"
    }

    pol <- paste0("mutate(test_pl, foo =", i, "(", variable, "))") |>
      str2lang() |>
      eval()

    res <- paste0("mutate(test, foo =", i, "(", variable, "))") |>
      str2lang() |>
      eval()

    expect_equal_lazy(pol, res, info = i)
  }
})

test_that("warns if unknown args", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample(11:15),
    value_trigo = seq(0, 0.4, 0.1),
    value_mix = -2:2,
    value_with_NA = c(-2, -1, NA, 1, 2)
  )
  test_pl <- as_polars_lf(test)
  foo <- test_pl |>
    mutate(x = sample(x2)) |>
    pull(x)

  expect_true(all(foo %in% c(1, 2, 3, 5)))

  expect_warning(
    test_pl |> mutate(x = sample(x2, prob = 0.5)),
    "doesn't know how to use some arguments"
  )
})

test_that("%% and %/% work", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample(11:15),
    value_trigo = seq(0, 0.4, 0.1),
    value_mix = -2:2,
    value_with_NA = c(-2, -1, NA, 1, 2)
  )
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> mutate(foo = value %% 10),
    test |> mutate(foo = value %% 10)
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = value %/% 10),
    test |> mutate(foo = value %/% 10)
  )
})

test_that("ensure na.rm works fine", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample(11:15),
    value_trigo = seq(0, 0.4, 0.1),
    value_mix = -2:2,
    value_with_NA = c(-2, -1, NA, 1, 2)
  )
  test_pl <- as_polars_lf(test)

  for (i in c("max", "mean", "median", "min", "sd", "sum", "var")) {
    for (remove_na in c(TRUE, FALSE)) {
      pol <- paste0(
        "mutate(test_pl, foo =",
        i,
        "(value_with_NA, na.rm = ",
        remove_na,
        "))"
      ) |>
        str2lang() |>
        eval()

      res <- paste0(
        "mutate(test, foo =",
        i,
        "(value_with_NA, na.rm = ",
        remove_na,
        "))"
      ) |>
        str2lang() |>
        eval()

      expect_equal_lazy(pol, res, info = i)
    }
  }
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
