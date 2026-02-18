test_that("basic behavior works", {
  test_df <- tibble(
    grp = rep(c("A", "B"), each = 3),
    x = c(NA, 1, NA, NA, 2, NA),
    y = c(3, NA, 4, NA, 3, 1)
  )
  test_pl <- as_polars_df(test_df)

  expect_is_tidypolars(fill(test_pl, everything(), .direction = "down"))

  expect_equal(
    fill(test_pl, everything(), .direction = "down"),
    fill(test_df, everything(), .direction = "down")
  )

  expect_equal(
    fill(test_pl, everything(), .direction = "down"),
    fill(test_pl, x, y)
  )

  expect_equal(
    fill(test_pl, everything(), .direction = "updown"),
    fill(test_df, everything(), .direction = "updown")
  )

  expect_equal(
    fill(test_pl, everything(), .direction = "downup"),
    fill(test_df, everything(), .direction = "downup")
  )
})

test_that("when nothing to fill, input = output", {
  test_df <- tibble(
    grp = rep(c("A", "B"), each = 3),
    x = c(NA, 1, NA, NA, 2, NA),
    y = c(3, NA, 4, NA, 3, 1)
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> fill(.direction = "updown"),
    test_df |> fill(.direction = "updown")
  )
})

test_that("works with grouped data", {
  test_df <- tibble(
    grp = rep(c("A", "B"), each = 3),
    x = c(NA, 1, NA, NA, 2, NA),
    y = c(3, NA, 4, NA, 3, 1)
  )
  test_pl <- as_polars_df(test_df)
  test_pl_grp <- test_pl |>
    group_by(grp, maintain_order = TRUE)
  test_grp <- test_df |>
    group_by(grp)

  expect_equal(
    fill(test_pl_grp, everything(), .direction = "down"),
    fill(test_grp, everything(), .direction = "down")
  )

  expect_equal(
    fill(test_pl_grp, everything(), .direction = "downup"),
    fill(test_grp, everything(), .direction = "downup")
  )

  expect_equal(
    fill(test_pl_grp, everything(), .direction = "updown"),
    fill(test_grp, everything(), .direction = "updown")
  )

  expect_equal(
    fill(test_pl_grp, everything(), .direction = "down") |> attr("pl_grps"),
    "grp"
  )

  expect_true(
    fill(test_pl_grp, everything(), .direction = "down") |>
      attr("maintain_grp_order")
  )
})

test_that("argument '.by' works", {
  test_df <- tibble(
    grp = rep(c("A", "B"), each = 3),
    x = c(NA, 1, NA, NA, 2, NA),
    y = c(3, NA, 4, NA, 3, 1)
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    fill(test_pl, everything(), .direction = "down", .by = grp),
    fill(test_df, everything(), .direction = "down", .by = grp)
  )
})
