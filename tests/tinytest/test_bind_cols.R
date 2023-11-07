source("helpers.R")
using("tidypolars")

# TODO: enable bind_cols() for LazyFrames, need with_context()
# https://github.com/pola-rs/polars/issues/2856#issuecomment-1209621687
l <- list(
  polars::pl$DataFrame(
    x = sample(letters, 20),
    y = sample(1:100, 20)
  ),
  polars::pl$DataFrame(
    a = sample(letters, 20),
    z = sample(1:100, 20)
  )
)

expect_dim(
  bind_cols_polars(l),
  c(20, 4)
)


p1 <- pl$DataFrame(
  x = sample(letters, 20),
  y = sample(1:100, 20)
)
p2 <- pl$DataFrame(
  z = sample(letters, 20),
  w = sample(1:100, 20)
)

expect_equal(
  bind_cols_polars(p1, p2),
  bind_cols_polars(list(p1, p2))
)

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
  bind_cols_polars(l2),
  "already exists"
)

l3 <- list(
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
  bind_cols_polars(l3),
  "must be either"
)
