source("helpers.R")
using("tidypolars")

pl_iris <- pl$DataFrame(iris)
pl_iris_lazy <- pl$LazyFrame(iris)

expect_is_tidypolars(compute(pl_iris_lazy))

expect_equal(
  compute(pl_iris_lazy),
  pl_iris
)

expect_equal(
  pl_iris_lazy |>
    filter(Species == "setosa") |>
    compute(),
  pl_iris |>
    filter(Species == "setosa")
)

expect_error(compute(pl_iris))

out <- pl_iris_lazy |>
  group_by(Species, maintain_order = TRUE) |>
  compute()

expect_equal(
  attr(out, "pl_grps"),
  "Species"
)

expect_equal(
  attr(out, "maintain_grp_order"),
  TRUE
)
