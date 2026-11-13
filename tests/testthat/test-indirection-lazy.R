### [GENERATED AUTOMATICALLY] Update test-indirection.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test_df <- tibble(x = c(1, 1, 1), y = 4:6, z = c("a", "a", "b"))
  test_pl <- as_polars_lf(test_df)

  add_one <- function(data, add_col) {
    data |> mutate(new_col = {{ add_col }} + 1)
  }

  add_two <- function(data, add_col) {
    data |> mutate("{{add_col}}_plus_2" := {{ add_col }} + 2)
  }

  expect_equal_lazy(
    test_pl |> add_one(x),
    test_df |> add_one(x)
  )

  expect_equal_lazy(
    test_pl |> add_two(x),
    test_df |> add_two(x)
  )

  test2 <- as_tibble(mtcars)
  test2_pl <- as_polars_lf(test2)

  var_summary <- function(data, var) {
    data |> summarise(min = min({{ var }}), max = max({{ var }}))
  }

  expect_equal_lazy(
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

test_that("forwarded expressions use the environment where they were written", {
  test_df <- tibble(x = 1:3, g = c("a", "a", "b"))
  test_pl <- as_polars_lf(test_df)

  # Each wrapper defines its own `val` that must not shadow the user's one.
  val <- 2L
  mutate_embrace <- function(data, expr) {
    val <- 100L
    data |> mutate(y = {{ expr }})
  }
  mutate_dots <- function(data, ...) {
    val <- 100L
    data |> mutate(...)
  }
  filter_embrace <- function(data, expr) {
    val <- 100L
    data |> filter({{ expr }})
  }
  summarise_dots <- function(data, ...) {
    val <- 100L
    data |> summarise(...)
  }
  arrange_embrace <- function(data, expr) {
    val <- 100L
    data |> arrange({{ expr }})
  }

  expect_equal_lazy(
    test_pl |> mutate_embrace(x * val),
    test_df |> mutate_embrace(x * val)
  )
  expect_equal_lazy(
    test_pl |> mutate_embrace(x * .env$val),
    test_df |> mutate_embrace(x * .env$val)
  )
  expect_equal_lazy(
    test_pl |> mutate_dots(y = x * val),
    test_df |> mutate_dots(y = x * val)
  )
  expect_equal_lazy(
    test_pl |> filter_embrace(x >= val),
    test_df |> filter_embrace(x >= val)
  )
  expect_equal_lazy(
    test_pl |> summarise_dots(y = sum(x) * val),
    test_df |> summarise_dots(y = sum(x) * val)
  )
  expect_equal_lazy(
    test_pl |> summarise_dots(y = sum(x) * val, .by = g) |> arrange(g),
    test_df |> summarise_dots(y = sum(x) * val, .by = g) |> arrange(g)
  )
  expect_equal_lazy(
    test_pl |> arrange_embrace(x %% val),
    test_df |> arrange_embrace(x %% val)
  )
})

test_that("variables local to the wrapper are still found", {
  test_df <- tibble(x = 1:3)
  test_pl <- as_polars_lf(test_df)

  val <- 2L
  mutate_local <- function(data) {
    val <- 100L
    data |> mutate(y = x * val)
  }
  mutate_quo <- function(data) {
    val <- 100L
    expr <- quo(x * val)
    data |> mutate(y = !!expr)
  }

  expect_equal_lazy(
    test_pl |> mutate_local(),
    test_df |> mutate_local()
  )
  expect_equal_lazy(
    test_pl |> mutate_quo(),
    test_df |> mutate_quo()
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
