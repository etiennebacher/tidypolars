test_that("unnest_longer_polars returns custom class", {
  df <- polars::pl$DataFrame(
    id = 1:3,
    values = list(c(1, 2), c(3, 4, 5), 6)
  )
  expect_is_tidypolars(df |> unnest_longer_polars(values))
})

test_that("basic unnest works", {
  df <- polars::pl$DataFrame(
    id = 1:3,
    values = list(c(1, 2), c(3, 4, 5), 6)
  )

  expect_equal(
    df |> unnest_longer_polars(values),
    as.data.frame(df) |> tidyr::unnest_longer(values) |> as.data.frame()
  )
})

test_that("unnest with values_to works", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    values = list(c(1, 2), c(3, 4))
  )

  expect_equal(
    df |> unnest_longer_polars(values, values_to = "val"),
    as.data.frame(df) |>
      tidyr::unnest_longer(values, values_to = "val") |>
      as.data.frame()
  )
})

test_that("unnest with indices_to works", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    values = list(c(10, 20), c(30, 40, 50))
  )

  expect_equal(
    df |> unnest_longer_polars(values, indices_to = "idx"),
    as.data.frame(df) |>
      tidyr::unnest_longer(values, indices_to = "idx") |>
      as.data.frame()
  )
})

test_that("unnest with both values_to and indices_to works", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    values = list(c(10, 20), c(30, 40, 50))
  )

  expect_equal(
    df |> unnest_longer_polars(values, values_to = "val", indices_to = "idx"),
    as.data.frame(df) |>
      tidyr::unnest_longer(
        values,
        values_to = "val",
        indices_to = "idx"
      ) |>
      as.data.frame()
  )
})

test_that("keep_empty = FALSE drops NULL values", {
  df <- polars::pl$DataFrame(
    id = 1:3,
    values = list(c(1, 2), NULL, 3)
  )

  expect_equal(
    df |> unnest_longer_polars(values, keep_empty = FALSE),
    as.data.frame(df) |>
      tidyr::unnest_longer(values, keep_empty = FALSE) |>
      as.data.frame()
  )
})

test_that("keep_empty = TRUE keeps NULL values as NA", {
  df <- polars::pl$DataFrame(
    id = 1:3,
    values = list(c(1, 2), NULL, 3)
  )

  expect_equal(
    df |> unnest_longer_polars(values, keep_empty = TRUE),
    as.data.frame(df) |>
      tidyr::unnest_longer(values, keep_empty = TRUE) |>
      as.data.frame()
  )
})

test_that("unnest works with string list columns", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    tags = list(c("apple", "banana"), c("grape", "pear"))
  )

  expect_equal(
    df |> unnest_longer_polars(tags),
    as.data.frame(df) |> tidyr::unnest_longer(tags) |> as.data.frame()
  )
})

test_that("column can be specified as string", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    values = list(c(1, 2), c(3, 4))
  )

  expect_equal(
    df |> unnest_longer_polars("values"),
    as.data.frame(df) |> tidyr::unnest_longer("values") |> as.data.frame()
  )
})

test_that("multiple columns can be unnested together", {
  df <- polars::pl$DataFrame(
    id = 1:3,
    a = list(c(1, 2), c(3, 4), c(5, 7, 6)),
    b = list(c("x", "y"), c("z", "w"), c("u", "v", "w"))
  )

  expect_equal(
    df |> unnest_longer_polars(c(a, b)),
    as.data.frame(df) |> tidyr::unnest_longer(c(a, b)) |> as.data.frame()
  )
})

test_that("chained unnest_longer works", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    a = list(1:2, 3:4),
    b = list(5:6, 7:8)
  )

  expect_equal(
    df |>
      unnest_longer_polars(a) |>
      unnest_longer_polars(b),
    as.data.frame(df) |>
      tidyr::unnest_longer(a) |>
      tidyr::unnest_longer(b) |>
      as.data.frame()
  )
})

test_that("multiple columns can be specified as character vector", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    a = list(c(1, 2), c(3, 4)),
    b = list(c("x", "y"), c("z", "w"))
  )

  expect_equal(
    df |> unnest_longer_polars(c("a", "b")),
    as.data.frame(df) |> tidyr::unnest_longer(c("a", "b")) |> as.data.frame()
  )
})

test_that("values_to errors with multiple columns without template", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    a = list(1:2, 3:4),
    b = list(5:6, 7:8)
  )

  expect_snapshot(
    df |> unnest_longer_polars(c(a, b), values_to = "val"),
    error = TRUE
  )
})

test_that("indices_to errors with multiple columns without template", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    a = list(1:2, 3:4),
    b = list(5:6, 7:8)
  )

  expect_snapshot(
    df |> unnest_longer_polars(c(a, b), indices_to = "idx"),
    error = TRUE
  )
})

test_that("values_to template works with multiple columns", {
  df <- polars::pl$DataFrame(
    x = c(1L, 2L),
    y = list(c(1L, 2L), c(3L, 4L)),
    z = list(c(5L, 6L), c(7L, 8L))
  )

  expect_equal(
    df |> unnest_longer_polars(c(y, z), values_to = "{col}_val"),
    as.data.frame(df) |>
      tidyr::unnest_longer(
        c(y, z),
        values_to = "{col}_val"
      ) |>
      as.data.frame()
  )
})

test_that("indices_to template works with multiple columns", {
  df <- polars::pl$DataFrame(
    x = c(1L, 2L),
    y = list(c(1L, 2L), c(3L, 4L)),
    z = list(c(5L, 6L), c(7L, 8L))
  )

  # Warning: `tidyr::unnest_longer()` places the index column immediately
  # after the corresponding value column.
  # `unnest_longer_polars()` currently places all index columns at the end.
  columns <- c("x", "y", "y_idx", "z", "z_idx")

  expect_equal(
    df |>
      unnest_longer_polars(
        c(y, z),
        indices_to = "{col}_idx"
      ) |>
      select(all_of(columns)),
    as.data.frame(df) |>
      tidyr::unnest_longer(
        c(y, z),
        indices_to = "{col}_idx"
      ) |>
      select(all_of(columns)) |>
      as.data.frame()
  )
})

test_that("both values_to and indices_to templates work together", {
  df <- polars::pl$DataFrame(
    x = c(1L, 2L),
    y = list(c(1L, 2L), c(3L, 4L)),
    z = list(c(5L, 6L), c(7L, 8L))
  )

  columns <- c("x", "y_val", "y_idx", "z_val", "z_idx")

  expect_equal(
    df |>
      unnest_longer_polars(
        c(y, z),
        values_to = "{col}_val",
        indices_to = "{col}_idx"
      ) |>
      select(all_of(columns)),
    as.data.frame(df) |>
      tidyr::unnest_longer(
        c(y, z),
        values_to = "{col}_val",
        indices_to = "{col}_idx"
      ) |>
      select(all_of(columns)) |>
      as.data.frame()
  )
})

test_that("errors on non-polars data", {
  df <- data.frame(id = 1:2, values = I(list(1:2, 3:4)))

  expect_snapshot(
    df |> unnest_longer_polars(values),
    error = TRUE
  )
})

test_that("errors on non-existent column", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    values = list(c(1, 2), c(3, 4))
  )

  expect_snapshot(
    df |> unnest_longer_polars(nonexistent),
    error = TRUE
  )
})

test_that("errors when no column is provided", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    values = list(c(1, 2), c(3, 4))
  )

  expect_snapshot(
    df |> unnest_longer_polars(),
    error = TRUE
  )
})

test_that("errors when ... is not empty", {
  df <- polars::pl$DataFrame(
    id = 1:2,
    values = list(c(1, 2), c(3, 4))
  )

  expect_snapshot(
    df |> unnest_longer_polars(values, extra_arg = TRUE),
    error = TRUE
  )
})
