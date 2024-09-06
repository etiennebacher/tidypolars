test_that("str_to_lower() works", {
  quickcheck::for_all(
    tests = 20,
    string = quickcheck::character_(),
    property = function(string, fun) {
      test_df <- data.frame(x1 = string)
      test <- pl$DataFrame(x1 = string)

      testthat::expect_equal(
        mutate(test, foo = str_to_lower(x1)) |>
          pull(foo),
        mutate(test_df, foo = str_to_lower(x1)) |>
          pull(foo)
      )
    }
  )
})

test_that("str_to_upper() works", {
  quickcheck::for_all(
    tests = 20,
    string = quickcheck::character_(),
    property = function(string, fun) {
      test_df <- data.frame(x1 = string)
      test <- pl$DataFrame(x1 = string)

      testthat::expect_equal(
        mutate(test, foo = str_to_upper(x1)) |>
          pull(foo),
        mutate(test_df, foo = str_to_upper(x1)) |>
          pull(foo)
      )
    }
  )
})

test_that("paste() and paste0() work", {
  quickcheck::for_all(
    tests = 20,
    string = quickcheck::character_(),
    property = function(string, fun) {
      test_df <- data.frame(x1 = string)
      test <- pl$DataFrame(x1 = string)

      testthat::expect_equal(
        mutate(test, foo = paste(x1, "he")) |>
          pull(foo),
        mutate(test_df, foo = paste(x1, "he")) |>
          pull(foo)
      )

      testthat::expect_equal(
        mutate(test, foo = paste(x1, "he", sep = "--")) |>
          pull(foo),
        mutate(test_df, foo = paste(x1, "he", sep = "--")) |>
          pull(foo)
      )

      testthat::expect_equal(
        mutate(test, foo = paste0(x1, "he")) |>
          pull(foo),
        mutate(test_df, foo = paste0(x1, "he")) |>
          pull(foo)
      )

      testthat::expect_equal(
        mutate(test, foo = paste0(x1, "he", x1)) |>
          pull(foo),
        mutate(test_df, foo = paste0(x1, "he", x1)) |>
          pull(foo)
      )
    }
  )
})

