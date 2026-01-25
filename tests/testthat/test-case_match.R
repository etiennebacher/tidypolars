# Do not test the output of case_match() on data.frame, it has a deprecation
# warning.
test_that("basic behavior works", {
  test <- pl$DataFrame(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5, )
  )

  expect_equal(
    test |>
      mutate(
        y = case_match(
          x1,
          'a' ~ "foo",
          'b' ~ "bar",
          .default = "hi there"
        )
      ) |>
      pull(y),
    c("foo", "foo", "bar", "foo", "hi there")
  )

  expect_equal(
    test |>
      mutate(
        y = dplyr::case_match(
          x1,
          'a' ~ "foo",
          'b' ~ "bar",
          .default = "hi there"
        )
      ) |>
      pull(y),
    c("foo", "foo", "bar", "foo", "hi there")
  )

  expect_equal(
    test |>
      mutate(
        y = case_match(
          x1,
          c('a', 'c') ~ "foo",
          'b' ~ "bar"
        )
      ) |>
      pull(y),
    c("foo", "foo", "bar", "foo", "foo")
  )

  expect_equal(
    test |>
      mutate(
        y = case_match(
          x2,
          1:3 ~ "foo",
          .default = "bar"
        )
      ) |>
      pull(y),
    c("foo", "foo", "bar", "foo", "foo")
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
      mutate(y = case_match(x1, "a" ~ NULL)),
    test |>
      mutate(y = case_match(x1, "a" ~ NULL))
  )
  expect_equal_or_both_error(
    test_pl |>
      mutate(y = case_match(x1, NULL ~ "a")),
    test |>
      mutate(y = case_match(x1, NULL ~ "a"))
  )
  expect_equal_or_both_error(
    test_pl |>
      mutate(y = case_match(x1, "a" ~ character(0))),
    test |>
      mutate(y = case_match(x1, "a" ~ character(0)))
  )
  expect_equal_or_both_error(
    test_pl |>
      mutate(y = case_match(x1, character(0) ~ "a")),
    test |>
      mutate(y = case_match(x1, character(0) ~ "a"))
  )
})
