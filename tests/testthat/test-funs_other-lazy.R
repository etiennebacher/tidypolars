### [GENERATED AUTOMATICALLY] Update test-funs_other.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("which.min() and which.max() work", {
  test_df <- data.frame(
    x = c(1:4, 0:5, 11, 10),
    x_na = c(1:4, NA, 1:5, 11, 10),
    x_inf = c(1, Inf, 3:4, -Inf, 1:5, 11, 10)
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    test |>
      mutate(
        argmin = which.min(x),
        argmax = which.max(x),
        argmin_na = which.min(x_na),
        argmax_na = which.max(x_na),
        argmin_inf = which.min(x_inf),
        argmax_inf = which.max(x_inf)
      ),
    test_df |>
      mutate(
        argmin = which.min(x),
        argmax = which.max(x),
        argmin_na = which.min(x_na),
        argmax_na = which.max(x_na),
        argmin_inf = which.min(x_inf),
        argmax_inf = which.max(x_inf)
      )
  )
})

test_that("n_distinct() works", {
  test <- polars::pl$LazyFrame(x = c("a", "a", "b", "b"), y = c(1:3, NA))

  expect_snapshot_lazy(
    test |> summarize(foo = n_distinct()),
    error = TRUE
  )

  expect_equal_lazy(
    test |>
      summarize(foo = n_distinct(y)) |>
      pull(foo),
    4
  )

  expect_equal_lazy(
    test |>
      summarize(foo = n_distinct(y, na.rm = TRUE)) |>
      pull(foo),
    3
  )

  expect_equal_lazy(
    test |>
      summarize(foo = n_distinct(y, x)) |>
      pull(foo),
    4
  )

  expect_equal_lazy(
    test |>
      summarize(foo = n_distinct(y, x, na.rm = TRUE)) |>
      pull(foo),
    3
  )

  expect_equal_lazy(
    test |>
      summarize(foo = n_distinct(y), .by = x) |>
      pull(foo),
    c(2, 2)
  )

  expect_equal_lazy(
    test |>
      summarize(foo = n_distinct(y, na.rm = TRUE), .by = x) |>
      pull(foo) |>
      sort(),
    c(1, 2)
  )
})

test_that("length() works", {
  test <- polars::pl$LazyFrame(x = c("a", "a", "a", "b", "b"), y = c(1:4, NA))

  expect_equal_lazy(
    test |>
      mutate(foo = length(y)) |>
      pull(foo),
    rep(5, 5)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = length(y), .by = x) |>
      pull(foo),
    c(3, 3, 3, 2, 2)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = length(y), .by = c(x, y)) |>
      pull(foo),
    rep(1, 5)
  )
})

test_that("unique() works", {
  test <- polars::pl$LazyFrame(
    x = c("a", "a", "a", "b", "b"),
    y = c(2, 2, 3, 4, NA)
  )

  expect_snapshot_lazy(
    test |> mutate(foo = unique(y)),
    error = TRUE
  )

  expect_equal_lazy(
    test |>
      mutate(foo = length(unique(y))) |>
      pull(foo),
    rep(4, 5)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = length(unique(y)), .by = x) |>
      pull(foo),
    rep(2, 5)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = length(unique(y)), .by = c(x, y)) |>
      pull(foo),
    rep(1, 5)
  )
})

test_that("rev() works", {
  test <- polars::pl$LazyFrame(
    x = c("a", "a", "a", "b", "b"),
    y = c(2, 2, 3, 4, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = rev(y)) |>
      pull(foo),
    c(NA, 4, 3, 2, 2)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = rev(x)) |>
      pull(foo),
    c("b", "b", "a", "a", "a")
  )

  expect_equal_lazy(
    test |>
      mutate(foo = rev(y), .by = x) |>
      pull(foo),
    c(3, 2, 2, NA, 4)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = rev(y), .by = c(x, y)) |>
      pull(foo),
    c(2, 2, 3, 4, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = rev(y + 1), .by = x) |>
      pull(foo),
    c(4, 3, 3, NA, 5)
  )
})

test_that("all() works", {
  test <- polars::pl$LazyFrame(x = c(TRUE, FALSE, NA), y = c(TRUE, TRUE, NA))

  expect_equal_lazy(
    test |>
      mutate(foo = all(x)) |>
      pull(foo),
    # we know it's FALSE because there's one FALSE in x, so the na.rm arg is irrelevant
    c(FALSE, FALSE, FALSE)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = all(y)) |>
      pull(foo),
    c(NA, NA, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = all(y, na.rm = TRUE)) |>
      pull(foo),
    c(TRUE, TRUE, TRUE)
  )
})

test_that("any() works", {
  test <- polars::pl$LazyFrame(x = c(FALSE, FALSE, NA), y = c(TRUE, TRUE, NA))

  expect_equal_lazy(
    test |>
      mutate(foo = any(x)) |>
      pull(foo),
    c(NA, NA, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = any(x, na.rm = TRUE)) |>
      pull(foo),
    c(FALSE, FALSE, FALSE)
  )
})

test_that("round() works", {
  test <- polars::pl$LazyFrame(x = c(0.33, 0.5212))

  expect_equal_lazy(
    test |>
      mutate(foo = round(x)) |>
      pull(foo),
    c(0, 1)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = round(x, 1)) |>
      pull(foo),
    c(0.3, 0.5)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = round(x, 3)) |>
      pull(foo),
    c(0.33, 0.521)
  )
})

test_that("consecutive_id() works", {
  test <- polars::pl$LazyFrame(
    x = c(3, 1, 2, 2, NA),
    y = c(2, 2, 4, 4, 4),
    grp = c("A", "A", "A", "B", "B")
  )

  expect_equal_lazy(
    test |>
      mutate(foo = consecutive_id(x)) |>
      pull(foo),
    c(1, 2, 3, 3, 4)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = consecutive_id(x, y)) |>
      pull(foo),
    c(1, 2, 3, 3, 4)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = consecutive_id(x), .by = grp) |>
      pull(foo),
    c(1, 2, 3, 1, 2)
  )
})

test_that("first() works", {
  test <- polars::pl$LazyFrame(
    x = c(3, 1, 2, 2, NA),
    grp = c("A", "A", "A", "B", "B")
  )

  expect_equal_lazy(
    test |>
      summarize(foo = first(x)) |>
      pull(foo),
    3
  )

  expect_equal_lazy(
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
  test <- polars::pl$LazyFrame(
    x = c(3, 1, 2, 2, NA),
    grp = c("A", "A", "A", "B", "B")
  )

  expect_equal_lazy(
    test |>
      summarize(foo = last(x)) |>
      pull(foo),
    NA_real_
  )

  expect_equal_lazy(
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
  test <- polars::pl$LazyFrame(
    x = c(3, 1, 2, 2, NA),
    idx = 1:5,
    grp = c("A", "A", "A", "B", "B")
  )

  expect_equal_lazy(
    test |>
      summarize(foo = nth(x, 2)) |>
      pull(foo),
    1
  )

  expect_equal_lazy(
    test |>
      summarize(foo = nth(x, -1)) |>
      pull(foo),
    NA_real_
  )

  # TODO: Requires null_on_oob argument in gather/get
  # https://github.com/pola-rs/polars/issues/15240
  # expect_equal_lazy(
  #   test |>
  #     summarize(foo = nth(x, 1000)) |>
  #     pull(foo),
  #   NA_real_
  # )

  expect_snapshot_lazy(
    test |> summarize(foo = nth(x, 2:3)),
    error = TRUE
  )
  expect_snapshot_lazy(
    test |> summarize(foo = nth(x, NA)),
    error = TRUE
  )
  expect_snapshot_lazy(
    test |> summarize(foo = nth(x, 1.5)),
    error = TRUE
  )
})

test_that("na_if() works", {
  test <- polars::pl$LazyFrame(
    x = c(3, 1, 2, 2, 3),
    grp = c("A", "A", "A", "B", "")
  )

  expect_equal_lazy(
    test |>
      mutate(foo = na_if(x, 3)) |>
      pull(foo),
    c(NA, 1, 2, 2, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = na_if(x, 3), .by = grp) |>
      pull(foo),
    c(NA, 1, 2, 2, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = na_if(grp, "")) |>
      pull(foo),
    c("A", "A", "A", "B", NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = na_if(x, c(3, 1, 1, 1, 1))) |>
      pull(foo),
    c(NA, NA, 2, 2, 3)
  )

  expect_snapshot_lazy(
    test |> mutate(foo = na_if(x, 1:2)),
    error = TRUE
  )

  expect_equal_lazy(
    test |>
      mutate(foo = na_if(x, NA)) |>
      pull(foo),
    c(3, 1, 2, 2, 3)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = na_if(x, c(NA, 1, 1, 1, 1))) |>
      pull(foo),
    c(3, NA, 2, 2, 3)
  )
})

test_that("min_rank() works", {
  test <- polars::pl$LazyFrame(x = c(5, 1, 3, 2, 2, NA), y = c(rep(NA, 5), 1))

  expect_equal_lazy(
    test |>
      mutate(foo = min_rank(x)) |>
      pull(foo),
    c(5, 1, 4, 2, 2, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = min_rank(y)) |>
      pull(foo),
    c(rep(NA, 5), 1)
  )
})

test_that("dense_rank() works", {
  test <- polars::pl$LazyFrame(x = c(5, 1, 3, 2, 2, NA), y = c(rep(NA, 5), 1))

  expect_equal_lazy(
    test |>
      mutate(foo = dense_rank(x)) |>
      pull(foo),
    c(4, 1, 3, 2, 2, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = dense_rank(y)) |>
      pull(foo),
    c(rep(NA, 5), 1)
  )

  test2 <- polars::pl$LazyFrame(x = numeric(0), y = numeric(0))

  expect_dim(
    test2 |> mutate(foo = dense_rank(x)),
    c(0, 3)
  )
})

test_that("row_number() works", {
  test <- polars::pl$LazyFrame(x = c(5, 1, 3, 2, 2, NA), y = c(rep(NA, 5), 1))

  expect_equal_lazy(
    test |>
      mutate(foo = row_number(x)) |>
      pull(foo),
    c(5, 1, 4, 2, 3, NA)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = row_number(y)) |>
      pull(foo),
    c(rep(NA, 5), 1)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = row_number()) |>
      pull(foo),
    1:6
  )

  test2 <- polars::pl$LazyFrame(
    grp = c(1, 1, 1, 2, 2, 2, 3, 3, 3),
    x = c(3, 2, 1, 1, 2, 2, 1, 1, 1)
  )

  expect_equal_lazy(
    test2 |>
      group_by(grp) |>
      filter(row_number(x) == 1) |>
      pull(x),
    rep(1, 3)
  )

  expect_equal_lazy(
    test2 |>
      group_by(grp) |>
      filter(min_rank(x) == 1) |>
      pull(x),
    rep(1, 5)
  )

  expect_equal_lazy(
    test2 |>
      group_by(grp) |>
      mutate(foo = row_number()) |>
      pull(foo),
    rep(1:3, 3)
  )

  test3 <- polars::pl$LazyFrame(x = numeric(0), y = numeric(0))

  expect_dim(
    test3 |> mutate(foo = row_number()),
    c(0, 3)
  )

  # row_number with random values and aggregation based on row index just to be sure

  set.seed(123)
  test4 <- polars::pl$LazyFrame(
    grp = sample.int(5, 10, replace = TRUE),
    val = 1:10
  )

  expect_equal_lazy(
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

test_that("stats::lag() is not supported", {
  dat <- pl$LazyFrame(x = c(10, 20, 30, 40, 10, 20, 30, 40))
  expect_error_lazy(
    dat |> mutate(x_lag = stats::lag(x)),
    "doesn't know how to translate this function: `stats::lag()`",
    fixed = TRUE
  )
})

test_that("dplyr::lag() works", {
  dat <- data.frame(
    g = c(1, 1, 1, 1, 2, 2, 2, 2),
    t = c(1, 2, 3, 4, 4, 1, 2, 3),
    x = c(10, 20, 30, 40, 10, 20, 30, 40)
  )
  # Need to explicitly namespace this because there is no pl_lag(). Without
  # namespace it works fine in interactive mode but not via devtools::test().
  expect_equal_lazy(
    dat |>
      as_polars_lf() |>
      mutate(x_lag = dplyr::lag(x, order_by = t), .by = g),
    dat |>
      mutate(x_lag = dplyr::lag(x, order_by = t), .by = g)
  )
  expect_equal_lazy(
    dat |>
      as_polars_lf() |>
      mutate(x_lag = dplyr::lag(x, order_by = t, n = 2), .by = g),
    dat |>
      mutate(x_lag = dplyr::lag(x, order_by = t, n = 2), .by = g)
  )

  # With one group only
  dat <- data.frame(
    g = c(1, 1, 1, 1),
    t = c(1, 2, 3, 4),
    x = c(10, 20, 30, 40)
  )
  expect_equal_lazy(
    dat |>
      as_polars_lf() |>
      mutate(x_lag = dplyr::lag(x, order_by = t), .by = g),
    dat |>
      mutate(x_lag = dplyr::lag(x, order_by = t), .by = g)
  )

  # fill NA
  dat <- data.frame(
    g = c(1, 1, 1, 1, 2),
    t = c(1, 2, 3, 4, 5),
    x = c(10, 20, 30, 40, 50)
  )
  expect_equal_lazy(
    dat |>
      as_polars_lf() |>
      mutate(x_lag = dplyr::lag(x, order_by = t, default = 99), .by = g),
    dat |>
      mutate(x_lag = dplyr::lag(x, order_by = t, default = 99), .by = g)
  )
})

test_that("dplyr::lead() works", {
  dat <- data.frame(
    g = c(1, 1, 1, 1, 2, 2, 2, 2),
    t = c(1, 2, 3, 4, 4, 1, 2, 3),
    x = c(10, 20, 30, 40, 10, 20, 30, 40)
  )
  expect_equal_lazy(
    dat |>
      as_polars_lf() |>
      mutate(x_lead = lead(x, order_by = t), .by = g),
    dat |>
      mutate(x_lead = lead(x, order_by = t), .by = g)
  )
  expect_equal_lazy(
    dat |>
      as_polars_lf() |>
      mutate(x_lead = lead(x, order_by = t, n = 2), .by = g),
    dat |>
      mutate(x_lead = lead(x, order_by = t, n = 2), .by = g)
  )

  # With one group only
  dat <- data.frame(
    g = c(1, 1, 1, 1),
    t = c(1, 2, 3, 4),
    x = c(10, 20, 30, 40)
  )
  expect_equal_lazy(
    dat |>
      as_polars_lf() |>
      mutate(x_lead = lead(x, order_by = t), .by = g),
    dat |>
      mutate(x_lead = lead(x, order_by = t), .by = g)
  )

  # fill NA
  dat <- data.frame(
    g = c(1, 1, 1, 1, 2),
    t = c(1, 2, 3, 4, 5),
    x = c(10, 20, 30, 40, 50)
  )
  expect_equal_lazy(
    dat |>
      as_polars_lf() |>
      mutate(x_lead = lead(x, order_by = t, default = 99), .by = g),
    dat |>
      mutate(x_lead = lead(x, order_by = t, default = 99), .by = g)
  )
})

test_that("seq() works", {
  dat <- data.frame(x = 1:4)
  expect_equal_lazy(
    mutate(as_polars_lf(dat), y = seq(2, 5)),
    mutate(dat, y = seq(2, 5))
  )
  expect_equal_lazy(
    mutate(as_polars_lf(dat), y = seq(1, 2, 4)),
    mutate(dat, y = seq(1, 2, 4))
  )

  dat <- data.frame(x = 1:2)
  expect_equal_lazy(
    mutate(as_polars_lf(dat), y = seq(1, 4, by = 2)),
    mutate(dat, y = seq(1, 4, by = 2))
  )

  expect_error_lazy(
    expect_warning(
      mutate(as_polars_lf(dat), y = seq(1, 4, length.out = 2)),
      "doesn't know how to"
    )
  )
})

test_that("seq_len() works", {
  dat <- data.frame(x = 1:4)
  expect_equal_lazy(
    mutate(as_polars_lf(dat), y = seq_len(4)),
    mutate(dat, y = seq_len(4))
  )
  expect_equal_lazy(
    mutate(as_polars_lf(dat), y = seq_len(1)),
    mutate(dat, y = seq_len(1))
  )
  expect_error_lazy(
    mutate(as_polars_lf(dat), y = seq_len(-1)),
    "must be a non-negative integer"
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
