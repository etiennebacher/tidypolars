# error messages when error in known function is good

    Code
      mutate(pl_iris, foo = min_rank())
    Condition
      Error in `mutate()`:
      ! Error while running function `min_rank()` in Polars.
      x argument "x" is missing, with no default

---

    Code
      mutate(pl_iris, foo = dplyr::min_rank())
    Condition
      Error in `mutate()`:
      ! Error while running function `dplyr::min_rank()` in Polars.
      x argument "x" is missing, with no default

# missing variables in ranges produce errors

    Code
      mutate(test_pl, in_range = x %in% missing_lower:4)
    Condition
      Error in `mutate()`:
      ! Error while translating `x %in% missing_lower:4`.
      Caused by error:
      ! object 'missing_lower' not found

---

    Code
      mutate(test_pl, in_range = x %notin% missing_lower:4)
    Condition
      Error in `mutate()`:
      ! Error while translating `x %notin% missing_lower:4`.
      Caused by error:
      ! object 'missing_lower' not found

---

    Code
      filter(test_pl, x %in% missing_lower:4)
    Condition
      Error in `filter()`:
      ! Error while translating `x %in% missing_lower:4`.
      Caused by error:
      ! object 'missing_lower' not found

