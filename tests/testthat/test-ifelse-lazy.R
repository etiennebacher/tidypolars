### [GENERATED AUTOMATICALLY] Update test-ifelse.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior of ifelse() works", {
  test <- pl$LazyFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )

  expect_equal_lazy(
    test |>
      mutate(y = ifelse(x1 == 'a', "foo", "bar")) |>
      pull(y),
    c("foo", "foo", "bar", "foo", "bar")
  )

  expect_equal_lazy(
    test |>
      mutate(y = base::ifelse(x1 == 'a', "foo", "bar")) |>
      pull(y),
    c("foo", "foo", "bar", "foo", "bar")
  )

  expect_equal_lazy(
    test |>
      mutate(y = ifelse(x1 == 'a', x3, x1)) |>
      pull(y),
    c("hello", "hello", "b", "hello", "c")
  )
})

test_that("basic behavior of if_else() works", {
  test <- pl$LazyFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )

  expect_equal_lazy(
    test |>
      mutate(y = if_else(x1 == 'a', "foo", "bar")) |>
      pull(y),
    c("foo", "foo", "bar", "foo", "bar")
  )

  expect_equal_lazy(
    test |>
      mutate(y = dplyr::if_else(x1 == 'a', "foo", "bar")) |>
      pull(y),
    c("foo", "foo", "bar", "foo", "bar")
  )

  expect_equal_lazy(
    test |>
      mutate(y = if_else(x1 == 'a', x3, x1)) |>
      pull(y),
    c("hello", "hello", "b", "hello", "c")
  )
})

test_that("if_else() and ifelse() work with named args", {
  test <- pl$LazyFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )

  expect_equal_lazy(
    test |>
      mutate(y = ifelse(test = x1 == 'a', yes = "foo", no = "bar")) |>
      pull(y),
    c("foo", "foo", "bar", "foo", "bar")
  )

  expect_equal_lazy(
    test |>
      mutate(y = if_else(condition = x1 == 'a', true = x3, false = x1)) |>
      pull(y),
    c("hello", "hello", "b", "hello", "c")
  )
})

test_that("error when different types", {
  test <- pl$LazyFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )

  # different behavior than from classic R (e.g iris$Species == 1
  # returns all FALSE)
  # I think it's better like this because it forces the user to
  # be clear about data types
  expect_snapshot_lazy(
    test |> mutate(y = ifelse(x1 == 1, "foo", "bar")),
    error = TRUE
  )
  expect_snapshot_lazy(
    test |> mutate(y = if_else(x1 == 1, "foo", "bar")),
    error = TRUE
  )
})

test_that("evaluation of external objects works", {
  test <- pl$LazyFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )

  foo <- "a"

  expect_equal_lazy(
    test |>
      mutate(y = ifelse(x1 %in% foo, x3, x1)) |>
      pull(y),
    c("hello", "hello", "b", "hello", "c")
  )

  expect_equal_lazy(
    test |>
      mutate(y = if_else(x1 %in% foo, x3, x1)) |>
      pull(y),
    c("hello", "hello", "b", "hello", "c")
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
