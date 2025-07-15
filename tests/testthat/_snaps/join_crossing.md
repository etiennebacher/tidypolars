# unsupported args throw warning

    Code
      cross_join(test, test2, copy = TRUE)
    Condition
      Error in `cross_join()`:
      ! Argument `copy` is not supported by tidypolars.
      i Use `options(tidypolars_unknown_args = "warn")` to warn when this happens instead of throwing an error.

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

