### [GENERATED AUTOMATICALLY] Update test_funs_string.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

library(dplyr, warn.conflicts = FALSE)
library(stringr)

test_df <- data.frame(
  x1 = c("heLLo there", "it's mE"),
  x2 = c("apples x4", "bag of flour"),
  x3 = c("\u6c49\u5b57", "\U0001f60a"),
  x4 = c("\u00fc", "u\u0308"),
  x5 = c("a.", "..."),
  x6 = c("  foo  ", "hi there  "),
  x7 = c("Jane saw a cat", "Jane sat down"),
  x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
  x9 = c(" Some text    with ws   ", "and more     white   space  ")
)

test <- pl$LazyFrame(test_df)

for (i in c("toupper", "tolower", "str_to_lower", "str_to_upper", "nchar")) {

  pol <- paste0("pl_mutate(test, foo = ", i, "(x1))") |>
    str2lang() |>
    eval() |>
    pl_pull(foo)

  res <- paste0("mutate(test_df, foo = ", i, "(x1))") |>
    str2lang() |>
    eval() |>
    pull(foo)

  expect_equal_lazy(pol, res, info = i)

}

expect_equal_lazy(
  pl_mutate(test, foo = paste(x1, "he")) |>
    pl_pull(foo),
  mutate(test_df, foo = paste(x1, "he")) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = paste(x1, "he", sep = "--")) |>
    pl_pull(foo),
  mutate(test_df, foo = paste(x1, "he", sep = "--")) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = paste0(x1, "he")) |>
    pl_pull(foo),
  mutate(test_df, foo = paste0(x1, "he")) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = paste0(x1, "he", x3)) |>
    pl_pull(foo),
  mutate(test_df, foo = paste0(x1, "he", x3)) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_starts(x1, "he")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_starts(x1, "he")) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_starts(x1, "he", negate = TRUE)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_starts(x1, "he", negate = TRUE)) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_ends(x1, "ere")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_ends(x1, "ere")) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_ends(x1, "ere", negate = TRUE)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_ends(x1, "ere", negate = TRUE)) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_extract(x2, "\\d")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_extract(x2, "\\d")) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_extract(x2, "[a-z]+")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_extract(x2, "[a-z]+")) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_extract(x2, "([a-z]+) of ([a-z]+)", group = 2)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_extract(x2, "([a-z]+) of ([a-z]+)", group = 2)) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_length(x2)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_length(x2)) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_length(x3)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_length(x3)) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_length(x4)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_length(x4)) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_replace(x1, "[aeiou]", "-")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_replace(x1, "[aeiou]", "-")) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_replace(x1, "[aeiou]", "")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_replace(x1, "[aeiou]", "")) |>
    pull(foo)
)

# TODO:
# expect_equal_lazy(
#   pl_mutate(test, foo = str_replace(x1, "[aeiou]", "\\1\\1")) |>
#     pl_pull(foo),
#   mutate(test_df, foo = str_replace(x1, "([aeiou])", "\\1\\1")) |>
#     pull(foo)
# )

expect_equal_lazy(
  pl_mutate(test, foo = str_replace(x1, "[aeiou]", c("1", "2"))) |>
    pl_pull(foo),
  mutate(test_df, foo = str_replace(x1, "[aeiou]", c("1", "2"))) |>
    pull(foo)
)

# TODO:
# expect_equal_lazy(
#   pl_mutate(test, foo = str_replace(x1, c("a", "e"), "-")) |>
#     pl_pull(foo),
#   mutate(test_df, foo = str_replace(x1, c("a", "e"), "-")) |>
#     pull(foo)
# )

expect_equal_lazy(
  pl_mutate(test, foo = str_replace_all(x1, "[aeiou]", "-")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_replace_all(x1, "[aeiou]", "-")) |>
    pull(foo)
)

# TODO:
# expect_equal_lazy(
#   pl_mutate(test, foo = str_replace_all(x1, "[aeiou]", toupper)) |>
#     pl_pull(foo),
#   mutate(test_df, foo = str_replace_all(x1, "[aeiou]", toupper)) |>
#     pull(foo)
# )


expect_equal_lazy(
  pl_mutate(test, foo = str_remove(x1, "[aeiou]")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_remove(x1, "[aeiou]")) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_remove(x2, "[[:digit:]]")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_remove(x2, "[[:digit:]]")) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_remove_all(x1, "[aeiou]")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_remove_all(x1, "[aeiou]")) |>
    pull(foo)
)


expect_equal_lazy(
  pl_mutate(test, foo = str_sub(x1, 1, 5)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_sub(x1, 1, 5)) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_sub(x1, -1)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_sub(x1, -1)) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_sub(x1, 0)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_sub(x1, 0)) |>
    pull(foo)
)

# TODO:
# expect_equal_lazy(
#   pl_mutate(test, foo = str_sub(x1, -10, -2)) |>
#     pl_pull(foo),
#   mutate(test_df, foo = str_sub(x1, -10, -2)) |>
#     pull(foo)
# )

expect_equal_lazy(
  pl_mutate(test, foo = str_count(x1, "[aeiou]")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_count(x1, "[aeiou]")) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_count(x5, ".")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_count(x5, ".")) |>
    pull(foo)
)

# TODO:
# expect_equal_lazy(
#   pl_mutate(test, foo = str_count(x5, ".")) |>
#     pl_pull(foo),
#   mutate(test_df, foo = str_count(x5, fixed("."))) |>
#     pull(foo)
# )

expect_equal_lazy(
  pl_mutate(test, foo = str_trim(x6)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_trim(x6)) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_trim(x6, side = "left")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_trim(x6, side = "left")) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_trim(x6, side = "right")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_trim(x6, side = "right")) |>
    pull(foo)
)


expect_equal_lazy(
  pl_mutate(test, foo = str_pad(x6, width = 10)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_pad(x6, width = 10)) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_pad(x6, width = 10, pad = "*")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_pad(x6, width = 10, pad = "*")) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_pad(x6, width = 10, side = "right")) |>
    pl_pull(foo),
  mutate(test_df, foo = str_pad(x6, width = 10, side = "right")) |>
    pull(foo)
)

expect_error_lazy(
  pl_mutate(test, foo = str_pad(x6, width = 10, side = "both")),
  "doesn't work in a Polars DataFrame"
)

expect_error_lazy(
  pl_mutate(test, foo = str_pad(x6, width = 10, use_width = FALSE)),
  "doesn't work in a Polars DataFrame"
)


expect_equal_lazy(
  pl_mutate(test, foo = word(x7)) |>
    pl_pull(foo),
  mutate(test_df, foo = word(x7)) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = word(x7, 2, 3)) |>
    pl_pull(foo),
  mutate(test_df, foo = word(x7, 2, 3)) |>
    pull(foo)
)

expect_error_lazy(
  pl_mutate(test, foo = word(x7, 2, 4)),
  "out of bounds"
)

expect_equal_lazy(
  pl_mutate(test, foo = word(x8, 2, 3, sep = "-")) |>
    pl_pull(foo),
  mutate(test_df, foo = word(x8, 2, 3, sep = "-")) |>
    pull(foo)
)



expect_equal_lazy(
  pl_mutate(test, foo = str_squish(x9)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_squish(x9)) |>
    pull(foo)
)

expect_equal_lazy(
  pl_mutate(test, foo = str_squish(x7)) |>
    pl_pull(foo),
  mutate(test_df, foo = str_squish(x7)) |>
    pull(foo)
)

Sys.setenv('TIDYPOLARS_TEST' = FALSE)