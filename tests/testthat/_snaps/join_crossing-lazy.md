# unsupported args throw warning

    Code
      current$collect()
    Condition
      Error in `cross_join()`:
      ! `...` must be empty.

# dots must be empty

    Code
      current$collect()
    Condition
      Error in `cross_join()`:
      ! `...` must be empty.

---

    Code
      current$collect()
    Condition
      Warning in `cross_join()`:
      Argument `copy` is not supported by tidypolars.
      Error in `cross_join()`:
      ! `...` must be empty.

