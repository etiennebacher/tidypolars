### [GENERATED AUTOMATICALLY] Update test_across.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(head(mtcars))

# single word function

expect_equal_lazy(
  pl_mutate(
    test,
    across(.cols = contains("a"), mean),
    cyl = cyl + 1
  ) |> to_r(),
  pl_mutate(
    test,
    drat = mean(drat),
    am = mean(am),
    gear = mean(gear),
    carb = mean(carb),
    cyl = cyl + 1
  ) |> to_r()
)

# purrr-style function

expect_equal_lazy(
  pl_mutate(
    test,
    across(.cols = contains("a"), ~ mean(.x)),
    cyl = cyl + 1
  ) |> to_r(),
  pl_mutate(
    test,
    drat = mean(drat),
    am = mean(am),
    gear = mean(gear),
    carb = mean(carb),
    cyl = cyl + 1
  ) |> to_r()
)

# anonymous functions has to return a Polars expression

expect_equal_lazy(
  pl_mutate(
    test,
    across(.cols = contains("ar"), \(x) x$mean())
  ) |> to_r(),
  pl_mutate(
    test,
    gear = mean(gear),
    carb = mean(carb)
  ) |> to_r()
)

expect_equal_lazy(
  pl_mutate(
    test,
    across(
      .cols = contains("ar"),
      list(
        mean = \(x) x$mean(),
        std = \(x) x$std()
      )
    )
  ) |> to_r(),
  pl_mutate(
    test,
    gear_mean = mean(gear),
    gear_std = sd(gear),
    carb_mean = mean(carb),
    carb_std = sd(carb),
  ) |> to_r()
)

expect_colnames(
  pl_mutate(
    test,
    across(
      .cols = contains("ar"),
      list(\(x) x$mean(), \(x) x$std())
    )
  ),
  c(names(mtcars), "gear_1", "gear_2", "carb_1", "carb_2")
)

expect_error_lazy(
  pl_mutate(
    test,
    across(.cols = contains("a"), \(x) mean(x)),
  ) |> to_r(),
  "Are you sure the anonymous function"
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
  ) |> to_r(),
  pl_mutate(
    test,
    drat = foo(drat),
    am = foo(am),
    gear = foo(gear),
    carb = foo(carb),
    cyl = cyl + 1
  ) |> to_r()
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
  ) |> to_r(),
  pl_mutate(test, mpg_1 = mean(mpg), mpg_2 = median(mpg)) |> to_r()
)

expect_equal_lazy(
  pl_mutate(
    test,
    across(
      .cols = mpg,
      list(my_mean = mean, my_median = median)
    )
  ) |> to_r(),
  pl_mutate(test, mpg_my_mean = mean(mpg), mpg_my_median = median(mpg)) |> to_r()
)

expect_equal_lazy(
  pl_mutate(
    test,
    across(
      .cols = mpg,
      list(mean = mean, median = median),
      .nms = "{.col}_foo_{.fn}"
    )
  ) |> to_r(),
  pl_mutate(test, mpg_foo_mean = mean(mpg), mpg_foo_median = median(mpg)) |> to_r()
)

expect_equal_lazy(
  pl_mutate(
    test,
    across(
      .cols = mpg,
      list(mean = ~mean(.x), median = median),
      .nms = "{.col}_foo_{.fn}"
    )
  ) |> to_r(),
  pl_mutate(test, mpg_foo_mean = mean(mpg), mpg_foo_median = median(mpg)) |> to_r()
)

# just one check for summarize()

test_grp <- pl_group_by(test, cyl, maintain_order = TRUE)

expect_equal_lazy(
  pl_summarize(
    test_grp,
    across(
      .cols = mpg,
      list(my_mean = mean, my_median = median)
    )
  ) |> to_r(),
  pl_summarize(test_grp, mpg_my_mean = mean(mpg), mpg_my_median = median(mpg)) |>
    to_r()
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)