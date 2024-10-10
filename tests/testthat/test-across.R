test_that("single word functions work", {
  test <- polars::pl$DataFrame(head(mtcars))

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
})


test_that("purrr-style function work", {
  test <- polars::pl$DataFrame(head(mtcars))

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
})


test_that("anonymous functions has to return a Polars expression", {
  test <- polars::pl$DataFrame(head(mtcars))

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

  expect_snapshot(
    mutate(
      test,
      across(.cols = contains("a"), \(x) mean(x)),
    ),
    error = TRUE
  )
})


test_that("custom function works", {
  test <- polars::pl$DataFrame(head(mtcars))

  foo <- function(x) {
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
})

test_that("works with grouped data", {
  test <- polars::pl$DataFrame(head(mtcars))

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
})

test_that("argument .names works", {
  test <- polars::pl$DataFrame(head(mtcars))

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
})

test_that("passing a list of functions works", {
  test <- polars::pl$DataFrame(head(mtcars))

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
})


test_that("single variable in .cols, single function", {
  test <- polars::pl$DataFrame(head(mtcars))

  expect_equal(
    mutate(
      test,
      across(.cols = mpg, mean)
    ),
    mutate(test, mpg = mean(mpg))
  )
})

test_that("also works with summarize()", {
  test_grp <- polars::pl$DataFrame(head(mtcars)) |>
    group_by(cyl, maintain_order = TRUE)

  expect_equal(
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
})

test_that("sequence of expressions modifying the same vars works", {
  test <- polars::pl$DataFrame(head(mtcars)) |>
    mutate(
      across(contains("a"), mean),
      am = 1, gear = NULL
    )

  expect_equal(pull(test, am) |> unique(), 1)
  expect_colnames(test, setdiff(colnames(mtcars), "gear"))
})

#

test_that("newly created variable is captured in across", {
  test <- polars::pl$DataFrame(head(mtcars))

  expect_equal(
    test |>
      mutate(
        bar = 1,
        across(.cols = contains("a"), \(x) x - 1)
      ) |>
      pull(bar),
    rep(0, 6)
  )

  expect_equal(
    test |>
      mutate(
        bar = 1,
        across(.cols = starts_with("b"), \(x) x - 1)
      ) |>
      pull(bar),
    rep(0, 6)
  )

  expect_equal(
    test |>
      mutate(
        bar = 1,
        across(.cols = ends_with("r"), \(x) x - 1)
      ) |>
      pull(bar),
    rep(0, 6)
  )

  expect_equal(
    test |>
      mutate(
        bar = 1,
        across(.cols = matches("^b"), \(x) x - 1)
      ) |>
      pull(bar),
    rep(0, 6)
  )

  expect_equal(
    test |>
      mutate(
        bar = 1,
        across(.cols = everything(), \(x) x - 1)
      ) |>
      pull(bar),
    rep(0, 6)
  )

  expect_equal(
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
})

test_that("need to specify .cols (either named or unnamed)", {
  test <- polars::pl$DataFrame(head(mtcars))

  expect_snapshot(
    mutate(test, across(.fns = mean)),
    error = TRUE
  )
})

test_that(".by works with across() and everything()", {
  test <- mtcars |>
    head(n = 5) |>
    as_polars_df() |>
    summarize(across(everything(), .fns = mean), .by = "cyl") |>
    distinct() |>
    arrange(cyl)

  expect_equal(
    test |> pull(cyl),
    c(4, 6, 8)
  )

  expect_equal(
    test |> pull(hp),
    c(93, 110, 175)
  )
})

test_that("cannot use external list of functions in across()", {
  test <- polars::pl$DataFrame(head(mtcars))
  my_fns <- list(my_mean = mean, my_median = median)

  expect_snapshot(
    mutate(
      test,
      across(.cols = mpg, .fns = my_fns)
    ),
    error = TRUE
  )
})
