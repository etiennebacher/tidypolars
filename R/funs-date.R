### Organization based on lubridate sections here:
### https://lubridate.tidyverse.org/reference/index.html

# Date/time parsing --------------------------------------

pl_ymd_lubridate <- function(x, ...) {
  check_empty_dots(...)
  # I can't specify a particular format: lubridate::ymd() can detect "2009/01/01"
  # and "2009-01-01" for example. I have to rely on polars' guessing, even if
  # it is less performant
  x$str$strptime(pl$Date, format = NULL, strict = FALSE)
}

pl_ydm_lubridate <- pl_mdy_lubridate <- pl_myd_lubridate <- pl_dmy_lubridate <- pl_dym_lubridate <- pl_ym_lubridate <- pl_my_lubridate <- pl_ymd_lubridate

pl_ymd_hms_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$str$strptime(pl$Datetime("ms"), format = NULL, strict = FALSE)
}


# Setting/getting/rounding --------------------------------------

pl_year_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$year()
}

pl_isoyear_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$iso_year()
}

pl_quarter_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$quarter()
}

pl_month_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$month()
}

pl_week_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$week()
}

pl_day_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$day()
}

# TODO: doesn't work because lubridate's default is start counting from Sundays
# (and has an option to change that)
pl_wday_lubridate <- function(x, ...) {
  x$dt$weekday()
}

pl_mday_lubridate <- pl_day_lubridate

pl_yday_lubridate <- function(x, ...) {
  x$dt$ordinal_day()
}

pl_hour_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$hour()
}

pl_minute_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$minute()
}

pl_second_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$second()
}


# Date-time helpers --------------------------------------


# Durations --------------------------------------

# TODO: annoying to parse `...` because of partial matching of args, e.g
# duration(second = 3, weeks = 1) and duration(second = 3, we = 1) are the same
# pl_duration <- function(num = NULL, units = "seconds", ...) {
#   pl$duration(weeks = x)
# }

pl_dweeks_lubridate <- function(x, ...) {
  pl$duration(weeks = x)
}

pl_ddays_lubridate <- function(x, ...) {
  pl$duration(days = x)
}

pl_dhours_lubridate <- function(x, ...) {
  pl$duration(hours = x)
}

pl_dminutes_lubridate <- function(x, ...) {
  pl$duration(minutes = x)
}

pl_dseconds_lubridate <- function(x, ...) {
  pl$duration(seconds = x)
}

pl_dmilliseconds_lubridate <- function(x, ...) {
  pl$duration(milliseconds = x)
}

pl_dmicroseconds_lubridate <- function(x, ...) {
  pl$duration(microseconds = x)
}

pl_dnanoseconds_lubridate <- function(x, ...) {
  pl$duration(nanoseconds = x)
}

pl_make_date_lubridate <- function(year = 1970, month = 1, day = 1) {
  pl$date(year = year, month = month, day = day)
}

pl_make_datetime_lubridate <- function(
    year = 1970,
    month = 1,
    day = 1,
    hour = 0,
    min = 0,
    sec = 0,
    tz = "UTC"
) {
  pl$datetime(
    year = year,
    month = month,
    day = day,
    hour = hour,
    minute = min,
    second = sec,
    time_zone = tz
  )
}

pl_ISOdatetime <- function(
    year = 1970,
    month = 1,
    day = 1,
    hour = 0,
    min = 0,
    sec = 0,
    tz = ""
) {
  if (tz == "") {
    tz <- Sys.timezone()
  }
  pl$datetime(
    year = year,
    month = month,
    day = day,
    hour = hour,
    minute = min,
    second = sec,
    time_zone = tz
  )
}


# Periods --------------------------------------


# Intervals --------------------------------------




# OLD IMPLEMENTATIONS

pl_hours_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$hours()
}

pl_microsecond_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$microsecond()
}

pl_microseconds_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$microseconds()
}

pl_millisecond_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$millisecond()
}

pl_milliseconds_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$milliseconds()
}

pl_minutes_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$minutes()
}


pl_nanosecond_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$nanosecond()
}

pl_nanoseconds_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$nanoseconds()
}

pl_seconds_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$seconds()
}

pl_strftime <- function(x, ...) {
  check_empty_dots(...)
  x$dt$strftime()
}

pl_strptime <- function(string, format, tz = "", strict = TRUE, ...) {
  check_empty_dots(...)
  if (grepl("%(I|H|c|T|M|p|r|R|S|X|z)", format)) {
    dtype = pl$Datetime("us", tz = tz)
  } else {
    dtype = pl$Date
  }
  string$str$strptime(dtype = dtype, format = format, strict = strict)
}

pl_timestamp <- function(x, ...) {
  check_empty_dots(...)
  x$dt$timestamp()
}

pl_truncate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$truncate()
}

pl_tz_localize <- function(x, ...) {
  check_empty_dots(...)
  x$dt$tz_localize()
}


# TODO: check the day of weekstart (lubridate starts the
# week on sunday, polars on monday)
pl_wday_lubridate <- function(
    x,
    label = FALSE,
    abbr = TRUE,
    week_start = getOption("lubridate.week.start", 7),
    ...
) {
  check_empty_dots(...)
  env <- env_from_dots(...)
  if (week_start != 7) {
    abort("Currently, tidypolars only works if `week_start` is 7.", call = env)
  }
  if (isTRUE(label)) {
    if (isTRUE(abbr)) {
      out <- x$dt$strftime("%a")
    } else {
      out <- x$dt$strftime("%A")
    }
  } else {
    out <- x$dt$weekday() + 1L
  }
  out
}
