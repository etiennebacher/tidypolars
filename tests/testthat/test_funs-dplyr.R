test_that("n_distinct() works", {
  test <- polars::pl$DataFrame(x = c("a", "a", "b", "b"), y = c(1:3, NA))

  expect_snapshot(
    test |> summarize(foo = n_distinct()),
    error = TRUE
  )

  expect_equal(
    test |>
      summarize(foo = n_distinct(y)) |>
      pull(foo),
    4
  )

  expect_equal(
    test |>
      summarize(foo = n_distinct(y, na.rm = TRUE)) |>
      pull(foo),
    3
  )

  expect_equal(
    test |>
      summarize(foo = n_distinct(y, x)) |>
      pull(foo),
    4
  )

  expect_equal(
    test |>
      summarize(foo = n_distinct(y, x, na.rm = TRUE)) |>
      pull(foo),
    3
  )

  expect_equal(
    test |>
      summarize(foo = n_distinct(y), .by = x) |>
      pull(foo),
    c(2, 2)
  )

  expect_equal(
    test |>
      summarize(foo = n_distinct(y, na.rm = TRUE), .by = x) |>
      pull(foo) |>
      sort(),
    c(1, 2)
  )
})


test_that("consecutive_id() works", {
  test <- polars::pl$DataFrame(
    x = c(3, 1, 2, 2, NA),
    y = c(2, 2, 4, 4, 4),
    grp = c("A", "A", "A", "B", "B")
  )

  expect_equal(
    test |>
      mutate(foo = consecutive_id(x)) |>
      pull(foo),
    c(1, 2, 3, 3, 4)
  )

  expect_equal(
    test |>
      mutate(foo = consecutive_id(x, y)) |>
      pull(foo),
    c(1, 2, 3, 3, 4)
  )

  expect_equal(
    test |>
      mutate(foo = consecutive_id(x), .by = grp) |>
      pull(foo),
    c(1, 2, 3, 1, 2)
  )
})

test_that("first() works", {
  test <- polars::pl$DataFrame(
    x = c(3, 1, 2, 2, NA),
    grp = c("A", "A", "A", "B", "B")
  )

  expect_equal(
    test |>
      summarize(foo = first(x)) |>
      pull(foo),
    3
  )

  expect_equal(
    test |>
      summarize(foo = first(x), .by = grp) |>
      pull(foo) |>
      sort(),
    c(2, 3)
  )

  expect_warning(
    test |>
      summarize(foo = first(x, order_by = "bar")),
    "doesn't know how to use some arguments"
  )
})

test_that("last() works", {
  test <- polars::pl$DataFrame(
    x = c(3, 1, 2, 2, NA),
    grp = c("A", "A", "A", "B", "B")
  )

  expect_equal(
    test |>
      summarize(foo = last(x)) |>
      pull(foo),
    NA_real_
  )

  expect_equal(
    test |>
      summarize(foo = last(x), .by = grp) |>
      pull(foo) |>
      sort(na.last = TRUE),
    c(2, NA)
  )

  expect_warning(
    test |>
      summarize(foo = last(x, order_by = "bar")),
    "doesn't know how to use some arguments"
  )
})

test_that("nth() work", {
  test <- polars::pl$DataFrame(
    x = c(3, 1, 2, 2, NA),
    idx = 1:5,
    grp = c("A", "A", "A", "B", "B")
  )

  expect_equal(
    test |>
      summarize(foo = nth(x, 2)) |>
      pull(foo),
    1
  )

  expect_equal(
    test |>
      summarize(foo = nth(x, -1)) |>
      pull(foo),
    NA_real_
  )

  # TODO: Requires null_on_oob argument in gather/get
  # https://github.com/pola-rs/polars/issues/15240
  # expect_equal(
  #   test |>
  #     summarize(foo = nth(x, 1000)) |>
  #     pull(foo),
  #   NA_real_
  # )

  expect_snapshot(
    test |> summarize(foo = nth(x, 2:3)),
    error = TRUE
  )
  expect_snapshot(
    test |> summarize(foo = nth(x, NA)),
    error = TRUE
  )
  expect_snapshot(
    test |> summarize(foo = nth(x, 1.5)),
    error = TRUE
  )
})

test_that("na_if() works", {
  test <- polars::pl$DataFrame(
    x = c(3, 1, 2, 2, 3),
    grp = c("A", "A", "A", "B", "")
  )

  expect_equal(
    test |>
      mutate(foo = na_if(x, 3)) |>
      pull(foo),
    c(NA, 1, 2, 2, NA)
  )

  expect_equal(
    test |>
      mutate(foo = na_if(x, 3), .by = grp) |>
      pull(foo),
    c(NA, 1, 2, 2, NA)
  )

  expect_equal(
    test |>
      mutate(foo = na_if(grp, "")) |>
      pull(foo),
    c("A", "A", "A", "B", NA)
  )

  expect_equal(
    test |>
      mutate(foo = na_if(x, c(3, 1, 1, 1, 1))) |>
      pull(foo),
    c(NA, NA, 2, 2, 3)
  )

  expect_snapshot(
    test |> mutate(foo = na_if(x, 1:2)),
    error = TRUE
  )

  expect_equal(
    test |>
      mutate(foo = na_if(x, NA)) |>
      pull(foo),
    c(3, 1, 2, 2, 3)
  )

  expect_equal(
    test |>
      mutate(foo = na_if(x, c(NA, 1, 1, 1, 1))) |>
      pull(foo),
    c(3, NA, 2, 2, 3)
  )
})

test_that("min_rank() works", {
  test <- polars::pl$DataFrame(
    x = c(5, 1, 3, 2, 2, NA),
    y = c(rep(NA, 5), 1)
  )

  expect_equal(
    test |>
      mutate(foo = min_rank(x)) |>
      pull(foo),
    c(5, 1, 4, 2, 2, NA)
  )

  expect_equal(
    test |>
      mutate(foo = min_rank(y)) |>
      pull(foo),
    c(rep(NA, 5), 1)
  )
})

test_that("dense_rank() works", {
  test <- polars::pl$DataFrame(
    x = c(5, 1, 3, 2, 2, NA),
    y = c(rep(NA, 5), 1)
  )

  expect_equal(
    test |>
      mutate(foo = dense_rank(x)) |>
      pull(foo),
    c(4, 1, 3, 2, 2, NA)
  )

  expect_equal(
    test |>
      mutate(foo = dense_rank(y)) |>
      pull(foo),
    c(rep(NA, 5), 1)
  )

  test2 <- polars::pl$DataFrame(x = numeric(0), y = numeric(0))

  expect_dim(
    test2 |> mutate(foo = dense_rank(x)),
    c(0, 3)
  )
})

test_that("row_number() works", {
  test <- polars::pl$DataFrame(
    x = c(5, 1, 3, 2, 2, NA),
    y = c(rep(NA, 5), 1)
  )

  expect_equal(
    test |>
      mutate(foo = row_number(x)) |>
      pull(foo),
    c(5, 1, 4, 2, 3, NA)
  )

  expect_equal(
    test |>
      mutate(foo = row_number(y)) |>
      pull(foo),
    c(rep(NA, 5), 1)
  )

  expect_equal(
    test |>
      mutate(foo = row_number()) |>
      pull(foo),
    1:6
  )

  test2 <- polars::pl$DataFrame(
    grp = c(1, 1, 1, 2, 2, 2, 3, 3, 3),
    x = c(3, 2, 1, 1, 2, 2, 1, 1, 1)
  )

  expect_equal(
    test2 |>
      group_by(grp) |>
      filter(row_number(x) == 1) |>
      pull(x),
    rep(1, 3)
  )

  expect_equal(
    test2 |>
      group_by(grp) |>
      filter(min_rank(x) == 1) |>
      pull(x),
    rep(1, 5)
  )

  expect_equal(
    test2 |>
      group_by(grp) |>
      mutate(foo = row_number()) |>
      pull(foo),
    rep(1:3, 3)
  )

  test3 <- polars::pl$DataFrame(x = numeric(0), y = numeric(0))

  expect_dim(
    test3 |> mutate(foo = row_number()),
    c(0, 3)
  )

  # row_number with random values and aggregation based on row index just to be sure

  set.seed(123)
  test4 <- polars::pl$DataFrame(
    grp = sample.int(5, 10, replace = TRUE),
    val = 1:10
  )

  expect_equal(
    test4 |>
      mutate(rn = row_number(), .by = grp) |>
      summarize(foo = sum(val), .by = rn) |>
      arrange(rn) |>
      as_tibble(),
    test4 |>
      as_tibble() |>
      mutate(rn = row_number(), .by = grp) |>
      summarize(foo = sum(val), .by = rn),
    ignore_attr = TRUE
  )
})


test_that("dplyr::lag() works", {
  dat <- tibble(
    g = c(1, 1, 1, 1, 2, 2, 2, 2),
    t = c(1, 2, 3, 4, 4, 1, 2, 3),
    x = c(10, 20, 30, 40, 10, 20, 30, 40)
  )
  # Need to explicitly namespace this because there is no pl_lag(). Without
  # namespace it works fine in interactive mode but not via devtools::test().
  expect_equal(
    dat |>
      as_polars_df() |>
      mutate(x_lag = dplyr::lag(x, order_by = t), .by = g),
    dat |>
      mutate(x_lag = dplyr::lag(x, order_by = t), .by = g)
  )
  expect_equal(
    dat |>
      as_polars_df() |>
      mutate(x_lag = dplyr::lag(x, order_by = t, n = 2), .by = g),
    dat |>
      mutate(x_lag = dplyr::lag(x, order_by = t, n = 2), .by = g)
  )

  # With one group only
  dat <- tibble(
    g = c(1, 1, 1, 1),
    t = c(1, 2, 3, 4),
    x = c(10, 20, 30, 40)
  )
  expect_equal(
    dat |>
      as_polars_df() |>
      mutate(x_lag = dplyr::lag(x, order_by = t), .by = g),
    dat |>
      mutate(x_lag = dplyr::lag(x, order_by = t), .by = g)
  )

  # fill NA
  dat <- tibble(
    g = c(1, 1, 1, 1, 2),
    t = c(1, 2, 3, 4, 5),
    x = c(10, 20, 30, 40, 50)
  )
  expect_equal(
    dat |>
      as_polars_df() |>
      mutate(x_lag = dplyr::lag(x, order_by = t, default = 99), .by = g),
    dat |>
      mutate(x_lag = dplyr::lag(x, order_by = t, default = 99), .by = g)
  )
})

test_that("dplyr::lead() works", {
  dat <- tibble(
    g = c(1, 1, 1, 1, 2, 2, 2, 2),
    t = c(1, 2, 3, 4, 4, 1, 2, 3),
    x = c(10, 20, 30, 40, 10, 20, 30, 40)
  )
  expect_equal(
    dat |>
      as_polars_df() |>
      mutate(x_lead = lead(x, order_by = t), .by = g),
    dat |>
      mutate(x_lead = lead(x, order_by = t), .by = g)
  )
  expect_equal(
    dat |>
      as_polars_df() |>
      mutate(x_lead = lead(x, order_by = t, n = 2), .by = g),
    dat |>
      mutate(x_lead = lead(x, order_by = t, n = 2), .by = g)
  )

  # With one group only
  dat <- tibble(
    g = c(1, 1, 1, 1),
    t = c(1, 2, 3, 4),
    x = c(10, 20, 30, 40)
  )
  expect_equal(
    dat |>
      as_polars_df() |>
      mutate(x_lead = lead(x, order_by = t), .by = g),
    dat |>
      mutate(x_lead = lead(x, order_by = t), .by = g)
  )

  # fill NA
  dat <- tibble(
    g = c(1, 1, 1, 1, 2),
    t = c(1, 2, 3, 4, 5),
    x = c(10, 20, 30, 40, 50)
  )
  expect_equal(
    dat |>
      as_polars_df() |>
      mutate(x_lead = lead(x, order_by = t, default = 99), .by = g),
    dat |>
      mutate(x_lead = lead(x, order_by = t, default = 99), .by = g)
  )
})

test_that("near() works", {
  dat <- tibble(
    x = c(sqrt(2)^2, 0.1, NA),
    y = c(2, 0.2, 1)
  )
  dat_pl <- as_polars_df(dat)

  expect_equal(
    dat_pl |> mutate(z = near(x, y)),
    dat |> mutate(z = near(x, y))
  )
  expect_equal(
    dat_pl |> mutate(z = near(x, 2)),
    dat |> mutate(z = near(x, 2))
  )
  expect_equal(
    dat_pl |> mutate(z = near(x, y, tol = 0.01)),
    dat |> mutate(z = near(x, y, tol = 0.01))
  )
  expect_equal(
    dat_pl |> mutate(z = near(x, y, tol = NA)),
    dat |> mutate(z = near(x, y, tol = NA))
  )
  # tidyverse doesn't error because of different lengths, but I think it's better
  # to do (don't really know how I'd prevent this error anyway).
  expect_snapshot(
    dat_pl |> mutate(z = near(x, 1:2)),
    error = TRUE
  )
})
