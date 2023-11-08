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

l2 <- list(
  polars::pl$LazyFrame(
    x = c("a", "b"),
    y = 1:2
  ),
  polars::pl$LazyFrame(
    y = 3:4,
    z = c("c", "d")
  )$with_columns(pl$col("y")$cast(pl$Int16))
)

expect_equal_lazy(
  bind_rows_polars(l2),
  data.frame(
    x = c("a", "b", NA, NA),
    y = 1:4,
    z = c(NA, NA, "c", "d")
  )
)


Sys.setenv('TIDYPOLARS_TEST' = FALSE)