### [GENERATED AUTOMATICALLY] Update test_across.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars:::pl$LazyFrame(head(mtcars))

# single word function

expect_equal_lazy(
  pl_mutate(
    test,
    across(
      .cols = contains("a"),
      mean
    ),
    cyl = cyl + 1
  ),
  pl_mutate(
    test,
    drat = mean(drat),
    am = mean(am),
    gear = mean(gear),
    carb = mean(carb),
    cyl = cyl + 1
  )
)

# purrr-style function

expect_equal_lazy(
  pl_mutate(
    test,
    across(
      .cols = contains("a"),
      ~ mean(.x)
    ),
    cyl = cyl + 1
  ),
  pl_mutate(
    test,
    drat = mean(drat),
    am = mean(am),
    gear = mean(gear),
    carb = mean(carb),
    cyl = cyl + 1
  )
)

# groups

# TODO: uncomment this when https://github.com/pola-rs/r-polars/issues/338 is
# solved
# expect_equal_lazy(
#   test |>
#     pl_group_by(am) |>
#     pl_mutate(
#       across(
#         .cols = contains("a"),
#         ~ mean(.x)
#       )
#     ) |>
#     pl_pull(carb),
#   c(3, 3, 3, 1.333, 1.333, 1.333),
#   tolerance = 1e-3
# )

# argument .names

expect_colnames(
  pl_mutate(
    test,
    across(
      .cols = contains("a"),
      mean,
      .names = "{.col}_new"
    ),
    cyl = cyl + 1
  ),
  c(
    "mpg", "cyl", "disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb",
    "drat_new", "am_new", "gear_new", "carb_new"
  )
)

expect_colnames(
  pl_mutate(
    test,
    across(
      .cols = contains("a"),
      mean,
      .names = "{.fn}_{.col}"
    ),
    cyl = cyl + 1
  ),
  c(
    "mpg", "cyl", "disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb",
    "mean_drat", "mean_am", "mean_gear", "mean_carb"
  )
)

expect_colnames(
  pl_mutate(
    test,
    across(
      .cols = contains("a"),
      ~mean(.x),
      .names = "{.fn}_{.col}"
    ),
    cyl = cyl + 1
  ),
  c(
    "mpg", "cyl", "disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb",
    "mean_drat", "mean_am", "mean_gear", "mean_carb"
  )
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)