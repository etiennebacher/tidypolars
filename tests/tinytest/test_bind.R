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

expect_equal(
  bind_rows_polars(l) |>
    nrow(),
  40
)

expect_equal(
  bind_rows_polars(l, .id = "foo") |>
    pull(foo),
  rep(1:2, each = 20)
)

l2 <- list(
  polars::pl$DataFrame(
    x = sample(letters, 20),
    y = sample(1:100, 20)
  ),
  polars::pl$DataFrame(
    a = sample(letters, 20),
    z = sample(1:100, 20)
  )
)

expect_equal(
  bind_cols_polars(l2) |>
    ncol(),
  4
)

expect_equal(
  bind_cols_polars(l2) |>
    nrow(),
  20
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

p3 <- pl$DataFrame(
  x = sample(letters, 20),
  y = sample(1:100, 20)
)
p4 <- pl$DataFrame(
  z = sample(letters, 20),
  w = sample(1:100, 20)
)

expect_equal(
  bind_cols_polars(p3, p4),
  bind_cols_polars(list(p3, p4))
)

# for now, error if not the same cols (for bind_rows) or duplicated col names
# (for bind_cols)

l3 <- list(
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
  bind_rows_polars(l3),
  "column names don't match"
)

l4 <- list(
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
  bind_cols_polars(l4),
  "already exists"
)

l5 <- list(
  data.frame(
    x = sample(letters, 20),
    y = sample(1:100, 20)
  ),
  polars::pl$DataFrame(
    y = sample(letters, 20),
    z = sample(1:100, 20)
  )
)

expect_error(
  bind_cols_polars(l5),
  "must be either"
)
