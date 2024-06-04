source("helpers.R")
using("tidypolars")

test_df <- data.frame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  value = sample(11:15),
  value_trigo = seq(0, 0.4, 0.1),
  value_mix = -2:2
)

test <- pl$DataFrame(test_df)

for (i in c(
  "abs",
  "acos", "acosh", "asin",
  "asinh", "atan", "atanh",
  "ceiling", "cos", "cosh",
  "cummin",
  "cumprod",
  "cumsum", "exp", "first",
  "floor", "lag",
  "last", "log", "log10",
  "max", "mean", "median", "min",
  "rank",
  "sign",
  "sin", "sinh", "sort",  "sqrt", "sd", "tan", "tanh", "var"
)) {

  if (i %in% c("acos", "asin", "atan", "atanh", "ceiling", "cos", "floor",
               "sin", "tan")) {

    variable <- "value_trigo"

  } else if (i %in% c("abs", "mean")) {
    variable <- "value_mix"
  } else {
    variable <- "value"
  }

  pol <- paste0("mutate(test, foo =", i, "(", variable, "))") |>
    str2lang() |>
    eval() |>
    pull(foo)

  res <- paste0("mutate(test_df, foo =", i, "(", variable, "))") |>
    str2lang() |>
    eval() |>
    pull(foo)

  expect_equal(pol, res, info = i)

}

foo <- test |> mutate(x = sample(x2)) |> pull(x)

expect_true(all(foo %in% c(1, 2, 3, 5)))

expect_warning(
  test |> mutate(x = sample(x2, prob = 0.5)),
  "will not be used: `prob`"
)

# diff

expect_equal(
  test |>
    summarize(foo = diff(value)) |>
    pull(foo),
  test_df |>
    summarize(foo = diff(value)) |>
    pull(foo) |>
    suppressWarnings()
)

expect_equal(
  test |>
    summarize(foo = diff(value, lag = 2)) |>
    pull(foo),
  test_df |>
    summarize(foo = diff(value, lag = 2)) |>
    pull(foo) |>
    suppressWarnings()
)

expect_error(
  test |> summarize(foo = diff(value, differences = 2)),
  "doesn't support"
)

# %% and %/%

expect_equal(
  test |>
    mutate(foo = value %% 10) |>
    pull(foo),
  test_df |>
    mutate(foo = value %% 10) |>
    pull(foo)
)

expect_equal(
  test |>
    mutate(foo = value %/% 10) |>
    pull(foo),
  test_df |>
    mutate(foo = value %/% 10) |>
    pull(foo)
)
