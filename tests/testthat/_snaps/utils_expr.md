# error messages when error in known function is good

    Code
      mutate(pl_iris, foo = min_rank())
    Condition
      Error in `mutate()`:
      ! Error in `min_rank()`.
      Caused by error in `min_rank()`:
      ! argument "x" is missing, with no default

---

    Code
      mutate(pl_iris, foo = dplyr::min_rank())
    Condition
      Error in `mutate()`:
      ! Error in `dplyr::min_rank()`.
      Caused by error in `dplyr::min_rank()`:
      ! argument "x" is missing, with no default

