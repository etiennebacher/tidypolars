test_that("%>% works in expression without '.'", {
  test <- pl$DataFrame(x = 1:3)
  expect_equal(
    test |> mutate(y = x %>% mean()),
    data.frame(x = 1:3, y = 2)
  )
})
