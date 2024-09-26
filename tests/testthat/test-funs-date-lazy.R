### [GENERATED AUTOMATICALLY] Update test-funs-date.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

patrick::with_parameters_test_that(
  "extracting date components works", {
    for_all(
      tests = 20,
      date = date_(),
      property = function(date) {
        test_df <- data.frame(x1 = date)
        test <- pl$LazyFrame(x1 = date)

        pl_code <- paste0("mutate(test, foo = ", fun, "(date)) |> pull(foo)")
        tv_code <- paste0("mutate(test_df, foo = ", fun, "(date)) |> pull(foo)")

        expect_equal_lazy(
          eval(parse(text = pl_code)),
          eval(parse(text = tv_code)),
        )
      }
    )
  },
  fun = c("year", "month", "day", "quarter", "mday", "yday")
)


Sys.setenv('TIDYPOLARS_TEST' = FALSE)