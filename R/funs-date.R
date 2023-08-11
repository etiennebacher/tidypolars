pl_dt_default_round <- function(x, ...) {
  check_empty_dots(...)
  x$default$round()
}

pl_dt_round <- function(x, ...) {
  check_empty_dots(...)
  x$dt$round()
}

pl_dt_cast_time_unit <- function(x, ...) {
  check_empty_dots(...)
  x$dt$cast_time_unit()
}

pl_dt_combine <- function(x, ...) {
  check_empty_dots(...)
  x$dt$combine()
}

pl_dt_convert_time_zone <- function(x, ...) {
  check_empty_dots(...)
  x$dt$convert_time_zone()
}

pl_dt_day <- function(x, ...) {
  check_empty_dots(...)
  x$dt$day()
}

pl_dt_mday <- pl_dt_day

pl_dt_yday <- function(x, ...) {
  x$dt$ordinal_day()
}

pl_dt_days <- function(x, ...) {
  check_empty_dots(...)
  x$dt$days()
}

pl_dt_epoch <- function(x, ...) {
  check_empty_dots(...)
  x$dt$epoch()
}

pl_dt_hour <- function(x, ...) {
  check_empty_dots(...)
  x$dt$hour()
}

pl_dt_hours <- function(x, ...) {
  check_empty_dots(...)
  x$dt$hours()
}

pl_dt_iso_year <- function(x, ...) {
  check_empty_dots(...)
  x$dt$iso_year()
}

pl_dt_microsecond <- function(x, ...) {
  check_empty_dots(...)
  x$dt$microsecond()
}

pl_dt_microseconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$microseconds()
}

pl_dt_millisecond <- function(x, ...) {
  check_empty_dots(...)
  x$dt$millisecond()
}

pl_dt_milliseconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$milliseconds()
}

pl_dt_minute <- function(x, ...) {
  check_empty_dots(...)
  x$dt$minute()
}

pl_dt_minutes <- function(x, ...) {
  check_empty_dots(...)
  x$dt$minutes()
}

pl_dt_month <- function(x, ...) {
  check_empty_dots(...)
  x$dt$month()
}

pl_dt_nanosecond <- function(x, ...) {
  check_empty_dots(...)
  x$dt$nanosecond()
}

pl_dt_nanoseconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$nanoseconds()
}

pl_dt_offset_by <- function(x, ...) {
  check_empty_dots(...)
  x$dt$offset_by()
}

pl_dt_ordinal_day <- function(x, ...) {
  check_empty_dots(...)
  x$dt$ordinal_day()
}

pl_dt_quarter <- function(x, ...) {
  check_empty_dots(...)
  x$dt$quarter()
}

pl_dt_replace_time_zone <- function(x, ...) {
  check_empty_dots(...)
  x$dt$replace_time_zone()
}

pl_dt_default_round <- function(x, ...) {
  check_empty_dots(...)
  x$default$round()
}

pl_dt_round <- function(x, ...) {
  check_empty_dots(...)
  x$dt$round()
}

pl_dt_second <- function(x, ...) {
  check_empty_dots(...)
  x$dt$second()
}

pl_dt_seconds <- function(x, ...) {
  check_empty_dots(...)
  x$dt$seconds()
}

pl_dt_strftime <- function(x, ...) {
  check_empty_dots(...)
  x$dt$strftime()
}

pl_dt_timestamp <- function(x, ...) {
  check_empty_dots(...)
  x$dt$timestamp()
}

pl_dt_truncate <- function(x, ...) {
  check_empty_dots(...)
  x$dt$truncate()
}

pl_dt_tz_localize <- function(x, ...) {
  check_empty_dots(...)
  x$dt$tz_localize()
}

pl_dt_week <- function(x, ...) {
  check_empty_dots(...)
  x$dt$week()
}

# TODO: check the day of weekstart (lubridate starts the
# week on sunday, polars on monday)
pl_dt_weekday <- function(x, ...) {
  check_empty_dots(...)
  x$dt$weekday()
}

pl_dt_with_time_unit <- function(x, ...) {
  check_empty_dots(...)
  x$dt$with_time_unit()
}

pl_dt_year <- function(x, ...) {
  check_empty_dots(...)
  x$dt$year()
}

pl_dt_ymd_hms <- function(x, ...) {
  check_empty_dots(...)
  x$str$strptime(pl$Datetime("ms"), "%Y-%m-%d %H:%M:%S", strict = FALSE)
}

pl_dt_ymd_hm <- function(x, ...) {
  check_empty_dots(...)
  x$str$strptime(pl$Datetime("ms"), "%Y-%m-%d %H:%M", strict = FALSE)
}
