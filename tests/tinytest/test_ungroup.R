source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(mtcars)

expect_equal(
  test |> group_by(am, cyl) |> ungroup(),
  test
)

expect_equal(
  test |> rowwise(am, cyl) |> ungroup(),
  test
)
