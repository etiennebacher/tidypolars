### [GENERATED AUTOMATICALLY] Update test-funs-string.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

# Generators shared by the regex-based tests below

# Patterns that mean the same thing for R (TRE/PCRE) and for the Rust regex
# crate used by Polars. Mixing hand-picked patterns with random letters gives
# both frequent matches and random coverage.
pattern_ <- function() {
  quickcheck::one_of(
    constant("[aeiou]"),
    constant("[[:digit:]]"),
    constant("\\d"),
    constant("[a-z]+"),
    constant("."),
    constant("a|e"),
    constant("^."),
    constant(".$"),
    character_letters(len = 1)
  )
}

# Patterns without any regex metacharacter. Needed for functions where Polars
# only does literal matching (e.g. `$str$split()`).
literal_pattern_ <- function() {
  quickcheck::one_of(
    constant(" "),
    constant("-"),
    constant("a"),
    character_letters(len = 1)
  )
}

whitespace_ <- function() {
  quickcheck::one_of(
    constant(""),
    constant(" "),
    constant("  "),
    constant("\t"),
    constant("\n"),
    constant(" \t\n ")
  )
}

test_that("paste() and paste0() work", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    separator = character_(len = 1),
    property = function(string, separator) {
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_lazy(
        mutate(test_pl, foo = paste(x1, "he")) |> pull(foo),
        mutate(test_df, foo = paste(x1, "he")) |> pull(foo)
      )

      expect_equal_lazy(
        mutate(test_pl, foo = paste(x1, "he", sep = separator)) |> pull(foo),
        mutate(test_df, foo = paste(x1, "he", sep = separator)) |> pull(foo)
      )

      expect_equal_lazy(
        mutate(test_pl, foo = paste0(x1, "he")) |> pull(foo),
        mutate(test_df, foo = paste0(x1, "he")) |> pull(foo)
      )

      expect_equal_lazy(
        mutate(test_pl, foo = paste0(x1, "he", x1)) |> pull(foo),
        mutate(test_df, foo = paste0(x1, "he", x1)) |> pull(foo)
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
        test_pl <- pl$LazyFrame(x1 = string)

        pl_code <- paste0(
          "mutate(test_pl, foo = ",
          fun,
          "(x1)) |> pull(foo)"
        )
        tv_code <- paste0(
          "mutate(test_df, foo = ",
          fun,
          "(x1)) |> pull(foo)"
        )

        expect_equal_lazy(
          eval(parse(text = pl_code)),
          eval(parse(text = tv_code))
        )
      }
    )
  },
  fun = c(
    "str_to_upper",
    "str_to_lower",
    "toupper",
    "tolower",
    "str_length",
    "nchar",
    "str_squish"
  )
)

test_that("str_to_title() and toTitleCase() work", {
  skip_if_not(polars::polars_info()$features$nightly)

  for_all(
    tests = 40,
    # Restricted to letters: Polars also capitalizes the character following a
    # digit or a punctuation character, stringr doesn't.
    # https://github.com/pola-rs/polars/issues/18260
    w1 = character_letters(len = 5, any_na = TRUE),
    w2 = character_letters(len = 5),
    w3 = character_letters(len = 5),
    # Words are separated by (and surrounded with) random whitespace so that
    # the strings are not always exactly two words joined by a single space.
    sep1 = whitespace_(),
    sep2 = whitespace_(),
    lead = whitespace_(),
    trail = whitespace_(),
    property = function(w1, w2, w3, sep1, sep2, lead, trail) {
      string <- paste0(lead, w1, sep1, w2, sep2, w3, trail)
      string[is.na(w1)] <- NA_character_
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_lazy(
        mutate(test_pl, foo = str_to_title(x1)) |> pull(foo),
        mutate(test_df, foo = str_to_title(x1)) |> pull(foo)
      )

      # tools::toTitleCase() has its own rules for small words ("a", "of", ...)
      # so the reference here is stringr::str_to_title().
      expect_equal_lazy(
        mutate(test_pl, foo = toTitleCase(x1)) |> pull(foo),
        mutate(test_df, foo = str_to_title(x1)) |> pull(foo)
      )
    }
  )
})

test_that("str_trim() and trimws() work", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    # Pad the random strings so that there is actually something to trim
    ws1 = whitespace_(),
    ws2 = whitespace_(),
    side = quickcheck::one_of(
      constant("both"),
      constant("left"),
      constant("right")
    ),
    property = function(string, ws1, ws2, side) {
      padded <- paste0(ws1, string, ws2)
      padded[is.na(string)] <- NA_character_
      test_df <- tibble(x1 = padded)
      test_pl <- pl$LazyFrame(x1 = padded)

      expect_equal_lazy(
        mutate(test_pl, foo = str_trim(x1)) |> pull(foo),
        mutate(test_df, foo = str_trim(x1)) |> pull(foo)
      )

      expect_equal_lazy(
        mutate(test_pl, foo = str_trim(x1, side = side)) |> pull(foo),
        mutate(test_df, foo = str_trim(x1, side = side)) |> pull(foo)
      )

      expect_equal_lazy(
        mutate(test_pl, foo = trimws(x1)) |> pull(foo),
        mutate(test_df, foo = trimws(x1)) |> pull(foo)
      )

      expect_equal_lazy(
        mutate(test_pl, foo = trimws(x1, which = side)) |> pull(foo),
        mutate(test_df, foo = trimws(x1, which = side)) |> pull(foo)
      )

      expect_equal_lazy(
        mutate(test_pl, foo = str_squish(x1)) |> pull(foo),
        mutate(test_df, foo = str_squish(x1)) |> pull(foo)
      )
    }
  )
})

test_that("str_pad() works", {
  length <- sample.int(10, 1)

  for_all(
    tests = 40,
    string = character_(any_na = TRUE, len = length),
    pad = quickcheck::one_of(constant(" "), constant("*"), constant("-")),
    width = integer_bounded(-5, 20, len = length, any_na = TRUE),
    scalar_width = integer_bounded(-5, 20, len = 1, any_na = TRUE),
    # can't use "both" in polars
    side = quickcheck::one_of(constant("left"), constant("right")),
    property = function(string, side, pad, width, scalar_width) {
      test_df <- tibble(x1 = string, w = width)
      test_pl <- pl$LazyFrame(x1 = string, w = width)

      expect_equal_or_both_error(
        mutate(
          test_pl,
          foo = str_pad(x1, side = side, pad = pad, width = scalar_width)
        ) |>
          pull(foo),
        mutate(
          test_df,
          foo = str_pad(x1, side = side, pad = pad, width = scalar_width)
        ) |>
          pull(foo)
      )

      # `width` as a column
      expect_equal_or_both_error(
        mutate(test_pl, foo = str_pad(x1, side = side, pad = pad, width = w)) |>
          pull(foo),
        mutate(test_df, foo = str_pad(x1, side = side, pad = pad, width = w)) |>
          pull(foo)
      )

      # `width` as an external vector
      expect_equal_or_both_error(
        mutate(
          test_pl,
          foo = str_pad(x1, side = side, pad = pad, width = width)
        ) |>
          pull(foo),
        mutate(
          test_df,
          foo = str_pad(x1, side = side, pad = pad, width = width)
        ) |>
          pull(foo)
      )
    }
  )
})

test_that("str_dup() works", {
  for_all(
    tests = 20,
    string = character_(any_na = TRUE),
    # Very high numbers crash the session, I guess because of stringr
    times = numeric_bounded(-10000, 10000, any_na = TRUE),
    property = function(string, times) {
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_dup(x1, times = times)) |> pull(foo),
        mutate(test_df, foo = str_dup(x1, times = times)) |> pull(foo)
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
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_sub(x1, start, end)) |> pull(foo),
        mutate(test_df, foo = str_sub(x1, start, end)) |> pull(foo)
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
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = substr(x1, start, end)) |> pull(foo),
        mutate(test_df, foo = substr(x1, start, end)) |> pull(foo)
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
      test_pl <- as_polars_lf(test_df)

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_equal(x, y)) |> pull(foo),
        mutate(test_df, foo = str_equal(x, y)) |> pull(foo)
      )
    }
  )
})

test_that("str_starts() and str_ends() work", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    pattern = pattern_(),
    negate = logical_(len = 1),
    property = function(string, pattern, negate) {
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_starts(x1, pattern, negate = negate)) |>
          pull(foo),
        mutate(test_df, foo = str_starts(x1, pattern, negate = negate)) |>
          pull(foo)
      )

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_ends(x1, pattern, negate = negate)) |>
          pull(foo),
        mutate(test_df, foo = str_ends(x1, pattern, negate = negate)) |>
          pull(foo)
      )

      # alternation
      alt <- paste0(pattern, "|e")

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_starts(x1, alt, negate = negate)) |>
          pull(foo),
        mutate(test_df, foo = str_starts(x1, alt, negate = negate)) |> pull(foo)
      )

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_ends(x1, alt, negate = negate)) |> pull(foo),
        mutate(test_df, foo = str_ends(x1, alt, negate = negate)) |> pull(foo)
      )
    }
  )
})

test_that("str_detect(), grepl() and str_count() work", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    pattern = pattern_(),
    negate = logical_(len = 1),
    property = function(string, pattern, negate) {
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_detect(x1, pattern, negate = negate)) |>
          pull(foo),
        mutate(test_df, foo = str_detect(x1, pattern, negate = negate)) |>
          pull(foo)
      )

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_count(x1, pattern)) |> pull(foo),
        mutate(test_df, foo = str_count(x1, pattern)) |> pull(foo)
      )
    }
  )
})

test_that("grepl() works", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    pattern = pattern_(),
    literal = literal_pattern_(),
    ignore_case = logical_(len = 1),
    property = function(string, pattern, literal, ignore_case) {
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = grepl(pattern, x1, ignore.case = ignore_case)) |>
          pull(foo),
        mutate(test_df, foo = grepl(pattern, x1, ignore.case = ignore_case)) |>
          pull(foo)
      )

      # `ignore.case` is not combined with `fixed` on purpose: base R silently
      # ignores `ignore.case` when `fixed = TRUE`, tidypolars honors both.
      expect_equal_or_both_error(
        mutate(test_pl, foo = grepl(literal, x1, fixed = TRUE)) |> pull(foo),
        mutate(test_df, foo = grepl(literal, x1, fixed = TRUE)) |> pull(foo)
      )
    }
  )
})

test_that("regex() and fixed() modifiers work", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    pattern = pattern_(),
    literal = literal_pattern_(),
    ignore_case = logical_(len = 1),
    property = function(string, pattern, literal, ignore_case) {
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      # The function name and the namespace prefix cannot be variables, so the
      # calls are built as code. `pattern` and `ignore_case` are passed as
      # variables on purpose: `regex()` and `fixed()` must accept those and not
      # only string literals.
      check <- function(code) {
        expect_equal_or_both_error(
          eval(parse(text = sprintf(code, "test_pl"))),
          eval(parse(text = sprintf(code, "test_df")))
        )
      }

      funs <- c(
        "str_detect",
        "str_count",
        "str_starts",
        "str_ends",
        "str_extract",
        "str_remove",
        "str_remove_all"
      )

      for (fun in funs) {
        # with and without the explicit namespace
        for (ns in c("", "stringr::")) {
          check(paste0(
            "mutate(%s, foo = ",
            fun,
            "(x1, ",
            ns,
            "regex(pattern, ignore_case = ignore_case))) |> pull(foo)"
          ))
        }
      }

      for (ns in c("", "stringr::")) {
        check(paste0(
          "mutate(%s, foo = str_detect(x1, ",
          ns,
          "fixed(literal))) |> pull(foo)"
        ))
      }

      # functions taking a `replacement` argument
      for (fun in c("str_replace", "str_replace_all")) {
        check(paste0(
          "mutate(%s, foo = ",
          fun,
          "(x1, regex(pattern, ignore_case = ignore_case), \"-\")) |> pull(foo)"
        ))
      }
    }
  )
})

test_that("str_extract() works", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    pattern = pattern_(),
    group = integer_bounded(0, 2, len = 1),
    property = function(string, pattern, group) {
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_extract(x1, pattern)) |> pull(foo),
        mutate(test_df, foo = str_extract(x1, pattern)) |> pull(foo)
      )

      grouped <- paste0("(", pattern, ")(.?)")

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_extract(x1, grouped, group = group)) |>
          pull(foo),
        mutate(test_df, foo = str_extract(x1, grouped, group = group)) |>
          pull(foo)
      )
    }
  )
})

test_that("str_extract_all() works", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    pattern = pattern_(),
    property = function(string, pattern) {
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_extract_all(x1, pattern)) |> pull(foo),
        mutate(test_df, foo = str_extract_all(x1, pattern)) |> pull(foo),
        ignore_attr = TRUE
      )
    }
  )
})

test_that("nchar() works", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    # `type = "width"` is not supported by tidypolars
    type = quickcheck::one_of(constant("chars"), constant("bytes")),
    property = function(string, type) {
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = nchar(x1, type)) |> pull(foo),
        mutate(test_df, foo = nchar(x1, type)) |> pull(foo)
      )
    }
  )
})

test_that("str_replace() and str_replace_all() work", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    pattern = pattern_(),
    replacement = character_letters(len = 1),
    property = function(string, pattern, replacement) {
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_replace(x1, pattern, replacement)) |>
          pull(foo),
        mutate(test_df, foo = str_replace(x1, pattern, replacement)) |>
          pull(foo)
      )

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_replace_all(x1, pattern, replacement)) |>
          pull(foo),
        mutate(test_df, foo = str_replace_all(x1, pattern, replacement)) |>
          pull(foo)
      )
    }
  )
})

test_that("backreferences in replacements work", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    pattern = pattern_(),
    property = function(string, pattern) {
      grouped <- paste0("(", pattern, ")")
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_replace(x1, grouped, "\\1\\1")) |> pull(foo),
        mutate(test_df, foo = str_replace(x1, grouped, "\\1\\1")) |> pull(foo)
      )

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_replace_all(x1, grouped, "\\1-\\1")) |>
          pull(foo),
        mutate(test_df, foo = str_replace_all(x1, grouped, "\\1-\\1")) |>
          pull(foo)
      )

      expect_equal_or_both_error(
        mutate(test_pl, foo = gsub(grouped, "\\1\\1", x1)) |> pull(foo),
        mutate(test_df, foo = gsub(grouped, "\\1\\1", x1)) |> pull(foo)
      )
    }
  )
})

test_that("str_replace_all() works with a named vector of replacements", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    p1 = pattern_(),
    p2 = pattern_(),
    r1 = character_letters(len = 1),
    r2 = character_letters(len = 1),
    property = function(string, p1, p2, r1, r2) {
      replacements <- c(r1, r2)
      names(replacements) <- c(p1, p2)
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_replace_all(x1, replacements)) |> pull(foo),
        mutate(test_df, foo = str_replace_all(x1, replacements)) |> pull(foo)
      )
    }
  )
})

test_that("gsub() works", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    pattern = pattern_(),
    literal = literal_pattern_(),
    replacement = character_letters(len = 1),
    ignore_case = logical_(len = 1),
    property = function(string, pattern, literal, replacement, ignore_case) {
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(
          test_pl,
          foo = gsub(pattern, replacement, x1, ignore.case = ignore_case)
        ) |>
          pull(foo),
        mutate(
          test_df,
          foo = gsub(pattern, replacement, x1, ignore.case = ignore_case)
        ) |>
          pull(foo)
      )

      # `ignore.case` is not combined with `fixed` on purpose: base R silently
      # ignores `ignore.case` when `fixed = TRUE`, tidypolars honors both.
      expect_equal_or_both_error(
        mutate(test_pl, foo = gsub(literal, replacement, x1, fixed = TRUE)) |>
          pull(foo),
        mutate(test_df, foo = gsub(literal, replacement, x1, fixed = TRUE)) |>
          pull(foo)
      )
    }
  )
})

test_that("str_remove() and str_remove_all() work", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    pattern = pattern_(),
    property = function(string, pattern) {
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_remove(x1, pattern)) |> pull(foo),
        mutate(test_df, foo = str_remove(x1, pattern)) |> pull(foo)
      )

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_remove_all(x1, pattern)) |> pull(foo),
        mutate(test_df, foo = str_remove_all(x1, pattern)) |> pull(foo)
      )
    }
  )
})

test_that("word() works", {
  for_all(
    tests = 40,
    w1 = character_letters(len = 3),
    w2 = character_letters(len = 3),
    w3 = character_letters(len = 3),
    # The strings below always have 3 words. `end` is not allowed to go below
    # -3 because stringr indexes a matrix with the resolved index, so an index
    # below 0 silently becomes a negative (i.e. "drop this row") subscript
    # instead of being out of bounds. tidypolars returns NA in that case.
    start = integer_bounded(-4, 4, len = 1),
    end = integer_bounded(-3, 4, len = 1),
    # `end` defaults to `start`, so this one is bounded like `end`
    single = integer_bounded(-3, 4, len = 1),
    sep = quickcheck::one_of(constant(" "), constant("-")),
    property = function(w1, w2, w3, start, end, single, sep) {
      string <- paste(w1, w2, w3, sep = sep)
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = word(x1, start, end, sep = sep)) |> pull(foo),
        mutate(test_df, foo = word(x1, start, end, sep = sep)) |> pull(foo)
      )

      expect_equal_or_both_error(
        mutate(test_pl, foo = word(x1, single, sep = sep)) |> pull(foo),
        mutate(test_df, foo = word(x1, single, sep = sep)) |> pull(foo)
      )
    }
  )
})

test_that("str_split() and str_split_i() work", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    pattern = pattern_(),
    literal = literal_pattern_(),
    i = integer_bounded(-5, 5, len = 1),
    property = function(string, pattern, literal, i) {
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_split(x1, pattern)) |> pull(foo),
        mutate(test_df, foo = str_split(x1, pattern)) |> pull(foo),
        ignore_attr = TRUE
      )

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_split(x1, fixed(literal))) |> pull(foo),
        mutate(test_df, foo = str_split(x1, fixed(literal))) |> pull(foo),
        ignore_attr = TRUE
      )

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_split_i(x1, pattern, i = i)) |> pull(foo),
        mutate(test_df, foo = str_split_i(x1, pattern, i = i)) |> pull(foo)
      )

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_split_i(x1, fixed(literal), i = i)) |>
          pull(foo),
        mutate(test_df, foo = str_split_i(x1, fixed(literal), i = i)) |>
          pull(foo)
      )
    }
  )
})

test_that("str_trunc() works", {
  for_all(
    tests = 40,
    string = character_(any_na = TRUE),
    width = integer_bounded(3, 8, len = 1),
    # `side = "center"` is not supported by tidypolars
    side = quickcheck::one_of(constant("right"), constant("left")),
    ellipsis = quickcheck::one_of(
      constant("..."),
      constant("<>"),
      constant("")
    ),
    property = function(string, width, side, ellipsis) {
      test_df <- tibble(x1 = string)
      test_pl <- pl$LazyFrame(x1 = string)

      expect_equal_or_both_error(
        mutate(
          test_pl,
          foo = str_trunc(x1, width, side = side, ellipsis = ellipsis)
        ) |>
          pull(foo),
        mutate(
          test_df,
          foo = str_trunc(x1, width, side = side, ellipsis = ellipsis)
        ) |>
          pull(foo)
      )
    }
  )
})

test_that("str_replace_na() works", {
  for_all(
    tests = 40,
    chr = character_(any_na = TRUE),
    int = integer_(any_na = TRUE),
    lgl = logical_(any_na = TRUE),
    replacement = character_letters(len = 1),
    property = function(chr, int, lgl, replacement) {
      # Doubles are excluded on purpose: casting a float to a string doesn't
      # give the same result in R and in Polars, and this is not specific to
      # `str_replace_na()`. R uses 15 significant digits and its own rules for
      # the scientific notation, Polars uses the shortest representation that
      # round-trips (0 -> "0.0", 1e5 -> "100000.0", 0.1 + 0.2 ->
      # "0.30000000000000004", ...). Matching R here would require a UDF.
      for (column in list(chr, int)) {
        test_df <- tibble(x1 = column)
        test_pl <- pl$LazyFrame(x1 = column)

        expect_equal_or_both_error(
          mutate(test_pl, foo = str_replace_na(x1)) |> pull(foo),
          mutate(test_df, foo = str_replace_na(x1)) |> pull(foo)
        )

        expect_equal_or_both_error(
          mutate(
            test_pl,
            foo = str_replace_na(x1, replacement = replacement)
          ) |>
            pull(foo),
          mutate(
            test_df,
            foo = str_replace_na(x1, replacement = replacement)
          ) |>
            pull(foo)
        )
      }

      # Logicals are expected to differ in case: `true` in Polars, `TRUE` in R
      test_df <- tibble(x1 = lgl)
      test_pl <- pl$LazyFrame(x1 = lgl)

      expect_equal_or_both_error(
        mutate(test_pl, foo = str_replace_na(x1)) |> pull(foo) |> tolower(),
        mutate(test_df, foo = str_replace_na(x1)) |> pull(foo) |> tolower()
      )
    }
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
