### [GENERATED AUTOMATICALLY] Update test-show_query.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

get_query <- function(x) {
  attr(x, "tp_query", exact = TRUE)
}

replay_query <- function(x) {
  pl <- polars::pl
  out <- eval(parse(text = get_query(x)))
  if (is_polars_lf(out)) {
    out$collect()
  } else {
    out
  }
}

test_that("basic behavior works", {
  query <- mtcars |>
    as_polars_lf() |>
    arrange(cyl, desc(disp)) |>
    distinct(cyl, am, .keep_all = TRUE)

  expect_snapshot_lazy(show_query(query))

  expect_equal_lazy(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("show_query() works with group_by() and summarize()", {
  query <- mtcars |>
    as_polars_lf() |>
    group_by(cyl, maintain_order = TRUE) |>
    summarize(mean_mpg = mean(mpg)) |>
    ungroup()

  expect_snapshot_lazy(show_query(query))

  expect_equal_lazy(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("show_query() works with joins and shows the query of both inputs", {
  lhs <- as_polars_lf(mtcars) |> select(cyl, mpg)
  rhs <- as_polars_lf(mtcars) |> summarize(mean_mpg = mean(mpg), .by = cyl)
  query <- left_join(lhs, rhs, by = "cyl")

  expect_snapshot_lazy(show_query(query))

  expect_equal_lazy(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("show_query() works with across()", {
  query <- mtcars |>
    as_polars_lf() |>
    mutate(across(contains("m"), mean))

  expect_snapshot_lazy(show_query(query))

  expect_equal_lazy(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("user-defined functions returning polars expressions are recorded", {
  pl_standardize <- function(x) {
    (x - x$mean()) / x$std()
  }
  query <- mtcars |>
    as_polars_lf() |>
    mutate(mpg_std = pl_standardize(mpg)) |>
    select(mpg_std)

  expect_snapshot_lazy(show_query(query))

  expect_equal_lazy(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("compute() records the $collect() call", {
  skip_if(!nzchar(Sys.getenv('TIDYPOLARS_TEST')))
  query <- mtcars |>
    as_polars_lf() |>
    filter(cyl == 4) |>
    compute()

  expect_match(get_query(query), "$collect(", fixed = TRUE)

  expect_equal_lazy(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("long vectors are truncated in the query", {
  large <- runif(200)
  query <- mtcars |>
    as_polars_lf() |>
    mutate(foo = mpg %in% large)

  expect_match(get_query(query), "<numeric of length 200>", fixed = TRUE)
})

test_that("the input data is not modified by the recording", {
  test_pl <- as_polars_lf(mtcars)
  invisible(mutate(test_pl, foo = 1))

  expect_false(inherits(test_pl, "tp_recorded"))
  expect_null(get_query(test_pl))
  expect_snapshot_lazy(show_query(test_pl), error = TRUE)
})

test_that("errors in the pipeline are not affected by the recording", {
  test_pl <- as_polars_lf(data.frame(char1 = c("a", "b")))
  expect_snapshot_lazy(
    mutate(test_pl, char1 = as.integer(char1)),
    error = TRUE
  )
})

test_that("option tidypolars_record_query = FALSE disables the recording", {
  withr::local_options(tidypolars_record_query = FALSE)

  query <- mtcars |>
    as_polars_lf() |>
    filter(cyl == 4)

  expect_null(get_query(query))
  expect_snapshot_lazy(show_query(query), error = TRUE)
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
