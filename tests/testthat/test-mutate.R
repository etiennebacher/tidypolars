test_that("basic ops +, -, *, /, ^, ** work", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_is_tidypolars(mutate(test_pl, x = 1 + 1))

  expect_equal(
    mutate(test_pl, x = 1 + 1),
    mutate(test_df, x = 1 + 1)
  )

  expect_equal(
    mutate(test_pl, x = 1 + 1, foo = x + 1),
    mutate(test_df, x = 1 + 1, foo = x + 1)
  )

  expect_equal(
    mutate(test_pl, x = Sepal.Width + Sepal.Length),
    mutate(test_df, x = Sepal.Width + Sepal.Length)
  )
  expect_equal(
    mutate(test_pl, x = Sepal.Width - Sepal.Length + Petal.Length),
    mutate(test_df, x = Sepal.Width - Sepal.Length + Petal.Length)
  )
  expect_equal(
    mutate(test_pl, x = Sepal.Width * Sepal.Length),
    mutate(test_df, x = Sepal.Width * Sepal.Length)
  )
  expect_equal(
    mutate(test_pl, x = Sepal.Width / Sepal.Length),
    mutate(test_df, x = Sepal.Width / Sepal.Length)
  )
  expect_equal(
    mutate(test_pl, x = Sepal.Width^Sepal.Length),
    mutate(test_df, x = Sepal.Width^Sepal.Length)
  )
  expect_equal(
    mutate(test_pl, x = Sepal.Width**Sepal.Length),
    mutate(test_df, x = Sepal.Width**Sepal.Length)
  )
})

test_that("logical ops +, -, *, / work", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    mutate(test_pl, x = Sepal.Width > Sepal.Length),
    mutate(test_df, x = Sepal.Width > Sepal.Length)
  )
  expect_equal(
    mutate(
      test_pl,
      x = Sepal.Width > Sepal.Length & Petal.Width > Petal.Length
    ),
    mutate(test_df, x = Sepal.Width > Sepal.Length & Petal.Width > Petal.Length)
  )

  expect_equal(
    mutate(test_pl, x = all(Sepal.Length / 2 > Sepal.Width)),
    mutate(test_df, x = all(Sepal.Length / 2 > Sepal.Width))
  )

  expect_equal(
    mutate(test_pl, x = all(Sepal.Width > 0)),
    mutate(test_df, x = all(Sepal.Width > 0))
  )

  expect_equal(
    mutate(test_pl, x = any(Sepal.Width > Sepal.Length)),
    mutate(test_df, x = any(Sepal.Width > Sepal.Length))
  )
})

test_that("%in operator works", {
  test_df <- tibble(
    x1 = c("a", "a", "foo", "a", "c"),
    x2 = c(2, 1, 5, 3, 1),
    value = 1:5
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    mutate(test_pl, x = x1 %in% letters),
    mutate(test_df, x = x1 %in% letters)
  )

  expect_equal(
    mutate(test_pl, x = x1 %in% letters & x2 < 3),
    mutate(test_df, x = x1 %in% letters & x2 < 3)
  )
})

test_that("can overwrite existin variables", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    mutate(test_pl, Sepal.Width = Sepal.Width * 2),
    mutate(test_df, Sepal.Width = Sepal.Width * 2)
  )
})

test_that("scalar value works", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    mutate(test_pl, Sepal.Width = 2),
    mutate(test_df, Sepal.Width = 2)
  )

  expect_equal(
    mutate(test_pl, Sepal.Width = "a"),
    mutate(test_df, Sepal.Width = "a")
  )

  expect_snapshot(
    mutate(test_pl, Sepal.Width = 1:2),
    error = TRUE
  )
  expect_snapshot(
    mutate(test_pl, Sepal.Width = letters[1:2]),
    error = TRUE
  )
})

test_that("passing several expressions works", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    mutate(
      test_pl,
      Sepal.Width = Sepal.Width * 2,
      Petal.Width = Petal.Width * 3
    ),
    mutate(
      test_df,
      Sepal.Width = Sepal.Width * 2,
      Petal.Width = Petal.Width * 3
    )
  )
})

test_that("dropping columns works", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_colnames(
    mutate(test_pl, Sepal.Length = 1, Species = NULL),
    names(test_df)[1:4]
  )
})

test_that("operations on grouped data work", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  out <- test_pl |>
    group_by(Species, maintain_order = TRUE) |>
    mutate(foo = mean(Sepal.Length))

  expect_equal(
    out |> ungroup(),
    test_df |>
      group_by(Species) |>
      mutate(foo = mean(Sepal.Length)) |>
      ungroup()
  )

  expect_equal(
    attr(out, "pl_grps"),
    "Species"
  )

  expect_true(attr(out, "maintain_grp_order"))

  expect_equal(
    test_pl |> mutate(foo = mean(Sepal.Length), .by = Species),
    test_df |> mutate(foo = mean(Sepal.Length), .by = Species)
  )

  expect_null(
    test_pl |>
      mutate(foo = mean(Sepal.Length), .by = Species) |>
      attr("pl_grps")
  )

  expect_null(
    test_pl |>
      mutate(foo = mean(Sepal.Length), .by = Species) |>
      attr("maintain_grp_order")
  )

  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |>
      group_by(cyl, am) |>
      mutate(disp2 = disp / mean(disp)) |>
      ungroup(),
    test_df |>
      group_by(cyl, am) |>
      mutate(disp2 = disp / mean(disp)) |>
      ungroup(),
    tolerance = 1e-5
  )

  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_colnames(
    test_pl |> group_by(Species) |> mutate(Sepal.Length = NULL),
    names(test_df)[2:5]
  )

  test_df <- as_tibble(mtcars)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> mutate(disp2 = disp / mean(disp), .by = c(cyl, am)),
    test_df |> mutate(disp2 = disp / mean(disp), .by = c(cyl, am)),
    tolerance = 1e-5
  )
})

test_that("warning if unknown argument", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_warning(
    mutate(test_pl, foo = mean(Sepal.Length, trim = 1)),
    "doesn't know how to use some arguments"
  )
})

test_that("custom function that returns Polars expression", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  foo <- function(x, y) {
    tmp <- x$mean()
    tmp2 <- y$mean()
    tmp + tmp2
  }

  expect_equal(
    mutate(test_pl, x = foo(Sepal.Length, Petal.Length)) |> pull(x),
    rep(mean(test_df$Sepal.Length) + mean(test_df$Petal.Length), nrow(test_df))
  )
})

test_that("custom function that doesn't return Polars expression", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  foo <- function(x, y) {
    near(x, y)
  }

  expect_snapshot(
    mutate(test_pl, x = foo(Sepal.Length, Petal.Length)),
    error = TRUE
  )
})

test_that("embracing work", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  some_value <- 1

  expect_equal(
    mutate(test_pl, x = {{ some_value }}),
    mutate(test_df, x = {{ some_value }})
  )

  expect_equal(
    mutate(test_pl, x = some_value + Sepal.Length),
    mutate(test_df, x = some_value + Sepal.Length)
  )
})

test_that("reordering expressions works", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |>
      mutate(
        x = Sepal.Length * 3,
        Petal.Length = Petal.Length / x,
        x = NULL,
        mean_pl = mean(Petal.Length),
        foo = Sepal.Width + Petal.Width
      ),
    test_pl$with_columns(
      x = pl$col("Sepal.Length") * 3,
      foo = pl$col("Sepal.Width") + pl$col("Petal.Width")
    )$with_columns(
      Petal.Length = pl$col("Petal.Length") / pl$col("x")
    )$with_columns(
      mean_pl = pl$col("Petal.Length")$mean()
    )$drop("x")
  )

  expect_equal(
    test_pl |>
      mutate(
        x = 1,
        x = NULL,
        mean_pl = mean(Petal.Length),
        x = 2
      ),
    test_pl$with_columns(
      mean_pl = pl$col("Petal.Length")$mean(),
      x = 2
    )
  )
})

test_that("correct sequential operations", {
  test_df <- as_tibble(iris[c(1, 2, 149, 150), ])
  # TODO: shouldn't be necessary
  test_df$Species <- as.character(test_df$Species)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |>
      mutate(
        x = Sepal.Length > 6,
        y = x & Species == "virginica",
        z = ifelse(y, Petal.Width, Petal.Length * Sepal.Width)
      ),
    test_df |>
      mutate(
        x = Sepal.Length > 6,
        y = x & Species == "virginica",
        z = ifelse(y, Petal.Width, Petal.Length * Sepal.Width)
      )
  )
})

test_that("argument .keep works", {
  test_df <- as_tibble(iris)
  test_pl <- as_polars_df(test_df)

  expect_snapshot(
    mutate(test_pl, x = 1, .keep = "foo"),
    error = TRUE
  )

  expect_colnames(
    mutate(test_pl, x = Sepal.Length, y = Species, .keep = "used"),
    c("Sepal.Length", "Species", "x", "y")
  )

  expect_colnames(
    mutate(test_pl, x = Sepal.Length, y = Species, .keep = "unused"),
    c("Sepal.Width", "Petal.Length", "Petal.Width", "x", "y")
  )

  expect_colnames(
    mutate(test_pl, x = Sepal.Length, y = Species, .keep = "none"),
    c("x", "y")
  )

  test_pl_grp <- test_pl |>
    group_by(Species, maintain_order = TRUE)

  expect_colnames(
    mutate(test_pl_grp, x = Sepal.Length, .keep = "used"),
    c("Sepal.Length", "Species", "x")
  )

  expect_colnames(
    mutate(test_pl_grp, x = Sepal.Length, .keep = "unused"),
    c("Sepal.Width", "Petal.Length", "Petal.Width", "Species", "x")
  )

  expect_colnames(
    mutate(test_pl_grp, x = Sepal.Length, .keep = "none"),
    c("Species", "x")
  )
})

test_that("works with a local variable defined in a function", {
  foobar <- function(x) {
    local_var <- "a"
    x |> mutate(foo = local_var)
  }

  test_df <- tibble(chars = letters[1:3])
  test_pl <- as_polars_df(test_df)

  expect_equal(
    foobar(test_pl),
    foobar(test_df)
  )
})

test_that("works with external data.frame/list elements", {
  test_df <- tibble(x = 1:3)
  test_pl <- as_polars_df(test_df)
  external_df <- tibble(x = 1:2)

  expect_equal(
    test_pl |> mutate(foo = x %in% external_df$x),
    test_df |> mutate(foo = x %in% external_df$x)
  )

  expect_equal(
    test_pl |> mutate(foo = x %in% external_df[["x"]]),
    test_df |> mutate(foo = x %in% external_df[["x"]])
  )
})

test_that("empty expressions", {
  test_df <- tibble(grp = 1, x = 1)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> mutate(),
    test_df |> mutate()
  )
  expect_equal(
    test_pl |> mutate(.by = grp),
    test_df |> mutate(.by = grp)
  )
})
