### [GENERATED AUTOMATICALLY] Update test_across.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(head(mtcars))

# single word function

expect_equal_lazy(
  mutate(
    test,
    across(.cols = contains("a"), mean),
    cyl = cyl + 1
  ),
  mutate(
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
  mutate(
    test,
    across(.cols = contains("a"), ~ mean(.x)),
    cyl = cyl + 1
  ),
  mutate(
    test,
    drat = mean(drat),
    am = mean(am),
    gear = mean(gear),
    carb = mean(carb),
    cyl = cyl + 1
  )
)

# anonymous functions has to return a Polars expression

expect_equal_lazy(
  mutate(
    test,
    across(.cols = contains("ar"), \(x) x$mean())
  ),
  mutate(
    test,
    gear = mean(gear),
    carb = mean(carb)
  )
)

expect_equal_lazy(
  mutate(
    test,
    across(
      .cols = contains("ar"),
      list(
        mean = \(x) x$mean(),
        std = \(x) x$std()
      )
    )
  ),
  mutate(
    test,
    gear_mean = mean(gear),
    gear_std = sd(gear),
    carb_mean = mean(carb),
    carb_std = sd(carb),
  )
)

expect_colnames(
  mutate(
    test,
    across(
      .cols = contains("ar"),
      list(\(x) x$mean(), \(x) x$std())
    )
  ),
  c(names(mtcars), "gear_1", "gear_2", "carb_1", "carb_2")
)

expect_colnames(
  mutate(
    test,
    across(
      .cols = gear,
      list(mean = \(x) x$mean(), \(x) x$std())
    )
  ),
  c(names(mtcars), "gear_mean", "gear_2")
)

expect_error_lazy(
  mutate(
    test,
    across(.cols = contains("a"), \(x) mean(x)),
  ),
  "Are you sure the anonymous function"
)

# custom function

foo <<- function(x) {
  tmp <- x$cos()$mean()
  tmp
}

expect_equal_lazy(
  mutate(
    test,
    across(
      .cols = contains("a"),
      foo
    ),
    cyl = cyl + 1
  ),
  mutate(
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
    group_by(am) |>
    mutate(
      across(
        .cols = contains("a"),
        ~ mean(.x)
      )
    ) |>
    pull(carb),
  c(3, 3, 3, 1.333, 1.333, 1.333),
  tolerance = 1e-3
)

# argument .names

expect_colnames(
  mutate(
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
  mutate(
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
  mutate(
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
  mutate(
    test,
    across(
      .cols = mpg,
      list(mean, median)
    )
  ),
  mutate(test, mpg_1 = mean(mpg), mpg_2 = median(mpg))
)

expect_equal_lazy(
  mutate(
    test,
    across(
      .cols = mpg,
      list(my_mean = mean, my_median = median)
    )
  ),
  mutate(test, mpg_my_mean = mean(mpg), mpg_my_median = median(mpg))
)

expect_equal_lazy(
  mutate(
    test,
    across(
      .cols = mpg,
      list(mean = mean, median = median),
      .nms = "{.col}_foo_{.fn}"
    )
  ),
  mutate(test, mpg_foo_mean = mean(mpg), mpg_foo_median = median(mpg))
)

expect_equal_lazy(
  mutate(
    test,
    across(
      .cols = mpg,
      list(mean = ~mean(.x), median = median),
      .nms = "{.col}_foo_{.fn}"
    )
  ),
  mutate(test, mpg_foo_mean = mean(mpg), mpg_foo_median = median(mpg))
)

# single variable in .cols, single function

expect_equal_lazy(
  mutate(
    test,
    across(.cols = mpg, mean)
  ),
  mutate(test, mpg = mean(mpg))
)

# just one check for summarize()

test_grp <- group_by(test, cyl, maintain_order = TRUE)

expect_equal_lazy(
  summarize(
    test_grp,
    across(
      .cols = mpg,
      list(my_mean = mean, my_median = median)
    )
  ),
  summarize(test_grp, mpg_my_mean = mean(mpg), mpg_my_median = median(mpg)) |>
    as.data.frame()
)

# sequence of expressions modifying the same vars works

test2 <- mutate(
  test, across(contains("a"), mean),
  am = 1, gear = NULL
)

expect_equal_lazy(
  pull(test2, am) |> unique(),
  1
)

expect_colnames(
  test2,
  setdiff(colnames(mtcars), "gear")
)

# newly created variable is captured in across

expect_equal_lazy(
  test |>
    mutate(
      bar = 1,
      across(.cols = contains("a"), \(x) x - 1)
    ) |>
    pull(bar),
  rep(0, 6)
)

expect_equal_lazy(
  test |>
    mutate(
      bar = 1,
      across(.cols = starts_with("b"), \(x) x - 1)
    ) |>
    pull(bar),
  rep(0, 6)
)

expect_equal_lazy(
  test |>
    mutate(
      bar = 1,
      across(.cols = ends_with("r"), \(x) x - 1)
    ) |>
    pull(bar),
  rep(0, 6)
)

expect_equal_lazy(
  test |>
    mutate(
      bar = 1,
      across(.cols = matches("^b"), \(x) x - 1)
    ) |>
    pull(bar),
  rep(0, 6)
)

expect_equal_lazy(
  test |>
    mutate(
      bar = 1,
      across(.cols = everything(), \(x) x - 1)
    ) |>
    pull(bar),
  rep(0, 6)
)

expect_equal_lazy(
  test |>
    mutate(
      foo = 1,
      across(.cols = contains("oo"), \(x) x - 1)
    ) |>
    pull(foo),
  rep(0, 6)
)

expect_warning(
  test |>
    mutate(
      foo = 1,
      across(.cols = where(is.numeric), \(x) x - 1)
    ),
  "will not take into account"
)


# Need to specify .cols (either named or unnamed)

expect_error_lazy(
  mutate(test, across(.fns = mean)),
  "You must supply the argument `.cols`"
)

# test .by with across + everything

test3 <- mtcars |>
  head(n = 5) |>
  as_polars_df() |>
  summarize(across(everything(), .fns = mean), .by = "cyl") |>
  distinct() |>
  arrange(cyl)

expect_equal_lazy(
  test3 |> pull(cyl),
  c(4, 6, 8)
)

expect_equal_lazy(
  test3 |> pull(hp),
  c(93, 110, 175)
)


Sys.setenv('TIDYPOLARS_TEST' = FALSE)