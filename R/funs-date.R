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

### Not in polars
# pl_dyears <- function(x) {
#   x$dt$years()
# }
#
# pl_dmonths <- function(x) {
#   x$dt$months()
# }
#
# pl_dweeks <- function(x) {
#   x$dt$weeks()
# }

### TODO: all of the following is wrong and requires pl$duration()

# pl_ddays <- function(x) {
#   x$dt$days()
# }
#
# pl_dhours <- function(x) {
#   x$dt$hours()
# }
#
# pl_dminutes <- function(x) {
#   x$dt$minutes()
# }
#
# pl_dseconds <- function(x) {
#   x$dt$seconds()
# }
#
# pl_dmilliseconds <- function(x) {
#   x$dt$milliseconds()
# }
#
# pl_dmicroseconds <- function(x) {
#   x$dt$microseconds()
# }
#
# pl_dnanoseconds <- function(x) {
#   x$dt$nanoseconds()
# }

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

pl_round <- function(x, ...) {
  check_empty_dots(...)
  x$dt$round()
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


