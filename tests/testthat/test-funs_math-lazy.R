### [GENERATED AUTOMATICALLY] Update test-funs_math.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("mathematical functions work", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample(11:15),
    value_trigo = seq(0, 0.4, 0.1),
    value_mix = -2:2,
  )
  test_pl <- as_polars_lf(test_df)

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
    "sign",
    "sin",
    "sinh",
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

    res <- paste0("mutate(test_df, foo =", i, "(", variable, "))") |>
      str2lang() |>
      eval()

    expect_equal_lazy(pol, res, info = i)
  }
})

test_that("mathematical functions work with NA", {
  test_df <- tibble(
    value_with_NA = c(11, 12, NA, 14, 15),
    value_trigo_with_NA = c(0, 0.1, NA, 0.3, 0.4),
    value_mix_with_NA = c(-2, -1, NA, 1, 2)
  )
  test_pl <- as_polars_lf(test_df)

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
    "sign",
    "sin",
    "sinh",
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

    res <- paste0("mutate(test_df, foo =", i, "(", variable, "))") |>
      str2lang() |>
      eval()

    expect_equal_lazy(pol, res, info = i)
  }
})

test_that("log() works with base", {
  test_df <- tibble(x = c(3, NA, 1, 2, NA))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> mutate(y = log(x, base = 3)),
    test_df |> mutate(y = log(x, base = 3))
  )
  expect_both_error(
    test_pl |> mutate(y = log(x, base = "3")),
    test_df |> mutate(y = log(x, base = "3"))
  )
  expect_snapshot_lazy(
    test_pl |> mutate(y = log(x, base = "3")),
    error = TRUE
  )
})

test_that("sort errors when na.last is absent or NA", {
  test_df <- tibble(x = c(3, NA, 1, 2, NA))
  test_pl <- as_polars_lf(test_df)

  expect_both_error(
    test_pl |> mutate(foo = sort(x)),
    test_df |> mutate(foo = sort(x))
  )
  expect_snapshot_lazy(
    test_pl |> mutate(foo = sort(x)),
    error = TRUE
  )

  expect_both_error(
    test_pl |> mutate(foo = sort(x, na.last = NA)),
    test_df |> mutate(foo = sort(x, na.last = NA))
  )
  expect_snapshot_lazy(
    test_pl |> mutate(foo = sort(x, na.last = NA)),
    error = TRUE
  )
})

test_that("sort supports decreasing and na.last", {
  test_df <- tibble(x = c(3, NA, 1, 2, NA))
  test_pl <- as_polars_lf(test_df)

  # With different parameters
  for (decreasing in c(TRUE, FALSE)) {
    for (na_last in c(TRUE, FALSE)) {
      pol <- paste0(
        "mutate(test_pl, foo = sort(x, decreasing = ",
        decreasing,
        ", na.last = ",
        na_last,
        "))"
      ) |>
        str2lang() |>
        eval()

      res <- paste0(
        "mutate(test_df, foo = sort(x, decreasing = ",
        decreasing,
        ", na.last = ",
        na_last,
        "))"
      ) |>
        str2lang() |>
        eval()

      expect_equal_lazy(pol, res)
    }
  }
})

test_that("rank error when na.last is not in TRUE/FALSE/keep", {
  test_df <- tibble(x = sample(c(0:9, NA), size = 10000, replace = TRUE))
  test_pl <- as_polars_lf(test_df)

  expect_snapshot_lazy(
    test_pl |> mutate(foo = rank(x, na.last = NA)),
    error = TRUE
  )
  expect_snapshot_lazy(
    test_pl |> mutate(foo = rank(x, na.last = "wrong")),
    error = TRUE
  )
  expect_snapshot_lazy(
    test_pl |> mutate(foo = rank(x, na.last = 5)),
    error = TRUE
  )
  expect_both_error(
    test_pl |> mutate(foo = rank(x, na.last = NA)),
    test_df |> mutate(foo = rank(x, na.last = NA))
  )
})

test_that("rank with default args", {
  test_df <- tibble(x = sample(c(0:9, NA), size = 10000, replace = TRUE))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> mutate(foo = rank(x)),
    test_df |> mutate(foo = rank(x))
  )
})

patrick::with_parameters_test_that(
  "rank with ties.method={ties_method} and na.last={na_last}",
  {
    test_df <- tibble(x = sample(c(0:9, NA), size = 10000, replace = TRUE))
    test_pl <- as_polars_lf(test_df)

    na_last <- switch(na_last, "TRUE" = TRUE, "FALSE" = FALSE, na_last)

    r_output <- test_df |>
      mutate(foo = rank(x, ties.method = ties_method, na.last = na_last))

    pl_output <- test_pl |>
      mutate(foo = rank(x, ties.method = ties_method, na.last = na_last))

    if (ties_method == "random") {
      expect_equal_lazy(
        pl_output |> arrange(x, foo),
        r_output |> arrange(x, foo)
      )
    } else {
      expect_equal_lazy(pl_output, r_output)
    }
  },
  .cases = tidyr::crossing(
    ties_method = c("average", "first", "last", "random", "max", "min"),
    na_last = c("TRUE", "FALSE", "keep")
  )
)

test_that("rank() works on various input types", {
  for_all(
    # TODO: Can't use any_atomic() because the behavior for factors is incorrect
    num = numeric_(len = 10, any_na = TRUE),
    str = character_(len = 10, any_na = TRUE),
    date = date_(len = 10, any_na = TRUE),
    dt = posixct_(len = 10, any_na = TRUE),
    property = function(num, str, date, dt) {
      for (i in c("num", "str", "date", "dt")) {
        test_df <- tibble(x = eval(parse(text = i)))
        test_pl <- pl$LazyFrame(x = eval(parse(text = i)))
        expect_equal_or_both_error(
          mutate(test_pl, y = rank(x)),
          mutate(test_df, y = rank(x))
        )
      }
    }
  )
})

test_that("warns if unknown args", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample(11:15),
    value_trigo = seq(0, 0.4, 0.1),
    value_mix = -2:2,
    value_with_NA = c(-2, -1, NA, 1, 2)
  )
  test_pl <- as_polars_lf(test_df)
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
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample(11:15),
    value_trigo = seq(0, 0.4, 0.1),
    value_mix = -2:2,
    value_with_NA = c(-2, -1, NA, 1, 2)
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |> mutate(foo = value %% 10),
    test_df |> mutate(foo = value %% 10)
  )

  expect_equal_lazy(
    test_pl |> mutate(foo = value %/% 10),
    test_df |> mutate(foo = value %/% 10)
  )
})

test_that("ensure na.rm works fine", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample(11:15),
    value_trigo = seq(0, 0.4, 0.1),
    value_mix = -2:2,
    value_with_NA = c(-2, -1, NA, 1, 2)
  )
  test_pl <- as_polars_lf(test_df)

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
        "mutate(test_df, foo =",
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
