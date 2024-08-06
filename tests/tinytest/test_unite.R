source("helpers.R")
using("tidypolars")

test <- polars::pl$DataFrame(
  year = 2009:2011,
  month = 10:12,
  day = c(11L, 22L, 28L),
  name_day = c("Monday", "Thursday", "Wednesday")
)

out1 <- unite(test, col = "full_date", year, month, day, sep = "-")

expect_is_tidypolars(out1)

expect_equal(
   pull(out1, full_date),
   c("2009-10-11", "2010-11-22", "2011-12-28")
)

expect_dim(out1, c(3, 2))

out2 <- unite(test, col = "full_date", year, month, day, sep = "-", remove = FALSE)

expect_dim(out2, c(3, 5))

test2 <- polars::pl$DataFrame(
  name = c("John", "Jack", "Thomas"),
  middlename = c("T.", NA, "F."),
  surname = c("Smith", "Thompson", "Jones")
)

out3 <- unite(test2, col = "full_name", everything(), sep = " ", na.rm = TRUE)

expect_equal(
  pull(out3, full_name),
  c("John T. Smith", "Jack  Thompson", "Thomas F. Jones")
)

expect_error(
  unite(test),
  "`col` is absent but must be supplied.",
  fixed = TRUE
)

expect_equal(
  test |> unite(col = "foo") |> pull(foo),
  c("2009_10_11_Monday", "2010_11_22_Thursday", "2011_12_28_Wednesday")
)
