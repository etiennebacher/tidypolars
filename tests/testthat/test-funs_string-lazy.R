### [GENERATED AUTOMATICALLY] Update test-funs_string.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("case functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  for (i in c("toupper", "tolower", "str_to_lower", "str_to_upper", "nchar")) {
    pol <- paste0("mutate(test, foo = ", i, "(x1))") |>
      str2lang() |>
      eval() |>
      pull(foo)

    res <- paste0("mutate(test_df, foo = ", i, "(x1))") |>
      str2lang() |>
      eval() |>
      pull(foo)

    expect_equal_lazy(pol, res, info = i)
  }

  if (neopolars::polars_info()$features$full_features) {
    # in this case, the output when there's an apostrophe is different from stringr
    # and tools::toTitleCase()
    # https://github.com/pola-rs/polars/issues/18260
    expect_equal_lazy(
      mutate(test, foo = str_to_title(x1)) |>
        pull(foo),
      c("Hello There", "It'S Me")
    )

    expect_equal_lazy(
      mutate(test, foo = toTitleCase(x1)) |>
        pull(foo),
      c("Hello There", "It'S Me")
    )
  }
})

test_that("paste and paste0 work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = paste(x1, "he")) |>
      pull(foo),
    mutate(test_df, foo = paste(x1, "he")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = paste(x1, "he", sep = "--")) |>
      pull(foo),
    mutate(test_df, foo = paste(x1, "he", sep = "--")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = paste0(x1, "he")) |>
      pull(foo),
    mutate(test_df, foo = paste0(x1, "he")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = paste0(x1, "he", x3)) |>
      pull(foo),
    mutate(test_df, foo = paste0(x1, "he", x3)) |>
      pull(foo)
  )
})

test_that("start and end functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = str_starts(x1, "he")) |>
      pull(foo),
    mutate(test_df, foo = str_starts(x1, "he")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_starts(x1, "he", negate = TRUE)) |>
      pull(foo),
    mutate(test_df, foo = str_starts(x1, "he", negate = TRUE)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_ends(x1, "ere")) |>
      pull(foo),
    mutate(test_df, foo = str_ends(x1, "ere")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_ends(x1, "ere", negate = TRUE)) |>
      pull(foo),
    mutate(test_df, foo = str_ends(x1, "ere", negate = TRUE)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_starts(x1, regex("hel", ignore_case = TRUE))) |>
      pull(foo),
    mutate(test_df, foo = str_starts(x1, regex("hel", ignore_case = TRUE))) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_ends(x1, regex("me", ignore_case = TRUE))) |>
      pull(foo),
    mutate(test_df, foo = str_ends(x1, regex("me", ignore_case = TRUE))) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_starts(x1, "he|it")) |>
      pull(foo),
    mutate(test_df, foo = str_starts(x1, "he|it")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_ends(x1, "re|mE")) |>
      pull(foo),
    mutate(test_df, foo = str_ends(x1, "re|mE")) |>
      pull(foo)
  )
})

# TODO: both should work
# filterlist <- c("he", "it")
# filtervar <- paste(filterlist, collapse = "|")
# mutate(test, foo = str_starts(x1, paste(filterlist, collapse = "|")))
# mutate(test, foo = str_starts(x1, filtervar))

test_that("extract functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = str_extract(x2, "\\d")) |>
      pull(foo),
    mutate(test_df, foo = str_extract(x2, "\\d")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_extract(x2, "[a-z]+")) |>
      pull(foo),
    mutate(test_df, foo = str_extract(x2, "[a-z]+")) |>
      pull(foo)
  )

  # Use a variable as pattern (in same mutate() call)
  expect_equal_lazy(
    test |>
      mutate(
        pattern = c("\\d", "[a-z]{1,4}"),
        foo = str_extract(x2, pattern)
      ) |>
      pull(foo),
    test_df |>
      mutate(
        pattern = c("\\d", "[a-z]{1,4}"),
        foo = str_extract(x2, pattern)
      ) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_extract(x2, "([a-z]+) of ([a-z]+)", group = 2)) |>
      pull(foo),
    mutate(test_df, foo = str_extract(x2, "([a-z]+) of ([a-z]+)", group = 2)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_extract(x7, regex("[a-z]", ignore_case = TRUE))) |>
      pull(foo),
    mutate(
      test_df,
      foo = str_extract(x7, regex("[a-z]", ignore_case = TRUE))
    ) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(
      test,
      foo = str_extract_all(x1, regex("[a-z]", ignore_case = TRUE))
    ) |>
      pull(foo),
    mutate(
      test_df,
      foo = str_extract_all(x1, regex("[a-z]", ignore_case = TRUE))
    ) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_extract_all(x2, "[a-z]+")) |>
      pull(foo),
    mutate(test_df, foo = str_extract_all(x2, "[a-z]+")) |>
      pull(foo)
  )

  expect_warning(
    mutate(test, foo = str_extract_all(x2, "[a-z]+", simplify = TRUE)),
    "doesn't know how to use some arguments"
  )
})

test_that("length functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = str_length(x2)) |>
      pull(foo),
    mutate(test_df, foo = str_length(x2)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_length(x3)) |>
      pull(foo),
    mutate(test_df, foo = str_length(x3)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_length(x4)) |>
      pull(foo),
    mutate(test_df, foo = str_length(x4)) |>
      pull(foo)
  )
})

test_that("replace functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = str_replace(x1, "[aeiou]", "-")) |>
      pull(foo),
    mutate(test_df, foo = str_replace(x1, "[aeiou]", "-")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_replace(x1, "[aeiou]", "")) |>
      pull(foo),
    mutate(test_df, foo = str_replace(x1, "[aeiou]", "")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_replace(x1, regex("l", ignore_case = TRUE), "-")) |>
      pull(foo),
    mutate(
      test_df,
      foo = str_replace(x1, regex("l", ignore_case = TRUE), "-")
    ) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_replace(x1, "([aeiou])", "\\1\\1")) |>
      pull(foo),
    mutate(test_df, foo = str_replace(x1, "([aeiou])", "\\1\\1")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(
      test,
      foo = str_replace(x10, "(\\d{1,2})(_)(\\d{1,2})", "\\1-\\3")
    ) |>
      pull(foo),
    mutate(
      test_df,
      foo = str_replace(x10, "(\\d{1,2})(_)(\\d{1,2})", "\\1-\\3")
    ) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_replace(x1, "[aeiou]", c("1", "2"))) |>
      pull(foo),
    mutate(test_df, foo = str_replace(x1, "[aeiou]", c("1", "2"))) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_replace_all(x1, "[aeiou]", "-")) |>
      pull(foo),
    mutate(test_df, foo = str_replace_all(x1, "[aeiou]", "-")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(
      test,
      foo = str_replace_all(x1, regex("[aeiou]", ignore_case = TRUE), "-")
    ) |>
      pull(foo),
    mutate(
      test_df,
      foo = str_replace_all(x1, regex("[aeiou]", ignore_case = TRUE), "-")
    ) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_replace_all(x1, "([aeiou])", "\\1")) |>
      pull(foo),
    mutate(test_df, foo = str_replace_all(x1, "([aeiou])", "\\1")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_replace_all(x1, c("LL" = "ll", " " = "_"))) |>
      pull(foo),
    mutate(test_df, foo = str_replace_all(x1, c("LL" = "ll", " " = "_"))) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_replace_all(x1, c("LL" = "ll", "( )" = "\\1\\1"))) |>
      pull(foo),
    mutate(
      test_df,
      foo = str_replace_all(x1, c("LL" = "ll", "( )" = "\\1\\1"))
    ) |>
      pull(foo)
  )

  # TODO: https://github.com/pola-rs/polars/issues/12110
  # expect_equal_lazy(
  #   mutate(test, foo = str_replace_all(x1, "[aeiou]", toupper)) |>
  #     pull(foo),
  #   mutate(test_df, foo = str_replace_all(x1, "[aeiou]", toupper)) |>
  #     pull(foo)
  # )
})

test_that("remove functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = str_remove(x1, "[aeiou]")) |>
      pull(foo),
    mutate(test_df, foo = str_remove(x1, "[aeiou]")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_remove(x1, regex("l", ignore_case = TRUE))) |>
      pull(foo),
    mutate(test_df, foo = str_remove(x1, regex("l", ignore_case = TRUE))) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_remove(x2, "[[:digit:]]")) |>
      pull(foo),
    mutate(test_df, foo = str_remove(x2, "[[:digit:]]")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_remove_all(x1, "[aeiou]")) |>
      pull(foo),
    mutate(test_df, foo = str_remove_all(x1, "[aeiou]")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(
      test,
      foo = str_remove_all(x1, regex("[aeiou]", ignore_case = TRUE))
    ) |>
      pull(foo),
    mutate(
      test_df,
      foo = str_remove_all(x1, regex("[aeiou]", ignore_case = TRUE))
    ) |>
      pull(foo)
  )
})

test_that("sub functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = str_sub(x1, 1, 1)) |>
      pull(foo),
    mutate(test_df, foo = str_sub(x1, 1, 1)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_sub(x1, 3, 5)) |>
      pull(foo),
    mutate(test_df, foo = str_sub(x1, 3, 5)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_sub(x1, -1)) |>
      pull(foo),
    mutate(test_df, foo = str_sub(x1, -1)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_sub(x1, 0)) |>
      pull(foo),
    mutate(test_df, foo = str_sub(x1, 0)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_sub(x1, -1)) |>
      pull(foo),
    mutate(test_df, foo = str_sub(x1, -1)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_sub(x1, 1, -2)) |>
      pull(foo),
    mutate(test_df, foo = str_sub(x1, 1, -2)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_sub(x1, -3, -2)) |>
      pull(foo),
    mutate(test_df, foo = str_sub(x1, -3, -2)) |>
      pull(foo)
  )

  # end = -1 is a special value
  expect_equal_lazy(
    mutate(test, foo = str_sub(x1, -3, -1)) |>
      pull(foo),
    mutate(test_df, foo = str_sub(x1, -3, -1)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_sub(x1, NA, 2)) |>
      pull(foo),
    mutate(test_df, foo = str_sub(x1, NA, 2)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_sub(x1, 2, NA)) |>
      pull(foo),
    mutate(test_df, foo = str_sub(x1, 2, NA)) |>
      pull(foo)
  )

  # Same with substr(), which is stricter about negative indices

  expect_equal_lazy(
    mutate(test, foo = substr(x1, 1, 1)) |>
      pull(foo),
    mutate(test_df, foo = substr(x1, 1, 1)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = substr(x1, 3, 5)) |>
      pull(foo),
    mutate(test_df, foo = substr(x1, 3, 5)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = substr(x1, 1, 100)) |>
      pull(foo),
    mutate(test_df, foo = substr(x1, 1, 100)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = substr(x1, 100, 101)) |>
      pull(foo),
    mutate(test_df, foo = substr(x1, 100, 101)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = substr(x1, -10, -2)) |>
      pull(foo),
    mutate(test_df, foo = substr(x1, -10, -2)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = substr(x1, NA, 2)) |>
      pull(foo),
    mutate(test_df, foo = substr(x1, NA, 2)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = substr(x1, 2, NA)) |>
      pull(foo),
    mutate(test_df, foo = substr(x1, 2, NA)) |>
      pull(foo)
  )
})

test_that("count functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = str_count(x1, "[aeiou]")) |>
      pull(foo),
    mutate(test_df, foo = str_count(x1, "[aeiou]")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_count(x5, ".")) |>
      pull(foo),
    mutate(test_df, foo = str_count(x5, ".")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_count(x5, fixed("."))) |>
      pull(foo),
    mutate(test_df, foo = str_count(x5, fixed("."))) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_count(x1, regex("hello", ignore_case = TRUE))) |>
      pull(foo),
    mutate(test_df, foo = str_count(x1, regex("hello", ignore_case = TRUE))) |>
      pull(foo)
  )
})

test_that("trim functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = str_trim(x6)) |>
      pull(foo),
    mutate(test_df, foo = str_trim(x6)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_trim(x6, side = "left")) |>
      pull(foo),
    mutate(test_df, foo = str_trim(x6, side = "left")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_trim(x6, side = "right")) |>
      pull(foo),
    mutate(test_df, foo = str_trim(x6, side = "right")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = trimws(x6)) |>
      pull(foo),
    mutate(test_df, foo = trimws(x6)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = trimws(x6, which = "left")) |>
      pull(foo),
    mutate(test_df, foo = trimws(x6, which = "left")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = trimws(x6, which = "right")) |>
      pull(foo),
    mutate(test_df, foo = trimws(x6, which = "right")) |>
      pull(foo)
  )

  expect_warning(
    mutate(test, foo = trimws(x6, which = "right", whitespace = " ")),
    "doesn't know how to use some arguments"
  )
})

test_that("pad functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = str_pad(x6, width = 10)) |>
      pull(foo),
    mutate(test_df, foo = str_pad(x6, width = 10)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_pad(x6, width = 10, pad = "*")) |>
      pull(foo),
    mutate(test_df, foo = str_pad(x6, width = 10, pad = "*")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_pad(x6, width = 10, side = "right")) |>
      pull(foo),
    mutate(test_df, foo = str_pad(x6, width = 10, side = "right")) |>
      pull(foo)
  )

  expect_error_lazy(
    mutate(test, foo = str_pad(x6, width = 10, side = "both")),
    "doesn't work in a Polars DataFrame"
  )

  expect_error_lazy(
    mutate(test, foo = str_pad(x6, width = 10, use_width = FALSE)),
    "doesn't work in a Polars DataFrame"
  )
})

test_that("word functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = word(x7)) |>
      pull(foo),
    mutate(test_df, foo = word(x7)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = word(x7, 2, 3)) |>
      pull(foo),
    mutate(test_df, foo = word(x7, 2, 3)) |>
      pull(foo)
  )

  expect_error_lazy(
    mutate(test, foo = word(x7, 2, 4)),
    "out of bounds"
  )

  expect_equal_lazy(
    mutate(test, foo = word(x8, 2, 3, sep = "-")) |>
      pull(foo),
    mutate(test_df, foo = word(x8, 2, 3, sep = "-")) |>
      pull(foo)
  )
})

test_that("squish functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = str_squish(x9)) |>
      pull(foo),
    mutate(test_df, foo = str_squish(x9)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_squish(x7)) |>
      pull(foo),
    mutate(test_df, foo = str_squish(x7)) |>
      pull(foo)
  )
})

test_that("detect functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = str_detect(x1, "e")) |>
      pull(foo),
    mutate(test_df, foo = str_detect(x1, "e")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_detect(x1, "^he")) |>
      pull(foo),
    mutate(test_df, foo = str_detect(x1, "^he")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_detect(x1, "e", negate = TRUE)) |>
      pull(foo),
    mutate(test_df, foo = str_detect(x1, "e", negate = TRUE)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = grepl("^he", x1)) |>
      pull(foo),
    mutate(test_df, foo = grepl("^he", x1)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_detect(x5, fixed("."))) |>
      pull(foo),
    mutate(test_df, foo = str_detect(x5, fixed("."))) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_detect(x1, regex("hello", ignore_case = TRUE))) |>
      pull(foo),
    mutate(test_df, foo = str_detect(x1, regex("hello", ignore_case = TRUE))) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = grepl(".", x5, fixed = TRUE)) |>
      pull(foo),
    mutate(test_df, foo = grepl(".", x5, fixed = TRUE)) |>
      pull(foo)
  )

  expect_warning(
    mutate(test, foo = grepl("e", x1, ignore.case = TRUE)),
    "doesn't know how to use some arguments"
  )
})

test_that("regex functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_warning(
    mutate(test, foo = str_detect(x1, regex("hello", multiline = TRUE))),
    "tidypolars only supports the argument `ignore_case` in `regex()`.",
    fixed = TRUE
  )

  expect_warning(
    mutate(
      test,
      foo = str_detect(x1, regex("hello", ignore_case = TRUE, multiline = TRUE))
    ),
    "tidypolars only supports the argument `ignore_case` in `regex()`.",
    fixed = TRUE
  )
})

test_that("dup functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = str_dup(x1, 5)) |>
      pull(foo),
    mutate(test_df, foo = str_dup(x1, 5)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_dup(x1, 0)) |>
      pull(foo),
    mutate(test_df, foo = str_dup(x1, 0)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_dup(x1, -1)) |>
      pull(foo),
    mutate(test_df, foo = str_dup(x1, -1)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_dup(x1, NA)) |>
      pull(foo),
    mutate(test_df, foo = str_dup(x1, NA)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_dup(x1, c(1, 2))) |>
      pull(foo),
    mutate(test_df, foo = str_dup(x1, c(1, 2))) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_dup(x1, c(-1, NA))) |>
      pull(foo),
    mutate(test_df, foo = str_dup(x1, c(-1, NA))) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_dup(x1, n)) |>
      pull(foo),
    mutate(test_df, foo = str_dup(x1, n)) |>
      pull(foo)
  )
})

test_that("split functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = str_split(x8, "-")) |>
      pull(foo),
    mutate(test_df, foo = str_split(x8, "-")) |>
      pull(foo)
  )

  expect_warning(
    mutate(test, foo = str_split(x8, "-", n = 2)) |>
      pull(foo),
    "doesn't know how to use some arguments"
  )

  expect_warning(
    mutate(test, foo = str_split(x8, "-", simplify = TRUE)) |>
      pull(foo),
    "doesn't know how to use some arguments"
  )

  # split_i ---------------------------------------------------------

  expect_equal_lazy(
    mutate(test, foo = str_split_i(x8, "-", i = 3)) |>
      pull(foo),
    mutate(test_df, foo = str_split_i(x8, "-", i = 3)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_split_i(x8, "-", i = 100)) |>
      pull(foo),
    mutate(test_df, foo = str_split_i(x8, "-", i = 100)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_split_i(x8, "-", i = -1)) |>
      pull(foo),
    mutate(test_df, foo = str_split_i(x8, "-", i = -1)) |>
      pull(foo)
  )

  expect_error_lazy(
    mutate(test, foo = str_split_i(x8, "-", i = 0)),
    "must not be 0"
  )
})

test_that("trunc functions work", {
  test_df <- data.frame(
    x1 = c("heLLo there", "it's mE"),
    x2 = c("apples x4", "bag of flour"),
    x3 = c("\u6c49\u5b57", "\U0001f60a"),
    x4 = c("\u00fc", "u\u0308"),
    x5 = c("a.", "..."),
    x6 = c("  foo  ", "hi there  "),
    x7 = c("Jane saw a cat", "Jane sat down"),
    x8 = c("Jane-saw-a-cat", "Jane-sat-down"),
    x9 = c(" Some text    with ws   ", "and more     white   space  "),
    x10 = c("Age_groups_0_4_years_Persons", "Age_groups_5_14_years_Persons"),
    n = 1:2
  )
  test <- as_polars_lf(test_df)

  expect_equal_lazy(
    mutate(test, foo = str_trunc(x1, 5)) |>
      pull(foo),
    mutate(test_df, foo = str_trunc(x1, 5)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_trunc(x1, 5, side = "left")) |>
      pull(foo),
    mutate(test_df, foo = str_trunc(x1, 5, side = "left")) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_trunc(x1, 3)) |>
      pull(foo),
    mutate(test_df, foo = str_trunc(x1, 3)) |>
      pull(foo)
  )

  expect_equal_lazy(
    mutate(test, foo = str_trunc(x1, 5, ellipsis = "<>")) |>
      pull(foo),
    mutate(test_df, foo = str_trunc(x1, 5, ellipsis = "<>")) |>
      pull(foo)
  )

  expect_error_lazy(
    mutate(test, foo = str_trunc(x1, 1)),
    "is shorter than `ellipsis`"
  )

  expect_error_lazy(
    mutate(test, foo = str_trunc(x1, 5, side = "center")),
    "is not supported"
  )

  expect_error_lazy(
    mutate(test, foo = str_trunc(x1, 5, side = "foobar")),
    "must be either"
  )
})

# str_replace_na ---------------------------------------------------------
test_that("stringr::str_replace_na works", {
  test_df <- data.frame(
    generic = c(NA, "abc", "def"),
    logical = c(NA, TRUE, FALSE),
    integer = c(NA_integer_, 2L, 3L),
    float = c(NA_real_, 2.1, 3.1),
    character = c(NA_character_, "abc", "def")
  )
  test_pl <- as_polars_lf(test_df)

  # generic NA
  expect_equal_lazy(
    test_pl |>
      mutate(rep = str_replace_na(generic)) |>
      pull(rep),
    test_df |>
      mutate(rep = str_replace_na(generic)) |>
      pull(rep)
  )
  # logical NA
  # Logical is expected to be different, because `true` is converted to
  # `"true"` in polars
  expect_equal_lazy(
    test_pl |>
      mutate(rep = str_replace_na(logical)) |>
      pull(rep) |>
      tolower(),
    test_df |>
      mutate(rep = str_replace_na(logical)) |>
      pull(rep) |>
      tolower()
  )
  # integer NA
  expect_equal_lazy(
    test_pl |>
      mutate(rep = str_replace_na(integer)) |>
      pull(rep),
    test_df |>
      mutate(rep = str_replace_na(integer)) |>
      pull(rep)
  )
  # float NA
  expect_equal_lazy(
    test_pl |>
      mutate(rep = str_replace_na(float)) |>
      pull(rep),
    test_df |>
      mutate(rep = str_replace_na(float)) |>
      pull(rep)
  )
  # character NA
  expect_equal_lazy(
    test_pl |>
      mutate(rep = str_replace_na(character)) |>
      pull(rep),
    test_df |>
      mutate(rep = str_replace_na(character)) |>
      pull(rep)
  )

  # arg 'replacement' works
  expect_equal_lazy(
    test_pl |>
      mutate(rep = str_replace_na(generic, replacement = "foo")) |>
      pull(rep),
    test_df |>
      mutate(rep = str_replace_na(generic, replacement = "foo")) |>
      pull(rep)
  )
  expect_snapshot_lazy(
    test_pl |>
      mutate(rep = str_replace_na(generic, replacement = NA)),
    error = TRUE
  )
  expect_snapshot_lazy(
    test_pl |>
      mutate(rep = str_replace_na(generic, replacement = 1)),
    error = TRUE
  )
  expect_snapshot_lazy(
    test_pl |>
      mutate(rep = str_replace_na(generic, replacement = c("a", "b"))),
    error = TRUE
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
