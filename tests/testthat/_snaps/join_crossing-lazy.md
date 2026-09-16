# unsupported args throw warning

    Code
      compute(current)
    Condition
      Error in `cross_join()`:
      ! Argument `copy` is not supported by tidypolars.
      i Use `options(tidypolars_unknown_args = "warn")` to warn when this happens instead of throwing an error.

# dots must be empty

    Code
      compute(current)
    Condition
      Error in `cross_join()`:
      ! `...` must be empty.

---

    Code
      compute(current)
    Condition
      Warning in `cross_join()`:
      Argument `copy` is not supported by tidypolars.
      Error in `cross_join()`:
      ! `...` must be empty.

