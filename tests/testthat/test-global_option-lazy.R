### [GENERATED AUTOMATICALLY] Update test-global_option.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  skip_if_not_installed("withr")
  test <- polars::pl$LazyFrame(x = c(2, 1, 5, 3, 1))

  expect_warning(
    test |> mutate(x2 = sample(x, prob = 0.5)),
    "tidypolars doesn't know how to use some arguments of `sample()`.",
    fixed = TRUE
  )

  withr::with_options(
    list(tidypolars_unknown_args = "error"),
    expect_snapshot_lazy(
      test |> mutate(x2 = sample(x, prob = 0.5)),
      error = TRUE
    )
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
