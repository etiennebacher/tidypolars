### [GENERATED AUTOMATICALLY] Update test-global_option.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("tidypolars_unknown_args: basic behavior works", {
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

test_that("tidypolars_fallback_to_r: basic behavior works", {
  test <- polars::pl$LazyFrame(x = c(2, 1, 5, 3, 1))

  expect_error_lazy(
    test |> mutate(x2 = mad(x)),
    "doesn't know how to translate this function"
  )

  withr::with_options(
    list(tidypolars_fallback_to_r = TRUE),
    {
      expect_equal_lazy(
        test |> mutate(x2 = mad(x)),
        test |> as.data.frame() |> mutate(x2 = mad(x))
      )

      # Can create other variables before and after
      expect_equal_lazy(
        test |>
          mutate(y = 1, x2 = mad(x), z = 2),
        test |>
          as.data.frame() |>
          mutate(y = 1, x2 = mad(x), z = 2)
      )

      # TODO: cannot use newly created variables in untranslated function
      expect_snapshot_lazy(
        test |>
          mutate(
            y = 1,
            x2 = mad(x),
            z = mad(y)
          ),
        error = TRUE
      )
    }
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
