### [GENERATED AUTOMATICALLY] Update test-funs-date.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

patrick::with_parameters_test_that(
  "extracting date components works",
  {
    for_all(
      tests = 20,
      date = date_(any_na = TRUE),
      datetime = posixct_(any_na = TRUE),
      property = function(date, datetime) {
        # date -----------------------------------
        test_df <- data.frame(x1 = date)
        test <- pl$LazyFrame(x1 = date)

        pl_code <- paste0("mutate(test, foo = ", fun, "(x1)) |> pull(foo)")
        tv_code <- paste0("mutate(test_df, foo = ", fun, "(x1)) |> pull(foo)")

        expect_equal_lazy(
          eval(parse(text = pl_code)),
          eval(parse(text = tv_code))
        )

        # datetime -----------------------------------
        # TODO: this should be removed eventually
        if (!fun %in% c("yday", "mday")) {
          test_df <- data.frame(x1 = datetime)
          test <- pl$LazyFrame(x1 = datetime)

          pl_code <- paste0("mutate(test, foo = ", fun, "(x1)) |> pull(foo)")
          tv_code <- paste0("mutate(test_df, foo = ", fun, "(x1)) |> pull(foo)")

          expect_equal_lazy(
            eval(parse(text = pl_code)),
            eval(parse(text = tv_code))
          )
        }
      }
    )
  },
  fun = c("year", "month", "day", "quarter", "mday", "yday")
)

test_that("extracting date component", {
  for_all(
    tests = 20,
    datetime = posixct_bounded(
      left = as.POSIXct("2001-01-01 00:00:00", tz = "UTC"),
      right = as.POSIXct("2015-01-01 00:00:00", tz = "UTC"),
      any_na = TRUE
    ),
    property = function(datetime) {
      test_df <- data.frame(x1 = ymd_hms(datetime, tz = "UTC"))
      test <- as_polars_lf(test_df)

      expect_equal_or_both_error(
        mutate(test, x1 = date(x1)),
        mutate(test_df, x1 = date(x1)),
        tolerance = 1e-6
      )
    }
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
