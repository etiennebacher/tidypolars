test_that("basic behavior works", {
  test <- tibble(x = c(NA, "x.y", "x.z", "y.z"))
  test_pl <- as_polars_df(test)

  expect_is_tidypolars(separate(
    test_pl,
    x,
    into = c("foo", "foo2"),
    sep = "\\."
  ))

  # TODO: both should take the same input when https://github.com/pola-rs/polars/pull/26060
  # is released
  expect_equal(
    separate(test_pl, x, into = c("foo", "foo2"), sep = "."),
    separate(test, x, into = c("foo", "foo2"), sep = "\\.")
  )
})

test_that("default value for sep works", {
  # tidypolars-specific: default sep differs from tidyr
  test <- tibble(x = c(NA, "x y", "x z", "y z"))
  test_pl <- as_polars_df(test)

  # TODO: test more extensively regex
  # https://github.com/pola-rs/polars/issues/4819
  # https://github.com/pola-rs/polars/pull/26060
  expect_equal(
    separate(test_pl, x, into = c("foo", "foo2")) |> pull(foo),
    c(NA, "x", "x", "y")
  )

  expect_equal(
    separate(test_pl, x, into = c("foo", "foo2")) |> pull(foo2),
    c(NA, "y", "z", "z")
  )
})
