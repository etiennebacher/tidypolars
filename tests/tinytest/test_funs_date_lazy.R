### [GENERATED AUTOMATICALLY] Update test_funs_date.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

library(lubridate, warn.conflicts = FALSE)

test_df <- data.frame(
  YMD = as.Date(c("2012-03-26", "2020-01-01", "2023-12-14")),
  # DMY = c("26-03-2012", "01-01-2020", "14-12-2023"),
  # YDM = c("2012-26-03", "2020-01-01", "2023-14-12"),
  # MDY = c("03-26-2012", "01-01-2020", "12-14-2023")
  YMD_HMS = ymd_hms(c("2012-03-26 12:00:00", "2020-01-01 12:00:00", "2023-12-14 12:00:00")),
  to_ymd_hms = c("2012-03-26 12:00:00", "2020-01-01 12:00:00", "2023-12-14 12:00:00"),
  to_ymd_hm = c("2012-03-26 12:00", "2020-01-01 12:00", "2023-12-14 12:00"),
  somedate = c("Jul 24 2014", "Dec 24 2015", "Jan 21 2016")
)

test <- pl$LazyFrame(test_df)


for (i in c("year", "month", "day", "quarter", "week", "mday", "yday"
            # TODO: "wday" (see pl_dt_weekday())
            )) {
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
#     to_r()
#
#   res <- paste0("mutate(test_df, to_", i, "  = ", i, "(to_", i, "))") |>
#     str2lang() |>
#     eval()
#
#   expect_equal_lazy(pol, res, info = i)
# }


# strptime

expect_equal_lazy(
  test |>
    mutate(foo = strptime(somedate, "%b %d %Y")) |>
    pull(foo),
  as.Date(c("2014-07-24", "2015-12-24", "2016-01-21"))
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)