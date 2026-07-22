test_that("basic behavior works", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)
  test_pl_grp <- test_pl |>
    group_by(Species, maintain_order = TRUE)
  test_grp <- test_df |>
    group_by(Species)

  expect_equal(
    summarize(test_pl_grp, x = mean(Sepal.Length)),
    summarize(test_grp, x = mean(Sepal.Length))
  )

  expect_equal(
    summarize(test_pl, x = mean(Sepal.Length), .by = Species) |>
      arrange(Species),
    summarize(test_df, x = mean(Sepal.Length), .by = Species) |>
      arrange(Species)
  )

  expect_equal(
    summarize(test_pl_grp, x = sum(Sepal.Length), y = mean(Sepal.Length)),
    summarize(test_grp, x = sum(Sepal.Length), y = mean(Sepal.Length))
  )

  expect_equal(
    summarize(test_pl_grp, x = 1),
    summarize(test_grp, x = 1)
  )

  expect_equal(
    summarize(test_pl, x = mean(Petal.Length)),
    summarize(test_df, x = mean(Petal.Length))
  )

  expect_equal(
    summarize(test_pl_grp, Sepal.Length = NULL),
    summarize(test_grp, Sepal.Length = NULL)
  )

  expect_equal(
    summarize(
      test_pl_grp,
      Sepal.Length = NULL,
      Petal.Length = sum(Petal.Length)
    ),
    summarize(test_grp, Sepal.Length = NULL, Petal.Length = sum(Petal.Length))
  )

  expect_equal(
    summarize(
      test_pl_grp,
      Petal.Length = sum(Petal.Length),
      Sepal.Length = NULL
    ),
    summarize(test_grp, Petal.Length = sum(Petal.Length), Sepal.Length = NULL)
  )
})

test_that("correctly handles attributes", {
  # tidypolars-specific attributes tests
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)
  test_pl_grp <- test_pl |>
    group_by(cyl, am, maintain_order = TRUE)

  expect_equal(
    summarize(test_pl_grp, x = mean(mpg)) |> attr("pl_grps"),
    "cyl"
  )

  expect_true(
    summarize(test_pl_grp, x = mean(mpg)) |> attr("maintain_grp_order")
  )

  expect_null(
    summarize(test_pl, x = mean(mpg), .by = c(cyl, am)) |> attr("pl_grps")
  )

  expect_null(
    summarize(test_pl, x = mean(mpg), .by = c(cyl, am)) |>
      attr("maintain_grp_order")
  )

  expect_is_tidypolars(
    summarize(test_pl, x = mean(mpg), .by = c(cyl, am))
  )
})

test_that("works with a local variable defined in a function", {
  foobar <- function(x) {
    local_var <- "a"
    x |> summarize(foo = local_var)
  }

  test_df <- tibble(chars = letters[1:3])
  test_pl <- as_polars_df(test_df)

  expect_equal(
    foobar(test_pl),
    foobar(test_df)
  )
})

test_that("check .add argument of group_by works", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |>
      group_by(cyl, am, maintain_order = TRUE) |>
      summarize(foo = sum(drat)),
    test_pl |>
      group_by(cyl, maintain_order = TRUE) |>
      group_by(am, maintain_order = TRUE, .add = TRUE) |>
      summarize(foo = sum(drat))
  )
})

test_that("argument .groups works", {
  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> group_by(am, cyl, vs) |> summarise(cyl_n = n()) |> group_vars(),
    test_df |> group_by(am, cyl, vs) |> summarise(cyl_n = n()) |> group_vars()
  )

  expect_equal(
    test_pl |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "drop_last") |>
      group_vars(),
    test_df |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "drop_last") |>
      group_vars()
  )
  expect_equal(
    test_pl |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "keep") |>
      group_vars(),
    test_df |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "keep") |>
      group_vars()
  )
  expect_equal(
    test_pl |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "drop") |>
      group_vars(),
    test_df |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "drop") |>
      group_vars()
  )
  expect_snapshot(
    test_pl |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "rowwise"),
    error = TRUE
  )
  expect_both_error(
    test_pl |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "foobar"),
    test_df |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "foobar")
  )
  expect_snapshot(
    test_pl |>
      group_by(am, cyl, vs) |>
      summarise(cyl_n = n(), .groups = "foobar"),
    error = TRUE
  )

  expect_equal(
    test_pl |>
      group_by(am) |>
      summarise(cyl_n = n(), .groups = "drop_last") |>
      group_vars(),
    test_df |>
      group_by(am) |>
      summarise(cyl_n = n(), .groups = "drop_last") |>
      group_vars()
  )
})


test_that("empty expressions", {
  test_df <- tibble(grp = 1:2, x = 1:2)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> summarize(),
    test_df |> summarize(),
    ignore_attr = TRUE
  )
  expect_equal(
    test_pl |> summarize(.by = grp) |> arrange(grp),
    test_df |> summarize(.by = grp)
  )
})
