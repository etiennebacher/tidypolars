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
  pl_bind_rows(l) |>
    nrow(),
  40
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
  pl_bind_cols(l2) |>
    ncol(),
  4
)

expect_equal(
  pl_bind_cols(l2) |>
    nrow(),
  20
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
  pl_bind_rows(l3),
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
  pl_bind_cols(l4),
  "already exists"
)
