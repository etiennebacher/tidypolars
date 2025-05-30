test_that("basic behavior works", {
  pl_iris <- as_polars_df(iris)

  expect_is_tidypolars(filter(pl_iris, Species == "setosa"))

  expect_dim(
    filter(pl_iris, Species == "setosa"),
    c(50, 5)
  )
})

test_that("combining combinations", {
  pl_iris <- as_polars_df(iris)

  expect_dim(
    filter(pl_iris, Sepal.Length < 5 & Species == "setosa"),
    c(20, 5)
  )

  expect_dim(
    filter(pl_iris, Sepal.Length < 5, Species == "setosa"),
    c(20, 5)
  )

  expect_dim(
    filter(pl_iris, Sepal.Length < 5 | Species == "setosa"),
    c(52, 5)
  )
})

test_that("expressions work", {
  pl_iris <- as_polars_df(iris)

  expect_dim(
    filter(pl_iris, Sepal.Length < Sepal.Width + Petal.Length),
    c(115, 5)
  )
})

test_that("is.na() works", {
  pl_iris <- as_polars_df(iris)

  iris2 <- iris
  iris2[c(3, 8, 58, 133), "Species"] <- NA
  pl_iris_2 <- as_polars_df(iris2)

  expect_dim(
    filter(pl_iris_2, is.na(Species)),
    c(4, 5)
  )
  expect_dim(
    filter(pl_iris_2, !is.na(Species)),
    c(146, 5)
  )
  expect_dim(
    filter(pl_iris_2, Species == "setosa", !is.na(Species)),
    c(48, 5)
  )
  expect_dim(
    filter(pl_iris_2, Species == "setosa" | is.na(Species)),
    c(52, 5)
  )
})

test_that("is.nan() works", {
  iris2 <- iris
  iris2[c(3, 8, 58, 133), "Sepal.Length"] <- NaN
  pl_iris_2 <- as_polars_df(iris2)

  expect_dim(
    filter(pl_iris_2, is.nan(Sepal.Length)),
    c(4, 5)
  )
  expect_dim(
    filter(pl_iris_2, !is.nan(Sepal.Length)),
    c(146, 5)
  )
  expect_dim(
    filter(pl_iris_2, Species == "setosa", !is.nan(Sepal.Length)),
    c(48, 5)
  )
  expect_dim(
    filter(pl_iris_2, Species == "setosa" | is.nan(Sepal.Length)),
    c(52, 5)
  )
})

test_that("%in% works", {
  pl_mtcars <- as_polars_df(mtcars)

  expect_dim(
    filter(pl_mtcars, cyl %in% 4:5),
    c(11, 11)
  )

  expect_dim(
    filter(pl_mtcars, cyl %in% 4:5 & am %in% 1),
    c(8, 11)
  )

  expect_dim(
    filter(pl_mtcars, cyl %in% 4:5, am %in% 1),
    c(8, 11)
  )

  expect_dim(
    filter(pl_mtcars, cyl %in% 4:5 | am %in% 1),
    c(16, 11)
  )

  expect_dim(
    filter(pl_mtcars, cyl %in% 4:5, vs == 1),
    c(10, 11)
  )

  expect_dim(
    filter(pl_mtcars, cyl %in% 4:5 | carb == 4),
    c(21, 11)
  )

  expect_dim(
    iris |>
      as_polars_df() |>
      filter(Species %in% c("setosa", "virginica")),
    c(100, 5)
  )

  expect_dim(
    iris |>
      as_polars_df() |>
      filter(Species %in% c("setosa", "virginica")),
    c(100, 5)
  )
})

test_that("between() works", {
  pl_iris <- as_polars_df(iris)

  expect_dim(
    filter(pl_iris, between(Sepal.Length, 5, 6)),
    c(67, 5)
  )

  expect_dim(
    filter(pl_iris, between(Sepal.Length, 5, 6), Species == "setosa"),
    c(30, 5)
  )
})

test_that("works with grouped data", {
  by_cyl <- polars::as_polars_df(mtcars) |>
    group_by(cyl, maintain_order = TRUE)

  expect_equal(
    by_cyl |>
      filter(disp == max(disp)) |>
      pull(mpg),
    c(21.4, 24.4, 10.4)
  )

  expect_equal(
    as_polars_df(mtcars) |>
      filter(disp == max(disp), .by = cyl) |>
      pull(mpg),
    by_cyl |>
      filter(disp == max(disp)) |>
      pull(mpg)
  )

  expect_dim(
    as_polars_df(iris) |>
      group_by(Species) |>
      filter(Sepal.Length > median(Sepal.Length) | Petal.Width > 0.4),
    c(123, 5)
  )

  expect_dim(
    as_polars_df(iris) |>
      filter(
        Sepal.Length > median(Sepal.Length) | Petal.Width > 0.4,
        .by = Species
      ),
    c(123, 5)
  )

  expect_equal(
    by_cyl |>
      filter(disp == max(disp)) |>
      attr("pl_grps"),
    "cyl"
  )

  expect_true(
    by_cyl |>
      filter(disp == max(disp)) |>
      attr("maintain_grp_order")
  )
})

test_that("all() and any() work with grouped data", {
  foo <- pl$DataFrame(
    grp = c("a", "a", "b", "b"),
    x = c(TRUE, TRUE, TRUE, FALSE)
  )

  expect_dim(
    foo |>
      group_by(grp) |>
      filter(all(x)),
    c(2, 2)
  )

  expect_dim(
    foo |>
      group_by(grp) |>
      filter(any(x)),
    c(4, 2)
  )
})

test_that("works with .by", {
  foo <- pl$DataFrame(
    grp = c("a", "a", "b", "b"),
    x = c(TRUE, TRUE, TRUE, FALSE)
  )

  expect_dim(
    foo |>
      filter(all(x), .by = starts_with("g")),
    c(2, 2)
  )

  expect_dim(
    foo |>
      filter(any(x), .by = starts_with("g")),
    c(4, 2)
  )

  expect_null(
    foo |>
      filter(all(x), .by = starts_with("g")) |>
      attr("pl_grps")
  )

  expect_null(
    foo |>
      filter(all(x), .by = starts_with("g")) |>
      attr("maintain_grp_order")
  )
})

test_that("works with a local variable defined in a function", {
  foobar <- function(x) {
    local_var <- "a"
    x |> filter(chars == local_var)
  }

  test <- polars::pl$DataFrame(chars = letters[1:3])

  expect_equal(
    foobar(test),
    data.frame(chars = "a")
  )
})

test_that("error message when using =", {
  withr::local_options(polars.do_not_repeat_call = TRUE)
  test <- polars::pl$DataFrame(chars = letters[1:3])

  expect_snapshot(
    test |> filter(chars = "a"),
    error = TRUE
  )
})

test_that("works with non-latin and weird characters", {
  test <- polars::pl$DataFrame(x = c(letters, "<other>$", "生脉胶囊"))

  expect_dim(
    test |> filter(x %in% c("<other>$", "生脉胶囊")),
    c(2, 1)
  )

  expect_dim(
    test |> filter(x == "生脉胶囊"),
    c(1, 1)
  )
})

test_that("works with external data.frame/list elements", {
  test <- polars::pl$DataFrame(x = 1:3)
  test_df <- data.frame(x = 1:2)

  expect_dim(
    test |>
      filter(x %in% test_df$x),
    c(2, 1)
  )

  expect_dim(
    test |>
      filter(x %in% test_df[["x"]]),
    c(2, 1)
  )
})

test_that("works when using [] on external objects", {
  test <- polars::pl$DataFrame(x = 1:3)
  obj <- 1:3

  expect_dim(
    test |>
      filter(x %in% obj[1:2]),
    c(2, 1)
  )
})
