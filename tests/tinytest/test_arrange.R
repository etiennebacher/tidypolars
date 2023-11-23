source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(
  x1 = c("a", "a", "b", "a", "c"),
  x2 = c(2, 1, 5, 3, 1),
  value = sample(1:5)
)

expect_equal(
  arrange(test, x1) |>
    pull(x1),
  c("a", "a", "a", "b", "c")
)

expect_equal(
  arrange(test, -x1) |>
    pull(x1),
  c("c", "b", "a", "a", "a")
)

expect_equal(
  arrange(test, -x1),
  arrange(test, !x1)
)

expect_equal(
  arrange(test, x1, -x2) |>
    select(starts_with("x")) |>
    to_r(),
  data.frame(
    x1 = c("a", "a", "a", "b", "c"),
    x2 = c(3, 2, 1, 5, 1)
  )
)

# vars don't exist

expect_equal(
  arrange(test, foo, x1),
  arrange(test, x1)
)

expect_equal(
  arrange(test, foo),
  test
)

# groups: need .by_group = TRUE

test_grp <- group_by(test, x1)

expect_equal(
  arrange(test_grp, x2),
  arrange(test, x2)
)

expect_equal(
  arrange(test_grp, x2, .by_group = TRUE) |>
    pull(x2),
  c(1, 2, 3, 5, 1)
)

# groups: regroup after operation

expect_equal(
  arrange(test_grp, x2) |> attr("pl_grps"),
  "x1"
)

test_grp <- group_by(test, x1, x2)

expect_equal(
  arrange(test_grp, value) |> attr("pl_grps"),
  c("x1", "x2")
)
