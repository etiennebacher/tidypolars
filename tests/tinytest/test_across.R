source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(head(mtcars))

# single word function

expect_equal(
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

expect_equal(
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

expect_equal(
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

expect_equal(
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

expect_error(
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

expect_equal(
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

expect_equal(
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

expect_equal(
  mutate(
    test,
    across(
      .cols = mpg,
      list(mean, median)
    )
  ),
  mutate(test, mpg_1 = mean(mpg), mpg_2 = median(mpg))
)

expect_equal(
  mutate(
    test,
    across(
      .cols = mpg,
      list(my_mean = mean, my_median = median)
    )
  ),
  mutate(test, mpg_my_mean = mean(mpg), mpg_my_median = median(mpg))
)

expect_equal(
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

expect_equal(
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

# just one check for summarize()

test_grp <- group_by(test, cyl, maintain_order = TRUE)

expect_equal(
  summarize(
    test_grp,
    across(
      .cols = mpg,
      list(my_mean = mean, my_median = median)
    )
  ),
  summarize(test_grp, mpg_my_mean = mean(mpg), mpg_my_median = median(mpg)) |>
    to_r()
)


# sequence of expressions modifying the same vars works

test2 <- mutate(
  test, across(contains("a"), mean),
  am = 1, gear = NULL
)

expect_equal(
  pull(test2, am) |> unique(),
  1
)

expect_colnames(
  test2,
  setdiff(colnames(mtcars), "gear")
)


# Need to specify .cols (either named or unnamed)

expect_error(
  mutate(test, across(.fns = mean)),
  "You must supply the argument `.cols`"
)

# test .by

test3 <- mtcars |>
  head(n = 5) |>
  as_polars() |>
  mutate(across(everything(), .fns = mean), .by = "cyl") |>
  distinct()

expect_equal(
  test3 |> pull(cyl),
  c(6, 4, 8)
)

expect_equal(
  test3 |> pull(hp),
  c(110, 93, 175)
)
