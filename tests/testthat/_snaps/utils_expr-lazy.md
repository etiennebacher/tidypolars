# error messages when error in known function is good

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `min_rank()` in Polars.
      x argument "x" is missing, with no default

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `dplyr::min_rank()` in Polars.
      x argument "x" is missing, with no default

# missing variables in ranges produce errors

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while translating `x %in% missing_lower:4`.
      Caused by error:
      ! object 'missing_lower' not found

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while translating `x %notin% missing_lower:4`.
      Caused by error:
      ! object 'missing_lower' not found

---

    Code
      current$collect()
    Condition
      Error in `filter()`:
      ! Error while translating `x %in% missing_lower:4`.
      Caused by error:
      ! object 'missing_lower' not found

