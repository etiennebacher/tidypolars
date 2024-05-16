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

# basic ---------------------------

expect_is_tidypolars(bind_rows_polars(l))

expect_dim(
  bind_rows_polars(l),
  c(40, 2)
)

# dots and list are equivalent -------------------------------

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

# different dtypes ---------------------------------------

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

# arg ".id" works ------------------------------------------

p1 <- pl$LazyFrame(
  x = sample(letters, 20),
  y = sample(1:100, 20)
)
p2 <- pl$LazyFrame(
  x = sample(letters, 20),
  y = sample(1:100, 20)
)

expect_equal_lazy(
  bind_rows_polars(p1, p2, .id = "foo") |>
    pull(foo),
  as.character(rep(1:2, each = 20))
)

expect_equal_lazy(
  bind_rows_polars(p1 = p1, p2 = p2, .id = "foo") |>
    pull(foo),
  rep(c("p1", "p2"), each = 20)
)

expect_equal_lazy(
  bind_rows_polars(list(p1 = p1, p2 = p2), .id = "foo") |>
    pull(foo),
  rep(c("p1", "p2"), each = 20)
)

expect_equal_lazy(
  bind_rows_polars(p1 = p1, p2, .id = "foo") |>
    pull(foo),
  as.character(rep(1:2, each = 20))
)


Sys.setenv('TIDYPOLARS_TEST' = FALSE)