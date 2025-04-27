test_that("non-translated functions do not error if they don't use data context", {
  test <- pl$DataFrame(a = c("a", "b", "c"), b = 1:3)
  test_df <- as.data.frame(test)

  # no column at all in the expression
  expect_equal(
    test |>
      mutate(x = agrep("a", "b")),
    test_df |>
      mutate(x = agrep("a", "b"))
  )
  expect_equal(
    test |>
      mutate(
        across(
          starts_with("x"),
          function(y) agrep("a", "b")
        )
      ),
    test_df |>
      mutate(
        across(
          starts_with("x"),
          function(y) agrep("a", "b")
        )
      )
  )

  # column in parts of the expression
  expect_equal(
    test |>
      filter(b >= agrep("a", "b")),
    test_df |>
      filter(b >= agrep("a", "b"))
  )
})

test_that("non-translated functions error if they use data context", {
  test <- pl$DataFrame(a = c("a", "b", "c"), b = 1:3)

  expect_snapshot(
    test |> mutate(x = agrep("a", a)),
    error = TRUE
  )
  expect_snapshot(
    test |> filter(a >= agrep("a", a)),
    error = TRUE
  )
})
