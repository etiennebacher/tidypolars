source("helpers.R")
using("tidypolars")

pl_test <- polars::pl$DataFrame(x = c(NA, 1), y = c(2L, NA_integer_))

expect_is_tidypolars(replace_na(pl_test, 0))

expect_equal(
  replace_na(pl_test, 0),
  data.frame(x = c(0, 1), y = c(2, 0))
)

expect_equal(
  replace_na(pl_test, list(x = 0, y = 999)),
  data.frame(x = c(0, 1), y = c(2, 999))
)

expect_equal(
  pl_test |>
    mutate(x = replace_na(x, 0)) ,
  data.frame(x = c(0, 1), y = c(2, NA))
)

# replacement type has to match...

expect_error(
  replace_na(pl_test, "a"),
  "conversion from `str` to `i32` failed in column 'literal' for 1 out of 1 values:"
)

expect_error(
  replace_na(pl_test, list(x = 1, y = "unknown")),
  "conversion from `str` to `i32` failed in column 'literal' for 1 out of 1 values:"
)

# ... except in some cases

expect_equal(
  replace_na(pl_test, 1.5),
  data.frame(x = c(1.5, 1), y = c(2, 1.5))
)

expect_equal(
  replace_na(pl_test, list(x = 0.1, y = 1.5)),
  data.frame(x = c(0.1, 1), y = c(2, 1.5))
)
