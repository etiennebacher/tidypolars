test_that("datatype NULL is correctly handled internally", {
  test <- polars0::pl$DataFrame(x = NULL)
  expect_dim(test |> select(x), c(1, 1))
})
