### [GENERATED AUTOMATICALLY] Update test-mutate.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic ops +, -, *, /, ^, ** work", {
  pl_iris <- polars::as_polars_lf(iris)

  expect_is_tidypolars(mutate(pl_iris, x = 1 + 1))

  expect_equal_lazy(
    mutate(pl_iris, x = 1 + 1) |>
      pull(x),
    rep(2, 150)
  )

  expect_equal_lazy(
    mutate(pl_iris, x = 1 + 1, foo = x + 1) |>
      pull(x),
    rep(2, 150)
  )

  expect_equal_lazy(
    mutate(pl_iris, x = Sepal.Width + Sepal.Length) |>
      pull(x),
    iris$Sepal.Width + iris$Sepal.Length
  )
  expect_equal_lazy(
    mutate(pl_iris, x = Sepal.Width - Sepal.Length + Petal.Length) |>
      pull(x),
    iris$Sepal.Width - iris$Sepal.Length + iris$Petal.Length
  )
  expect_equal_lazy(
    mutate(pl_iris, x = Sepal.Width * Sepal.Length) |>
      pull(x),
    iris$Sepal.Width * iris$Sepal.Length
  )
  expect_equal_lazy(
    mutate(pl_iris, x = Sepal.Width / Sepal.Length) |>
      pull(x),
    iris$Sepal.Width / iris$Sepal.Length
  )
  expect_equal_lazy(
    mutate(pl_iris, x = Sepal.Width^Sepal.Length) |>
      pull(x),
    iris$Sepal.Width^iris$Sepal.Length
  )
  expect_equal_lazy(
    mutate(pl_iris, x = Sepal.Width**Sepal.Length) |>
      pull(x),
    iris$Sepal.Width**iris$Sepal.Length
  )
})

test_that("logical ops +, -, *, / work", {
  pl_iris <- polars::as_polars_lf(iris)

  expect_equal_lazy(
    mutate(pl_iris, x = Sepal.Width > Sepal.Length) |>
      pull(x),
    iris$Sepal.Width > iris$Sepal.Length
  )
  expect_equal_lazy(
    mutate(pl_iris, x = Sepal.Width > Sepal.Length & Petal.Width > Petal.Length) |>
      pull(x),
    iris$Sepal.Width > iris$Sepal.Length & iris$Petal.Width > iris$Petal.Length
  )

  expect_false(
    mutate(pl_iris, x = all(Sepal.Length / 2 > Sepal.Width)) |>
      pull(x) |>
      unique()
  )

  expect_true(
    mutate(pl_iris, x = all(Sepal.Width > 0)) |>
      pull(x) |>
      unique()
  )

  expect_false(
    mutate(pl_iris, x = any(Sepal.Width > Sepal.Length)) |>
      pull(x) |>
      unique()
  )
})

test_that("%in operator works", {
  pl_iris <- polars::as_polars_lf(iris)

  test <- pl$LazyFrame(
    x1 = c("a", "a", "foo", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = sample(1:5)
  )

  expect_equal_lazy(
    mutate(test, x = x1 %in% letters) |>
      pull(x),
    c(TRUE, TRUE, FALSE, TRUE, TRUE)
  )

  expect_equal_lazy(
    mutate(test, x = x1 %in% letters & x2 < 3) |>
      pull(x),
    c(TRUE, TRUE, FALSE, FALSE, TRUE)
  )
})


test_that("can overwrite existin variables", {
  pl_iris <- polars::as_polars_lf(iris)

  expect_equal_lazy(
    mutate(pl_iris, Sepal.Width = Sepal.Width * 2) |>
      pull(Sepal.Width),
    iris$Sepal.Width * 2
  )
})


test_that("scalar value works", {
  pl_iris <- polars::as_polars_lf(iris)

  expect_equal_lazy(
    mutate(pl_iris, Sepal.Width = 2) |>
      pull(Sepal.Width) |>
      unique(),
    2
  )

  expect_equal_lazy(
    mutate(pl_iris, Sepal.Width = "a") |>
      pull(Sepal.Width) |>
      unique(),
    "a"
  )

  expect_snapshot_lazy(
    mutate(pl_iris, Sepal.Width = 1:2),
    error = TRUE
  )
  expect_snapshot_lazy(
    mutate(pl_iris, Sepal.Width = letters[1:2]),
    error = TRUE
  )
})

test_that("passing several expressions works", {
  pl_iris <- polars::as_polars_lf(iris)
  out <- mutate(
    pl_iris,
    Sepal.Width = Sepal.Width * 2,
    Petal.Width = Petal.Width * 3
  )

  expect_equal_lazy(
    c(
      pull(out, Sepal.Width),
      pull(out, Petal.Width)
    ),
    c(iris$Sepal.Width * 2, iris$Petal.Width * 3)
  )
})


test_that("dropping columns works", {
  pl_iris <- polars::as_polars_lf(iris)

  expect_colnames(
    mutate(pl_iris, Sepal.Length = 1, Species = NULL),
    names(iris)[1:4]
  )
})


test_that("operations on grouped data work", {
  pl_iris <- polars::as_polars_lf(iris)

  out <- pl_iris |>
    group_by(Species, maintain_order = TRUE) |>
    mutate(
      foo = mean(Sepal.Length)
    )

  expect_equal_lazy(
    pull(out, foo) |> unique(),
    c(5.006, 5.936, 6.588)
  )

  expect_equal_lazy(
    attr(out, "pl_grps"),
    "Species"
  )

  expect_equal_lazy(
    attr(out, "maintain_grp_order"),
    TRUE
  )

  expect_equal_lazy(
    pull(out, foo) |> unique(),
    as_polars_lf(iris) |>
      mutate(foo = mean(Sepal.Length), .by = Species) |>
      pull(foo) |>
      unique()
  )

  expect_equal_lazy(
    as_polars_lf(iris) |>
      mutate(foo = mean(Sepal.Length), .by = Species) |>
      attr("pl_grps"),
    NULL
  )

  expect_equal_lazy(
    as_polars_lf(iris) |>
      mutate(foo = mean(Sepal.Length), .by = Species) |>
      attr("maintain_grp_order"),
    NULL
  )

  pl_mtcars <- polars::as_polars_lf(mtcars)
  out <- pl_mtcars |>
    group_by(cyl, am) |>
    mutate(
      disp2 = disp / mean(disp)
    ) |>
    ungroup()

  expect_equal_lazy(
    out |> slice_head(n = 5) |> pull(disp2),
    c(1.032258, 1.032258, 1.153692, 1.261305, 1.006664),
    tolerance = 1e5
  )

  expect_colnames(
    pl_iris |>
      group_by(Species) |>
      mutate(Sepal.Length = NULL),
    names(iris)[2:5]
  )

  expect_equal_lazy(
    pl_mtcars |>
      mutate(disp2 = disp / mean(disp), .by = c(cyl, am)),
    out
  )
})


test_that("warning if unknown argument", {
  pl_iris <- polars::as_polars_lf(iris)

  expect_warning(
    mutate(pl_iris, foo = mean(Sepal.Length, trim = 1)),
    "doesn't know how to use some arguments"
  )
})


test_that("custom function that returns Polars expression", {
  pl_iris <- polars::as_polars_lf(iris)

  foo <- function(x, y) {
    tmp <- x$mean()
    tmp2 <- y$mean()
    tmp + tmp2
  }

  expect_equal_lazy(
    mutate(pl_iris, x = foo(Sepal.Length, Petal.Length)) |>
      pull(x),
    rep(mean(iris$Sepal.Length) + mean(iris$Petal.Length), nrow(iris))
  )
})


test_that("custom function that doesn't return Polars expression", {
  pl_iris <- polars::as_polars_lf(iris)

  foo <- function(x, y) {
    dplyr::near(x, y)
  }

  expect_snapshot_lazy(
    mutate(pl_iris, x = foo(Sepal.Length, Petal.Length)),
    error = TRUE
  )
})

test_that("embracing work", {
  pl_iris <- polars::as_polars_lf(iris)

  some_value <- 1

  expect_equal_lazy(
    mutate(pl_iris, x = {{ some_value }}),
    mutate(pl_iris, x = 1)
  )

  expect_equal_lazy(
    mutate(pl_iris, x = some_value + Sepal.Length),
    mutate(pl_iris, x = 1 + Sepal.Length)
  )
})

test_that("reordering expressions works", {
  pl_iris <- polars::as_polars_lf(iris)

  expect_equal_lazy(
    pl_iris |>
      mutate(
        x = Sepal.Length * 3,
        Petal.Length = Petal.Length / x,
        x = NULL,
        mean_pl = mean(Petal.Length),
        foo = Sepal.Width + Petal.Width
      ),
    pl_iris$with_columns(
      x = pl$col("Sepal.Length") * 3,
      foo = pl$col("Sepal.Width") + pl$col("Petal.Width")
    )$with_columns(
      Petal.Length = pl$col("Petal.Length") / pl$col("x")
    )$with_columns(
      mean_pl = pl$col("Petal.Length")$mean()
    )$drop("x")
  )

  expect_equal_lazy(
    pl_iris |>
      mutate(
        x = 1,
        x = NULL,
        mean_pl = mean(Petal.Length),
        x = 2
      ),
    pl_iris$with_columns(
      mean_pl = pl$col("Petal.Length")$mean(),
      x = 2
    )
  )
})


test_that("correct sequential operations", {
  pl_iris <- polars::as_polars_lf(iris)
  expect_equal_lazy(
    iris[c(1, 2, 149, 150), ] |>
      as_polars_lf() |>
      mutate(
        x = Sepal.Length > 6,
        y = x & Species == "virginica",
        z = ifelse(y, Petal.Width, Petal.Length * Sepal.Width)
      ) |>
      pull(z),
    c(4.9, 4.2, 2.3, 15.3)
  )
})


test_that("argument .keep works", {
  pl_iris <- polars::as_polars_lf(iris)

  expect_snapshot_lazy(
    mutate(pl_iris, x = 1, .keep = "foo"),
    error = TRUE
  )

  expect_colnames(
    mutate(pl_iris, x = Sepal.Length, y = Species, .keep = "used"),
    c("Sepal.Length", "Species", "x", "y")
  )

  expect_colnames(
    mutate(pl_iris, x = Sepal.Length, y = Species, .keep = "unused"),
    c("Sepal.Width", "Petal.Length", "Petal.Width", "x", "y")
  )

  expect_colnames(
    mutate(pl_iris, x = Sepal.Length, y = Species, .keep = "none"),
    c("x", "y")
  )

  pl_grp <- pl_iris |>
    group_by(Species, maintain_order = TRUE)

  expect_colnames(
    mutate(pl_grp, x = Sepal.Length, .keep = "used"),
    c("Sepal.Length", "Species", "x")
  )

  expect_colnames(
    mutate(pl_grp, x = Sepal.Length, .keep = "unused"),
    c("Sepal.Width", "Petal.Length", "Petal.Width", "Species", "x")
  )

  expect_colnames(
    mutate(pl_grp, x = Sepal.Length, .keep = "none"),
    c("Species", "x")
  )
})


test_that("works with a local variable defined in a function", {
  pl_iris <- polars::as_polars_lf(iris)
  foobar <- function(x) {
    local_var <- "a"
    x |> mutate(foo = local_var)
  }

  test <- polars::pl$LazyFrame(chars = letters[1:3])

  expect_equal_lazy(
    foobar(test),
    data.frame(chars = letters[1:3], foo = "a")
  )
})


test_that("works with external data.frame/list elements", {
  pl_iris <- polars::as_polars_lf(iris)
  test <- polars::pl$LazyFrame(x = 1:3)
  test_df <- data.frame(x = 1:2)

  expect_equal_lazy(
    test |>
      mutate(foo = x %in% test_df$x) |>
      pull(foo),
    c(TRUE, TRUE, FALSE)
  )

  expect_equal_lazy(
    test |>
      mutate(foo = x %in% test_df[["x"]]) |>
      pull(foo),
    c(TRUE, TRUE, FALSE)
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)