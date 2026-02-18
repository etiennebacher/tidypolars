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
      datetime = posixct_right_bounded(
        as.POSIXct("2100-01-01 00:00:00"),
        any_na = TRUE
      ),
      property = function(date, datetime) {
        # date -----------------------------------
        test_df <- tibble(x1 = date)
        test_pl <- pl$DataFrame(x1 = date)

        pl_code <- paste0(
          "mutate(test_pl, foo = ",
          fun,
          "(x1))"
        )
        tv_code <- paste0("mutate(test_df, foo = ", fun, "(x1))")

        expect_equal(
          eval(parse(text = pl_code)),
          eval(parse(text = tv_code))
        )

        # datetime -----------------------------------
        # TODO: this should be removed eventually
        if (!fun %in% c("yday", "mday")) {
          test_df <- tibble(x1 = datetime)
          test_pl <- pl$DataFrame(x1 = datetime)

          pl_code <- paste0(
            "mutate(test_df, foo = ",
            fun,
            "(x1)) |> pull(foo) |> as.numeric()"
          )
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
      test_df <- tibble(x1 = ymd_hms(datetime))
      test_pl <- as_polars_df(test_df)

      # TODO: lubridate:: needed here otherwise the test_df call uses
      # base::date(), which errors. Why is lubridate::date() not overwriting
      # base::date()?
      expect_equal_or_both_error(
        mutate(test_pl, x1 = lubridate::date(x1)),
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
        test_df <- tibble(x1 = ymd_hms(datetime, tz = "UTC"))
        test_pl <- pl$DataFrame(x1 = ymd_hms(datetime, tz = "UTC"))

        expect_equal_or_both_error(
          mutate(
            test_pl,
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
        test_df <- tibble(x1 = ymd_hms(datetime, tz = "UTC"))
        test_pl <- pl$DataFrame(x1 = ymd_hms(datetime, tz = "UTC"))

        expect_equal_or_both_error(
          mutate(
            test_pl,
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
      test_df <- tibble(x1 = ymd_hms(datetime))
      test_pl <- as_polars_df(test_df)

      expect_equal_or_both_error(
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

test_that("rollbackward and rollforward work - date", {
  for_all(
    tests = 40,
    date = date_(),
    roll_to_first = logical_(len = 1, any_na = TRUE),
    preserve_hms = logical_(len = 1, any_na = TRUE),
    property = function(date, roll_to_first, preserve_hms) {
      date[is.na(date)] <- NA_Date_
      test_df <- tibble(date = as_date(date))
      test_pl <- as_polars_df(test_df)

      # TODO: once the TODO in the implementations is fixed, use `preserve_hms = preserve_hms`
      expect_equal_or_both_error(
        mutate(
          test_df,
          date_rb = rollbackward(
            date,
            roll_to_first = roll_to_first,
            preserve_hms = TRUE
          ),
          date_rf = rollforward(
            date,
            roll_to_first = roll_to_first,
            preserve_hms = TRUE
          )
        ),
        mutate(
          test_df,
          date_rb = rollbackward(
            date,
            roll_to_first = roll_to_first,
            preserve_hms = TRUE
          ),
          date_rf = rollforward(
            date,
            roll_to_first = roll_to_first,
            preserve_hms = TRUE
          )
        )
      )
    }
  )
})

test_that("rollbackward and rollforward work - datetime", {
  for_all(
    datetime = posixct_bounded(
      # Set this lower bound because before that R uses the "LMT" tz when dealing
      # with ancient dates.
      left = as.POSIXct("1850-01-01 00:00:00", tz = "UTC"),
      right = as.POSIXct("2099-01-01 00:00:00", tz = "UTC"),
      any_na = TRUE,
      len = 1
    ),
    roll_to_first = logical_(len = 1, any_na = TRUE),
    preserve_hms = logical_(len = 1, any_na = TRUE),
    property = function(datetime, roll_to_first, preserve_hms) {
      datetime[is.na(datetime)] <- NA_POSIXct_

      # Ideally, this would also need to be checked for different timezones, but
      # then we start hitting a bunch of problems with invalid timezones, cases
      # where Polars and R likely don't have the same list of timezones, or
      # OS differences. I couldn't find a way to reliably test for those.
      # One of this edge cases (among many):
      # https://github.com/etiennebacher/tidypolars/pull/252/commits/5e2acdcccb912bf034d23534865bce12b755d82b

      test_df <- tibble(datetime = datetime)
      test_pl <- as_polars_df(test_df)

      expect_equal_or_both_error(
        mutate(
          test_df,
          datetime_rb = rollbackward(
            datetime,
            roll_to_first = roll_to_first,
            preserve_hms = preserve_hms
          ),
          datetime_rf = rollforward(
            datetime,
            roll_to_first = roll_to_first,
            preserve_hms = preserve_hms
          )
        ),
        mutate(
          test_df,
          datetime_rb = rollbackward(
            datetime,
            roll_to_first = roll_to_first,
            preserve_hms = preserve_hms
          ),
          datetime_rf = rollforward(
            datetime,
            roll_to_first = roll_to_first,
            preserve_hms = preserve_hms
          )
        )
      )
    }
  )
})
