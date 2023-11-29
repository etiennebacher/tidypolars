pl_cast_time_unit <- function(x, ...) {
  check_empty_dots(...)
  x$dt$cast_time_unit()
}

pl_combine <- function(x, ...) {
  check_empty_dots(...)
  x$dt$combine()
}

pl_convert_time_zone <- function(x, ...) {
  check_empty_dots(...)
  x$dt$convert_time_zone()
}

pl_day <- function(x, ...) {
  check_empty_dots(...)
  x$dt$day()
}

pl_days <- function(x, ...) {
  check_empty_dots(...)
  x$dt$days()
}

pl_default_round <- function(x, ...) {
  check_empty_dots(...)
  x$default$round()
}

pl_epoch <- function(x, ...) {
  check_empty_dots(...)
  x$dt$epoch()
}

pl_hour <- function(x, ...) {
  check_empty_dots(...)
  x$dt$hour()
}

pl_hours <- function(x, ...) {
  check_empty_dots(...)
  x$dt$hours()
}

pl_iso_year <- function(x, ...) {
  check_empty_dots(...)
  x$dt$iso_year()
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

pl_minute <- function(x, ...) {
  check_empty_dots(...)
  x$dt$minute()
}

pl_minutes <- function(x, ...) {
  check_empty_dots(...)
  x$dt$minutes()
}

pl_mday <- pl_day


pl_month <- function(x, ...) {
  check_empty_dots(...)
  x$dt$month()
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

pl_quarter <- function(x, ...) {
  check_empty_dots(...)
  x$dt$quarter()
}

pl_replace_time_zone <- function(x, ...) {
  check_empty_dots(...)
  x$dt$replace_time_zone()
}

pl_round <- function(x, ...) {
  check_empty_dots(...)
  x$dt$round()
}

pl_second <- function(x, ...) {
  check_empty_dots(...)
  x$dt$second()
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
    datatype = pl$Datetime("us", tz = tz)
  } else {
    datatype = pl$Date
  }
  string$str$strptime(datatype = datatype, format = format, strict = strict)
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

pl_week <- function(x, ...) {
  check_empty_dots(...)
  x$dt$week()
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

pl_year <- function(x, ...) {
  check_empty_dots(...)
  x$dt$year()
}

pl_yday <- function(x, ...) {
  x$dt$ordinal_day()
}

pl_ymd_hms <- function(x, ...) {
  check_empty_dots(...)
  x$str$strptime(pl$Datetime("ms"), "%Y-%m-%d %H:%M:%S", strict = FALSE)
}

pl_ymd_hm <- function(x, ...) {
  check_empty_dots(...)
  x$str$strptime(pl$Datetime("ms"), "%Y-%m-%d %H:%M", strict = FALSE)
}
