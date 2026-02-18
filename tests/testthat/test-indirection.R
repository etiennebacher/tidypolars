test_that("basic behavior works", {
  test_df <- tibble(x = c(1, 1, 1), y = 4:6, z = c("a", "a", "b"))
  test_pl <- as_polars_df(test_df)

  add_one <- function(data, add_col) {
    data |> mutate(new_col = {{ add_col }} + 1)
  }

  add_two <- function(data, add_col) {
    data |> mutate("{{add_col}}_plus_2" := {{ add_col }} + 2)
  }

  expect_equal(
    test_pl |> add_one(x),
    test_df |> add_one(x)
  )

  expect_equal(
    test_pl |> add_two(x),
    test_df |> add_two(x)
  )

  test2 <- as_tibble(mtcars)
  test2_pl <- as_polars_df(test2)

  var_summary <- function(data, var) {
    data |> summarise(min = min({{ var }}), max = max({{ var }}))
  }

  expect_equal(
    test2_pl |>
      group_by(cyl) |>
      var_summary(mpg) |>
      arrange(min),
    test2 |>
      group_by(cyl) |>
      var_summary(mpg) |>
      arrange(min)
  )
})
