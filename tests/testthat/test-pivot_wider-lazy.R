### [GENERATED AUTOMATICALLY] Update test-pivot_wider.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
  test_df <- as_tibble(tidyr::fish_encounters)
  test_pl <- as_polars_lf(test_df)

  expect_is_tidypolars(
    test_pl |> pivot_wider(names_from = station, values_from = seen)
  )

  expect_equal_lazy(
    test_pl |>
      pivot_wider(names_from = station, values_from = seen) |>
      arrange(fish),
    test_df |> pivot_wider(names_from = station, values_from = seen)
  )
})

test_that("names_prefix works", {
  test_df <- as_tibble(tidyr::fish_encounters)
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |>
      pivot_wider(
        names_from = station,
        values_from = seen,
        names_prefix = "foo_"
      ) |>
      arrange(fish),
    test_df |>
      pivot_wider(
        names_from = station,
        values_from = seen,
        names_prefix = "foo_"
      )
  )

  expect_both_error(
    test_pl |>
      pivot_wider(
        names_from = station,
        values_from = seen,
        names_prefix = c("foo1", "foo2")
      ),
    test_df |>
      pivot_wider(
        names_from = station,
        values_from = seen,
        names_prefix = c("foo1", "foo2")
      )
  )
  expect_snapshot_lazy(
    test_pl |>
      pivot_wider(
        names_from = station,
        values_from = seen,
        names_prefix = c("foo1", "foo2")
      ),
    error = TRUE
  )
})

test_that("names_sep works", {
  test_df <- as_tibble(tidyr::us_rent_income)
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |>
      pivot_wider(
        names_from = variable,
        names_sep = ".",
        values_from = c(estimate, moe)
      ) |>
      arrange(GEOID, NAME),
    test_df |>
      pivot_wider(
        names_from = variable,
        names_sep = ".",
        values_from = c(estimate, moe)
      )
  )
})

test_that("values_fill works", {
  test_df <- as_tibble(tidyr::fish_encounters)
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |>
      pivot_wider(names_from = station, values_from = seen, values_fill = 0) |>
      arrange(fish),
    test_df |>
      pivot_wider(names_from = station, values_from = seen, values_fill = 0)
  )
})

test_that("several columns in names_from works", {
  test_df <- expand.grid(
    product = c("A", "B"),
    country = c("AI", "EI"),
    year = 2000:2014
  ) |>
    filter((product == "A" & country == "AI") | product == "B") |>
    mutate(production = 1:45)
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |>
      pivot_wider(
        names_from = c(product, country),
        values_from = production,
        names_sep = ".",
        names_prefix = "prod."
      ) |>
      arrange(year),
    test_df |>
      pivot_wider(
        names_from = c(product, country),
        values_from = production,
        names_sep = ".",
        names_prefix = "prod."
      )
  )
})

test_that("names_glue works", {
  test_df <- expand.grid(
    product = c("A", "B"),
    country = c("AI", "EI"),
    year = 2000:2014
  ) |>
    filter((product == "A" & country == "AI") | product == "B") |>
    mutate(production = 1:45)
  test_pl <- as_polars_lf(test_df)

  expect_equal_lazy(
    test_pl |>
      pivot_wider(
        names_from = c(product, country),
        values_from = production,
        names_glue = "prod_{product}_{country}"
      ) |>
      arrange(year),
    test_df |>
      pivot_wider(
        names_from = c(product, country),
        values_from = production,
        names_glue = "prod_{product}_{country}"
      )
  )

  expect_equal_lazy(
    test_pl |>
      pivot_wider(
        names_from = product,
        values_from = production,
        names_glue = "prod_{product}"
      ) |>
      arrange(year, country),
    test_df |>
      pivot_wider(
        names_from = product,
        values_from = production,
        names_glue = "prod_{product}"
      )
  )
})

test_that("error when overwriting existing column", {
  test_df <- tibble(
    a = c(1, 1),
    key = c("a", "b"),
    val = c(1, 2)
  )
  test_pl <- as_polars_lf(test_df)

  expect_both_error(
    pivot_wider(test_pl, names_from = key, values_from = val),
    pivot_wider(test_df, names_from = key, values_from = val)
  )
  expect_snapshot_lazy(
    pivot_wider(test_pl, names_from = key, values_from = val),
    error = TRUE
  )

  # With multiple columns in names_from
  test_df <- tibble(
    a_c = c(1, 1),
    key = c("a", "b"),
    key_2 = c("c", "d"),
    val = c(1, 2)
  )
  test_pl <- as_polars_lf(test_df)

  expect_both_error(
    pivot_wider(test_pl, names_from = c(key, key_2), values_from = val),
    pivot_wider(test_df, names_from = c(key, key_2), values_from = val)
  )
  expect_snapshot_lazy(
    pivot_wider(test_pl, names_from = c(key, key_2), values_from = val),
    error = TRUE
  )
})

test_that("`names_from` must be supplied if `name` isn't in data", {
  test_df <- tibble(key = "x", val = 1)
  test_pl <- as_polars_lf(test_df)
  expect_both_error(
    pivot_wider(test_pl, values_from = val),
    pivot_wider(test_df, values_from = val)
  )
  expect_snapshot_lazy(
    pivot_wider(test_pl, values_from = val),
    error = TRUE
  )
})

test_that("`values_from` must be supplied if `value` isn't in data", {
  test_df <- tibble(key = "x", val = 1)
  test_pl <- as_polars_lf(test_df)
  expect_both_error(
    pivot_wider(test_pl, names_from = key),
    pivot_wider(test_df, names_from = key)
  )
  expect_snapshot_lazy(
    pivot_wider(test_pl, names_from = key),
    error = TRUE
  )
})

test_that("`names_from` must identify at least 1 column", {
  test_df <- tibble(key = "x", val = 1)
  test_pl <- as_polars_lf(test_df)
  expect_both_error(
    pivot_wider(test_pl, names_from = starts_with("foo"), values_from = val),
    pivot_wider(test_df, names_from = starts_with("foo"), values_from = val)
  )
  expect_snapshot_lazy(
    pivot_wider(test_pl, names_from = starts_with("foo"), values_from = val),
    error = TRUE
  )
})

test_that("`values_from` must identify at least 1 column", {
  test_df <- tibble(key = "x", val = 1)
  test_pl <- as_polars_lf(test_df)
  expect_both_error(
    pivot_wider(test_pl, names_from = key, values_from = starts_with("foo")),
    pivot_wider(test_df, names_from = key, values_from = starts_with("foo"))
  )
  expect_snapshot_lazy(
    pivot_wider(test_pl, names_from = key, values_from = starts_with("foo")),
    error = TRUE
  )
})

test_that("`id_cols = everything()` excludes `names_from` and `values_from`", {
  test_df <- tibble(key = "x", name = "a", value = 1L)
  test_pl <- as_polars_lf(test_df)
  expect_equal_lazy(
    pivot_wider(test_pl, id_cols = everything()),
    pivot_wider(test_df, id_cols = everything())
  )
})

test_that("`id_cols` can't select columns from `names_from` or `values_from`", {
  test_df <- tibble(name = c("x", "y"), value = c(1, 2))
  test_pl <- as_polars_lf(test_df)
  expect_both_error(
    pivot_wider(
      test_pl,
      id_cols = name,
      names_from = name,
      values_from = value
    ),
    pivot_wider(test_df, id_cols = name, names_from = name, values_from = value)
  )
  expect_snapshot_lazy(
    pivot_wider(
      test_pl,
      id_cols = name,
      names_from = name,
      values_from = value
    ),
    error = TRUE
  )
  expect_both_error(
    pivot_wider(
      test_pl,
      id_cols = value,
      names_from = name,
      values_from = value
    ),
    pivot_wider(
      test_df,
      id_cols = value,
      names_from = name,
      values_from = value
    )
  )
  expect_snapshot_lazy(
    pivot_wider(
      test_pl,
      id_cols = value,
      names_from = name,
      values_from = value
    ),
    error = TRUE
  )
})

test_that("unsupported args throw warning", {
  test_df <- as_tibble(tidyr::fish_encounters)
  test_pl <- as_polars_lf(test_df)

  expect_warning(
    pivot_wider(
      test_pl,
      names_from = station,
      values_from = seen,
      names_sort = TRUE,
      names_vary = TRUE
    )
  )
})

test_that("dots must be empty", {
  test_df <- as_tibble(tidyr::fish_encounters)
  test_pl <- as_polars_lf(test_df)

  expect_both_error(
    pivot_wider(
      test_pl,
      names_from = station,
      values_from = seen,
      foo = TRUE
    ),
    pivot_wider(
      test,
      names_from = station,
      values_from = seen,
      foo = TRUE
    )
  )
  expect_snapshot_lazy(
    pivot_wider(
      test_pl,
      names_from = station,
      values_from = seen,
      foo = TRUE
    ),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
