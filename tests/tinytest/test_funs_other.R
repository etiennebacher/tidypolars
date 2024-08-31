source("helpers.R")
using("tidypolars")

test_df <- data.frame(
  x = c(1:4, 0:5, 11, 10),
  x_na = c(1:4, NA, 1:5, 11, 10),
  x_inf = c(1, Inf, 3:4, -Inf, 1:5, 11, 10)
)
test <- polars::pl$DataFrame(test_df)

# which.min and which.max

expect_equal(
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

# n_distinct

test <- polars::pl$DataFrame(x = c("a", "a", "b", "b"), y = c(1:3, NA))

expect_error(
  test |>
    summarize(foo = n_distinct()),
  "must be supplied"
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

# length

test <- polars::pl$DataFrame(x = c("a", "a", "a", "b", "b"), y = c(1:4, NA))

expect_equal(
  test |>
    mutate(foo = length(y)) |>
    pull(foo),
  rep(5, 5)
)

expect_equal(
  test |>
    mutate(foo = length(y), .by = x) |>
    pull(foo),
  c(3, 3, 3, 2, 2)
)

expect_equal(
  test |>
    mutate(foo = length(y), .by = c(x, y)) |>
    pull(foo),
  rep(1, 5)
)


# unique

test <- polars::pl$DataFrame(x = c("a", "a", "a", "b", "b"), y = c(2, 2, 3, 4, NA))

expect_error(
  test |>
    mutate(foo = unique(y)),
  "lengths don't match"
)

expect_equal(
  test |>
    mutate(foo = length(unique(y))) |>
    pull(foo),
  rep(4, 5)
)

expect_equal(
  test |>
    mutate(foo = length(unique(y)), .by = x) |>
    pull(foo),
  rep(2, 5)
)

expect_equal(
  test |>
    mutate(foo = length(unique(y)), .by = c(x, y)) |>
    pull(foo),
  rep(1, 5)
)


# rev

test <- polars::pl$DataFrame(x = c("a", "a", "a", "b", "b"), y = c(2, 2, 3, 4, NA))

expect_equal(
  test |>
    mutate(foo = rev(y)) |>
    pull(foo),
  c(NA, 4, 3, 2, 2)
)

expect_equal(
  test |>
    mutate(foo = rev(x)) |>
    pull(foo),
  c("b", "b", "a", "a", "a")
)

expect_equal(
  test |>
    mutate(foo = rev(y), .by = x) |>
    pull(foo),
  c(3, 2, 2, NA, 4)
)

expect_equal(
  test |>
    mutate(foo = rev(y), .by = c(x, y)) |>
    pull(foo),
  c(2, 2, 3, 4, NA)
)

expect_equal(
  test |>
    mutate(foo = rev(y + 1), .by = x) |>
    pull(foo),
  c(4, 3, 3, NA, 5)
)

# all

test <- polars::pl$DataFrame(x = c(TRUE, FALSE, NA), y = c(TRUE, TRUE, NA))

expect_equal(
  test |>
    mutate(foo = all(x)) |>
    pull(foo),
  # we know it's FALSE because there's one FALSE in x, so the na.rm arg is irrelevant
  c(FALSE, FALSE, FALSE)
)

expect_equal(
  test |>
    mutate(foo = all(y)) |>
    pull(foo),
  c(NA, NA, NA)
)

expect_equal(
  test |>
    mutate(foo = all(y, na.rm = TRUE)) |>
    pull(foo),
  c(TRUE, TRUE, TRUE)
)

# any

test <- polars::pl$DataFrame(x = c(FALSE, FALSE, NA), y = c(TRUE, TRUE, NA))

expect_equal(
  test |>
    mutate(foo = any(x)) |>
    pull(foo),
  c(NA, NA, NA)
)

expect_equal(
  test |>
    mutate(foo = any(x, na.rm = TRUE)) |>
    pull(foo),
  c(FALSE, FALSE, FALSE)
)

# round

test <- polars::pl$DataFrame(x = c(0.33, 0.5212))

expect_equal(
  test |>
    mutate(foo = round(x)) |>
    pull(foo),
  c(0, 1)
)

expect_equal(
  test |>
    mutate(foo = round(x, 1)) |>
    pull(foo),
  c(0.3, 0.5)
)

expect_equal(
  test |>
    mutate(foo = round(x, 3)) |>
    pull(foo),
  c(0.33, 0.521)
)

# consecutive_id

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

# first

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

# last

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

# nth

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

expect_error(
  test |>
    summarize(foo = nth(x, 2:3)) |>
    pull(foo),
  "must have size 1"
)

expect_error(
  test |>
    summarize(foo = nth(x, NA)) |>
    pull(foo),
  "can't be `NA`"
)

expect_error(
  test |>
    summarize(foo = nth(x, 1.5)) |>
    pull(foo),
  "must be an integer"
)

# na_if

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

expect_error(
  test |>
    mutate(foo = na_if(x, 1:2)),
  "different lengths"
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

# min_rank

test <- polars::pl$DataFrame(x = c(5, 1, 3, 2, 2, NA), y = c(rep(NA, 5), 1))

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

# dense_rank

test <- polars::pl$DataFrame(x = c(5, 1, 3, 2, 2, NA), y = c(rep(NA, 5), 1))

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

# row_number

test <- polars::pl$DataFrame(x = c(5, 1, 3, 2, 2, NA), y = c(rep(NA, 5), 1))

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

expect_error(
  test |> mutate(foo = row_number()),
  "No translation"
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
