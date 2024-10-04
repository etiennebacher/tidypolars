### [GENERATED AUTOMATICALLY] Update test-join_inequality.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic inequality join works", {
  companies <- pl$LazyFrame(
    id = c("A", "B", "B"),
    since = c(1973, 2009, 2022),
    name = c("Patagonia", "RStudio", "Posit")
  )
  
  transactions <- pl$LazyFrame(
    company = c("A", "A", "B", "B"),
    year = c(2019, 2020, 2021, 2023),
    revenue = c(50, 4, 10, 12)
  )
  
  expect_equal_lazy(
    inner_join(transactions, companies, join_by(company == id, year >= since)),
    data.frame(
      company = rep(c("A", "B"), 2:3),
      year = c(2019, 2020, 2021, 2023, 2023),
      revenue = c(50, 4, 10, 12, 12),
      since = c(1973, 1973, 2009, 2009, 2022),
      name = c("Patagonia", "Patagonia", "RStudio", "RStudio", "Posit")
    )
  )
})

test_that("inequality joins only work in inner joins for now", {
  a <- pl$LazyFrame(x = 1)
  b <- pl$LazyFrame(y = 1)
  expect_snapshot_lazy(
    left_join(a, b, join_by(x > y)),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)