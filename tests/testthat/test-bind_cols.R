test_that("returns a custom class", {
  l <- list(
    polars::pl$DataFrame(
      x = sample(letters, 20),
      y = sample(1:100, 20)
    ),
    polars::pl$DataFrame(
      a = sample(letters, 20),
      z = sample(1:100, 20)
    )
  )

  expect_is_tidypolars(bind_cols_polars(l))
})

test_that("basic behavior with list works", {
  l <- list(
    polars::pl$DataFrame(
      x = sample(letters, 20),
      y = sample(1:100, 20)
    ),
    polars::pl$DataFrame(
      a = sample(letters, 20),
      z = sample(1:100, 20)
    )
  )
  expect_dim(
    bind_cols_polars(l),
    c(20, 4)
  )
})

test_that("passing individual elements works", {
  p1 <- pl$DataFrame(
    x = sample(letters, 20),
    y = sample(1:100, 20)
  )
  p2 <- pl$DataFrame(
    z = sample(letters, 20),
    w = sample(1:100, 20)
  )

  expect_equal(
    bind_cols_polars(p1, p2),
    bind_cols_polars(list(p1, p2))
  )
})

test_that("error if not all elements don't have the same class", {
  l <- list(
    data.frame(
      x = sample(letters, 20),
      y = sample(1:100, 20)
    ),
    polars::pl$DataFrame(
      y = sample(letters, 20),
      z = sample(1:100, 20)
    )
  )

  expect_snapshot(
    bind_cols_polars(l),
    error = TRUE
  )
})


test_that("can only bind more than 2 elements if DataFrame", {
  l <- list(
    polars::pl$DataFrame(
      x = sample(letters, 20),
      y = sample(1:100, 20)
    ),
    polars::pl$DataFrame(
      a = sample(letters, 20),
      z = sample(1:100, 20)
    ),
    polars::pl$DataFrame(
      v = sample(letters, 20),
      w = sample(1:100, 20)
    )
  )

  if (Sys.getenv("TIDYPOLARS_TEST") == "TRUE") {
    expect_snapshot(
      bind_cols_polars(l),
      error = TRUE
    )
  } else {
    expect_dim(bind_cols_polars(l), c(20, 6))

    expect_colnames(
      bind_cols_polars(l),
      c("x", "y", "a", "z", "v", "w")
    )
  }
})


test_that("arg .name_repair works", {
  skip_if_not_installed("withr")
  withr::local_options(rlib_message_verbosity = "quiet")

  l <- list(
    pl$DataFrame(a = 1, x = 2, y = 3),
    pl$DataFrame(z = 1, x = 2, y = 3)
  )

  expect_equal(
    names(bind_cols_polars(l)),
    c("a", "x...2", "y...3", "z", "x...5", "y...6")
  )

  expect_equal(
    names(bind_cols_polars(l, .name_repair = "universal")),
    c("a", "x...2", "y...3", "z", "x...5", "y...6")
  )

  expect_snapshot(
    bind_cols_polars(l, .name_repair = "check_unique"),
    error = TRUE
  )
  expect_snapshot(
    bind_cols_polars(l, .name_repair = "minimal"),
    error = TRUE
  )
  expect_snapshot(
    bind_cols_polars(l, .name_repair = "blahblah"),
    error = TRUE
  )
})

test_that("arg .name_repair works", {
  skip_if_not_installed("withr")
  withr::local_options(rlib_message_verbosity = "quiet")

  l <- list(
    pl$DataFrame(x = 1)$rename(list(x = " ")),
    pl$DataFrame(x = 1)$rename(list(x = " "))
  )

  expect_equal(
    names(bind_cols_polars(l)),
    c(" ...1", " ...2")
  )

  expect_equal(
    names(bind_cols_polars(l, .name_repair = "universal")),
    c("....1", "....2")
  )
})
