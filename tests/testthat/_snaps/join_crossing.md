# unsupported args throw warning

    Code
      cross_join(test, test2, keep = TRUE)
    Condition
      Error in `cross_join()`:
      ! `...` must be empty.

# dots must be empty

    Code
      cross_join(test, test2, foo = TRUE)
    Condition
      Error in `cross_join()`:
      ! `...` must be empty.

---

    Code
      cross_join(test, test2, copy = TRUE, foo = TRUE)
    Condition
      Warning in `cross_join()`:
      Argument `copy` is not supported by tidypolars.
      Error in `cross_join()`:
      ! `...` must be empty.

