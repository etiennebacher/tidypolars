# Most string functions are tested with quickcheck in test-funs-string.R.
# Only the tests that quickcheck cannot express are kept here: error and
# warning messages, and the few cases that the generators cannot produce.

test_that("paste with groups and collapse", {
  test_df <- tibble(
    grp = c(1, 1, 2, 2),
    x = c("aa", "bb", "cc", "dd")
  )
  test_pl <- as_polars_df(test_df)

  expect_equal(
    mutate(test_pl, foo = paste(x), .by = grp) |> pull(foo),
    mutate(test_df, foo = paste(x), .by = grp) |> pull(foo)
  )
  expect_equal(
    mutate(test_pl, foo = paste(x, sep = "/"), .by = grp) |> pull(foo),
    mutate(test_df, foo = paste(x, sep = "/"), .by = grp) |> pull(foo)
  )
  expect_equal(
    mutate(test_pl, foo = paste(x, collapse = "-")) |> pull(foo),
    mutate(test_df, foo = paste(x, collapse = "-")) |> pull(foo)
  )
  expect_equal(
    mutate(test_pl, foo = paste(x, collapse = "-"), .by = grp) |> pull(foo),
    mutate(test_df, foo = paste(x, collapse = "-"), .by = grp) |> pull(foo)
  )
  expect_equal(
    mutate(test_pl, foo = paste(x, sep = "/", collapse = "-"), .by = grp) |>
      pull(foo),
    mutate(test_df, foo = paste(x, sep = "/", collapse = "-"), .by = grp) |>
      pull(foo)
  )
  expect_equal(
    mutate(
      test_pl,
      foo = paste(x, "a", sep = "/", collapse = "-"),
      .by = grp
    ) |>
      pull(foo),
    mutate(
      test_df,
      foo = paste(x, "a", sep = "/", collapse = "-"),
      .by = grp
    ) |>
      pull(foo)
  )

  expect_snapshot(
    mutate(test_pl, foo = paste(x, collapse = 1:2)),
    error = TRUE
  )
})

# TODO: both should work
# filterlist <- c("he", "it")
# filtervar <- paste(filterlist, collapse = "|")
# mutate(test_df, foo = str_starts(x1, paste(filterlist, collapse = "|")))
# mutate(test_df, foo = str_starts(x1, filtervar))

test_that("extract functions work", {
  test_df <- tibble(x2 = c("apples x4", "bag of flour"))
  test_pl <- as_polars_df(test_df)

  # Use a variable as pattern (in same mutate() call)
  expect_equal(
    test_pl |>
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

  expect_warning(
    mutate(test_pl, foo = str_extract_all(x2, "[a-z]+", simplify = TRUE)),
    "doesn't know how to use some arguments"
  )
})

test_that("length functions work", {
  test_df <- tibble(x4 = c("\u00fc", "u\u0308"))
  test_pl <- as_polars_df(test_df)

  expect_snapshot(
    mutate(test_pl, foo = nchar(x4, "foo")),
    error = TRUE
  )
})

test_that("replace functions work", {
  test_df <- tibble(
    x1 = c("heLLo there", "it's mE"),
    x11 = c("[hello]", "[hi]")
  )
  test_pl <- as_polars_df(test_df)

  # `replacement` has the same length as the column
  expect_equal(
    mutate(test_pl, foo = str_replace(x1, "[aeiou]", c("1", "2"))) |> pull(foo),
    mutate(test_df, foo = str_replace(x1, "[aeiou]", c("1", "2"))) |> pull(foo)
  )

  # `pattern` is not a valid regex, so this only works because of `fixed`
  expect_equal(
    mutate(test_pl, foo = gsub("[h", "-", x11, fixed = TRUE)) |> pull(foo),
    mutate(test_df, foo = gsub("[h", "-", x11, fixed = TRUE)) |> pull(foo)
  )

  # TODO: https://github.com/pola-rs/polars/issues/12110
  # expect_equal(
  #   mutate(test_df, foo = str_replace_all(x1, "[aeiou]", toupper)) |>
  #     pull(foo),
  #   mutate(test_df, foo = str_replace_all(x1, "[aeiou]", toupper)) |>
  #     pull(foo)
  # )
})

test_that("trim functions work", {
  test_df <- tibble(x6 = c("  foo  ", "hi there  "))
  test_pl <- as_polars_df(test_df)

  expect_warning(
    mutate(test_pl, foo = trimws(x6, which = "right", whitespace = " ")),
    "doesn't know how to use some arguments"
  )
})

test_that("pad functions work", {
  test_df <- tibble(x6 = c("  foo  ", "hi there  "))
  test_pl <- as_polars_df(test_df)

  expect_error(
    mutate(test_pl, foo = str_pad(x6, width = 10, side = "both")),
    "doesn't work with a Polars object"
  )

  expect_error(
    mutate(test_pl, foo = str_pad(x6, width = 10, use_width = FALSE)),
    "doesn't work with a Polars object"
  )

  # Polars only accepts a single fill character
  expect_error(
    mutate(test_pl, foo = str_pad(x6, width = 10, pad = c("*", "-"))),
    "`pad` has a length greater than 1"
  )
})

test_that("word functions work", {
  test_df <- tibble(x7 = c("Jane saw a cat", "Jane sat down"))
  test_pl <- as_polars_df(test_df)

  expect_error(
    mutate(test_pl, foo = word(x7, c(1L, 2L))),
    "`start` or `end` has a length greater than 1"
  )
})

test_that("regex functions work", {
  test_df <- tibble(x1 = c("heLLo there", "it's mE"))
  test_pl <- as_polars_df(test_df)

  expect_warning(
    mutate(test_pl, foo = str_detect(x1, regex("hello", multiline = TRUE))),
    "tidypolars only supports the argument `ignore_case` in `regex()`.",
    fixed = TRUE
  )

  expect_warning(
    mutate(
      test_pl,
      foo = str_detect(x1, regex("hello", ignore_case = TRUE, multiline = TRUE))
    ),
    "tidypolars only supports the argument `ignore_case` in `regex()`.",
    fixed = TRUE
  )
})

test_that("split functions work", {
  test_df <- tibble(x8 = c("Jane-saw-a-cat", "Jane-sat-down"))
  test_pl <- as_polars_df(test_df)

  expect_warning(
    mutate(test_pl, foo = str_split(x8, "-", n = 2)) |> pull(foo),
    "doesn't know how to use some arguments"
  )

  expect_warning(
    mutate(test_pl, foo = str_split(x8, "-", simplify = TRUE)) |> pull(foo),
    "doesn't know how to use some arguments"
  )

  expect_error(
    mutate(test_pl, foo = str_split_i(x8, "-", i = 0)),
    "must not be 0"
  )
})

test_that("trunc functions work", {
  test_df <- tibble(x1 = c("heLLo there", "it's mE"))
  test_pl <- as_polars_df(test_df)

  expect_error(
    mutate(test_pl, foo = str_trunc(x1, 1)),
    "is shorter than `ellipsis`"
  )

  expect_error(
    mutate(test_pl, foo = str_trunc(x1, 5, side = "center")),
    "is not supported"
  )

  expect_error(
    mutate(test_pl, foo = str_trunc(x1, 5, side = "foobar")),
    "must be either"
  )
})

# str_replace_na ---------------------------------------------------------
test_that("stringr::str_replace_na works", {
  test_df <- tibble(generic = c(NA, "abc", "def"))
  test_pl <- as_polars_df(test_df)

  expect_snapshot(
    test_pl |> mutate(rep = str_replace_na(generic, replacement = NA)),
    error = TRUE
  )
  expect_snapshot(
    test_pl |> mutate(rep = str_replace_na(generic, replacement = 1)),
    error = TRUE
  )
  expect_snapshot(
    test_pl |> mutate(rep = str_replace_na(generic, replacement = c("a", "b"))),
    error = TRUE
  )
})

test_that("str_equal() works", {
  test_df <- tibble(x = c("\u00e1", "\u2126"), y = c("a\u0301", "\u03A9"))
  test_pl <- as_polars_df(test_df)

  expect_warning(
    mutate(test_pl, eq = str_equal(x, y, ignore_case = TRUE)),
    "doesn't know how to use some arguments"
  )
})
