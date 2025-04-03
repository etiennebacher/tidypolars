# TODO:
# Sometimes this test fails for day() (and maybe others), e.g. with:
# date <- as.POSIXct("2493-05-15 00:00:00 CEST")

set.seed(123)
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
        test <- pl$DataFrame(x1 = date)

        pl_code <- paste0("mutate(test, foo = ", fun, "(x1)) |> pull(foo)")
        tv_code <- paste0("mutate(test_df, foo = ", fun, "(x1)) |> pull(foo)")

        expect_equal(
          eval(parse(text = pl_code)),
          eval(parse(text = tv_code))
        )

        # datetime -----------------------------------
        # TODO: this should be removed eventually
        if (!fun %in% c("yday", "mday")) {
          test_df <- data.frame(x1 = datetime)
          test <- pl$DataFrame(x1 = datetime)

          pl_code <- paste0("mutate(test, foo = ", fun, "(x1)) |> pull(foo)")
          tv_code <- paste0("mutate(test_df, foo = ", fun, "(x1)) |> pull(foo)")

          expect_equal(
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
      test_df <- data.frame(x1 = ymd_hms(datetime))
      test <- as_polars_df(test_df)

      expect_equal_or_both_error(
        mutate(test, x1 = date(x1)),
        mutate(test_df, x1 = date(x1)),
        tolerance = 1e-6
      )
    }
  )
})

patrick::with_parameters_test_that(
  "changing timezone works",
  {
    for_all(
      tests = 20,
      datetime = posixct_(any_na = TRUE),
      property = function(datetime) {
        test_df <- data.frame(x1 = ymd_hms(datetime, tz = "UTC"))
        test <- pl$DataFrame(x1 = ymd_hms(datetime, tz = "UTC"))

        expect_equal_or_both_error(
          mutate(
            test,
            x1 = force_tz(x1, tz)
          ),
          mutate(
            test_df,
            x1 = force_tz(x1, tz)
          ),
          # TODO: investigate more why this is needed
          tolerance = 1e-2
        )
      }
    )
  },
  tz = list("Pacific/Auckland", "foobar", NA, "")
)

patrick::with_parameters_test_that(
  "converting timezone works",
  {
    for_all(
      tests = 20,
      datetime = posixct_(any_na = FALSE),
      property = function(datetime) {
        test_df <- data.frame(x1 = ymd_hms(datetime, tz = "UTC"))
        test <- pl$DataFrame(x1 = ymd_hms(datetime, tz = "UTC"))

        expect_equal_or_both_error(
          mutate(
            test,
            x1 = with_tz(x1, tz)
          ),
          mutate(
            test_df,
            x1 = with_tz(x1, tz)
          ),
          # TODO: investigate more why this is needed
          tolerance = 1e-6
        )
      }
    )
  },
  # TODO: see https://github.com/tidyverse/lubridate/issues/1186
  # If lubridate changed the behavior to error, then we can add "foo" and ""
  tz = list("Pacific/Auckland", "Europe/Rome", NA)
)
