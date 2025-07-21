### [GENERATED AUTOMATICALLY] Update test-datatype.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("datatype NULL is correctly handled internally", {
  test <- polars0::pl$LazyFrame(x = NULL)
  expect_dim(test |> select(x), c(1, 1))
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
