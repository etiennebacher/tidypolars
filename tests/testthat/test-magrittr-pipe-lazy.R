### [GENERATED AUTOMATICALLY] Update test-magrittr-pipe.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("%>% works in expression without '.'", {
  test <- tibble(x = 1:3)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> mutate(y = x %>% mean()),
    test |> mutate(y = x %>% mean())
  )
  expect_equal_lazy(
    test_pl |> mutate(y = x %>% mean(na.rm = TRUE)),
    test |> mutate(y = x %>% mean(na.rm = TRUE))
  )
})

test_that("%>% works in expression with '.'", {
  test <- tibble(x = 1:3)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> mutate(y = x %>% mean(x = .)),
    test |> mutate(y = x %>% mean(x = .))
  )
})

test_that("%>% works with summarize()", {
  test <- tibble(x = 1:3)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> summarize(y = x %>% mean(x = .)),
    test |> summarize(y = x %>% mean(x = .))
  )
})

test_that("chaining %>% works", {
  test <- tibble(x = 1:3)
  test_pl <- as_polars_lf(test)

  expect_equal_lazy(
    test_pl |> mutate(y = x %>% sqrt() %>% mean(na.rm = TRUE)),
    test |> mutate(y = x %>% sqrt() %>% mean(na.rm = TRUE))
  )
  expect_equal_lazy(
    test_pl |> mutate(y = x %>% sqrt(x = .) %>% mean(x = ., na.rm = TRUE)),
    test |> mutate(y = x %>% sqrt(x = .) %>% mean(x = ., na.rm = TRUE))
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
