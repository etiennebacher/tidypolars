test_that("paste() and paste0() work", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    separator = character_(len = 1),
    property = function(string, separator) {
      test_df <- tibble(x1 = string)
      test <- pl$DataFrame(x1 = string)

      expect_equal(
        mutate(test, foo = paste(x1, "he")) |>
          pull(foo),
        mutate(test_df, foo = paste(x1, "he")) |>
          pull(foo)
      )

      expect_equal(
        mutate(test, foo = paste(x1, "he", sep = separator)) |>
          pull(foo),
        mutate(test_df, foo = paste(x1, "he", sep = separator)) |>
          pull(foo)
      )

      expect_equal(
        mutate(test, foo = paste0(x1, "he")) |>
          pull(foo),
        mutate(test_df, foo = paste0(x1, "he")) |>
          pull(foo)
      )

      expect_equal(
        mutate(test, foo = paste0(x1, "he", x1)) |>
          pull(foo),
        mutate(test_df, foo = paste0(x1, "he", x1)) |>
          pull(foo)
      )
    }
  )
})

patrick::with_parameters_test_that(
  "several non-regex functions work",
  {
    for_all(
      tests = 40,
      string = character_(any_na = TRUE),
      property = function(string) {
        test_df <- tibble(x1 = string)
        test <- pl$DataFrame(x1 = string)

        pl_code <- paste0("mutate(test, foo = ", fun, "(string)) |> pull(foo)")
        tv_code <- paste0(
          "mutate(test_df, foo = ",
          fun,
          "(string)) |> pull(foo)"
        )

        expect_equal(
          eval(parse(text = pl_code)),
          eval(parse(text = tv_code))
        )
      }
    )
  },
  fun = c("str_to_upper", "str_to_lower", "str_length", "str_squish")
)

test_that("str_trim() works", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    side = quickcheck::one_of(
      constant("both"),
      constant("left"),
      constant("right")
    ),
    property = function(string, side) {
      test_df <- tibble(x1 = string)
      test <- pl$DataFrame(x1 = string)

      expect_equal(
        mutate(test, foo = str_trim(x1)) |>
          pull(foo),
        mutate(test_df, foo = str_trim(x1)) |>
          pull(foo)
      )

      expect_equal(
        mutate(test, foo = str_trim(x1, side = side)) |>
          pull(foo),
        mutate(test_df, foo = str_trim(x1, side = side)) |>
          pull(foo)
      )
    }
  )
})

# TODO: Problem is that I don't have a way to check that length of string is the
# same as length of pad or width. This will probably error in polars but
# if let it happen I can't catch the early return when width/pad = NA

# test_that("str_pad() works", {
#   for_all(
#     tests = 40,
#     string = character_(any_na = TRUE),
#     pad = character_(any_na = TRUE),
#     width = numeric_(any_na = TRUE),
#     # can't use "both" in polars
#     side = quickcheck::one_of(constant("left"), constant("right")),
#     property = function(string, side, pad, width) {
#       test_df <- tibble(x1 = string)
#       test <- pl$DataFrame(x1 = string)
#
#       # Might work in the future but for now width must have length 1
#       if (length(width) > 1) {
#         expect_error(
#           mutate(test, foo = str_pad(x1, side = side, pad = pad, width = width)),
#           "doesn't work in a Polars DataFrame when `width` has a length greater than 1"
#         )
#       } else {
#         expect_equal_or_both_error(
#           mutate(test, foo = str_pad(x1, side = side, pad = pad, width = width)) |>
#             pull(foo),
#           mutate(test_df, foo = str_pad(x1, side = side, pad = pad, width = width)) |>
#             pull(foo)
#         )
#       }
#     }
#   )
# })

test_that("str_dup() works", {
  for_all(
    tests = 20,
    string = character_(any_na = TRUE),
    # Very high numbers crash the session, I guess because of stringr
    times = numeric_bounded(-10000, 10000, any_na = TRUE),
    property = function(string, times) {
      test_df <- tibble(x1 = string)
      test <- pl$DataFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test, foo = str_dup(x1, times = times)) |>
          pull(foo),
        mutate(test_df, foo = str_dup(x1, times = times)) |>
          pull(foo)
      )
    }
  )
})

test_that("str_sub() works", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    start = numeric_(any_na = TRUE),
    end = numeric_(any_na = TRUE),
    property = function(string, start, end) {
      test_df <- tibble(x1 = string)
      test <- pl$DataFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test, foo = str_sub(x1, start, end)) |>
          pull(foo),
        mutate(test_df, foo = str_sub(x1, start, end)) |>
          pull(foo)
      )
    }
  )
})

test_that("substr() works", {
  # substr() doesn't error with different lengths but polars does. I don't want
  # this weird case to prevent quickcheck to run, especially since this is a
  # weird behavior in base R and we're more conservative on this.
  length <- sample.int(10, 1)

  for_all(
    tests = 40,
    string = character_(any_na = TRUE, len = length),
    start = numeric_(any_na = TRUE, len = length),
    end = numeric_(any_na = TRUE, len = length),
    property = function(string, start, end) {
      test_df <- tibble(x1 = string)
      test <- pl$DataFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test, foo = substr(x1, start, end)) |>
          pull(foo),
        mutate(test_df, foo = substr(x1, start, end)) |>
          pull(foo)
      )
    }
  )
})

test_that("str_equal() works", {
  # need equal length of inputs
  length <- sample(0:10, 1)

  for_all(
    tests = 40,
    x = character_(any_na = TRUE, len = length),
    y = character_(any_na = TRUE, len = length),
    property = function(x, y) {
      test_df <- tibble(x = x, y = y)
      test <- as_polars_df(test_df)

      expect_equal_or_both_error(
        mutate(test, foo = str_equal(x, y)) |>
          pull(foo),
        mutate(test_df, foo = str_equal(x, y)) |>
          pull(foo)
      )
    }
  )
})
