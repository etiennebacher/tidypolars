### [GENERATED AUTOMATICALLY] Update test_join_filtering.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

# Same column names ----------------------------------

test <- polars::pl$LazyFrame(
  x = c(1, 2, 3),
  y = c(1, 2, 3),
  z = c(1, 2, 3)
)
test2 <- polars::pl$LazyFrame(
  x = c(1, 2, 4),
  y = c(1, 2, 4),
  z2 = c(1, 2, 4)
)

expect_equal_lazy(
  semi_join(test, test2, by = c("x", "y")),
  pl$LazyFrame(
    x = c(1, 2), y = c(1, 2), z = c(1, 2)
  )
)

expect_equal_lazy(
  anti_join(test, test2, by = c("x", "y")),
  pl$LazyFrame(
    x = 3, y = 3, z = 3
  )
)


# Different column names ----------------------------------

test3 <- polars::pl$LazyFrame(
  x = c(1, 2, 3),
  y1 = c(1, 2, 3),
  z = c(1, 2, 3)
)
test4 <- polars::pl$LazyFrame(
  x = c(1, 2, 4),
  y2 = c(1, 2, 4),
  z2 = c(1, 2, 4)
)

expect_equal_lazy(
  semi_join(test3, test4, by = c("x", "y1" = "y2")),
  pl$LazyFrame(
    x = c(1, 2), y1 = c(1, 2), z = c(1, 2)
  )
)

expect_equal_lazy(
  anti_join(test3, test4, by = c("x", "y1" = "y2")),
  pl$LazyFrame(
    x = 3, y1 = 3, z = 3
  )
)


# with join_by: strict equality ----------------------------

expect_equal_lazy(
  semi_join(test3, test4, by = join_by(x, y1 == y2)),
  pl$LazyFrame(
    x = c(1, 2), y1 = c(1, 2), z = c(1, 2)
  )
)

expect_equal_lazy(
  anti_join(test3, test4, by = join_by(x, y1 == y2)),
  pl$LazyFrame(
    x = 3, y1 = 3, z = 3
  )
)

# join_by doesn't work with inequality -------------------------

expect_error_lazy(
  semi_join(test3, test4, by = join_by(x, y1 > y2)),
  "doesn't support inequality conditions"
)

expect_error_lazy(
  anti_join(test3, test4, by = join_by(x, y1 > y2)),
  "doesn't support inequality conditions"
)

# fallback on dplyr error if wrong join_by specification -------------------------

expect_error_lazy(
  semi_join(test3, test4, by = join_by(x, y1 = y2)),
  "Can't name join expressions"
)

expect_error_lazy(
  anti_join(test3, test4, by = join_by(x, y1 = y2)),
  "Can't name join expressions"
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)