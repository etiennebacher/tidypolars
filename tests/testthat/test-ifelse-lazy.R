### [GENERATED AUTOMATICALLY] Update test-ifelse.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior of ifelse() works", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> mutate(y = ifelse(x1 == 'a', "foo", "bar")),
    test |> mutate(y = ifelse(x1 == 'a', "foo", "bar"))
  )

  expect_equal_lazy(
    test_pl |> mutate(y = base::ifelse(x1 == 'a', "foo", "bar")),
    test |> mutate(y = base::ifelse(x1 == 'a', "foo", "bar"))
  )

  expect_equal_lazy(
    test_pl |> mutate(y = ifelse(x1 == 'a', x3, x1)),
    test |> mutate(y = ifelse(x1 == 'a', x3, x1))
  )
})

test_that("basic behavior of if_else() works", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> mutate(y = if_else(x1 == 'a', "foo", "bar")),
    test |> mutate(y = if_else(x1 == 'a', "foo", "bar"))
  )

  expect_equal_lazy(
    test_pl |> mutate(y = dplyr::if_else(x1 == 'a', "foo", "bar")),
    test |> mutate(y = dplyr::if_else(x1 == 'a', "foo", "bar"))
  )

  expect_equal_lazy(
    test_pl |> mutate(y = if_else(x1 == 'a', x3, x1)),
    test |> mutate(y = if_else(x1 == 'a', x3, x1))
  )
})

test_that("if_else() and ifelse() work with named args", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |>
      mutate(y = ifelse(test = x1 == 'a', yes = "foo", no = "bar")),
    test |>
      mutate(y = ifelse(test = x1 == 'a', yes = "foo", no = "bar"))
  )

  expect_equal_lazy(
    test_pl |>
      mutate(y = if_else(condition = x1 == 'a', true = x3, false = x1)),
    test |>
      mutate(y = if_else(condition = x1 == 'a', true = x3, false = x1))
  )
})

test_that("error when different types", {
  # I think it's better like this because it forces the user to
  # be clear about data types
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )
  test_pl <- as_polars_lf(test)

  expect_snapshot_lazy(
    test_pl |> mutate(y = ifelse(x1 == 1, "foo", "bar")),
    error = TRUE
  )
  expect_snapshot_lazy(
    test_pl |> mutate(y = if_else(x1 == 1, "foo", "bar")),
    error = TRUE
  )
})

test_that("evaluation of external objects works", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )
  test_pl <- as_polars_lf(test)

  foo <- "a"

  expect_equal_lazy(
    test_pl |> mutate(y = ifelse(x1 %in% foo, x3, x1)),
    test |> mutate(y = ifelse(x1 %in% foo, x3, x1))
  )

  expect_equal_lazy(
    test_pl |> mutate(y = if_else(x1 %in% foo, x3, x1)),
    test |> mutate(y = if_else(x1 %in% foo, x3, x1))
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
