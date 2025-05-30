test_that("basic behavior works", {
  skip_if_not_installed("withr")
  test <- neopolars::pl$DataFrame(x = c(2, 1, 5, 3, 1))

  expect_warning(
    test |> mutate(x2 = sample(x, prob = 0.5)),
    "tidypolars doesn't know how to use some arguments of `sample()`.",
    fixed = TRUE
  )

  withr::with_options(
    list(tidypolars_unknown_args = "error"),
    expect_snapshot(
      test |> mutate(x2 = sample(x, prob = 0.5)),
      error = TRUE
    )
  )
})
