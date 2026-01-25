test_that("basic behavior works", {
  fish_encounters <- as.data.frame(tidyr::fish_encounters)
  fish_encounters_pl <- as_polars_df(fish_encounters)

  out <- fish_encounters_pl |>
    pivot_wider(names_from = station, values_from = seen)

  expect_is_tidypolars(out)

  expect_equal(
    out,
    fish_encounters |>
      tidyr::pivot_wider(names_from = station, values_from = seen) |>
      as.data.frame()
  )
  expect_colnames(
    out,
    c(
      "fish",
      "Release",
      "I80_1",
      "Lisbon",
      "Rstr",
      "Base_TD",
      "BCE",
      "BCW",
      "BCE2",
      "BCW2",
      "MAE",
      "MAW"
    )
  )

  first <- slice_head(out, n = 5)

  expect_equal(
    pull(first, I80_1),
    rep(1, 5)
  )
  expect_equal(
    pull(first, BCE2),
    c(1, 1, 1, NA, NA)
  )
})

test_that("names_prefix works", {
  fish_encounters <- as.data.frame(tidyr::fish_encounters)
  fish_encounters_pl <- as_polars_df(fish_encounters)

  prefixed <- fish_encounters_pl |>
    pivot_wider(
      names_from = station,
      values_from = seen,
      names_prefix = "foo_"
    ) |>
    slice_head(n = 5)

  expect_equal(
    names(prefixed)[11:12],
    c("foo_MAE", "foo_MAW")
  )

  expect_snapshot(
    fish_encounters_pl |>
      pivot_wider(
        names_from = station,
        values_from = seen,
        names_prefix = c("foo1", "foo2")
      ),
    error = TRUE
  )
})

test_that("names_sep works", {
  us_rent_income <- as.data.frame(tidyr::us_rent_income)
  us_rent_income_pl <- as_polars_df(us_rent_income)

  expect_equal(
    us_rent_income |>
      tidyr::pivot_wider(
        names_from = variable,
        names_sep = ".",
        values_from = c(estimate, moe)
      ) |>
      as.data.frame(),
    us_rent_income_pl |>
      pivot_wider(
        names_from = variable,
        names_sep = ".",
        values_from = c(estimate, moe)
      )
  )
})

test_that("values_fill works", {
  fish_encounters <- as.data.frame(tidyr::fish_encounters)
  fish_encounters_pl <- as_polars_df(fish_encounters)

  filled <- fish_encounters_pl |>
    pivot_wider(names_from = station, values_from = seen, values_fill = 0) |>
    slice_head(n = 5)

  expect_equal(
    pull(filled, I80_1),
    rep(1, 5)
  )
  expect_equal(
    pull(filled, BCE2),
    c(1, 1, 1, 0, 0)
  )
})

test_that("several columns in names_from works", {
  production <- expand.grid(
    product = c("A", "B"),
    country = c("AI", "EI"),
    year = 2000:2014
  ) |>
    dplyr::filter((product == "A" & country == "AI") | product == "B") |>
    dplyr::mutate(production = 1:45)
  production_pl <- as_polars_df(production)

  wide <- production_pl |>
    pivot_wider(
      names_from = c(product, country),
      values_from = production,
      names_sep = ".",
      names_prefix = "prod."
    )

  expect_equal(
    wide |> slice_head(n = 1),
    data.frame(year = 2000, prod.A.AI = 1, prod.B.AI = 2, prod.B.EI = 3)
  )
})

test_that("names_glue works", {
  production <- expand.grid(
    product = c("A", "B"),
    country = c("AI", "EI"),
    year = 2000:2014
  ) |>
    dplyr::filter((product == "A" & country == "AI") | product == "B") |>
    dplyr::mutate(production = 1:45)
  production_pl <- as_polars_df(production)

  wide <- production_pl |>
    pivot_wider(
      names_from = c(product, country),
      values_from = production,
      names_glue = "prod_{product}_{country}"
    )

  expect_equal(
    wide |> slice_head(n = 1),
    data.frame(year = 2000, prod_A_AI = 1, prod_B_AI = 2, prod_B_EI = 3)
  )

  wide <- production_pl |>
    pivot_wider(
      names_from = product,
      values_from = production,
      names_glue = "prod_{product}"
    )

  expect_equal(
    wide |> slice_head(n = 2),
    data.frame(
      country = factor(c("AI", "EI")),
      year = c(2000, 2000),
      prod_A = c(1, NA),
      prod_B = c(2, 3)
    )
  )
})

test_that("error when overwriting existing column", {
  df <- tibble(
    a = c(1, 1),
    key = c("a", "b"),
    val = c(1, 2)
  )
  df_pl <- as_polars_df(df)

  expect_snapshot(
    pivot_wider(df_pl, names_from = key, values_from = val),
    error = TRUE
  )
})

test_that("`names_from` must be supplied if `name` isn't in data", {
  df <- tibble(key = "x", val = 1)
  df_pl <- as_polars_df(df)
  expect_snapshot(
    pivot_wider(df_pl, values_from = val),
    error = TRUE
  )
})

test_that("`values_from` must be supplied if `value` isn't in data", {
  df <- tibble(key = "x", val = 1)
  df_pl <- as_polars_df(df)
  expect_snapshot(
    pivot_wider(df_pl, names_from = key),
    error = TRUE
  )
})

test_that("`names_from` must identify at least 1 column", {
  df <- tibble(key = "x", val = 1)
  df_pl <- as_polars_df(df)
  expect_snapshot(
    pivot_wider(df_pl, names_from = starts_with("foo"), values_from = val),
    error = TRUE
  )
})

test_that("`values_from` must identify at least 1 column", {
  df <- tibble(key = "x", val = 1)
  df_pl <- as_polars_df(df)
  expect_snapshot(
    pivot_wider(df_pl, names_from = key, values_from = starts_with("foo")),
    error = TRUE
  )
})

test_that("`id_cols = everything()` excludes `names_from` and `values_from`", {
  df <- tibble(key = "x", name = "a", value = 1L)
  df_pl <- as_polars_df(df)
  expect_equal(
    pivot_wider(df_pl, id_cols = everything()),
    data.frame(key = "x", a = 1L)
  )
})

test_that("`id_cols` can't select columns from `names_from` or `values_from`", {
  df <- tibble(name = c("x", "y"), value = c(1, 2))
  df_pl <- as_polars_df(df)
  expect_snapshot(
    pivot_wider(df_pl, id_cols = name, names_from = name, values_from = value),
    error = TRUE
  )
  expect_snapshot(
    pivot_wider(df_pl, id_cols = value, names_from = name, values_from = value),
    error = TRUE
  )
})

test_that("unsupported args throw warning", {
  fish_encounters <- as.data.frame(tidyr::fish_encounters)
  fish_encounters_pl <- as_polars_df(fish_encounters)

  expect_warning(
    pivot_wider(
      fish_encounters_pl,
      names_from = station,
      values_from = seen,
      names_sort = TRUE,
      names_vary = TRUE
    )
  )
})

test_that("dots must be empty", {
  fish_encounters <- as.data.frame(tidyr::fish_encounters)
  fish_encounters_pl <- as_polars_df(fish_encounters)

  expect_snapshot(
    pivot_wider(
      fish_encounters_pl,
      names_from = station,
      values_from = seen,
      foo = TRUE,
      names_sort = TRUE
    ),
    error = TRUE
  )
})
