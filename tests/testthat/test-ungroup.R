test_that("basic behavior works", {
  test <- pl$DataFrame(mtcars)

  expect_equal(
    test |> group_by(am, cyl) |> ungroup() |> attributes() |> length(),
    1
  )
  expect_equal(
    test |> rowwise(am, cyl) |> ungroup() |> attributes() |> length(),
    1
  )
})
