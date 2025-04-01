### [GENERATED AUTOMATICALLY] Update test-funs_date.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("extracting components of date works", {
  test_df <- data.frame(
    YMD = as.Date(c("2012-03-26", "2020-01-01", "2023-12-14", NA)),
    YMD_tz = ymd(
      c("2012-03-26", "2020-01-01", "2023-12-14", NA),
      tz = "America/Chicago"
    ),
    # DMY = c("26-03-2012", "01-01-2020", "14-12-2023"),
    # YDM = c("2012-26-03", "2020-01-01", "2023-14-12"),
    # MDY = c("03-26-2012", "01-01-2020", "12-14-2023")
    YMD_HMS = ymd_hms(
      c("2012-03-26 12:00:00", "2020-01-01 12:00:00", "2023-12-14 12:00:00", NA)
    ),
    to_ymd_hms = c(
      "2012-03-26 12:00:00",
      "2020-01-01 12:00:00",
      "2023-12-14 12:00:00",
      NA
    ),
    to_ymd_hm = c(
      "2012-03-26 12:00",
      "2020-01-01 12:00",
      "2023-12-14 12:00",
      NA
    ),
    somedate = c("Jul 24 2014", "Dec 24 2015", "Jan 21 2016", NA),
    y = c(2020:2022, NA),
    m = c(1, 2, 20, 3),
    d = 1:4,
    h = 0:3,
    min = 24:27,
    s = 55:58
  )
  test <- as_polars_lf(test_df)

  for (i in c("year", "month", "day", "quarter", "week", "mday", "yday")) {
    pol <- paste0("mutate(test, foo = ", i, "(YMD))") |>
      str2lang() |>
      eval() |>
      pull(foo)

    res <- paste0("mutate(test_df, foo = ", i, "(YMD))") |>
      str2lang() |>
      eval() |>
      pull(foo)

    expect_equal_lazy(pol, res, info = i)
  }

  for (i in c("hour", "minute", "second")) {
    pol <- paste0("mutate(test, foo = ", i, "(YMD_HMS))") |>
      str2lang() |>
      eval() |>
      pull(foo)

    res <- paste0("mutate(test_df, foo = ", i, "(YMD_HMS))") |>
      str2lang() |>
      eval() |>
      pull(foo)

    expect_equal_lazy(pol, res, info = i)
  }

  # TODO: fix timezone attributes
  # for (i in c("ymd_hms", "ymd_hm")) {
  #   pol <- paste0("mutate(test, to_", i, "  = ", i, "(to_", i, "))") |>
  #     str2lang() |>
  #     eval() |>
  #     as.data.frame()
  #
  #   res <- paste0("mutate(test_df, to_", i, "  = ", i, "(to_", i, "))") |>
  #     str2lang() |>
  #     eval()
  #
  #   expect_equal_lazy(pol, res, info = i)
  # }
})

test_that("weekday is a special function", {
  test_df <- data.frame(
    YMD = as.Date(c("2012-03-26", "2020-01-01", "2023-12-14", NA)),
    YMD_tz = ymd(
      c("2012-03-26", "2020-01-01", "2023-12-14", NA),
      tz = "America/Chicago"
    ),
    # DMY = c("26-03-2012", "01-01-2020", "14-12-2023"),
    # YDM = c("2012-26-03", "2020-01-01", "2023-14-12"),
    # MDY = c("03-26-2012", "01-01-2020", "12-14-2023")
    YMD_HMS = ymd_hms(
      c("2012-03-26 12:00:00", "2020-01-01 12:00:00", "2023-12-14 12:00:00", NA)
    ),
    to_ymd_hms = c(
      "2012-03-26 12:00:00",
      "2020-01-01 12:00:00",
      "2023-12-14 12:00:00",
      NA
    ),
    to_ymd_hm = c(
      "2012-03-26 12:00",
      "2020-01-01 12:00",
      "2023-12-14 12:00",
      NA
    ),
    somedate = c("Jul 24 2014", "Dec 24 2015", "Jan 21 2016", NA),
    y = c(2020:2022, NA),
    m = c(1, 2, 20, 3),
    d = 1:4,
    h = 0:3,
    min = 24:27,
    s = 55:58
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    test |>
      mutate(foo = wday(YMD)),
    test_df |>
      mutate(foo = wday(YMD))
  )

  expect_error_lazy(
    test |> mutate(foo = wday(YMD, week_start = 1)),
    "Currently, tidypolars only works if `week_start` is 7."
  )

  expect_equal_lazy(
    test |>
      mutate(foo = wday(YMD, label = TRUE)) |>
      pull(foo),
    c("Mon", "Wed", "Thu", NA)
  )
  expect_equal_lazy(
    test |>
      mutate(foo = wday(YMD, label = TRUE, abbr = FALSE)) |>
      pull(foo),
    c("Monday", "Wednesday", "Thursday", NA)
  )
})

test_that("strptime() works", {
  test_df <- data.frame(
    YMD = as.Date(c("2012-03-26", "2020-01-01", "2023-12-14", NA)),
    YMD_tz = ymd(
      c("2012-03-26", "2020-01-01", "2023-12-14", NA),
      tz = "America/Chicago"
    ),
    # DMY = c("26-03-2012", "01-01-2020", "14-12-2023"),
    # YDM = c("2012-26-03", "2020-01-01", "2023-14-12"),
    # MDY = c("03-26-2012", "01-01-2020", "12-14-2023")
    YMD_HMS = ymd_hms(
      c("2012-03-26 12:00:00", "2020-01-01 12:00:00", "2023-12-14 12:00:00", NA)
    ),
    to_ymd_hms = c(
      "2012-03-26 12:00:00",
      "2020-01-01 12:00:00",
      "2023-12-14 12:00:00",
      NA
    ),
    to_ymd_hm = c(
      "2012-03-26 12:00",
      "2020-01-01 12:00",
      "2023-12-14 12:00",
      NA
    ),
    somedate = c("Jul 24 2014", "Dec 24 2015", "Jan 21 2016", NA),
    y = c(2020:2022, NA),
    m = c(1, 2, 20, 3),
    d = 1:4,
    h = 0:3,
    min = 24:27,
    s = 55:58
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    test |>
      mutate(foo = strptime(somedate, "%b %d %Y")) |>
      pull(foo),
    as.Date(c("2014-07-24", "2015-12-24", "2016-01-21", NA))
  )
})

test_that("isoyear (test taken from the lubridate test suite)", {
  df <- read.table(
    textConnection(
      "Sat 1 Jan 2005 	2005-01-01 	2004-W53-6
      Sun 2 Jan 2005 	2005-01-02 	2004-W53-7
      Sat 31 Dec 2005 	2005-12-31 	2005-W52-6
      Mon 1 Jan 2007 	2007-01-01 	2007-W01-1 	Both years 2007 start with the same day.
      Sun 30 Dec 2007 	2007-12-30 	2007-W52-7
      Mon 31 Dec 2007 	2007-12-31 	2008-W01-1
      Tue 1 Jan 2008 	2008-01-01 	2008-W01-2 	Gregorian year 2008 is a leap year. ISO year 2008 is 2 days shorter: 1 day longer at the start, 3 days shorter at the end.
      Sun 28 Dec 2008 	2008-12-28 	2008-W52-7 	ISO year 2009 begins three days before the end of Gregorian 2008.
      Mon 29 Dec 2008 	2008-12-29 	2009-W01-1
      Tue 30 Dec 2008 	2008-12-30 	2009-W01-2
      Wed 31 Dec 2008 	2008-12-31 	2009-W01-3
      Thu 1 Jan 2009 	2009-01-01 	2009-W01-4
      Thu 31 Dec 2009 	2009-12-31 	2009-W53-4 	ISO year 2009 has 53 weeks and ends three days into Gregorian year 2010.
      Fri 1 Jan 2010 	2010-01-01 	2009-W53-5
      Sat 2 Jan 2010 	2010-01-02 	2009-W53-6
      Sun 3 Jan 2010 	2010-01-03 	2009-W53-7"
    ),
    sep = "\t",
    fill = TRUE,
    stringsAsFactors = FALSE,
    header = FALSE
  )

  names(df) <- c("Gregorian", "ymd", "iso", "note")
  df <- mutate(
    df,
    ymd = ymd(ymd),
    isoweek = as.numeric(gsub(".*W([0-9]+).*", "\\1", iso)),
    isoyear = as.numeric(gsub("^([0-9]+).*", "\\1", iso))
  )
  df_pl <- as_polars_lf(df)

  expect_equal_lazy(
    mutate(df_pl, ymd = isoyear(ymd)) |>
      pull(ymd),
    df$isoyear
  )
})

test_that("handling durations work", {
  test_df <- data.frame(
    YMD = as.Date(c("2012-03-26", "2020-01-01", "2023-12-14", NA)),
    YMD_tz = ymd(
      c("2012-03-26", "2020-01-01", "2023-12-14", NA),
      tz = "America/Chicago"
    ),
    # DMY = c("26-03-2012", "01-01-2020", "14-12-2023"),
    # YDM = c("2012-26-03", "2020-01-01", "2023-14-12"),
    # MDY = c("03-26-2012", "01-01-2020", "12-14-2023")
    YMD_HMS = ymd_hms(
      c("2012-03-26 12:00:00", "2020-01-01 12:00:00", "2023-12-14 12:00:00", NA)
    ),
    to_ymd_hms = c(
      "2012-03-26 12:00:00",
      "2020-01-01 12:00:00",
      "2023-12-14 12:00:00",
      NA
    ),
    to_ymd_hm = c(
      "2012-03-26 12:00",
      "2020-01-01 12:00",
      "2023-12-14 12:00",
      NA
    ),
    somedate = c("Jul 24 2014", "Dec 24 2015", "Jan 21 2016", NA),
    y = c(2020:2022, NA),
    m = c(1, 2, 20, 3),
    d = 1:4,
    h = 0:3,
    min = 24:27,
    s = 55:58
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    test |>
      mutate(foo = YMD + dweeks(3) + ddays(5)) |>
      pull(foo),
    test_df |>
      mutate(foo = YMD + dweeks(3) + ddays(5)) |>
      pull(foo)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = YMD_tz + dweeks(3) + ddays(5)) |>
      pull(foo),
    test_df |>
      mutate(foo = YMD_tz + dweeks(3) + ddays(5)) |>
      pull(foo)
  )

  # TODO: should return NAs
  expect_error_lazy(
    test |>
      mutate(foo = NA + dweeks(3) + ddays(5)) |>
      pull(foo)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = YMD_HMS + dhours(3) + dminutes(5)) |>
      pull(foo),
    test_df |>
      mutate(foo = YMD_HMS + dhours(3) + dminutes(5)) |>
      pull(foo)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = YMD_HMS + dseconds(3) + dmilliseconds(5)) |>
      pull(foo),
    test_df |>
      mutate(foo = YMD_HMS + dseconds(3) + dmilliseconds(5)) |>
      pull(foo)
  )

  # TODO: will be hard to check for accuracy for microseconds and nanoseconds
})

test_that("make_date() works", {
  test_df <- data.frame(
    YMD = as.Date(c("2012-03-26", "2020-01-01", "2023-12-14", NA)),
    YMD_tz = ymd(
      c("2012-03-26", "2020-01-01", "2023-12-14", NA),
      tz = "America/Chicago"
    ),
    # DMY = c("26-03-2012", "01-01-2020", "14-12-2023"),
    # YDM = c("2012-26-03", "2020-01-01", "2023-14-12"),
    # MDY = c("03-26-2012", "01-01-2020", "12-14-2023")
    YMD_HMS = ymd_hms(
      c("2012-03-26 12:00:00", "2020-01-01 12:00:00", "2023-12-14 12:00:00", NA)
    ),
    to_ymd_hms = c(
      "2012-03-26 12:00:00",
      "2020-01-01 12:00:00",
      "2023-12-14 12:00:00",
      NA
    ),
    to_ymd_hm = c(
      "2012-03-26 12:00",
      "2020-01-01 12:00",
      "2023-12-14 12:00",
      NA
    ),
    somedate = c("Jul 24 2014", "Dec 24 2015", "Jan 21 2016", NA),
    y = c(2020:2022, NA),
    m = c(1, 2, 20, 3),
    d = 1:4,
    h = 0:3,
    min = 24:27,
    s = 55:58
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    test |>
      mutate(foo = make_date(year = y, m, d)) |>
      pull(foo),
    test_df |>
      mutate(foo = make_date(year = y, m, d)) |>
      pull(foo)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = make_date(year = y)) |>
      pull(foo),
    test_df |>
      mutate(foo = make_date(year = y)) |>
      pull(foo)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = make_date(year = y, m, d)) |>
      pull(foo),
    test_df |>
      mutate(foo = make_date(year = y, m, d)) |>
      pull(foo)
  )
})

test_that("make_datetime() works", {
  test_df <- data.frame(
    YMD = as.Date(c("2012-03-26", "2020-01-01", "2023-12-14", NA)),
    YMD_tz = ymd(
      c("2012-03-26", "2020-01-01", "2023-12-14", NA),
      tz = "America/Chicago"
    ),
    # DMY = c("26-03-2012", "01-01-2020", "14-12-2023"),
    # YDM = c("2012-26-03", "2020-01-01", "2023-14-12"),
    # MDY = c("03-26-2012", "01-01-2020", "12-14-2023")
    YMD_HMS = ymd_hms(
      c("2012-03-26 12:00:00", "2020-01-01 12:00:00", "2023-12-14 12:00:00", NA)
    ),
    to_ymd_hms = c(
      "2012-03-26 12:00:00",
      "2020-01-01 12:00:00",
      "2023-12-14 12:00:00",
      NA
    ),
    to_ymd_hm = c(
      "2012-03-26 12:00",
      "2020-01-01 12:00",
      "2023-12-14 12:00",
      NA
    ),
    somedate = c("Jul 24 2014", "Dec 24 2015", "Jan 21 2016", NA),
    y = c(2020:2022, NA),
    m = c(1, 2, 20, 3),
    d = 1:4,
    h = 0:3,
    min = 24:27,
    s = 55:58
  )
  test <- as_polars_lf(test_df)

  # setting hour = 25 adds 1 day + 1 hour, which is not the behavior of
  # ISOdatetime() or pl$datetime()

  expect_equal_lazy(
    test |>
      mutate(foo = make_datetime(hour = h, min = min, sec = s)) |>
      pull(foo),
    test_df |>
      mutate(foo = make_datetime(hour = h, min = min, sec = s)) |>
      pull(foo)
  )

  expect_equal_lazy(
    test |>
      mutate(
        foo = make_datetime(
          hour = 6,
          min = min,
          sec = s,
          tz = "Australia/Sydney"
        )
      ) |>
      pull(foo),
    test_df |>
      mutate(
        foo = make_datetime(
          hour = 6,
          min = min,
          sec = s,
          tz = "Australia/Sydney"
        )
      ) |>
      pull(foo)
  )
})

test_that("ISOdatetime() works", {
  test_df <- data.frame(
    YMD = as.Date(c("2012-03-26", "2020-01-01", "2023-12-14", NA)),
    YMD_tz = ymd(
      c("2012-03-26", "2020-01-01", "2023-12-14", NA),
      tz = "America/Chicago"
    ),
    # DMY = c("26-03-2012", "01-01-2020", "14-12-2023"),
    # YDM = c("2012-26-03", "2020-01-01", "2023-14-12"),
    # MDY = c("03-26-2012", "01-01-2020", "12-14-2023")
    YMD_HMS = ymd_hms(
      c("2012-03-26 12:00:00", "2020-01-01 12:00:00", "2023-12-14 12:00:00", NA)
    ),
    to_ymd_hms = c(
      "2012-03-26 12:00:00",
      "2020-01-01 12:00:00",
      "2023-12-14 12:00:00",
      NA
    ),
    to_ymd_hm = c(
      "2012-03-26 12:00",
      "2020-01-01 12:00",
      "2023-12-14 12:00",
      NA
    ),
    somedate = c("Jul 24 2014", "Dec 24 2015", "Jan 21 2016", NA),
    y = c(2020:2022, NA),
    m = c(1, 2, 20, 3),
    d = 1:4,
    h = 0:3,
    min = 24:27,
    s = 55:58
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    test |>
      mutate(
        foo = ISOdatetime(
          year = 0,
          month = 1,
          day = 1,
          hour = h,
          min = min,
          sec = s
        )
      ) |>
      pull(foo),
    test_df |>
      mutate(
        foo = ISOdatetime(
          year = 0,
          month = 1,
          day = 1,
          hour = h,
          min = min,
          sec = s
        )
      ) |>
      pull(foo),
    ignore_attr = TRUE
  )

  expect_equal_lazy(
    test |>
      mutate(
        foo = ISOdatetime(
          year = 0,
          month = 1,
          day = 1,
          hour = 6,
          min = min,
          sec = s,
          tz = "Australia/Sydney"
        )
      ) |>
      pull(foo),
    test_df |>
      mutate(
        foo = ISOdatetime(
          year = 0,
          month = 1,
          day = 1,
          hour = 6,
          min = min,
          sec = s,
          tz = "Australia/Sydney"
        )
      ) |>
      pull(foo),
    ignore_attr = TRUE
  )

  expect_equal_lazy(
    test |>
      mutate(
        foo = ISOdatetime(
          year = 0,
          month = 1,
          day = 1,
          hour = 25,
          min = min,
          sec = s,
          tz = "Australia/Sydney"
        )
      ) |>
      pull(foo),
    test_df |>
      mutate(
        foo = ISOdatetime(
          year = 0,
          month = 1,
          day = 1,
          hour = 25,
          min = min,
          sec = s,
          tz = "Australia/Sydney"
        )
      ) |>
      pull(foo),
    ignore_attr = TRUE
  )
})

test_that("am/pm work", {
  test_df <- data.frame(
    datetime = ymd_hms(
      c(
        "2012-03-26 00:00:00",
        "2012-03-26 11:30:20",
        "2020-01-01 12:00:00",
        "2023-12-14 24:00:00",
        NA
      )
    )
  )
  test <- as_polars_lf(test_df)
  expect_equal_lazy(
    test |>
      mutate(
        am = am(datetime),
        pm = pm(datetime)
      ),
    test_df |>
      mutate(
        am = am(datetime),
        pm = pm(datetime)
      )
  )

  expect_error_lazy(
    pl$LazyFrame(x = as.Date("2020-01-01")) |>
      mutate(x = am(x)),
    "not supported for dtype `date`"
  )
})

test_that("days_in_month() works", {
  test_df <- data.frame(
    x = ymd_hms(
      c(
        "2012-03-26 00:00:00",
        "2011-02-26 11:30:20",
        "2012-02-26 11:30:20", # leap year
        "2023-11-14 24:00:00",
        NA
      )
    )
  )
  test <- as_polars_lf(test_df)
  expect_equal_lazy(
    mutate(test, x = days_in_month(x)),
    mutate(test_df, x = days_in_month(x)),
    # lubridate output is a named integer vector
    ignore_attr = TRUE
  )
})

test_that("leap_year() works", {
  test_df <- data.frame(
    date = ymd(c("2011-02-26", "2012-02-26", NA)),
    datetime = ymd_hms(
      c(
        "2011-02-26 11:30:20",
        "2012-02-26 11:30:20", # leap year
        NA
      )
    )
  )
  test <- as_polars_lf(test_df)
  expect_equal_lazy(
    mutate(test, date = leap_year(date)),
    mutate(test_df, date = leap_year(date))
  )
  expect_equal_lazy(
    mutate(test, datetime = leap_year(datetime)),
    mutate(test_df, datetime = leap_year(datetime))
  )
})


test_that("date() works", {
  datetime <- c("2021-03-04 10:01:00", "1990-12-01 00:01:00")
  test_df <- data.frame(x1 = ymd_hms(datetime, tz = "UTC"))
  test <- pl$LazyFrame(x1 = ymd_hms(datetime, tz = "UTC"))

  expect_equal_lazy(
    test |>
      mutate(foo = date(x1)),
    test_df |>
      mutate(foo = date(x1))
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
