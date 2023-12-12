### [GENERATED AUTOMATICALLY] Update test_bind_cols.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

l <- list(
  polars::pl$LazyFrame(
    x = sample(letters, 20),
    y = sample(1:100, 20)
  ),
  polars::pl$LazyFrame(
    a = sample(letters, 20),
    z = sample(1:100, 20)
  )
)

expect_dim(
  bind_cols_polars(l),
  c(20, 4)
)


p1 <- pl$LazyFrame(
  x = sample(letters, 20),
  y = sample(1:100, 20)
)
p2 <- pl$LazyFrame(
  z = sample(letters, 20),
  w = sample(1:100, 20)
)

expect_equal_lazy(
  bind_cols_polars(p1, p2),
  bind_cols_polars(list(p1, p2))
)


# for now, error if duplicated col names

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
  bind_cols_polars(l2),
  "duplicated names"
)

l3 <- list(
  data.frame(
    x = sample(letters, 20),
    y = sample(1:100, 20)
  ),
  polars::pl$LazyFrame(
    y = sample(letters, 20),
    z = sample(1:100, 20)
  )
)

expect_error_lazy(
  bind_cols_polars(l3),
  "must be either"
)


# more than 2 elements: only with DataFrame

l4 <- append(
  l,
  polars::pl$LazyFrame(
    v = sample(letters, 20),
    w = sample(1:100, 20)
  )
)

if (Sys.getenv("TIDYPOLARS_TEST") == "TRUE") {
  expect_error_lazy(
    bind_cols_polars(l4),
    "doesn't work with more than two"
  )
} else {
  expect_dim(bind_cols_polars(l4), c(20, 6))

  expect_colnames(
    bind_cols_polars(l4),
    c("x", "y", "a", "z", "v", "w")
  )
}



Sys.setenv('TIDYPOLARS_TEST' = FALSE)