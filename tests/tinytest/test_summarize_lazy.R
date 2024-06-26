### [GENERATED AUTOMATICALLY] Update test_summarize.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

pl_iris <- polars::pl$LazyFrame(iris)
pl_iris_g <- pl_iris |>
  group_by(Species, maintain_order = TRUE)

expect_equal_lazy(
  summarize(pl_iris_g, x = mean(Sepal.Length)) |>
    pull(x),
  c(5.006, 5.936, 6.588)
)

expect_equal_lazy(
  summarize(pl_iris, x = mean(Sepal.Length), .by = Species) |>
    pull(x) |>
    sort(),
  summarize(pl_iris_g, x = mean(Sepal.Length)) |>
    pull(x) |>
    sort()
)

expect_equal_lazy(
  summarize(pl_iris_g,
               x = sum(Sepal.Length),
               y = mean(Sepal.Length)) |>
    pull(y),
  c(5.006, 5.936, 6.588)
)

expect_equal_lazy(
  summarize(pl_iris_g, x = 1) |>
    pull(x),
  rep(1, 3)
)

expect_equal_lazy(
  summarize(pl_iris, x = mean(Petal.Length)) |>
    pull(x),
  3.758
)

expect_colnames(
  summarize(pl_iris_g, Sepal.Length = NULL),
  names(iris)[2:5]
)

# attributes ------------------------

expect_equal_lazy(
  summarize(pl_iris_g, x = mean(Sepal.Length)) |>
    attr("pl_grps"),
  "Species"
)

expect_equal_lazy(
  summarize(pl_iris_g, x = mean(Sepal.Length)) |>
    attr("maintain_grp_order"),
  TRUE
)

expect_equal_lazy(
  summarize(pl_iris, x = mean(Sepal.Length), .by = Species) |>
    attr("pl_grps"),
  NULL
)

expect_equal_lazy(
  summarize(pl_iris, x = mean(Sepal.Length), .by = Species) |>
    attr("maintain_grp_order"),
  NULL
)

expect_is_tidypolars(summarize(pl_iris, x = mean(Sepal.Length), .by = Species))

# works with a local variable defined in a function

foobar <- function(x) {
  local_var <- "a"
  x |> summarize(foo = local_var)
}

test <- polars::pl$LazyFrame(chars = letters[1:3])

expect_equal_lazy(
  foobar(test),
  data.frame(foo = "a")
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)