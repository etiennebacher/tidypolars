### [GENERATED AUTOMATICALLY] Update test_bind_rows.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

l <- list(
  polars::pl$LazyFrame(
    x = sample(letters, 20),
    y = sample(1:100, 20)
  ),
  polars::pl$LazyFrame(
    x = sample(letters, 20),
    y = sample(1:100, 20)
  )
)

expect_dim(
  bind_rows_polars(l),
  c(40, 2)
)

expect_equal_lazy(
  bind_rows_polars(l, .id = "foo") |>
    pull(foo),
  rep(1:2, each = 20)
)


p1 <- pl$LazyFrame(
  x = sample(letters, 20),
  y = sample(1:100, 20)
)
p2 <- pl$LazyFrame(
  x = sample(letters, 20),
  y = sample(1:100, 20)
)

expect_equal_lazy(
  bind_rows_polars(p1, p2),
  bind_rows_polars(list(p1, p2))
)


# for now, error if not the same cols (for bind_rows) or duplicated col names
# (for bind_cols)

l2 <- list(
  polars::pl$LazyFrame(
    x = sample(letters, 20),
    y = sample(1:100, 20)
  ),
  polars::pl$LazyFrame(
    y = sample(letters, 20),
    z = sample(1:100, 20)
  )
)

expect_error_lazy(
  bind_rows_polars(l2),
  "column names don't match"
)


Sys.setenv('TIDYPOLARS_TEST' = FALSE)