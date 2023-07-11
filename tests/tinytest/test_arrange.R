source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  value = sample(1:5)
)

expect_equal(
  pl_arrange(test, x1) |>
    pl_pull(x1),
  c("a", "a", "a", "b", "c")
)

expect_equal(
  pl_arrange(test, -x1) |>
    pl_pull(x1),
  c("c", "b", "a", "a", "a")
)

expect_equal(
  pl_arrange(test, -x1),
  pl_arrange(test, !x1)
)

expect_equal(
  pl_arrange(test, x1, -x2) |>
    pl_select(starts_with("x")) |>
    to_r(),
  data.frame(
    x1 = c("a", "a", "a", "b", "c"),
    x2 = c(3, 2, 1, 5, 1)
  )
)

# vars don't exist

expect_equal(
  pl_arrange(test, foo, x1),
  pl_arrange(test, x1)
)

expect_equal(
  pl_arrange(test, foo),
  test
)


### LAZY

test <- pl$LazyFrame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  value = sample(1:5)
)

expect_equal(
  pl_arrange(test, x1) |>
    pl_collect() |>
    pl_pull(x1),
  c("a", "a", "a", "b", "c")
)

expect_equal(
  pl_arrange(test, -x1) |>
    pl_collect() |>
    pl_pull(x1),
  c("c", "b", "a", "a", "a")
)

expect_equal(
  pl_arrange(test, -x1) |> pl_collect(),
  pl_arrange(test, !x1) |> pl_collect()
)

expect_equal(
  pl_arrange(test, x1, -x2) |>
    pl_select(starts_with("x")) |>
    pl_collect() |>
    to_r(),
  data.frame(
    x1 = c("a", "a", "a", "b", "c"),
    x2 = c(3, 2, 1, 5, 1)
  )
)

# vars don't exist

expect_equal(
  pl_arrange(test, foo, x1) |> pl_collect(),
  pl_arrange(test, x1) |> pl_collect()
)

expect_equal(
  pl_arrange(test, foo) |> pl_collect(),
  test$collect()
)
