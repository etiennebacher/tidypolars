# error messages when error in known function is good

    Code
      mutate(pl_iris, foo = min_rank())
    Condition
      Error in `mutate()`:
      ! Error while running function `min_rank()` in Polars.
      x Argument "x" is missing, with no default

---

    Code
      mutate(pl_iris, foo = dplyr::min_rank())
    Condition
      Error in `mutate()`:
      ! Error while running function `dplyr::min_rank()` in Polars.
      x Argument "x" is missing, with no default

