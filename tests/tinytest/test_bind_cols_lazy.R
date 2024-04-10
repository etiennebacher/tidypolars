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

expect_is_tidypolars(bind_cols_polars(l))

expect_dim(
  bind_cols_polars(l),
  c(20, 4)
)


p1 <- polars::pl$LazyFrame(
  x = sample(letters, 20),
  y = sample(1:100, 20)
)
p2 <- polars::pl$LazyFrame(
  z = sample(letters, 20),
  w = sample(1:100, 20)
)

expect_equal_lazy(
  bind_cols_polars(p1, p2),
  bind_cols_polars(list(p1, p2))
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


# arg ".name_repair"

l5 <- list(
  polars::pl$LazyFrame(a = 1, x = 2, y = 3),
  polars::pl$LazyFrame(z = 1, x = 2, y = 3)
)

options(rlib_message_verbosity = "quiet")

expect_equal_lazy(
  names(bind_cols_polars(l5)),
  c("a", "x...2", "y...3", "z", "x...5", "y...6")
)

expect_equal_lazy(
  names(bind_cols_polars(l5, .name_repair = "universal")),
  c("a", "x...2", "y...3", "z", "x...5", "y...6")
)

expect_error_lazy(
  bind_cols_polars(l5, .name_repair = "check_unique"),
  "Names must be unique"
)

expect_error_lazy(
  bind_cols_polars(l5, .name_repair = "minimal"),
  "Either provide unique names or use"
)

expect_error_lazy(
  bind_cols_polars(l5, .name_repair = "blahblah"),
  "must be one of"
)

l6 <- list(
  polars::pl$LazyFrame(x = 1)$rename(list(" " = "x")),
  polars::pl$LazyFrame(x = 1)$rename(list(" " = "x"))
)

expect_equal_lazy(
  names(bind_cols_polars(l6)),
  c(" ...1", " ...2")
)

expect_equal_lazy(
  names(bind_cols_polars(l6, .name_repair = "universal")),
  c("....1", "....2")
)

options(rlib_message_verbosity = "default")

Sys.setenv('TIDYPOLARS_TEST' = FALSE)