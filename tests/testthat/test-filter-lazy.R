### [GENERATED AUTOMATICALLY] Update test-filter.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test <- as_tibble(iris)
  # TODO: this shouldn't be necessary
  # test$Species <- as.character(test$Species)
  test_pl <- as_polars_lf(test)

  expect_is_tidypolars(filter(test_pl, Species == "setosa"))

  expect_equal_lazy(
    filter(test_pl, Species == "setosa"),
    filter(test, Species == "setosa")
  )
  expect_equal_lazy(
    filter_out(test_pl, Species == "setosa"),
    filter_out(test, Species == "setosa")
  )
})

test_that("combining combinations", {
  test <- as_tibble(iris)
  # TODO: this shouldn't be necessary
  # test$Species <- as.character(test$Species)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    filter(test_pl, Sepal.Length < 5 & Species == "setosa"),
    filter(test, Sepal.Length < 5 & Species == "setosa")
  )
  expect_equal_lazy(
    filter_out(test_pl, Sepal.Length < 5 & Species == "setosa"),
    filter_out(test, Sepal.Length < 5 & Species == "setosa")
  )

  expect_equal_lazy(
    filter(test_pl, Sepal.Length < 5, Species == "setosa"),
    filter(test, Sepal.Length < 5, Species == "setosa")
  )
  expect_equal_lazy(
    filter_out(test_pl, Sepal.Length < 5, Species == "setosa"),
    filter_out(test, Sepal.Length < 5, Species == "setosa")
  )

  expect_equal_lazy(
    filter(test_pl, Sepal.Length < 5 | Species == "setosa"),
    filter(test, Sepal.Length < 5 | Species == "setosa")
  )
  expect_equal_lazy(
    filter_out(test_pl, Sepal.Length < 5 | Species == "setosa"),
    filter_out(test, Sepal.Length < 5 | Species == "setosa")
  )
})

test_that("expressions work", {
  test <- as_tibble(iris)
  # TODO: this shouldn't be necessary
  # test$Species <- as.character(test$Species)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    filter(test_pl, Sepal.Length < Sepal.Width + Petal.Length),
    filter(test, Sepal.Length < Sepal.Width + Petal.Length)
  )
  expect_equal_lazy(
    filter_out(test_pl, Sepal.Length < Sepal.Width + Petal.Length),
    filter_out(test, Sepal.Length < Sepal.Width + Petal.Length)
  )
})

test_that("is.na() works", {
  test2 <- as_tibble(iris)
  # TODO: this shouldn't be necessary
  test2$Species <- as.character(test2$Species)

  test2[c(3, 8, 58, 133), "Species"] <- NA
  test2_pl <- as_polars_lf(test2)

  expect_equal_lazy(
    filter(test2_pl, is.na(Species)),
    filter(test2, is.na(Species))
  )
  expect_equal_lazy(
    filter(test2_pl, base::is.na(Species)),
    filter(test2, base::is.na(Species))
  )
  expect_equal_lazy(
    filter(test2_pl, !is.na(Species)),
    filter(test2, !is.na(Species))
  )
  expect_equal_lazy(
    filter(test2_pl, Species == "setosa", !is.na(Species)),
    filter(test2, Species == "setosa", !is.na(Species))
  )
  expect_equal_lazy(
    filter(test2_pl, Species == "setosa" | is.na(Species)),
    filter(test2, Species == "setosa" | is.na(Species))
  )
})

test_that("is.nan() works", {
  test2 <- as_tibble(iris)
  # TODO: this shouldn't be necessary
  test2$Species <- as.character(test2$Species)

  test2[c(3, 8, 58, 133), "Sepal.Length"] <- NaN
  test2_pl <- as_polars_lf(test2)

  expect_equal_lazy(
    filter(test2_pl, is.nan(Sepal.Length)),
    filter(test2, is.nan(Sepal.Length))
  )
  expect_equal_lazy(
    filter(test2_pl, base::is.nan(Sepal.Length)),
    filter(test2, base::is.nan(Sepal.Length))
  )
  expect_equal_lazy(
    filter(test2_pl, !is.nan(Sepal.Length)),
    filter(test2, !is.nan(Sepal.Length))
  )
  expect_equal_lazy(
    filter(test2_pl, Species == "setosa", !is.nan(Sepal.Length)),
    filter(test2, Species == "setosa", !is.nan(Sepal.Length))
  )
  expect_equal_lazy(
    filter(test2_pl, Species == "setosa" | is.nan(Sepal.Length)),
    filter(test2, Species == "setosa" | is.nan(Sepal.Length))
  )
})

test_that("%in% works", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    filter(test_pl, cyl %in% 4:5),
    filter(test, cyl %in% 4:5)
  )

  expect_equal_lazy(
    filter(test_pl, cyl %in% 4:5 & am %in% 1),
    filter(test, cyl %in% 4:5 & am %in% 1)
  )

  expect_equal_lazy(
    filter(test_pl, cyl %in% 4:5, am %in% 1),
    filter(test, cyl %in% 4:5, am %in% 1)
  )

  expect_equal_lazy(
    filter(test_pl, cyl %in% 4:5 | am %in% 1),
    filter(test, cyl %in% 4:5 | am %in% 1)
  )

  expect_equal_lazy(
    filter(test_pl, cyl %in% 4:5, vs == 1),
    filter(test, cyl %in% 4:5, vs == 1)
  )

  expect_equal_lazy(
    filter(test_pl, cyl %in% 4:5 | carb == 4),
    filter(test, cyl %in% 4:5 | carb == 4)
  )

  test <- as_tibble(iris)
  # TODO: this shouldn't be necessary
  # test$Species <- as.character(test$Species)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> filter(Species %in% c("setosa", "virginica")),
    test |> filter(Species %in% c("setosa", "virginica"))
  )

  expect_equal_lazy(
    test_pl |> filter(Species %in% c("setosa", "virginica")),
    test |> filter(Species %in% c("setosa", "virginica"))
  )

  test <- tibble(x = c(1, 2, 3), y = c(1, 3, 2))
  test_pl <- pl$LazyFrame(x = c(1, 2, 3), y = c(1, 3, 2))

  expect_equal_lazy(
    test_pl |> filter(x %in% y),
    test |> filter(x %in% y)
  )
})

test_that("%in% works with NA", {
  test <- tibble(x = c(1, 2, NA))
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> filter(x %in% c(1, NA)),
    test |> filter(x %in% c(1, NA))
  )
})

test_that("between() works", {
  test <- as_tibble(iris)
  # TODO: this shouldn't be necessary
  # test$Species <- as.character(test$Species)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    filter(test_pl, between(Sepal.Length, 5, 6)),
    filter(test, between(Sepal.Length, 5, 6))
  )

  expect_equal_lazy(
    filter(test_pl, between(Sepal.Length, 5, 6), Species == "setosa"),
    filter(test, between(Sepal.Length, 5, 6), Species == "setosa")
  )
})

test_that("works with grouped data", {
  test <- as_tibble(mtcars)
  test_pl <- as_polars_lf(test)

  by_cyl <- test |>
    group_by(cyl)
  by_cyl_pl <- test_pl |>
    group_by(cyl, maintain_order = TRUE)

  expect_equal_lazy(
    by_cyl_pl |> filter(disp == max(disp)),
    by_cyl |> filter(disp == max(disp))
  )

  expect_equal_lazy(
    test_pl |> filter(disp == max(disp), .by = cyl),
    test |> filter(disp == max(disp), .by = cyl)
  )

  expect_equal_lazy(
    by_cyl_pl |> filter(disp == max(disp)) |> attr("pl_grps"),
    "cyl"
  )

  expect_true(
    by_cyl_pl |> filter(disp == max(disp)) |> attr("maintain_grp_order")
  )

  test <- as_tibble(iris)
  # TODO: this shouldn't be necessary
  # test$Species <- as.character(test$Species)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |>
      group_by(Species) |>
      filter(Sepal.Length > median(Sepal.Length) | Petal.Width > 0.4),
    test |>
      group_by(Species) |>
      filter(Sepal.Length > median(Sepal.Length) | Petal.Width > 0.4)
  )

  expect_equal_lazy(
    test_pl |>
      filter(
        Sepal.Length > median(Sepal.Length) | Petal.Width > 0.4,
        .by = Species
      ),
    test |>
      filter(
        Sepal.Length > median(Sepal.Length) | Petal.Width > 0.4,
        .by = Species
      )
  )
})

test_that("all() and any() work with grouped data", {
  test <- tibble(
    grp = c("a", "a", "b", "b"),
    x = c(TRUE, TRUE, TRUE, FALSE)
  )
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> group_by(grp) |> filter(all(x)),
    test |> group_by(grp) |> filter(all(x))
  )

  expect_equal_lazy(
    test_pl |> group_by(grp) |> filter(any(x)),
    test |> group_by(grp) |> filter(any(x))
  )
})

test_that("works with .by", {
  test <- tibble(
    grp = c("a", "a", "b", "b"),
    x = c(TRUE, TRUE, TRUE, FALSE)
  )
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> filter(all(x), .by = starts_with("g")),
    test |> filter(all(x), .by = starts_with("g"))
  )

  expect_equal_lazy(
    test_pl |> filter(any(x), .by = starts_with("g")),
    test |> filter(any(x), .by = starts_with("g"))
  )

  expect_null(
    test_pl |> filter(all(x), .by = starts_with("g")) |> attr("pl_grps")
  )

  expect_null(
    test_pl |>
      filter(all(x), .by = starts_with("g")) |>
      attr("maintain_grp_order")
  )
})

test_that("works with a local variable defined in a function", {
  foobar <- function(x) {
    local_var <- "a"
    x |> filter(chars == local_var)
  }

  test <- tibble(chars = letters[1:3])
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    foobar(test_pl),
    foobar(test)
  )
})

test_that("error message when using =", {
  test_pl <- pl$LazyFrame(chars = letters[1:3])

  expect_snapshot_lazy(
    test_pl |> filter(chars = "a"),
    error = TRUE
  )
})

test_that("works with non-latin and weird characters", {
  test <- tibble(x = c(letters, "<other>$", "生脉胶囊"))
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> filter(x %in% c("<other>$", "生脉胶囊")),
    test |> filter(x %in% c("<other>$", "生脉胶囊"))
  )

  expect_equal_lazy(
    test_pl |> filter(x == "生脉胶囊"),
    test |> filter(x == "生脉胶囊")
  )
})

test_that("works with external tibble/list elements", {
  test <- tibble(x = 1:3)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> filter(x %in% test$x),
    test |> filter(x %in% test$x)
  )

  expect_equal_lazy(
    test_pl |> filter(x %in% test[["x"]]),
    test |> filter(x %in% test[["x"]])
  )
})

test_that("works when using [] on external objects", {
  test <- tibble(x = 1:3)
  test_pl <- as_polars_lf(test)
  obj <- 1:3

  expect_equal_lazy(
    test_pl |> filter(x %in% obj[1:2]),
    test |> filter(x %in% obj[1:2])
  )
})

test_that("NA handling is correct", {
  test <- tibble(x = c(1, NA))
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> filter(x == 1),
    test |> filter(x == 1)
  )
  expect_equal_lazy(
    test_pl |> filter_out(x == 1),
    test |> filter_out(x == 1)
  )
})

test_that("no input is equivalent to all rows being TRUE", {
  test <- tibble(x = c(1, NA))
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> filter(!!!list()),
    test |> filter(!!!list())
  )
  expect_equal_lazy(
    test_pl |> filter_out(!!!list()),
    test |> filter_out(!!!list())
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
