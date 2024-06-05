source("helpers.R")
using("tidypolars")

test_df <- data.frame(x = c(2, 2), y = c(2, 3), z = c(5, NA)) |>
  rowwise()
test <- polars::pl$DataFrame(test_df) |>
  rowwise()

expect_is_tidypolars(test)

expect_equal(
  test |>
    mutate(
      mean = mean(c(x, y, z)),
      sum = sum(c(x, y, z)),
      median = median(c(x, y, z)),
      min = min(c(x, y, z)),
      max = max(c(x, y, z)),

      mean2 = mean(c(x, y, z), na.rm = TRUE),
      sum2 = sum(c(x, y, z), na.rm = TRUE),
      median2 = median(c(x, y, z), na.rm = TRUE),
      min2 = min(c(x, y, z), na.rm = TRUE),
      max2 = max(c(x, y, z), na.rm = TRUE)
    ),
  test_df |>
    mutate(
      mean = mean(c(x, y, z)),
      sum = sum(c(x, y, z)),
      median = median(c(x, y, z)),
      min = min(c(x, y, z)),
      max = max(c(x, y, z)),

      mean2 = mean(c(x, y, z), na.rm = TRUE),
      sum2 = sum(c(x, y, z), na.rm = TRUE),
      median2 = median(c(x, y, z), na.rm = TRUE),
      min2 = min(c(x, y, z), na.rm = TRUE),
      max2 = max(c(x, y, z), na.rm = TRUE)
    ),
  check.attributes = FALSE
)

# Note: the default behavior with only NA is different between R (and therefore
# dplyr) and polars:
# - Polars all() returns TRUE if only NA, R returns NA (unless na.rm = TRUE)
# - Polars any() returns FALSE if only NA, R returns NA (unless na.rm = TRUE)

test2 <- polars::pl$DataFrame(x = c(TRUE, TRUE, NA), y = c(TRUE, FALSE, NA), z = c(TRUE, NA, NA)) |>
  rowwise()

expect_equal(
  test2 |>
    mutate(m = all(c(x, y, z))) |>
    pull(m),
  c(TRUE, FALSE, TRUE)
)

expect_equal(
  test2 |>
    mutate(m = all(c(x, y, !z))) |>
    pull(m),
  c(FALSE, FALSE, TRUE)
)

expect_equal(
  test2 |>
    mutate(m = any(c(x, y, z))) |>
    pull(m),
  c(TRUE, TRUE, FALSE)
)

expect_equal(
  test2 |>
    mutate(m = any(c(x, y, !z))) |>
    pull(m),
  c(TRUE, TRUE, FALSE)
)

# can only use rowwise() on a subset of functions

expect_error(
  test2 |> mutate(m = range(c(x, y, !z))),
  "Can't use function"
)


# rowwise mode is kept after operations

expect_equal(
  (test2 |>
    mutate(m = all(c(x, y, z))) |>
    attributes())$grp_type,
  "rowwise"
)

expect_equal(
  (test2 |>
    summarize(m = all(c(x, y, z))) |>
    attributes())$grp_type,
  "rowwise"
)

# can't apply rowwise on grouped data, and vice versa

expect_error(
  polars::as_polars_df(mtcars) |>
    group_by(cyl) |>
    rowwise(),
  "Cannot use "
)

expect_error(
  polars::as_polars_df(mtcars) |>
    rowwise() |>
    group_by(cyl),
  "Cannot use "
)

