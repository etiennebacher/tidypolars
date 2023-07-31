source("helpers.R")
using("tidypolars")

test <- pl$DataFrame(mtcars)

# TODO: uncomment this when https://github.com/pola-rs/r-polars/issues/338 is
# solved
# expect_equal(
#   test |> pl_group_by(am, cyl) |> pl_ungroup(),
#   test
# )
