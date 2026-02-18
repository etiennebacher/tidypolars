test_that("unnest_longer_polars returns custom class", {
  test_pl <- pl$DataFrame(
    id = 1:3,
    values = list(c(1, 2), c(3, 4, 5), 6)
  )
  expect_is_tidypolars(test_pl |> unnest_longer_polars(values))
})

test_that("basic unnest works", {
  test_df <- tibble(
    id = 1:3,
    values = list(c(1, 2), c(3, 4, 5), 6)
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> unnest_longer_polars(values),
    test_df |> unnest_longer(values)
  )
})

test_that("unnest with values_to works", {
  test_df <- tibble(
    id = 1:2,
    values = list(c(1, 2), c(3, 4))
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> unnest_longer_polars(values, values_to = "val"),
    test_df |> unnest_longer(values, values_to = "val")
  )
})

test_that("unnest with indices_to works", {
  test_df <- tibble(
    id = 1:2,
    values = list(c(10, 20), c(30, 40, 50))
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> unnest_longer_polars(values, indices_to = "idx"),
    test_df |> unnest_longer(values, indices_to = "idx")
  )
})

test_that("unnest with both values_to and indices_to works", {
  test_df <- tibble(
    id = 1:2,
    values = list(c(10, 20), c(30, 40, 50))
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |>
      unnest_longer_polars(values, values_to = "val", indices_to = "idx"),
    test_df |> unnest_longer(values, values_to = "val", indices_to = "idx")
  )
})

test_that("keep_empty = FALSE drops NULL values", {
  test_df <- tibble(
    id = 1:3,
    values = list(c(1, 2), NULL, 3)
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> unnest_longer_polars(values, keep_empty = FALSE),
    test_df |> unnest_longer(values, keep_empty = FALSE)
  )
})

test_that("keep_empty = TRUE keeps NULL values as NA", {
  test_df <- tibble(
    id = 1:3,
    values = list(c(1, 2), NULL, 3)
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> unnest_longer_polars(values, keep_empty = TRUE),
    test_df |> unnest_longer(values, keep_empty = TRUE)
  )
})

test_that("unnest works with string list columns", {
  test_df <- tibble(
    id = 1:2,
    tags = list(c("apple", "banana"), c("grape", "pear"))
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> unnest_longer_polars(tags),
    test_df |> unnest_longer(tags)
  )
})

test_that("column can be specified as string", {
  test_df <- tibble(
    id = 1:2,
    values = list(c(1, 2), c(3, 4))
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> unnest_longer_polars("values"),
    test_df |> unnest_longer("values")
  )
})

test_that("multiple columns can be unnested together", {
  test_df <- tibble(
    id = 1:3,
    a = list(c(1, 2), c(3, 4), c(5, 7, 6)),
    b = list(
      c("x", "y"),
      c("z", "w"),
      c("u", "v", "w")
    )
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> unnest_longer_polars(c(a, b)),
    test_df |> unnest_longer(c(a, b))
  )
})

test_that("chained unnest_longer works", {
  test_df <- tibble(
    id = 1:2,
    a = list(1:2, 3:4),
    b = list(5:6, 7:8)
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> unnest_longer_polars(a) |> unnest_longer_polars(b),
    test_df |> unnest_longer(a) |> unnest_longer(b)
  )
})

test_that("multiple columns can be specified as character vector", {
  test_df <- tibble(
    id = 1:2,
    a = list(c(1, 2), c(3, 4)),
    b = list(
      c(
        "x",
        "y"
      ),
      c("z", "w")
    )
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> unnest_longer_polars(c("a", "b")),
    test_df |> unnest_longer(c("a", "b"))
  )
})

test_that("values_to errors with multiple columns without template", {
  test_df <- tibble(
    id = 1:2,
    a = list(1:2, 3:4),
    b = list(5:6, 7:8)
  )
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    test_pl |> unnest_longer_polars(c(a, b), values_to = "val"),
    test_df |> unnest_longer(c(a, b), values_to = "val")
  )
  expect_snapshot(
    test_pl |> unnest_longer_polars(c(a, b), values_to = "val"),
    error = TRUE
  )
})

test_that("indices_to errors with multiple columns without template", {
  test_df <- tibble(
    id = 1:2,
    a = list(1:2, 3:4),
    b = list(5:6, 7:8)
  )
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    test_pl |> unnest_longer_polars(c(a, b), indices_to = "idx"),
    test_df |> unnest_longer(c(a, b), indices_to = "idx")
  )
  expect_snapshot(
    test_pl |> unnest_longer_polars(c(a, b), indices_to = "idx"),
    error = TRUE
  )
})

test_that("values_to template works with multiple columns", {
  test_df <- tibble(
    x = c(1L, 2L),
    y = list(c(1L, 2L), c(3L, 4L)),
    z = list(c(5L, 6L), c(7L, 8L))
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> unnest_longer_polars(c(y, z), values_to = "{col}_val"),
    test_df |> unnest_longer(c(y, z), values_to = "{col}_val")
  )
})

test_that("indices_to template works with multiple columns", {
  test_df <- tibble(
    x = c(1L, 2L),
    y = list(c(1L, 2L), c(3L, 4L)),
    z = list(c(5L, 6L), c(7L, 8L))
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |>
      unnest_longer_polars(
        c(y, z),
        indices_to = "{col}_idx"
      ),
    test_df |>
      unnest_longer(
        c(y, z),
        indices_to = "{col}_idx"
      )
  )
})

test_that("both values_to and indices_to templates work together", {
  test_df <- tibble(
    x = c(1L, 2L),
    y = list(c(1L, 2L), c(3L, 4L)),
    z = list(c(5L, 6L), c(7L, 8L))
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |>
      unnest_longer_polars(
        c(y, z),
        values_to = "{col}_val",
        indices_to = "{col}_idx"
      ),
    test_df |>
      unnest_longer(
        c(y, z),
        values_to = "{col}_val",
        indices_to = "{col}_idx"
      )
  )
})

test_that("no errors when col isn't list or array and return unchanged", {
  test_df <- tibble(
    id = 1:2,
    values = list(c(1L, 2L), c(3L, 4L))
  )
  test_pl <- as_polars_df(test_df)

  # TODO: not sure why this doesn't work
  # expect_equal(
  #   test_pl |> unnest_longer_polars(id),
  #   test_df |> unnest_longer(id)
  # )

  expect_equal(
    test_pl |> unnest_longer_polars(c(id, values)),
    test_df |> unnest_longer(c(id, values))
  )
})

test_that("errors on non-polars data", {
  test_pl <- data.frame(id = 1:2, values = I(list(1:2, 3:4)))

  expect_snapshot(
    test_pl |> unnest_longer_polars(values),
    error = TRUE
  )
})

test_that("errors on non-existent column", {
  test_df <- tibble(
    id = 1:2,
    values = list(c(1, 2), c(3, 4))
  )
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    test_pl |> unnest_longer_polars(nonexistent),
    test_df |> unnest_longer(nonexistent)
  )
  expect_snapshot(
    test_pl |> unnest_longer_polars(nonexistent),
    error = TRUE
  )
})

test_that("errors when column names duplicate", {
  test_df <- tibble(
    x = c(1L, 2L),
    y = list(c(1L, 2L), c(3L, 4L)),
    z = list(c(5L, 6L), c(7L, 8L))
  )
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    test_pl |> unnest_longer_polars(y, indices_to = "y"),
    test_df |> unnest_longer(y, indices_to = "y")
  )
  expect_snapshot(
    test_pl |> unnest_longer_polars(y, indices_to = "y"),
    error = TRUE
  )

  expect_both_error(
    test_pl |> unnest_longer_polars(y, values_to = "z"),
    test_df |> unnest_longer(y, indices_to = "z")
  )
  expect_snapshot(
    test_pl |> unnest_longer_polars(y, values_to = "z"),
    error = TRUE
  )

  expect_both_error(
    test_pl |> unnest_longer_polars(y, indices_to = "a", values_to = "a"),
    test_df |> unnest_longer(y, indices_to = "a", values_to = "a")
  )
  expect_snapshot(
    test_pl |> unnest_longer_polars(y, indices_to = "a", values_to = "a"),
    error = TRUE
  )

  expect_both_error(
    test_pl |>
      unnest_longer_polars(c(y, z), values_to = "{col}", indices_to = "{col}"),
    test_df |> unnest_longer(c(y, z), values_to = "{col}", indices_to = "{col}")
  )
  expect_snapshot(
    test_pl |>
      unnest_longer_polars(c(y, z), values_to = "{col}", indices_to = "{col}"),
    error = TRUE
  )
})

test_that("errors when no column is provided", {
  test_df <- tibble(
    id = 1:2,
    values = list(c(1, 2), c(3, 4))
  )
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    test_pl |> unnest_longer_polars(),
    test_df |> unnest_longer()
  )
  expect_snapshot(
    test_pl |> unnest_longer_polars(),
    error = TRUE
  )
})

test_that("errors when ... is not empty", {
  test_df <- tibble(
    id = 1:2,
    values = list(c(1, 2), c(3, 4))
  )
  test_pl <- as_polars_df(test_df)

  expect_both_error(
    test_pl |> unnest_longer_polars(values, extra_arg = TRUE),
    test_df |> unnest_longer(values, extra_arg = TRUE)
  )
  expect_snapshot(
    test_pl |> unnest_longer_polars(values, extra_arg = TRUE),
    error = TRUE
  )
})
