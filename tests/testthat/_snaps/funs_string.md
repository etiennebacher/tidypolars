# paste with groups and collapse

    Code
      mutate(test, foo = paste(x, collapse = 1:2))
    Condition
      Error in `mutate()`:
      ! Error while running function `paste()` in Polars.
      x `collapse` must be a single string or `NULL`, not an integer vector.

# stringr::str_replace_na works

    Code
      mutate(test_pl, rep = str_replace_na(generic, replacement = NA))
    Condition
      Error in `mutate()`:
      ! Error while running function `str_replace_na()` in Polars.
      x `replacement` must be a single string, not `NA`.

---

    Code
      mutate(test_pl, rep = str_replace_na(generic, replacement = 1))
    Condition
      Error in `mutate()`:
      ! Error while running function `str_replace_na()` in Polars.
      x `replacement` must be a single string, not the number 1.

---

    Code
      mutate(test_pl, rep = str_replace_na(generic, replacement = c("a", "b")))
    Condition
      Error in `mutate()`:
      ! Error while running function `str_replace_na()` in Polars.
      x `replacement` must be a single string, not a character vector.

