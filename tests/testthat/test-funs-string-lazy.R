### [GENERATED AUTOMATICALLY] Update test-funs-string.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

# TODO: Counter example:
#  string = NA

# test_that("paste() and paste0() work", {
#   for_all(
#     tests = 40,
#     string = character_(any_na = TRUE),
#     property = function(string, fun) {
#       test_df <- data.frame(x1 = string)
#       test <- pl$LazyFrame(x1 = string)
#
#       expect_equal_lazy(
#         mutate(test, foo = paste(x1, "he")) |>
#           pull(foo),
#         mutate(test_df, foo = paste(x1, "he")) |>
#           pull(foo)
#       )
#
#       expect_equal_lazy(
#         mutate(test, foo = paste(x1, "he", sep = "--")) |>
#           pull(foo),
#         mutate(test_df, foo = paste(x1, "he", sep = "--")) |>
#           pull(foo)
#       )
#
#       expect_equal_lazy(
#         mutate(test, foo = paste0(x1, "he")) |>
#           pull(foo),
#         mutate(test_df, foo = paste0(x1, "he")) |>
#           pull(foo)
#       )
#
#       expect_equal_lazy(
#         mutate(test, foo = paste0(x1, "he", x1)) |>
#           pull(foo),
#         mutate(test_df, foo = paste0(x1, "he", x1)) |>
#           pull(foo)
#       )
#     }
#   )
# })

patrick::with_parameters_test_that("several non-regex functions work", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    property = function(string) {
      test_df <- data.frame(x1 = string)
      test <- pl$LazyFrame(x1 = string)

      pl_code <- paste0("mutate(test, foo = ", fun, "(string)) |> pull(foo)")
      tv_code <- paste0("mutate(test_df, foo = ", fun, "(string)) |> pull(foo)")

      expect_equal_lazy(
        eval(parse(text = pl_code)),
        eval(parse(text = tv_code)),
      )
    }
  )
}, fun = c("str_to_upper", "str_to_lower", "str_length", "str_squish"))


test_that("str_trim() works", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    side = quickcheck::one_of(constant("both"), constant("left"), constant("right")),
    property = function(string, side) {
      test_df <- data.frame(x1 = string)
      test <- pl$LazyFrame(x1 = string)

      expect_equal_lazy(
        mutate(test, foo = str_trim(x1)) |>
          pull(foo),
        mutate(test_df, foo = str_trim(x1)) |>
          pull(foo)
      )

      expect_equal_lazy(
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
#       test_df <- data.frame(x1 = string)
#       test <- pl$LazyFrame(x1 = string)
#
#       # Might work in the future but for now width must have length 1
#       if (length(width) > 1) {
#         expect_error_lazy(
#           mutate(test, foo = str_pad(x1, side = side, pad = pad, width = width)),
#           "doesn't work in a Polars DataFrame when `width` has a length greater than 1"
#         )
#       } else {
#         expect_equal_lazy_or_both_error(
#           mutate(test, foo = str_pad(x1, side = side, pad = pad, width = width)) |>
#             pull(foo),
#           mutate(test_df, foo = str_pad(x1, side = side, pad = pad, width = width)) |>
#             pull(foo)
#         )
#       }
#     }
#   )
# })


# TODO: Counter example
# string = c(NA, NA, NA, NA, "VsF7|'x", "VsF7|'x", NA, "VsF7|'x")
# times = c(0, 0,  0,  0, NA, NA, NA,  0)

# test_that("str_dup() works", {
#   for_all(
#     tests = 20,
#     string = character_(any_na = TRUE),
#     # Very high numbers crash the session, I guess because of stringr
#     times = numeric_bounded(-10000, 10000, any_na = TRUE),
#     property = function(string, times) {
#       test_df <- data.frame(x1 = string)
#       test <- pl$LazyFrame(x1 = string)
#
#       expect_equal_lazy_or_both_error(
#         mutate(test, foo = str_dup(x1, times = times)) |>
#           pull(foo),
#         mutate(test_df, foo = str_dup(x1, times = times)) |>
#           pull(foo)
#       )
#     }
#   )
# })

# test_that("str_sub() works", {
#   for_all(
#     tests = 40,
#     string = character_(any_na = TRUE),
#     start = numeric_(any_na = TRUE),
#     end = numeric_(any_na = TRUE),
#     property = function(string, start, end) {
#       test_df <- data.frame(x1 = string)
#       test <- pl$LazyFrame(x1 = string)
#
#       expect_equal_lazy_or_both_error(
#         mutate(test, foo = str_sub(x1, start, end)) |>
#           pull(foo),
#         mutate(test_df, foo = str_sub(x1, start, end)) |>
#           pull(foo)
#       )
#     }
#   )
# })

Sys.setenv('TIDYPOLARS_TEST' = FALSE)