# error messages when error in known function is good

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error in `min_rank()`.
      Caused by error in `min_rank()`:
      ! argument "x" is missing, with no default

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error in `dplyr::min_rank()`.
      Caused by error in `dplyr::min_rank()`:
      ! argument "x" is missing, with no default

