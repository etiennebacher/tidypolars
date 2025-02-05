test_that("basic behavior works", {
  test <- polars::pl$DataFrame(
    country = c("France", "France", "UK", "UK", "Spain"),
    year = c(2020, 2021, 2019, 2020, 2022),
    value = c(1, 2, 3, 4, 5)
  )

  expect_is_tidypolars(complete(test, country, year))

  expect_dim(
    complete(test, country, year),
    c(12, 3)
  )

  expect_equal(
    complete(test, country, year) |>
      pull(country),
    rep(c("France", "Spain", "UK"), each = 4)
  )

  expect_equal(
    complete(test, country, year) |>
      slice_head(n = 4) |>
      pull(value),
    c(NA, 1, 2, NA)
  )

  expect_equal(
    complete(test, country, year, fill = list(value = 99)) |>
      slice_head(n = 4) |>
      pull(value),
    c(99, 1, 2, 99)
  )

  expect_equal(
    complete(test, country),
    test
  )
})

test_that("works on grouped data", {
  df <- pl$DataFrame(
    g = c("a", "b", "a"),
    a = c(1L, 1L, 2L),
    b = c("a", "a", "b"),
    c = c(4, 5, 6)
  )
  gdf <- group_by(df, g, maintain_order = TRUE)
  out <- complete(gdf, a, b)

  expect_equal(
    out,
    data.frame(
      g = c(rep("a", 4), "b"),
      a = c(1, 1, 2, 2, 1),
      b = c("a", "b", "a", "b", "a"),
      c = c(4, NA, NA, 6, 5)
    )
  )

  expect_equal(
    attr(out, "pl_grps"),
    "g"
  )

  expect_equal(
    attr(out, "maintain_grp_order"),
    TRUE
  )
})

test_that("argument 'explicit' works", {
  df <- pl$DataFrame(
    g = c("a", "b", "a"),
    a = c(1L, 1L, 2L),
    b = c("a", NA, "b"),
    c = c(4, 5, NA)
  )

  expect_equal(
    df |>
      complete(g, a, fill = list(b = "foo", c = 1), explicit = FALSE),
    data.frame(
      g = rep(c("a", "b"), each = 2),
      a = rep(1:2, 2),
      b = c("a", "b", NA, "foo"),
      c = c(4, NA, 5, 1)
    )
  )

  expect_equal(
    df |>
      group_by(g, maintain_order = TRUE) |>
      complete(a, b, fill = list(c = 1), explicit = FALSE),
    data.frame(
      g = rep(c("a", "b"), c(4L, 1L)),
      a = c(1L, 1L, 2L, 2L, 1L),
      b = c("a", "b", "a", "b", NA),
      c = c(4, 1, 1, NA, 5)
    )
  )
})

test_that("can use named arguments", {
  df <- pl$DataFrame(
    group = c(1:2, 1, 2),
    item_id = c(1:2, 2, 3),
    item_name = c("a", "a", "b", "b"),
    value1 = c(1, NA, 3, 4),
    value2 = 4:7
  )

  expect_equal(
    complete(df, group, value1 = c(1, 2, 3, 4)),
    data.frame(
      group = rep(c(1, 2), 4:5),
      value1 = c(1, 2, 3, 4, 1, 2, 3, 4, NA),
      item_id = c(1, NA, 2, NA, NA, NA, NA, 3, 2),
      item_name = c("a", NA, "b", NA, NA, NA, NA, "b", "a"),
      value2 = c(4L, NA, 6L, NA, NA, NA, NA, 7L, 5L)
    )
  )

  # expect_equal(
  #   complete(df, value1 = c(1, 2, 3, 4)),
  #   data.frame(
  #     group = rep(c(1, 2), 4:5),
  #     value1 = c(1, 2, 3, 4, 1, 2, 3, 4, NA),
  #     item_id = c(1, NA, 2, NA, NA, NA, NA, 3, 2),
  #     item_name = c("a", NA, "b", NA, NA, NA, NA, "b", "a"),
  #     value2 = c(4L, NA, 6L, NA, NA, NA, NA, 7L, 5L)
  #   )
  # )

  # add a test with "value1 = ..., group" to ensure that column order
  # matches tidyr's
})
