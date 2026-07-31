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
      translate_in_caller(rlang::expr(x %in% missing_lower:4))
    Condition
      Error:
      ! object 'missing_lower' not found

---

    Code
      translate_in_caller(rlang::expr(x %notin% missing_lower:4))
    Condition
      Error:
      ! object 'missing_lower' not found

