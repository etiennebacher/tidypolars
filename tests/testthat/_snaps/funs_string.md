# stringr::str_replace_na works

    Code
      mutate(test_pl, rep = str_replace_na(generic, replacement = NA))
    Condition
      Error in `mutate()`:
      ! Error while running function `str_replace_na()` in Polars.
      x `replacement` must be a single string, not `NA`.

