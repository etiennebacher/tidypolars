source("helpers.R")
using("tidypolars")

l <- list(
  polars::pl$DataFrame(
    x = sample(letters, 20),
    y = sample(1:100, 20)
  ),
  polars::pl$DataFrame(
    x = sample(letters, 20),
    y = sample(1:100, 20)
  )
)

expect_dim(
  bind_rows_polars(l),
  c(40, 2)
)

expect_equal(
  bind_rows_polars(l, .id = "foo") |>
    pull(foo),
  rep(1:2, each = 20)
)


p1 <- pl$DataFrame(
  x = sample(letters, 20),
  y = sample(1:100, 20)
)
p2 <- pl$DataFrame(
  x = sample(letters, 20),
  y = sample(1:100, 20)
)

expect_equal(
  bind_rows_polars(p1, p2),
  bind_rows_polars(list(p1, p2))
)


# for now, error if not the same cols (for bind_rows) or duplicated col names
# (for bind_cols)

l2 <- list(
  polars::pl$DataFrame(
    x = sample(letters, 20),
    y = sample(1:100, 20)
  ),
  polars::pl$DataFrame(
    y = sample(letters, 20),
    z = sample(1:100, 20)
  )
)

expect_error(
  bind_rows_polars(l2),
  "column names don't match"
)

