### [GENERATED AUTOMATICALLY] Update test-funs-date.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

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
      test_df <- data.frame(x1 = ymd_hms(datetime))
      test <- as_polars_lf(test_df)

      # TODO: lubridate:: needed here otherwise the test_df call uses
      # base::date(), which errors. Why is lubridate::date() not overwriting
      # base::date()?
      expect_equal_or_both_error(
        mutate(test, x1 = lubridate::date(x1)),
        mutate(test_df, x1 = lubridate::date(x1))
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
        test <- pl$LazyFrame(x1 = ymd_hms(datetime, tz = "UTC"))

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
        test <- pl$LazyFrame(x1 = ymd_hms(datetime, tz = "UTC"))

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

test_that("operations on dates and durations", {
  for_all(
    tests = 40,
    datetime = posixct_(any_na = TRUE),
    weeks = integer_(len = 1, any_na = TRUE),
    days = integer_(len = 1, any_na = TRUE),
    hours = integer_(len = 1, any_na = TRUE),
    minutes = integer_(len = 1, any_na = TRUE),
    seconds = integer_(len = 1, any_na = TRUE),
    milliseconds = integer_(len = 1, any_na = TRUE),
    microseconds = integer_(len = 1, any_na = TRUE),
    nanoseconds = integer_(len = 1, any_na = TRUE),
    property = function(
      datetime,
      weeks,
      days,
      hours,
      minutes,
      seconds,
      milliseconds,
      microseconds,
      nanoseconds
    ) {
      datetime[is.na(datetime)] <- NA_POSIXct_
      test_df <- data.frame(x1 = ymd_hms(datetime))
      test <- as_polars_lf(test_df)

      expect_equal_or_both_error(
        mutate(
          test,
          x1 = x1 +
            weeks(weeks) +
            days(days) +
            hours(hours) +
            minutes(minutes) +
            seconds(seconds) +
            milliseconds(milliseconds) +
            microseconds(microseconds) +
            nanoseconds(nanoseconds)
        ),
        mutate(
          test_df,
          x1 = x1 +
            weeks(weeks) +
            days(days) +
            hours(hours) +
            minutes(minutes) +
            seconds(seconds) +
            milliseconds(milliseconds) +
            microseconds(microseconds) +
            nanoseconds(nanoseconds)
        )
      )
    }
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
