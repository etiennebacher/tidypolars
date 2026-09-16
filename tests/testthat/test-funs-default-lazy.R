### [GENERATED AUTOMATICALLY] Update test-funs-default.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

patrick::with_parameters_test_that(
  "var() works",
  {
    for_all(
      tests = 20,
      x = numeric_(len = 30, any_na = TRUE),
      y = numeric_(len = 30, any_na = TRUE),
      property = function(x, y) {
        test_df <- tibble(x = x, y = y)
        test_pl <- pl$LazyFrame(x = x, y = y)

        expect_equal_lazy(
          mutate(test_pl, foo = var(x, use = use, na.rm = na.rm)),
          mutate(test_df, foo = var(x, use = use, na.rm = na.rm))
        )
        expect_equal_lazy(
          mutate(test_pl, foo = var(x, y, use = use, na.rm = na.rm)),
          mutate(test_df, foo = var(x, y, use = use, na.rm = na.rm))
        )
      }
    )
  },
  .cases = expand.grid(
    use = c(
      "complete.obs",
      "pairwise.complete.obs",
      "everything",
      "na.or.complete"
    ),
    na.rm = c(TRUE, FALSE),
    stringsAsFactors = FALSE
  )
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
