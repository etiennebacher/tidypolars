test_that("basic behavior works", {
  iris_pl <- polars::as_polars_df(iris)
  iris_g_pl <- iris_pl |>
    group_by(Species, maintain_order = TRUE)

  expect_equal(
    summarize(iris_g_pl, x = mean(Sepal.Length)) |>
      pull(x),
    iris |>
      dplyr::group_by(Species) |>
      dplyr::summarize(x = mean(Sepal.Length)) |>
      dplyr::pull(x)
  )

  expect_equal(
    summarize(iris_pl, x = mean(Sepal.Length), .by = Species) |>
      pull(x) |>
      sort(),
    summarize(iris_g_pl, x = mean(Sepal.Length)) |>
      pull(x) |>
      sort()
  )

  expect_equal(
    summarize(iris_g_pl, x = sum(Sepal.Length), y = mean(Sepal.Length)) |>
      pull(y),
    iris |>
      dplyr::group_by(Species) |>
      dplyr::summarize(x = sum(Sepal.Length), y = mean(Sepal.Length)) |>
      dplyr::pull(y)
  )

  expect_equal(
    summarize(iris_g_pl, x = 1) |>
      pull(x),
    rep(1, 3)
  )

  expect_equal(
    summarize(iris_pl, x = mean(Petal.Length)) |>
      pull(x),
    iris |>
      dplyr::summarize(x = mean(Petal.Length)) |>
      dplyr::pull(x)
  )

  expect_colnames(
    summarize(iris_g_pl, Sepal.Length = NULL),
    names(iris)[2:5]
  )
})

test_that("correctly handles attributes", {
  mtcars_pl <- polars::as_polars_df(mtcars)
  mtcars_g_pl <- mtcars_pl |>
    group_by(cyl, am, maintain_order = TRUE)

  expect_equal(
    summarize(mtcars_g_pl, x = mean(mpg)) |>
      attr("pl_grps"),
    "cyl"
  )

  expect_true(
    summarize(mtcars_g_pl, x = mean(mpg)) |>
      attr("maintain_grp_order")
  )

  expect_null(
    summarize(mtcars_pl, x = mean(mpg), .by = c(cyl, am)) |>
      attr("pl_grps")
  )

  expect_null(
    summarize(mtcars_pl, x = mean(mpg), .by = c(cyl, am)) |>
      attr("maintain_grp_order")
  )

  expect_is_tidypolars(
    summarize(mtcars_pl, x = mean(mpg), .by = c(cyl, am))
  )
})

test_that("works with a local variable defined in a function", {
  iris_pl <- polars::as_polars_df(iris)
  iris_g_pl <- iris_pl |>
    group_by(Species, maintain_order = TRUE)

  foobar <- function(x) {
    local_var <- "a"
    x |> summarize(foo = local_var)
  }

  test <- polars::pl$DataFrame(chars = letters[1:3])

  expect_equal(
    foobar(test),
    data.frame(foo = "a")
  )
})

test_that("check .add argument of group_by works", {
  test <- polars::as_polars_df(mtcars)

  expect_equal(
    test |>
      group_by(cyl, am, maintain_order = TRUE) |>
      summarize(foo = sum(drat)),
    test |>
      group_by(cyl, maintain_order = TRUE) |>
      group_by(am, maintain_order = TRUE, .add = TRUE) |>
      summarize(foo = sum(drat))
  )
})

test_that("argument .groups works", {
  mtcars_pl <- as_polars_df(mtcars)

  expect_equal(
    mtcars_pl |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n()) |>
      group_vars(),
    c("am", "cyl")
  )

  expect_equal(
    mtcars_pl |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "drop_last") |>
      group_vars(),
    c("am", "cyl")
  )
  expect_equal(
    mtcars_pl |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "keep") |>
      group_vars(),
    c("am", "cyl", "vs")
  )
  expect_equal(
    mtcars_pl |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "drop") |>
      group_vars(),
    character(0)
  )
  expect_snapshot(
    mtcars_pl |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "rowwise"),
    error = TRUE
  )
  expect_snapshot(
    mtcars_pl |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "foobar"),
    error = TRUE
  )

  expect_equal(
    mtcars_pl |>
      group_by(am) |>
      summarise(cyl_n = n(), .groups = "drop_last") |>
      group_vars(),
    character(0)
  )
})


test_that("empty expressions", {
  test <- pl$DataFrame(grp = 1:2, x = 1:2)
  test_df <- tibble(grp = 1:2, x = 1:2)
  expect_equal(
    test |> summarize() |> ncol(),
    0
  )
  expect_equal(
    test |> summarize(.by = grp) |> arrange(grp),
    test_df |> summarize(.by = grp)
  )
})
