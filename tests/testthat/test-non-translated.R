test_that("non-translated functions do not error if they don't use data context", {
  test <- pl$DataFrame(a = c("a", "b", "c"), b = 1:3)
  test_df <- as.data.frame(test)

  # no column at all in the expression
  expect_equal(
    test |>
      mutate(x = agrep("a", "b")),
    test_df |>
      mutate(x = agrep("a", "b"))
  )
  expect_equal(
    test |>
      mutate(
        across(
          starts_with("x"),
          function(y) agrep("a", "b")
        )
      ),
    test_df |>
      mutate(
        across(
          starts_with("x"),
          function(y) agrep("a", "b")
        )
      )
  )

  # column in parts of the expression
  expect_equal(
    test |>
      filter(b >= agrep("a", "b")),
    test_df |>
      filter(b >= agrep("a", "b"))
  )
})

test_that("non-translated functions error if they use data context", {
  test <- pl$DataFrame(a = c("a", "b", "c"), b = 1:3)

  expect_snapshot(
    test |> mutate(x = agrep("a", a)),
    error = TRUE
  )
  expect_snapshot(
    test |> filter(a >= agrep("a", a)),
    error = TRUE
  )
})

test_that("correct behavior when two expressions are identical but used in a different data context", {
  test <- pl$DataFrame(foo = c("bla", "ble", "bli"))
  test_df <- as.data.frame(test)

  a <- c("bla", "ble", "bli")

  # For now, there's no column "a" in the data so we use the object "a" in the
  # environment
  expect_equal(
    test |> mutate(x = agrep("aa", a)),
    test_df |> mutate(x = agrep("aa", a))
  )

  # But if we create the column "a" then this should error because we now use
  # the column in the function
  # => the hash of the expression `agrep("aa", a)` is the same but we need to
  #    be sure it's properly invalidated and not shared between expressions.
  expect_snapshot(
    test |>
      mutate(
        a = "foo",
        x = agrep("aa", a)
      ),
    error = TRUE
  )
  expect_snapshot(
    test |>
      mutate(
        x = agrep("aa", a),
        a = "foo",
        x = agrep("aa", a)
      ),
    error = TRUE
  )
})

test_that("correct behavior with nested functions", {
  test <- pl$DataFrame(foo = c("a", "b", "c"), bar = 1:3)
  test_df <- as.data.frame(test)

  a <- c("a", "b", "c")

  ### Two unknown functions
  expect_equal(
    test |> mutate(x = identity(agrep("a", a))),
    test_df |> mutate(x = identity(agrep("a", a)))
  )
  expect_snapshot(
    test |> mutate(a = "a", x = identity(agrep("a", a))),
    error = TRUE
  )

  ### One known function wrapping an unknown one
  expect_equal(
    test |> mutate(x = mean(agrep("a", a))),
    test_df |> mutate(x = mean(agrep("a", a)))
  )
  expect_snapshot(
    test |> mutate(a = "a", x = mean(agrep("a", a))),
    error = TRUE
  )

  ### One unknown function wrapping a known one
  a <- 1:3
  expect_equal(
    test |> mutate(x = agrep("a", mean(a))),
    test_df |> mutate(x = agrep("a", mean(a)))
  )
  expect_snapshot(
    test |> mutate(a = 1, x = agrep("a", mean(a))),
    error = TRUE
  )
})
