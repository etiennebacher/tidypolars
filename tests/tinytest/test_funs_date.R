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

test <- pl$DataFrame(test_df)


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

  expect_equal(pol, res, info = i)
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

  expect_equal(pol, res, info = i)
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
#   expect_equal(pol, res, info = i)
# }


# strptime

expect_equal(
  test |>
    mutate(foo = strptime(somedate, "%b %d %Y")) |>
    pull(foo),
  as.Date(c("2014-07-24", "2015-12-24", "2016-01-21"))
)


# isoyear (test taken from the lubridate test suite)

df <- read.table(textConnection(
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
sep = "\t", fill = T, stringsAsFactors = F, header = F
)

names(df) <- c("Gregorian", "ymd", "iso", "note")
df <- mutate(
  df,
  ymd = ymd(ymd),
  isoweek = as.numeric(gsub(".*W([0-9]+).*", "\\1", iso)),
  isoyear = as.numeric(gsub("^([0-9]+).*", "\\1", iso))
)
df_pl <- as_polars(df)

expect_equal(
  mutate(df_pl, ymd = isoyear(ymd)) |>
    pull(ymd),
  df$isoyear
)
