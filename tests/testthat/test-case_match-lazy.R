### [GENERATED AUTOMATICALLY] Update test-case_match.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

# Do not test the output of case_match() on data.frame, it has a deprecation
# warning.
test_that("basic behavior works", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5)
  )
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |>
      mutate(
        y = case_match(
          x1,
          'a' ~ "foo",
          'b' ~ "bar",
          .default = "hi there"
        )
      ),
    test_df |>
      mutate(
        y = case_match(
          x1,
          'a' ~ "foo",
          'b' ~ "bar",
          .default = "hi there"
        )
      ) |>
      suppressWarnings()
  )

  expect_equal_lazy(
    test_pl |>
      mutate(
        y = dplyr::case_match(
          x1,
          'a' ~ "foo",
          'b' ~ "bar",
          .default = "hi there"
        )
      ),
    test_df |>
      mutate(
        y = dplyr::case_match(
          x1,
          'a' ~ "foo",
          'b' ~ "bar",
          .default = "hi there"
        )
      ) |>
      suppressWarnings()
  )

  expect_equal_lazy(
    test_pl |>
      mutate(
        y = case_match(
          x1,
          c('a', 'c') ~ "foo",
          'b' ~ "bar"
        )
      ),
    test_df |>
      mutate(
        y = case_match(
          x1,
          c('a', 'c') ~ "foo",
          'b' ~ "bar"
        )
      ) |>
      suppressWarnings()
  )

  expect_equal_lazy(
    test_pl |>
      mutate(
        y = case_match(
          x2,
          1:3 ~ "foo",
          .default = "bar"
        )
      ),
    test_df |>
      mutate(
        y = case_match(
          x2,
          1:3 ~ "foo",
          .default = "bar"
        )
      ) |>
      suppressWarnings()
  )
})

test_that("some errors", {
  test_df <- tibble(
    x1 = c("a", "a", "b", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample.int(5)
  )
  test_pl <- as_polars_lf(test_df)

  expect_both_error(
    test_pl |> mutate(y = case_match(x1, "a" ~ NULL)),
    test_df |> mutate(y = case_match(x1, "a" ~ NULL))
  )
  expect_both_error(
    test_pl |> mutate(y = case_match(x1, NULL ~ "a")),
    test_df |> mutate(y = case_match(x1, NULL ~ "a"))
  )
  expect_both_error(
    test_pl |> mutate(y = case_match(x1, "a" ~ character(0))),
    test_df |> mutate(y = case_match(x1, "a" ~ character(0)))
  )
  expect_both_error(
    test_pl |> mutate(y = case_match(x1, character(0) ~ "a")),
    test_df |> mutate(y = case_match(x1, character(0) ~ "a"))
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
