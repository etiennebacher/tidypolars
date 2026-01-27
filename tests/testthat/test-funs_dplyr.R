test_that("n_distinct() works", {
  test <- tibble(x = c("a", "a", "b", "b"), y = c(1:3, NA))
  test_pl <- as_polars_df(test)

  expect_both_error(
    test_pl |> summarize(foo = n_distinct()),
    test |> summarize(foo = n_distinct())
  )
  expect_snapshot(
    test_pl |> summarize(foo = n_distinct()),
    error = TRUE
  )

  expect_equal(
    test_pl |> summarize(foo = n_distinct(y)),
    test |> summarize(foo = n_distinct(y))
  )

  expect_equal(
    test_pl |> summarize(foo = n_distinct(y, na.rm = TRUE)),
    test |> summarize(foo = n_distinct(y, na.rm = TRUE))
  )

  expect_equal(
    test_pl |> summarize(foo = n_distinct(y, x)),
    test |> summarize(foo = n_distinct(y, x))
  )

  expect_equal(
    test_pl |> summarize(foo = n_distinct(y, x, na.rm = TRUE)),
    test |> summarize(foo = n_distinct(y, x, na.rm = TRUE))
  )

  # Need to sort because unstable group order in polars
  expect_equal(
    test_pl |>
      summarize(foo = n_distinct(y), .by = x) |>
      arrange(x),
    test |> summarize(foo = n_distinct(y), .by = x)
  )

  # Need to sort because unstable group order in polars
  expect_equal(
    test_pl |>
      summarize(foo = n_distinct(y, na.rm = TRUE), .by = x) |>
      arrange(x),
    test |> summarize(foo = n_distinct(y, na.rm = TRUE), .by = x)
  )
})


test_that("consecutive_id() works", {
  test <- tibble(
    x = c(3, 1, 2, 2, NA),
    y = c(2, 2, 4, 4, 4),
    grp = c("A", "A", "A", "B", "B")
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(foo = consecutive_id(x)),
    test |> mutate(foo = consecutive_id(x))
  )

  expect_equal(
    test_pl |> mutate(foo = consecutive_id(x, y)),
    test |> mutate(foo = consecutive_id(x, y))
  )

  expect_equal(
    test_pl |> mutate(foo = consecutive_id(x), .by = grp),
    test |> mutate(foo = consecutive_id(x), .by = grp)
  )
})

test_that("first() works", {
  test <- tibble(
    x = c(3, 1, 2, 2, NA),
    grp = c("A", "A", "A", "B", "B")
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> summarize(foo = first(x)),
    test |> summarize(foo = first(x))
  )

  # Need to sort because unstable group order in polars
  expect_equal(
    test_pl |> summarize(foo = first(x), .by = grp) |> arrange(grp),
    test |> summarize(foo = first(x), .by = grp)
  )

  expect_warning(
    test_pl |> summarize(foo = first(x, order_by = "bar")),
    "doesn't know how to use some arguments"
  )
})

test_that("last() works", {
  test <- tibble(
    x = c(3, 1, 2, 2, NA),
    grp = c("A", "A", "A", "B", "B")
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> summarize(foo = last(x)),
    test |> summarize(foo = last(x))
  )

  # Need to sort because unstable group order in polars
  expect_equal(
    test_pl |> summarize(foo = last(x), .by = grp) |> arrange(grp),
    test |> summarize(foo = last(x), .by = grp)
  )

  expect_warning(
    test_pl |> summarize(foo = last(x, order_by = "bar")),
    "doesn't know how to use some arguments"
  )
})

test_that("nth() work", {
  test <- tibble(
    x = c(3, 1, 2, 2, NA),
    idx = 1:5,
    grp = c("A", "A", "A", "B", "B")
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> summarize(foo = nth(x, 2)),
    test |> summarize(foo = nth(x, 2))
  )

  expect_equal(
    test_pl |> summarize(foo = nth(x, -1)),
    test |> summarize(foo = nth(x, -1))
  )

  # TODO: Requires null_on_oob argument in gather/get
  # https://github.com/pola-rs/polars/issues/15240
  # expect_equal(
  #   test_pl |>
  #     summarize(foo = nth(x, 1000)),
  #   test |>
  #     summarize(foo = nth(x, 1000))
  # )

  expect_both_error(
    test_pl |> summarize(foo = nth(x, 2:3)),
    test |> summarize(foo = nth(x, 2:3))
  )
  expect_snapshot(
    test_pl |> summarize(foo = nth(x, 2:3)),
    error = TRUE
  )
  expect_both_error(
    test_pl |> summarize(foo = nth(x, NA)),
    test |> summarize(foo = nth(x, NA))
  )
  expect_snapshot(
    test_pl |> summarize(foo = nth(x, NA)),
    error = TRUE
  )
  expect_both_error(
    test_pl |> summarize(foo = nth(x, 1.5)),
    test |> summarize(foo = nth(x, 1.5))
  )
  expect_snapshot(
    test_pl |> summarize(foo = nth(x, 1.5)),
    error = TRUE
  )
})

test_that("na_if() works", {
  test <- tibble(
    x = c(3, 1, 2, 2, 3),
    grp = c("A", "A", "A", "B", "")
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(foo = na_if(x, 3)),
    test |> mutate(foo = na_if(x, 3))
  )

  expect_equal(
    test_pl |> mutate(foo = na_if(x, 3), .by = grp),
    test |> mutate(foo = na_if(x, 3), .by = grp)
  )

  expect_equal(
    test_pl |> mutate(foo = na_if(grp, "")),
    test |> mutate(foo = na_if(grp, ""))
  )

  expect_equal(
    test_pl |> mutate(foo = na_if(x, c(3, 1, 1, 1, 1))),
    test |> mutate(foo = na_if(x, c(3, 1, 1, 1, 1)))
  )

  expect_both_error(
    test_pl |> mutate(foo = na_if(x, 1:2)),
    test |> mutate(foo = na_if(x, 1:2))
  )
  expect_snapshot(
    test_pl |> mutate(foo = na_if(x, 1:2)),
    error = TRUE
  )

  expect_equal(
    test_pl |> mutate(foo = na_if(x, NA)),
    test |> mutate(foo = na_if(x, NA))
  )

  expect_equal(
    test_pl |> mutate(foo = na_if(x, c(NA, 1, 1, 1, 1))),
    test |> mutate(foo = na_if(x, c(NA, 1, 1, 1, 1)))
  )
})

test_that("min_rank() works", {
  test <- tibble(
    x = c(5, 1, 3, 2, 2, NA),
    y = c(rep(NA, 5), 1)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(foo = min_rank(x)),
    test |> mutate(foo = min_rank(x))
  )

  expect_equal(
    test_pl |> mutate(foo = min_rank(y)),
    test |> mutate(foo = min_rank(y))
  )
})

test_that("dense_rank() works", {
  test <- tibble(
    x = c(5, 1, 3, 2, 2, NA),
    y = c(rep(NA, 5), 1)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(foo = dense_rank(x)),
    test |> mutate(foo = dense_rank(x))
  )

  expect_equal(
    test_pl |> mutate(foo = dense_rank(y)),
    test |> mutate(foo = dense_rank(y))
  )

  test <- tibble(x = numeric(0), y = numeric(0))
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(foo = dense_rank(x)),
    test |> mutate(foo = dense_rank(x))
  )
})

test_that("row_number() works", {
  test <- tibble(
    x = c(5, 1, 3, 2, 2, NA),
    y = c(rep(NA, 5), 1)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(foo = row_number(x)),
    test |> mutate(foo = row_number(x))
  )

  expect_equal(
    test_pl |> mutate(foo = row_number(y)),
    test |> mutate(foo = row_number(y))
  )

  expect_equal(
    test_pl |> mutate(foo = row_number()),
    test |> mutate(foo = row_number())
  )

  test <- tibble(
    grp = c(1, 1, 1, 2, 2, 2, 3, 3, 3),
    x = c(3, 2, 1, 1, 2, 2, 1, 1, 1)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> group_by(grp) |> filter(row_number(x) == 1),
    test |> group_by(grp) |> filter(row_number(x) == 1)
  )

  expect_equal(
    test_pl |> group_by(grp) |> filter(min_rank(x) == 1),
    test |> group_by(grp) |> filter(min_rank(x) == 1)
  )

  expect_equal(
    test_pl |> group_by(grp) |> mutate(foo = row_number()),
    test |> group_by(grp) |> mutate(foo = row_number())
  )

  test <- tibble(x = numeric(0), y = numeric(0))
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(foo = row_number()),
    test |> mutate(foo = row_number())
  )

  # row_number with random values and aggregation based on row index just to be sure

  set.seed(123)
  test <- tibble(
    grp = sample.int(5, 10, replace = TRUE),
    val = 1:10
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |>
      mutate(rn = row_number(), .by = grp) |>
      summarize(foo = sum(val), .by = rn) |>
      arrange(rn),
    test |>
      mutate(rn = row_number(), .by = grp) |>
      summarize(foo = sum(val), .by = rn) |>
      arrange(rn)
  )
})


test_that("dplyr::lag() works", {
  test <- tibble(
    g = c(1, 1, 1, 1, 2, 2, 2, 2),
    t = c(1, 2, 3, 4, 4, 1, 2, 3),
    x = c(10, 20, 30, 40, 10, 20, 30, 40)
  )
  test_pl <- as_polars_df(test)

  # Need to explicitly namespace this because there is no pl_lag(). Without
  # namespace it works fine in interactive mode but not via devtools::test().
  expect_equal(
    test_pl |> mutate(x_lag = dplyr::lag(x, order_by = t), .by = g),
    test |> mutate(x_lag = dplyr::lag(x, order_by = t), .by = g)
  )
  expect_equal(
    test_pl |> mutate(x_lag = dplyr::lag(x, order_by = t, n = 2), .by = g),
    test |> mutate(x_lag = dplyr::lag(x, order_by = t, n = 2), .by = g)
  )

  # With one group only
  test <- tibble(
    g = c(1, 1, 1, 1),
    t = c(1, 2, 3, 4),
    x = c(10, 20, 30, 40)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(x_lag = dplyr::lag(x, order_by = t), .by = g),
    test |> mutate(x_lag = dplyr::lag(x, order_by = t), .by = g)
  )

  # fill NA
  test <- tibble(
    g = c(1, 1, 1, 1, 2),
    t = c(1, 2, 3, 4, 5),
    x = c(10, 20, 30, 40, 50)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |>
      mutate(x_lag = dplyr::lag(x, order_by = t, default = 99), .by = g),
    test |> mutate(x_lag = dplyr::lag(x, order_by = t, default = 99), .by = g)
  )
})

test_that("dplyr::lead() works", {
  test <- tibble(
    g = c(1, 1, 1, 1, 2, 2, 2, 2),
    t = c(1, 2, 3, 4, 4, 1, 2, 3),
    x = c(10, 20, 30, 40, 10, 20, 30, 40)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(x_lead = lead(x, order_by = t), .by = g),
    test |> mutate(x_lead = lead(x, order_by = t), .by = g)
  )
  expect_equal(
    test_pl |> mutate(x_lead = lead(x, order_by = t, n = 2), .by = g),
    test |> mutate(x_lead = lead(x, order_by = t, n = 2), .by = g)
  )

  # With one group only
  test <- tibble(
    g = c(1, 1, 1, 1),
    t = c(1, 2, 3, 4),
    x = c(10, 20, 30, 40)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(x_lead = lead(x, order_by = t), .by = g),
    test |> mutate(x_lead = lead(x, order_by = t), .by = g)
  )

  # fill NA
  test <- tibble(
    g = c(1, 1, 1, 1, 2),
    t = c(1, 2, 3, 4, 5),
    x = c(10, 20, 30, 40, 50)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(x_lead = lead(x, order_by = t, default = 99), .by = g),
    test |> mutate(x_lead = lead(x, order_by = t, default = 99), .by = g)
  )
})

test_that("near() works", {
  test <- tibble(
    x = c(sqrt(2)^2, 0.1, NA),
    y = c(2, 0.2, 1)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |> mutate(z = near(x, y)),
    test |> mutate(z = near(x, y))
  )
  expect_equal(
    test_pl |> mutate(z = near(x, 2)),
    test |> mutate(z = near(x, 2))
  )
  expect_equal(
    test_pl |> mutate(z = near(x, y, tol = 0.01)),
    test |> mutate(z = near(x, y, tol = 0.01))
  )
  expect_equal(
    test_pl |> mutate(z = near(x, y, tol = NA)),
    test |> mutate(z = near(x, y, tol = NA))
  )
  # tidyverse doesn't error because of different lengths, but I think it's better
  # to do (don't really know how I'd prevent this error anyway).
  # tidypolars-specific error
  expect_snapshot(
    test_pl |> mutate(z = near(x, 1:2)),
    error = TRUE
  )
})

test_that("replace_when(): basic usage", {
  # TODO: this should work when `type` is a factor, see examples in dplyr docs
  dat <- tibble(
    name = c("Max", "Bella", "Chuck", "Luna", "Cooper"),
    type = c("dog", "dog", "cat", "dog", "cat"),
    age = c(1, 3, 5, 2, 4)
  )
  dat_pl <- as_polars_df(dat)

  expect_equal(
    dat_pl |>
      mutate(y = replace_when(type, type == "dog" & age <= 2 ~ "puppy")),
    dat |>
      mutate(y = replace_when(type, type == "dog" & age <= 2 ~ "puppy"))
  )
})

test_that("replace_when() errors if cannot preserve type", {
  dat <- tibble(
    name = c("Max", "Bella", "Chuck", "Luna", "Cooper"),
    type = factor(
      c("dog", "dog", "cat", "dog", "cat"),
      levels = c("dog", "cat", "puppy")
    ),
    age = c(1, 3, 5, 2, 4)
  )
  dat_pl <- as_polars_df(dat)

  expect_both_error(
    dat_pl |>
      mutate(y = replace_when(type, type == "dog" & age <= 2 ~ 1)),
    dat |>
      mutate(y = replace_when(type, type == "dog" & age <= 2 ~ 1))
  )
  # TODO: tidyverse errors here, which is better I think
  # expect_both_error(
  #   dat_pl |>
  #     mutate(y = replace_when(name, name == "Max" ~ 1)),
  #   dat |>
  #     mutate(y = replace_when(name, name == "Max" ~ 1))
  # )
})

test_that("replace_when(): corner cases", {
  dat <- tibble(
    name = c("Max", "Bella", "Chuck", "Luna", "Cooper"),
    type = factor(
      c("dog", "dog", "cat", "dog", "cat"),
      levels = c("dog", "cat", "puppy")
    ),
    age = c(1, 3, 5, 2, 4)
  )
  dat_pl <- as_polars_df(dat)

  expect_both_error(
    dat_pl |>
      mutate(y = replace_when(type, type == "dog" ~ character(0))),
    dat |>
      mutate(y = replace_when(type, type == "dog" ~ character(0)))
  )
  expect_both_error(
    dat_pl |>
      mutate(y = replace_when(type, type == "dog" ~ NULL)),
    dat |>
      mutate(y = replace_when(type, type == "dog" ~ NULL))
  )
  expect_both_error(
    dat_pl |>
      mutate(y = replace_when(type, type == "dog" ~ c("a", "b"))),
    dat |>
      mutate(y = replace_when(type, type == "dog" ~ c("a", "b")))
  )
  expect_both_error(
    dat_pl |>
      mutate(y = replace_when(type, logical(0) ~ "a")),
    dat |>
      mutate(y = replace_when(type, logical(0) ~ "a"))
  )
  expect_both_error(
    dat_pl |>
      mutate(y = replace_when(type, NULL ~ "a")),
    dat |>
      mutate(y = replace_when(type, NULL ~ "a"))
  )
})


test_that("dplyr::when_all() and dplyr::when_any() work", {
  dat <- tibble(
    x = c(TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, NA, NA, NA),
    y = c(TRUE, FALSE, NA, TRUE, FALSE, NA, TRUE, FALSE, NA)
  )
  dat_pl <- as_polars_df(dat)

  expect_equal(
    dat_pl |>
      mutate(
        any_propagate = when_any(x, y),
        all_propagate = when_all(x, y),
      ),
    dat |>
      mutate(
        any_propagate = when_any(x, y),
        all_propagate = when_all(x, y),
      )
  )

  expect_snapshot(
    dat_pl |> mutate(any_propagate = when_any(x, y, na_rm = TRUE)),
    error = TRUE
  )
  expect_snapshot(
    dat_pl |> mutate(any_propagate = when_any(x, y, size = TRUE)),
    error = TRUE
  )

  expect_snapshot(
    dat_pl |> mutate(all_propagate = when_all(x, y, na_rm = TRUE)),
    error = TRUE
  )
  expect_snapshot(
    dat_pl |> mutate(all_propagate = when_all(x, y, size = TRUE)),
    error = TRUE
  )

  # From dplyr examples, just to be sure it works fine
  countries <- tibble(
    name = c("US", "CA", "PR", "RU", "US", NA, "CA", "PR", "RU"),
    score = c(200, 100, 150, NA, 50, 100, 300, 250, 120)
  )
  countries_pl <- as_polars_df(countries)

  expect_equal(
    countries_pl |>
      filter(when_any(
        name %in% c("US", "CA") & between(score, 200, 300),
        name %in% c("PR", "RU") & between(score, 100, 200)
      )),
    countries |>
      as_polars_df() |>
      filter(when_any(
        name %in% c("US", "CA") & between(score, 200, 300),
        name %in% c("PR", "RU") & between(score, 100, 200)
      ))
  )
})

test_that("replace_values(): basic usage", {
  dat <- tibble(x = c("NC", "NYC", "CA", NA, "NYC", "Unknown"))
  dat_pl <- as_polars_df(dat)

  expect_equal(
    dat_pl |>
      mutate(y = replace_values(x, "NYC" ~ "NY", "Unknown" ~ "a")),
    dat |>
      mutate(y = replace_values(x, "NYC" ~ "NY", "Unknown" ~ "a"))
  )
  expect_equal(
    dat_pl |>
      mutate(
        y = replace_values(x, from = c("NYC", "Unknown"), to = c("NY", "a"))
      ),
    dat |>
      mutate(
        y = replace_values(x, from = c("NYC", "Unknown"), to = c("NY", "a"))
      )
  )

  # broadcasting
  expect_equal(
    dat_pl |>
      mutate(y = replace_values(x, from = c("NYC", "Unknown"), to = "a")),
    dat |>
      mutate(y = replace_values(x, from = c("NYC", "Unknown"), to = "a"))
  )

  # basic errors
  expect_snapshot(
    mutate(dat_pl, y = replace_values(x, "NYC" ~ "NY", from = "a")),
    error = TRUE
  )
  expect_snapshot(
    mutate(dat_pl, y = replace_values(x, "NYC" ~ "NY", to = "a")),
    error = TRUE
  )
  expect_snapshot(
    mutate(dat_pl, y = replace_values(x, from = "a")),
    error = TRUE
  )
  expect_snapshot(
    mutate(dat_pl, y = replace_values(x, to = "a")),
    error = TRUE
  )
})

test_that("replace_values(): corner cases", {
  dat <- tibble(x = c("NC", "NYC", "CA", NA, "NYC", "Unknown"))
  dat_pl <- as_polars_df(dat)

  # TODO: this errors with tidyverse, which I think is more helpful
  # expect_both_error(
  #   dat_pl |>
  #     mutate(y = replace_values(x, "NYC" ~ 1)),
  #   dat |>
  #     mutate(y = replace_values(x, "NYC" ~ 1))
  # )
  # expect_both_error(
  #   dat_pl |>
  #     mutate(y = replace_values(x, 1 ~ "NYC")),
  #   dat |>
  #     mutate(y = replace_values(x, 1 ~ "NYC"))
  # )

  expect_equal(
    dat_pl |>
      mutate(y = replace_values(x, "NYC" ~ NA)),
    dat |>
      mutate(y = replace_values(x, "NYC" ~ NA))
  )
  expect_both_error(
    dat_pl |>
      mutate(y = replace_values(x, "NYC" ~ NULL)),
    dat |>
      mutate(y = replace_values(x, "NYC" ~ NULL))
  )
  expect_both_error(
    dat_pl |>
      mutate(y = replace_values(x, NULL ~ "NYC")),
    dat |>
      mutate(y = replace_values(x, NULL ~ "NYC"))
  )
  expect_both_error(
    dat_pl |>
      mutate(y = replace_values(x, "NYC" ~ character(0))),
    dat |>
      mutate(y = replace_values(x, "NYC" ~ character(0)))
  )
  # TODO: tidypolars errors here, not tidyverse, so less impact.
  # expect_both_error(
  #   dat_pl |>
  #     mutate(y = replace_values(x, character(0) ~ "NYC")),
  #   dat |>
  #     mutate(y = replace_values(x, character(0) ~ "NYC"))
  # )
  expect_both_error(
    dat_pl |>
      mutate(y = replace_values(x, "NYC" ~ "NY", 1)),
    dat |>
      mutate(y = replace_values(x, "NYC" ~ "NY", 1))
  )
  expect_both_error(
    dat_pl |>
      mutate(
        y = replace_values(
          x,
          from = c("NYC", "CA", "Unknown"),
          to = c("a", "b")
        )
      ),
    dat |>
      mutate(
        y = replace_values(
          x,
          from = c("NYC", "CA", "Unknown"),
          to = c("a", "b")
        )
      )
  )
})

test_that("recode_values(): basic usage", {
  dat <- tibble(x = c("NC", "NYC", "CA", NA, "NYC", "Unknown"))
  dat_pl <- as_polars_df(dat)

  # basic usage
  expect_equal(
    dat_pl |>
      mutate(y = recode_values(x, "NYC" ~ "NY", "Unknown" ~ "a")),
    dat |>
      mutate(y = recode_values(x, "NYC" ~ "NY", "Unknown" ~ "a"))
  )
  expect_equal(
    dat_pl |>
      mutate(
        y = recode_values(x, from = c("NYC", "Unknown"), to = c("NY", "a"))
      ),
    dat |>
      mutate(
        y = recode_values(x, from = c("NYC", "Unknown"), to = c("NY", "a"))
      )
  )
  expect_equal(
    dat_pl |>
      mutate(
        y = recode_values(x, "NYC" ~ "NY", "Unknown" ~ "a", default = "foo")
      ),
    dat |>
      mutate(
        y = recode_values(x, "NYC" ~ "NY", "Unknown" ~ "a", default = "foo")
      )
  )
  expect_equal(
    dat_pl |>
      mutate(
        y = recode_values(
          x,
          from = c("NYC", "Unknown"),
          to = c("NY", "a"),
          default = "foo"
        )
      ),
    dat |>
      mutate(
        y = recode_values(
          x,
          from = c("NYC", "Unknown"),
          to = c("NY", "a"),
          default = "foo"
        )
      )
  )

  # broadcasting
  expect_equal(
    dat_pl |>
      mutate(y = recode_values(x, from = c("NYC", "Unknown"), to = "a")),
    dat |>
      mutate(y = recode_values(x, from = c("NYC", "Unknown"), to = "a"))
  )

  expect_snapshot(
    mutate(dat_pl, y = recode_values(x, "NYC" ~ "NY", from = "a")),
    error = TRUE
  )
  expect_snapshot(
    mutate(dat_pl, y = recode_values(x, "NYC" ~ "NY", to = "a")),
    error = TRUE
  )
  expect_snapshot(
    mutate(dat_pl, y = recode_values(x, from = "a")),
    error = TRUE
  )
  expect_snapshot(
    mutate(dat_pl, y = recode_values(x, to = "a")),
    error = TRUE
  )
})

test_that("recode_values(): errors and corner cases", {
  dat <- tibble(x = c("NC", "NYC", "CA", NA, "NYC", "Unknown"))
  dat_pl <- as_polars_df(dat)

  # TODO: this errors with tidyverse, which I think is more helpful
  # expect_both_error(
  #   dat_pl |>
  #     mutate(y = recode_values(x, "NYC" ~ 1)),
  #   dat |>
  #     mutate(y = recode_values(x, "NYC" ~ 1))
  # )
  # expect_both_error(
  #   dat_pl |>
  #     mutate(y = recode_values(x, 1 ~ "NYC")),
  #   dat |>
  #     mutate(y = recode_values(x, 1 ~ "NYC"))
  # )

  # corner cases on the LHS/RHS
  expect_equal(
    dat_pl |>
      mutate(y = recode_values(x, "NYC" ~ NA)),
    dat |>
      mutate(y = recode_values(x, "NYC" ~ NA))
  )
  expect_both_error(
    dat_pl |>
      mutate(y = recode_values(x, "NYC" ~ NULL)),
    dat |>
      mutate(y = recode_values(x, "NYC" ~ NULL))
  )
  expect_both_error(
    dat_pl |>
      mutate(y = recode_values(x, NULL ~ "NYC")),
    dat |>
      mutate(y = recode_values(x, NULL ~ "NYC"))
  )
  expect_both_error(
    dat_pl |>
      mutate(y = recode_values(x, "NYC" ~ character(0))),
    dat |>
      mutate(y = recode_values(x, "NYC" ~ character(0)))
  )
  # TODO: tidypolars errors here, not tidyverse, so less impact.
  # expect_both_error(
  #   dat_pl |>
  #     mutate(y = recode_values(x, character(0) ~ "NYC")),
  #   dat |>
  #     mutate(y = recode_values(x, character(0) ~ "NYC"))
  # )
  expect_both_error(
    dat_pl |>
      mutate(y = recode_values(x, "NYC" ~ "NY", 1)),
    dat |>
      mutate(y = recode_values(x, "NYC" ~ "NY", 1))
  )
  expect_both_error(
    dat_pl |>
      mutate(
        y = replace_values(
          x,
          from = c("NYC", "CA", "Unknown"),
          to = c("a", "b")
        )
      ),
    dat |>
      mutate(
        y = replace_values(
          x,
          from = c("NYC", "CA", "Unknown"),
          to = c("a", "b")
        )
      )
  )
})
