test_that("%>% works in expression without '.'", {
  test <- pl$DataFrame(x = 1:3)
  expect_equal(
    test |> mutate(y = x %>% mean()),
    data.frame(x = 1:3, y = 2)
  )
  expect_equal(
    test |> mutate(y = x %>% mean(na.rm = TRUE)),
    data.frame(x = 1:3, y = 2)
  )
})

test_that("%>% works in expression with '.'", {
  test <- pl$DataFrame(x = 1:3)
  expect_equal(
    test |> mutate(y = x %>% mean(x = .)),
    data.frame(x = 1:3, y = 2)
  )
})

test_that("%>% works with summarize()", {
  test <- pl$DataFrame(x = 1:3)
  expect_equal(
    test |> summarize(y = x %>% mean(x = .)),
    data.frame(y = 2)
  )
})

test_that("chaining %>% works", {
  test <- pl$DataFrame(x = 1:3)
  expect_equal(
    test |> mutate(y = x %>% sqrt() %>% mean(na.rm = TRUE)),
    data.frame(x = 1:3, y = 1.3820),
    tolerance = 1e-4
  )
  expect_equal(
    test |> mutate(y = x %>% sqrt(x = .) %>% mean(x = ., na.rm = TRUE)),
    data.frame(x = 1:3, y = 1.3820),
    tolerance = 1e-4
  )
})
