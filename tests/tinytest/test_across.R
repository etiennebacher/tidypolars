source("helpers.R")
using("tidypolars")

test <- polars:::pl$DataFrame(head(mtcars))

# single word function

expect_equal(
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

expect_equal(
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

expect_equal(
  test |>
    pl_group_by(am) |>
    pl_mutate(
      across(
        .cols = contains("a"),
        ~ mean(.x)
      )
    ) |>
    pl_pull(carb),
  c(3, 3, 3, 1.333, 1.333, 1.333),
  tolerance = 1e-3
)

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
