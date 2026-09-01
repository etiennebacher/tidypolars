# join_by() doesn't work with inequality

    Code
      collect(current)
    Condition
      Error in `semi_join()`:
      ! Inequality joins are only supported in `inner_join()` for now.

---

    Code
      collect(current)
    Condition
      Error in `anti_join()`:
      ! Inequality joins are only supported in `inner_join()` for now.

# fallback on dplyr error if wrong join_by specification

    Code
      collect(current)
    Condition
      Error in `join_by()`:
      ! Can't name join expressions.
      i Did you use `=` instead of `==`?

---

    Code
      collect(current)
    Condition
      Error in `join_by()`:
      ! Can't name join expressions.
      i Did you use `=` instead of `==`?

# unsupported args throw warning

    Code
      collect(current)
    Condition
      Error in `semi_join()`:
      ! Argument `copy` is not supported by tidypolars.
      i Use `options(tidypolars_unknown_args = "warn")` to warn when this happens instead of throwing an error.

# dots must be empty

    Code
      collect(current)
    Condition
      Error in `semi_join()`:
      ! `...` must be empty.

---

    Code
      collect(current)
    Condition
      Warning in `semi_join()`:
      Argument `copy` is not supported by tidypolars.
      Error in `semi_join()`:
      ! `...` must be empty.

