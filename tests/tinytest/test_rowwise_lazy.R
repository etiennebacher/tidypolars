### [GENERATED AUTOMATICALLY] Update test_rowwise.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test <- polars::pl$LazyFrame(x = c(2, 2), y = c(2, 3), z = c(5, NA)) |>
  rowwise()

expect_equal_lazy(
  test |>
    mutate(
      m = mean(c(x, y, z)),
      s = sum(c(x, y, z))
    ) |>
    pull(m),
  c(3, 2.5)
)

expect_equal_lazy(
  test |>
    mutate(m = sum(c(x, y, z))) |>
    pull(m),
  c(9, 5)
)

expect_equal_lazy(
  test |>
    mutate(m = min(c(x, y, z))) |>
    pull(m),
  c(2, 2)
)

expect_equal_lazy(
  test |>
    mutate(m = max(c(x, y, z))) |>
    pull(m),
  c(5, 3)
)

# Note: the default behavior with only NA is different between R (and therefore
# dplyr) and polars:
# - Polars all() returns TRUE if only NA, R returns NA (unless na.rm = TRUE)
# - Polars any() returns FALSE if only NA, R returns NA (unless na.rm = TRUE)

test2 <- polars::pl$LazyFrame(x = c(TRUE, TRUE, NA), y = c(TRUE, FALSE, NA), z = c(TRUE, NA, NA)) |>
  rowwise()

expect_equal_lazy(
  test2 |>
    mutate(m = all(c(x, y, z))) |>
    pull(m),
  c(TRUE, FALSE, TRUE)
)

expect_equal_lazy(
  test2 |>
    mutate(m = all(c(x, y, !z))) |>
    pull(m),
  c(FALSE, FALSE, TRUE)
)

expect_equal_lazy(
  test2 |>
    mutate(m = any(c(x, y, z))) |>
    pull(m),
  c(TRUE, TRUE, FALSE)
)

expect_equal_lazy(
  test2 |>
    mutate(m = any(c(x, y, !z))) |>
    pull(m),
  c(TRUE, TRUE, FALSE)
)


# rowwise mode is kept after operations

expect_equal_lazy(
  (test2 |>
    mutate(m = all(c(x, y, z))) |>
    attributes())$grp_type,
  "rowwise"
)

expect_equal_lazy(
  (test2 |>
    summarize(m = all(c(x, y, z))) |>
    attributes())$grp_type,
  "rowwise"
)

# can't apply rowwise on grouped data, and vice versa

expect_error_lazy(
  polars::as_polars_df(mtcars) |>
    group_by(cyl) |>
    rowwise(),
  "Cannot use "
)

expect_error_lazy(
  polars::as_polars_df(mtcars) |>
    rowwise() |>
    group_by(cyl),
  "Cannot use "
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)