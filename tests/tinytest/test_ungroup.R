source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(mtcars)

expect_equal(
  test |> pl_group_by(am, cyl) |> pl_ungroup(),
  test
)
