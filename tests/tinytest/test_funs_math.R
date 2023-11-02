source("helpers.R")
using("tidypolars")

library(dplyr, warn.conflicts = FALSE)

test_df <- data.frame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  value = sample(1:5),
  value_trigo = seq(0, 0.4, 0.1)
)

test <- pl$DataFrame(test_df)

# auto <- r_polars_funs[!is.na(r_polars_funs$category), ]
# auto$r_funs |> constructive::construct()

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
  "round",
  "sign",
  "sin", "sinh", "sort",  "sqrt", "sd", "tan", "tanh", "var"
)) {

  if (i %in% c("acos", "asin", "atan", "atanh", "ceiling", "cos", "floor",
               "round", "sin", "tan")) {

    variable <- "value_trigo"

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
