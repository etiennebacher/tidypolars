get_query <- function(x) {
  attr(x, "tp_query", exact = TRUE)
}

replay_query <- function(x) {
  pl <- polars::pl
  out <- eval(parse(text = get_query(x)), envir = caller_env())
  if (is_polars_lf(out)) {
    out$collect()
  } else {
    out
  }
}

test_that("basic behavior works", {
  query <- mtcars |>
    as_polars_df() |>
    arrange(cyl, desc(disp)) |>
    distinct(cyl, am, .keep_all = TRUE)

  expect_snapshot(show_query(query))

  expect_equal(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("show_query() works with group_by() and summarize()", {
  query <- mtcars |>
    as_polars_df() |>
    group_by(cyl, maintain_order = TRUE) |>
    summarize(mean_mpg = mean(mpg)) |>
    ungroup()

  expect_snapshot(show_query(query))

  expect_equal(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("show_query() works with joins and shows the query of both inputs", {
  lhs <- as_polars_df(mtcars) |> select(cyl, mpg)
  rhs <- as_polars_df(mtcars) |> summarize(mean_mpg = mean(mpg), .by = cyl)
  query <- left_join(lhs, rhs, by = "cyl")

  expect_snapshot(show_query(query))

  expect_equal(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("show_query() works with across()", {
  query <- mtcars |>
    as_polars_df() |>
    mutate(across(contains("m"), mean))

  expect_snapshot(show_query(query))

  expect_equal(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("user-defined functions returning polars expressions are recorded", {
  pl_standardize <- function(x) {
    (x - x$mean()) / x$std()
  }
  query <- mtcars |>
    as_polars_df() |>
    mutate(mpg_std = pl_standardize(mpg)) |>
    select(mpg_std)

  expect_snapshot(show_query(query))

  expect_equal(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("compute() records the $collect() call", {
  skip_if(Sys.getenv('TIDYPOLARS_TEST') %in% c("", "FALSE"))
  query <- mtcars |>
    as_polars_df() |>
    filter(cyl == 4) |>
    compute()

  expect_match(get_query(query), "$collect(", fixed = TRUE)

  expect_equal(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("long vectors are truncated in the query", {
  large <- runif(200)
  query <- mtcars |>
    as_polars_df() |>
    mutate(foo = mpg %in% large)

  expect_snapshot(show_query(query))
})

test_that("the input data is not modified by the recording", {
  test_pl <- as_polars_df(mtcars)
  invisible(mutate(test_pl, foo = 1))

  expect_false(inherits(test_pl, "tp_recorded"))
  expect_null(get_query(test_pl))
  expect_snapshot(show_query(test_pl), error = TRUE)
})

test_that("errors in the pipeline are not affected by the recording", {
  test_pl <- as_polars_df(data.frame(char1 = c("a", "b")))
  expect_snapshot(
    mutate(test_pl, char1 = as.integer(char1)),
    error = TRUE
  )
})

test_that("option tidypolars_record_query = FALSE disables the recording", {
  withr::local_options(tidypolars_record_query = FALSE)

  query <- mtcars |>
    as_polars_df() |>
    filter(cyl == 4)

  expect_null(get_query(query))
  expect_snapshot(show_query(query), error = TRUE)
})

# Test code from vignettes and examples

test_that("vignette 'Getting started': who pipeline", {
  who_pl <- as_polars_df(tidyr::who)

  query <- who_pl |>
    filter(year > 1990) |>
    drop_na(newrel_f3544) |>
    select(iso3, year, matches("^newrel(.*)_f")) |>
    arrange(iso3, year) |>
    rename_with(.fn = toupper) |>
    head()

  expect_snapshot(show_query(query))

  expect_equal(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("vignette 'R and Polars expressions': unsupported argument is dropped", {
  query <- suppressWarnings(
    mtcars |>
      as_polars_df() |>
      mutate(x = mean(mpg, trim = 2))
  )

  expect_snapshot(show_query(query))

  expect_equal(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("vignette 'R and Polars expressions': external object in filter", {
  dat <- pl$DataFrame(foo = c(2, 1, 2))
  a <- c("d", "e", "f")

  query <- dat |>
    filter(foo >= agrep("a", a))

  expect_snapshot(show_query(query))

  expect_equal(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})

test_that("show_query() example: grouped mutate with .by", {
  query <- mtcars |>
    as_polars_df() |>
    filter(cyl == 4) |>
    mutate(mpg2 = mpg * 2, .by = am)

  expect_snapshot(show_query(query))

  expect_equal(
    as_tibble(replay_query(query)),
    as_tibble(query)
  )
})
