test_that("%>% works in expression without '.'", {
  test_df <- tibble(x = 1:3)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> mutate(y = x %>% mean()),
    test_df |> mutate(y = x %>% mean())
  )
  expect_equal(
    test_pl |> mutate(y = x %>% mean(na.rm = TRUE)),
    test_df |> mutate(y = x %>% mean(na.rm = TRUE))
  )
})

test_that("%>% works in expression with '.'", {
  test_df <- tibble(x = 1:3)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> mutate(y = x %>% mean(x = .)),
    test_df |> mutate(y = x %>% mean(x = .))
  )
})

test_that("%>% works with summarize()", {
  test_df <- tibble(x = 1:3)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> summarize(y = x %>% mean(x = .)),
    test_df |> summarize(y = x %>% mean(x = .))
  )
})

test_that("chaining %>% works", {
  test_df <- tibble(x = 1:3)
  test_pl <- as_polars_df(test_df)

  expect_equal(
    test_pl |> mutate(y = x %>% sqrt() %>% mean(na.rm = TRUE)),
    test_df |> mutate(y = x %>% sqrt() %>% mean(na.rm = TRUE))
  )
  expect_equal(
    test_pl |> mutate(y = x %>% sqrt(x = .) %>% mean(x = ., na.rm = TRUE)),
    test_df |> mutate(y = x %>% sqrt(x = .) %>% mean(x = ., na.rm = TRUE))
  )
})
