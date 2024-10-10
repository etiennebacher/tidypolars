test_that("datatype NULL is correctly handled internally", {
  test <- polars::pl$DataFrame(x = NULL)
  expect_dim(test |> select(x), c(1, 1))
})
