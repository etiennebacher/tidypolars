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

p1 <- pl$DataFrame(
  x = sample(letters, 20),
  y = sample(1:100, 20)
)
p2 <- pl$DataFrame(
  x = sample(letters, 20),
  y = sample(1:100, 20)
)

expect_equal(
  pl_bind_rows(p1, p2),
  pl_bind_rows(list(p1, p2))
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
  pl_bind_cols(p3, p4),
  pl_bind_cols(list(p3, p4))
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
  pl_bind_cols(l5),
  "must be of the same class"
)
