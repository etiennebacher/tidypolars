# paste with groups and collapse

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `paste()` in Polars.
      x `collapse` must be a single string or `NULL`, not an integer vector.

# length functions work

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `nchar()` in Polars.
      x `type` must be one of "chars" or "bytes", not "foo".

# stringr::str_replace_na works

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `str_replace_na()` in Polars.
      x `replacement` must be a single string, not `NA`.

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `str_replace_na()` in Polars.
      x `replacement` must be a single string, not the number 1.

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `str_replace_na()` in Polars.
      x `replacement` must be a single string, not a character vector.

