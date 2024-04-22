source("helpers.R")
using("tidypolars")

pl_iris <- pl$DataFrame(iris)
pl_iris_lazy <- pl$LazyFrame(iris)

expect_warning(
  collect(pl_iris_lazy),
  "automatically convert the"
)
expect_is_tidypolars(collect(pl_iris_lazy, verbose = FALSE))

expect_equal(
  collect(pl_iris_lazy, verbose = FALSE),
  pl_iris
)

expect_equal(
  pl_iris_lazy |>
    filter(Species == "setosa") |>
    collect(verbose = FALSE),
  pl_iris |>
    filter(Species == "setosa")
)

expect_error(collect(pl_iris, verbose = FALSE))

out <- pl_iris_lazy |>
  group_by(Species, maintain_order = TRUE) |>
  collect(verbose = FALSE)

expect_equal(
  attr(out, "pl_grps"),
  "Species"
)

expect_equal(
  attr(out, "maintain_grp_order"),
  TRUE
)
