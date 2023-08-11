### [GENERATED AUTOMATICALLY] Update test_across.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(head(mtcars))

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

# custom function

foo <<- function(x) {
  tmp <- x$cos()$mean()
  tmp
}

expect_equal_lazy(
  pl_mutate(
    test,
    across(
      .cols = contains("a"),
      foo
    ),
    cyl = cyl + 1
  ),
  pl_mutate(
    test,
    drat = foo(drat),
    am = foo(am),
    gear = foo(gear),
    carb = foo(carb),
    cyl = cyl + 1
  )
)

# groups

expect_equal_lazy(
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
    cyl = NULL
  ),
  c(
    "mpg", "disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb",
    "1_drat", "1_am", "1_gear", "1_carb"
  )
)

# List of functions ---------------

expect_equal_lazy(
  pl_mutate(
    test,
    across(
      .cols = mpg,
      list(mean, median)
    )
  ),
  pl_mutate(test, mpg_mean = mean(mpg), mpg_median = median(mpg))
)

expect_equal_lazy(
  pl_mutate(
    test,
    across(
      .cols = mpg,
      list(my_mean = mean, my_median = median)
    )
  ),
  pl_mutate(test, my_mpg_mean = mean(mpg), my_mpg_median = median(mpg))
)

expect_equal_lazy(
  pl_mutate(
    test,
    across(
      .cols = mpg,
      list(mean = mean, median = median),
      .nms = "{.col}_foo_{.fn}"
    )
  ),
  pl_mutate(test, mpg_foo_mean = mean(mpg), mpg_foo_median = median(mpg))
)

expect_equal_lazy(
  pl_mutate(
    test,
    across(
      .cols = mpg,
      list(mean = ~mean(.x), median = median),
      .nms = "{.col}_foo_{.fn}"
    )
  ),
  pl_mutate(test, mpg_foo_mean = mean(mpg), mpg_foo_median = median(mpg))
)

# just one check for summarize()

test_grp <- pl_group_by(test, cyl)

expect_equal_lazy(
  pl_summarize(
    test_grp,
    across(
      .cols = mpg,
      list(my_mean = mean, my_median = median)
    )
  ),
  pl_summarize(test_grp, my_mpg_mean = mean(mpg), my_mpg_median = median(mpg))
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)