### Organization based on lubridate sections here:
### https://lubridate.tidyverse.org/reference/index.html

# Date/time parsing --------------------------------------

pl_ymd <- function(x, ...) {
  check_empty_dots(...)
  # I can't specify a particular format: lubridate::ymd() can detect "2009/01/01"
  # and "2009-01-01" for example. I have to rely on polars' guessing, even if
  # it is less performant
  x$str$strptime(pl$Date, format = NULL, strict = FALSE)
}

pl_ydm <- pl_mdy<- pl_myd <- pl_dmy<- pl_dym <- pl_ym <- pl_my <- pl_ymd

pl_ymd_hms <- function(x, ...) {
  check_empty_dots(...)
  x$str$strptime(pl$Datetime("ms"), format = NULL, strict = FALSE)
}


# Setting/getting/rounding --------------------------------------

pl_year <- function(x, ...) {
  check_empty_dots(...)
  x$dt$year()
}

pl_isoyear <- function(x, ...) {
  check_empty_dots(...)
  x$dt$iso_year()
}

pl_quarter <- function(x, ...) {
  check_empty_dots(...)
  x$dt$quarter()
}

pl_month <- function(x, ...) {
  check_empty_dots(...)
  x$dt$month()
}

pl_week <- function(x, ...) {
  check_empty_dots(...)
  x$dt$week()
}

pl_day <- function(x, ...) {
  check_empty_dots(...)
  x$dt$day()
}

# TODO: doesn't work because lubridate's default is start counting from Sundays
# (and has an option to change that)
pl_wday <- function(x, ...) {
  x$dt$weekday()
}

pl_mday <- pl_day

pl_yday <- function(x, ...) {
  x$dt$ordinal_day()
}

pl_hour <- function(x, ...) {
  check_empty_dots(...)
  x$dt$hour()
}

pl_minute <- function(x, ...) {
  check_empty_dots(...)
  x$dt$minute()
}

pl_second <- function(x, ...) {
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

pl_dweeks <- function(x, ...) {
  pl$duration(weeks = x)
}

pl_ddays <- function(x, ...) {
  pl$duration(days = x)
}

pl_dhours <- function(x, ...) {
  pl$duration(hours = x)
}

pl_dminutes <- function(x, ...) {
  pl$duration(minutes = x)
}

pl_dseconds <- function(x, ...) {
  pl$duration(seconds = x)
}

pl_dmilliseconds <- function(x, ...) {
  pl$duration(milliseconds = x)
}

pl_dmicroseconds <- function(x, ...) {
  pl$duration(microseconds = x)
}

pl_dnanoseconds <- function(x, ...) {
  pl$duration(nanoseconds = x)
}

pl_make_date <- function(year = 1970, month = 1, day = 1) {
  pl$date(year = year, month = month, day = day)
}

pl_make_datetime <- function(
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




pl_default_round <- function(x, ...) {
  check_empty_dots(...)
  x$default$round()
}

pl_epoch <- function(x, ...) {
  check_empty_dots(...)
  x$dt$epoch()
}


pl_hours <- function(x, ...) {
  check_empty_dots(...)
  x$dt$hours()
}

pl_microsecond <- function(x, ...) {
  check_empty_dots(...)
  x$dt$microsecond()
}

pl_microseconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$microseconds()
}

pl_millisecond <- function(x, ...) {
  check_empty_dots(...)
  x$dt$millisecond()
}

pl_milliseconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$milliseconds()
}

pl_minutes <- function(x, ...) {
  check_empty_dots(...)
  x$dt$minutes()
}


pl_nanosecond <- function(x, ...) {
  check_empty_dots(...)
  x$dt$nanosecond()
}

pl_nanoseconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$nanoseconds()
}

pl_offset_by <- function(x, ...) {
  check_empty_dots(...)
  x$dt$offset_by()
}

pl_ordinal_day <- function(x, ...) {
  check_empty_dots(...)
  x$dt$ordinal_day()
}


pl_replace_time_zone <- function(x, ...) {
  check_empty_dots(...)
  x$dt$replace_time_zone()
}

pl_seconds <- function(x, ...) {
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
pl_weekday <- function(x, ...) {
  check_empty_dots(...)
  x$dt$weekday()
}

pl_with_time_unit <- function(x, ...) {
  check_empty_dots(...)
  x$dt$with_time_unit()
}


