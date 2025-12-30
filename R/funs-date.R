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
pl_date_lubridate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$date()
}

pl_now_lubridate <- function(tzone = "") {
  pl$lit(lubridate::now(tzone = tzone))
}


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

pl_weeks_lubridate <- function(x = 1) {
  x <- polars_expr_to_r(x)
  check_number_whole(x, allow_na = TRUE)
  pl$duration(weeks = x)
}
pl_days_lubridate <- function(x = 1) {
  x <- polars_expr_to_r(x)
  check_number_whole(x, allow_na = TRUE)
  pl$duration(days = x)
}
pl_hours_lubridate <- function(x = 1) {
  x <- polars_expr_to_r(x)
  check_number_whole(x, allow_na = TRUE)
  pl$duration(hours = x)
}
pl_minutes_lubridate <- function(x = 1) {
  x <- polars_expr_to_r(x)
  check_number_whole(x, allow_na = TRUE)
  pl$duration(minutes = x)
}

# Those don't have the integer check
pl_seconds_lubridate <- function(x = 1) {
  pl$duration(seconds = x)
}
pl_milliseconds_lubridate <- function(x = 1) {
  pl$duration(milliseconds = x)
}
pl_microseconds_lubridate <- function(x = 1) {
  pl$duration(microseconds = x)
}
pl_nanoseconds_lubridate <- function(x = 1) {
  pl$duration(nanoseconds = x)
}

# Intervals --------------------------------------

# Other modification functions -------------------------------------------
pl_force_tz_lubridate <- function(time, tzone = "", ...) {
  check_empty_dots(...)
  tzone <- check_timezone(tzone, empty_allowed = TRUE)

  time$dt$replace_time_zone(tzone)
}

pl_rollbackward_lubridate <- function(
  dates,
  roll_to_first = FALSE,
  preserve_hms = TRUE
) {
  roll_to_first <- polars_expr_to_r(roll_to_first)
  preserve_hms <- polars_expr_to_r(preserve_hms)
  check_bool(roll_to_first)
  check_bool(preserve_hms)

  out <- dates$dt$month_start()
  if (isFALSE(roll_to_first)) {
    out <- out$dt$offset_by("-1d")
  }
  if (isFALSE(preserve_hms)) {
    # TODO: When I have the tool to detect the datatype, then I can use
    # $cast(pl$Datetime(time_zone = "UTC")) if `out` is a Date column.
    # Fix property tests for date.
    # Also remove the note in vignette.
    out <- out$dt$replace(hour = 0, minute = 0, second = 0)
  }
  out
}

pl_rollback_lubridate <- pl_rollbackward_lubridate

pl_rollforward_lubridate <- function(
  dates,
  roll_to_first = FALSE,
  preserve_hms = TRUE
) {
  roll_to_first <- polars_expr_to_r(roll_to_first)
  preserve_hms <- polars_expr_to_r(preserve_hms)
  check_bool(roll_to_first)
  check_bool(preserve_hms)

  out <- dates$dt$month_end()
  if (isTRUE(roll_to_first)) {
    out <- out$dt$offset_by("1d")
  }
  if (isFALSE(preserve_hms)) {
    out <- out$dt$replace(hour = 0, minute = 0, second = 0, microsecond = 0)
  }
  out
}

# Had to change here default argument from `tzone=""` to
# `tzone = "UTC"`, to avoid error since the polars
# `convert_time_zone()` doesn't support NULL timezone
pl_with_tz_lubridate <- function(time, tzone = "UTC", ...) {
  check_empty_dots(...)
  tzone <- check_timezone(tzone, empty_allowed = FALSE)

  time$dt$convert_time_zone(tzone)
}

# OLD IMPLEMENTATIONS

# pl_strftime <- function(x, ...) {
#   check_empty_dots(...)
#   x$dt$strftime()
# }

pl_strptime <- function(string, format, tz = "", strict = TRUE, ...) {
  check_empty_dots(...)
  if (grepl("%(I|H|c|T|M|p|r|R|S|X|z)", format)) {
    dtype <- pl$Datetime("us", tz = tz)
  } else {
    dtype <- pl$Date
  }
  string$str$strptime(dtype = dtype, format = format, strict = strict)
}

# pl_timestamp <- function(x, ...) {
#   check_empty_dots(...)
#   x$dt$timestamp()
# }

# pl_truncate <- function(x, ...) {
#   check_empty_dots(...)
#   x$dt$truncate()
# }

# pl_tz_localize <- function(x, ...) {
#   check_empty_dots(...)
#   x$dt$tz_localize()
# }

# wday() implementation
# Conversion formula: (polars_weekday - week_start + 7) % 7 + 1
pl_wday_lubridate <- function(
  x,
  label = FALSE,
  abbr = TRUE,
  week_start = getOption("lubridate.week.start", 7),
  ...
) {
  check_empty_dots(...)
  env <- env_from_dots(...)
  week_start <- polars_expr_to_r(week_start)
  check_number_whole(
    week_start,
    min = 1,
    max = 7,
    allow_na = FALSE,
    arg = "week_start",
    call = env
  )

  if (isTRUE(label)) {
    if (isTRUE(abbr)) {
      out <- x$dt$strftime("%a")
    } else {
      out <- x$dt$strftime("%A")
    }
  } else {
    out <- (x$dt$weekday() - as.integer(week_start) + 7L) %% 7L + 1L
  }
  out
}

# Other date-time components --------------------------------------

pl_am_lubridate <- function(x) {
  x$dt$hour() < 12
}

pl_pm_lubridate <- function(x) {
  x$dt$hour() >= 12
}

pl_days_in_month_lubridate <- function(x) {
  pl$when(x$is_null())$then(NA)$when(
    x$dt$month()$is_in(list(c(1, 3, 5, 7, 8, 10, 12)))
  )$then(31)$when(
    x$dt$month()$is_in(list(c(4, 6, 9, 11)))
  )$then(30)$when(x$dt$month() == 2 & x$dt$is_leap_year())$then(29)$otherwise(
    28
  )$cast(pl$Int32)
}

pl_leap_year_lubridate <- function(x) {
  x$dt$is_leap_year()
}
