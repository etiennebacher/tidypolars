test_that("basic behavior works", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |>
      mutate(
        y = case_when(x1 == 'a' ~ "foo", x2 == 3 ~ "bar", .default = "hi there")
      ),
    test |>
      mutate(
        y = case_when(x1 == 'a' ~ "foo", x2 == 3 ~ "bar", .default = "hi there")
      )
  )

  expect_equal(
    test_pl |>
      mutate(
        y = dplyr::case_when(
          x1 == 'a' ~ "foo",
          x2 == 3 ~ "bar",
          .default = "hi there"
        )
      ),
    test |>
      mutate(
        y = dplyr::case_when(
          x1 == 'a' ~ "foo",
          x2 == 3 ~ "bar",
          .default = "hi there"
        )
      )
  )

  expect_equal(
    test_pl |>
      mutate(
        y = case_when(
          x1 %in% 'a' ~ "foo",
          x2 == 3 ~ "bar",
          .default = "hi there"
        )
      ),
    test |>
      mutate(
        y = case_when(
          x1 %in% 'a' ~ "foo",
          x2 == 3 ~ "bar",
          .default = "hi there"
        )
      )
  )

  expect_equal(
    test_pl |>
      mutate(
        y = case_when(
          x1 %in% 'a' & x2 == 2 ~ "foo",
          x2 == 3 ~ "bar",
          .default = "hi there"
        )
      ),
    test |>
      mutate(
        y = case_when(
          x1 %in% 'a' & x2 == 2 ~ "foo",
          x2 == 3 ~ "bar",
          .default = "hi there"
        )
      )
  )
})

test_that("if no .default, NA is used", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5)
  )
  test_pl <- as_polars_df(test)

  expect_equal(
    test_pl |>
      mutate(
        y = case_when(x1 == 'a' ~ "foo", x2 == 3 ~ "bar")
      ),
    test |>
      mutate(
        y = case_when(x1 == 'a' ~ "foo", x2 == 3 ~ "bar")
      )
  )
})

test_that("evaluation of external objects works", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5)
  )
  test_pl <- as_polars_df(test)
  foo <- "a"
  foo2 <- "b"

  expect_equal(
    test_pl |>
      mutate(
        y = case_when(x1 %in% foo ~ "foo", x1 %in% foo2 ~ "foo2", .default = x1)
      ),
    test |>
      mutate(
        y = case_when(x1 %in% foo ~ "foo", x1 %in% foo2 ~ "foo2", .default = x1)
      )
  )
})

test_that("some errors", {
  test <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5)
  )
  test_pl <- as_polars_df(test)

  expect_equal_or_both_error(
    test_pl |>
      mutate(y = case_when("a" ~ "b")),
    test |>
      mutate(y = case_when("a" ~ "b"))
  )
  expect_equal_or_both_error(
    test_pl |>
      mutate(y = case_when(x1 == "a" ~ NULL)),
    test |>
      mutate(y = case_when(x1 == "a" ~ NULL))
  )
  expect_equal_or_both_error(
    test_pl |>
      mutate(y = case_when(NULL ~ "a")),
    test |>
      mutate(y = case_when(NULL ~ "a"))
  )
  expect_equal_or_both_error(
    test_pl |>
      mutate(y = case_when(x1 == "a" ~ character(0))),
    test |>
      mutate(y = case_when(x1 == "a" ~ character(0)))
  )
  expect_equal_or_both_error(
    test_pl |>
      mutate(y = case_when(character(0) ~ "a")),
    test |>
      mutate(y = case_when(character(0) ~ "a"))
  )
})
