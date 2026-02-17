test_that("basic behavior of ifelse() works", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> mutate(y = ifelse(x1 == 'a', "foo", "bar")),
    test_df |> mutate(y = ifelse(x1 == 'a', "foo", "bar"))
  )

  expect_equal(
    test_pl |> mutate(y = base::ifelse(x1 == 'a', "foo", "bar")),
    test_df |> mutate(y = base::ifelse(x1 == 'a', "foo", "bar"))
  )

  expect_equal(
    test_pl |> mutate(y = ifelse(x1 == 'a', x3, x1)),
    test_df |> mutate(y = ifelse(x1 == 'a', x3, x1))
  )
})

test_that("basic behavior of if_else() works", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> mutate(y = if_else(x1 == 'a', "foo", "bar")),
    test_df |> mutate(y = if_else(x1 == 'a', "foo", "bar"))
  )

  expect_equal(
    test_pl |> mutate(y = dplyr::if_else(x1 == 'a', "foo", "bar")),
    test_df |> mutate(y = dplyr::if_else(x1 == 'a', "foo", "bar"))
  )

  expect_equal(
    test_pl |> mutate(y = if_else(x1 == 'a', x3, x1)),
    test_df |> mutate(y = if_else(x1 == 'a', x3, x1))
  )
})

test_that("if_else() and ifelse() work with named args", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |>
      mutate(y = ifelse(test = x1 == 'a', yes = "foo", no = "bar")),
    test_df |>
      mutate(y = ifelse(test = x1 == 'a', yes = "foo", no = "bar"))
  )

  expect_equal(
    test_pl |>
      mutate(y = if_else(condition = x1 == 'a', true = x3, false = x1)),
    test_df |>
      mutate(y = if_else(condition = x1 == 'a', true = x3, false = x1))
  )
})

test_that("error when different types", {
  # I think it's better like this because it forces the user to
  # be clear about data types
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )
  test_pl <- as_polars_df(test_df)

  expect_snapshot(
    test_pl |> mutate(y = ifelse(x1 == 1, "foo", "bar")),
    error = TRUE
  )
  expect_snapshot(
    test_pl |> mutate(y = if_else(x1 == 1, "foo", "bar")),
    error = TRUE
  )
})

test_that("evaluation of external objects works", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    x3 = rep("hello", 5)
  )
  test_pl <- as_polars_df(test_df)

  foo <- "a"

  expect_equal(
    test_pl |> mutate(y = ifelse(x1 %in% foo, x3, x1)),
    test_df |> mutate(y = ifelse(x1 %in% foo, x3, x1))
  )

  expect_equal(
    test_pl |> mutate(y = if_else(x1 %in% foo, x3, x1)),
    test_df |> mutate(y = if_else(x1 %in% foo, x3, x1))
  )
})
