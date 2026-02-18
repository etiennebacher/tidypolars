### [GENERATED AUTOMATICALLY] Update test-across.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("single word functions work", {
  test_df <- as_tibble(head(mtcars))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(
      test_pl,
      across(.cols = contains("a"), mean),
      cyl = cyl + 1
    ),
    mutate(
      test_pl,
      drat = mean(drat),
      am = mean(am),
      gear = mean(gear),
      carb = mean(carb),
      cyl = cyl + 1
    )
  )
})

test_that("purrr-style function work", {
  test_df <- as_tibble(head(mtcars))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(
      test_pl,
      across(.cols = contains("a"), ~ mean(.x)),
      cyl = cyl + 1
    ),
    mutate(
      test_pl,
      drat = mean(drat),
      am = mean(am),
      gear = mean(gear),
      carb = mean(carb),
      cyl = cyl + 1
    )
  )

  expect_equal_lazy(
    mutate(
      test_pl,
      across(.cols = contains("a"), ~ mean(.)),
      cyl = cyl + 1
    ),
    mutate(
      test_pl,
      drat = mean(drat),
      am = mean(am),
      gear = mean(gear),
      carb = mean(carb),
      cyl = cyl + 1
    )
  )
})

test_that("anonymous functions has to return a Polars expression", {
  test_df <- as_tibble(head(mtcars))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(
      test_pl,
      across(.cols = contains("ar"), \(x) x$mean())
    ),
    mutate(
      test_pl,
      gear = mean(gear),
      carb = mean(carb)
    )
  )

  expect_equal_lazy(
    mutate(
      test_pl,
      across(
        .cols = contains("ar"),
        list(
          mean = \(x) x$mean(),
          std = \(x) x$std()
        )
      )
    ),
    mutate(
      test_pl,
      gear_mean = mean(gear),
      gear_std = sd(gear),
      carb_mean = mean(carb),
      carb_std = sd(carb)
    )
  )

  expect_colnames(
    mutate(
      test_pl,
      across(
        .cols = contains("ar"),
        list(\(x) x$mean(), \(x) x$std())
      )
    ),
    c(names(mtcars), "gear_1", "gear_2", "carb_1", "carb_2")
  )

  expect_colnames(
    mutate(
      test_pl,
      across(
        .cols = gear,
        list(mean = \(x) x$mean(), \(x) x$std())
      )
    ),
    c(names(mtcars), "gear_mean", "gear_2")
  )

  expect_snapshot_lazy(
    mutate(
      test_pl,
      across(.cols = contains("a"), \(x) mean(x))
    ),
    error = TRUE
  )
})

test_that("custom function works", {
  test_df <- as_tibble(head(mtcars))
  test_pl <- as_polars_lf(test_df)

  foo <- function(x) {
    tmp <- x$cos()$mean()
    tmp
  }

  expect_equal_lazy(
    mutate(
      test_pl,
      across(
        .cols = contains("a"),
        foo
      ),
      cyl = cyl + 1
    ),
    mutate(
      test_pl,
      drat = foo(drat),
      am = foo(am),
      gear = foo(gear),
      carb = foo(carb),
      cyl = cyl + 1
    )
  )
})

test_that("works with grouped data", {
  test_df <- as_tibble(head(mtcars))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |>
      group_by(am) |>
      mutate(
        across(
          .cols = contains("a"),
          ~ mean(.x)
        )
      ),
    test_df |>
      group_by(am) |>
      mutate(
        across(
          .cols = contains("a"),
          ~ mean(.x)
        )
      )
  )
})

test_that("argument .names works", {
  test_df <- as_tibble(head(mtcars))
  test_pl <- as_polars_lf(test_df)

  expect_colnames(
    mutate(
      test_pl,
      across(
        .cols = contains("a"),
        mean,
        .names = "{.col}_new"
      ),
      cyl = cyl + 1
    ),
    c(
      "mpg",
      "cyl",
      "disp",
      "hp",
      "drat",
      "wt",
      "qsec",
      "vs",
      "am",
      "gear",
      "carb",
      "drat_new",
      "am_new",
      "gear_new",
      "carb_new"
    )
  )

  expect_colnames(
    mutate(
      test_pl,
      across(
        .cols = contains("a"),
        mean,
        .names = "{.fn}_{.col}"
      ),
      cyl = cyl + 1
    ),
    c(
      "mpg",
      "cyl",
      "disp",
      "hp",
      "drat",
      "wt",
      "qsec",
      "vs",
      "am",
      "gear",
      "carb",
      "mean_drat",
      "mean_am",
      "mean_gear",
      "mean_carb"
    )
  )

  expect_colnames(
    mutate(
      test_pl,
      across(
        .cols = contains("a"),
        ~ mean(.x),
        .names = "{.fn}_{.col}"
      ),
      cyl = NULL
    ),
    c(
      "mpg",
      "disp",
      "hp",
      "drat",
      "wt",
      "qsec",
      "vs",
      "am",
      "gear",
      "carb",
      "1_drat",
      "1_am",
      "1_gear",
      "1_carb"
    )
  )
})

test_that("passing a list of functions works", {
  test_df <- as_tibble(head(mtcars))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(
      test_pl,
      across(
        .cols = mpg,
        list(mean, median)
      )
    ),
    mutate(test_pl, mpg_1 = mean(mpg), mpg_2 = median(mpg))
  )

  expect_equal_lazy(
    mutate(
      test_pl,
      across(
        .cols = mpg,
        list(my_mean = mean, my_median = median)
      )
    ),
    mutate(test_pl, mpg_my_mean = mean(mpg), mpg_my_median = median(mpg))
  )

  expect_equal_lazy(
    mutate(
      test_pl,
      across(
        .cols = mpg,
        list(mean = mean, median = median),
        .nms = "{.col}_foo_{.fn}"
      )
    ),
    mutate(test_pl, mpg_foo_mean = mean(mpg), mpg_foo_median = median(mpg))
  )

  expect_equal_lazy(
    mutate(
      test_pl,
      across(
        .cols = mpg,
        list(mean = ~ mean(.x), median = median),
        .nms = "{.col}_foo_{.fn}"
      )
    ),
    mutate(test_pl, mpg_foo_mean = mean(mpg), mpg_foo_median = median(mpg))
  )
})

test_that("single variable in .cols, single function", {
  test_df <- as_tibble(head(mtcars))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(
      test_pl,
      across(.cols = mpg, mean)
    ),
    mutate(test_pl, mpg = mean(mpg))
  )
})

test_that("also works with summarize()", {
  test_df <- as_tibble(head(mtcars))
  test_pl <- as_polars_lf(test_df)
  test_grp_pl <- test_pl |>
    group_by(cyl, maintain_order = TRUE)

  expect_equal_lazy(
    summarize(
      test_grp_pl,
      across(
        .cols = mpg,
        list(my_mean = mean, my_median = median)
      )
    ),
    summarize(
      test_grp_pl,
      mpg_my_mean = mean(mpg),
      mpg_my_median = median(mpg)
    )
  )
})

test_that("sequence of expressions modifying the same vars works", {
  test_df <- as_tibble(head(mtcars))
  test_pl <- as_polars_lf(test_df)
  out <- test_pl |>
    mutate(
      across(contains("a"), mean),
      am = 1,
      gear = NULL
    )

  expect_equal_lazy(pull(out, am) |> unique(), 1)
  expect_colnames(out, setdiff(colnames(mtcars), "gear"))
})

test_that("newly created variable is captured in across", {
  test_df <- as_tibble(head(mtcars))
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |>
      mutate(
        bar = 1,
        across(.cols = contains("a"), \(x) x - 1)
      ),
    test_df |>
      mutate(
        bar = 1,
        across(.cols = contains("a"), \(x) x - 1)
      )
  )

  expect_equal_lazy(
    test_pl |>
      mutate(
        bar = 1,
        across(.cols = starts_with("b"), \(x) x - 1)
      ),
    test_df |>
      mutate(
        bar = 1,
        across(.cols = starts_with("b"), \(x) x - 1)
      )
  )

  expect_equal_lazy(
    test_pl |>
      mutate(
        bar = 1,
        across(.cols = ends_with("r"), \(x) x - 1)
      ),
    test_df |>
      mutate(
        bar = 1,
        across(.cols = ends_with("r"), \(x) x - 1)
      )
  )

  expect_equal_lazy(
    test_pl |>
      mutate(
        bar = 1,
        across(.cols = matches("^b"), \(x) x - 1)
      ),
    test_df |>
      mutate(
        bar = 1,
        across(.cols = matches("^b"), \(x) x - 1)
      )
  )

  expect_equal_lazy(
    test_pl |>
      mutate(
        bar = 1,
        across(.cols = everything(), \(x) x - 1)
      ),
    test_df |>
      mutate(
        bar = 1,
        across(.cols = everything(), \(x) x - 1)
      )
  )

  expect_equal_lazy(
    test_pl |>
      mutate(
        foo = 1,
        across(.cols = contains("oo"), \(x) x - 1)
      ),
    test_df |>
      mutate(
        foo = 1,
        across(.cols = contains("oo"), \(x) x - 1)
      )
  )

  expect_warning(
    test_pl |>
      mutate(
        foo = 1,
        across(.cols = where(is.numeric), \(x) x - 1)
      ),
    "will not take into account"
  )
})

test_that("need to specify .cols (either named or unnamed)", {
  test_df <- as_tibble(head(mtcars))
  test_pl <- as_polars_lf(test_df)

  expect_snapshot_lazy(
    mutate(test_pl, across(.fns = mean)),
    error = TRUE
  )
})

test_that(".by works with across() and everything()", {
  test_df <- head(mtcars, n = 5)
  test_pl <- as_polars_lf(test_df)
  out <- test_pl |>
    summarize(across(everything(), .fns = mean), .by = "cyl") |>
    distinct() |>
    arrange(cyl)

  expected <- test_df |>
    summarize(across(everything(), .fns = mean), .by = "cyl") |>
    distinct() |>
    arrange(cyl)

  expect_equal_lazy(
    out |> pull(cyl),
    expected |> pull(cyl)
  )

  expect_equal_lazy(
    out |> pull(hp),
    expected |> pull(hp)
  )
})

test_that("cannot use external list of functions in across()", {
  test_df <- as_tibble(head(mtcars))
  test_pl <- as_polars_lf(test_df)
  my_fns <- list(my_mean = mean, my_median = median)

  expect_snapshot_lazy(
    mutate(
      test_pl,
      across(.cols = mpg, .fns = my_fns)
    ),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
