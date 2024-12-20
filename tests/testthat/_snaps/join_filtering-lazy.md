# join_by() doesn't work with inequality

    Code
      current$collect()
    Condition
      Error in `semi_join()`:
      ! Inequality joins are only supported in `inner_join()` for now.

---

    Code
      current$collect()
    Condition
      Error in `anti_join()`:
      ! Inequality joins are only supported in `inner_join()` for now.

# fallback on dplyr error if wrong join_by specification

    Code
      current$collect()
    Condition
      Error in `join_by()`:
      ! Can't name join expressions.
      i Did you use `=` instead of `==`?

---

    Code
      current$collect()
    Condition
      Error in `join_by()`:
      ! Can't name join expressions.
      i Did you use `=` instead of `==`?

# unsupported args throw warning

    Code
      current$collect()
    Condition
      Error in `semi_join()`:
      ! Argument `copy` is not supported by tidypolars.
      i Use `options(tidypolars_unknown_args = "warn")` to warn when this happens instead of throwing an error.

# dots must be empty

    Code
      current$collect()
    Condition
      Error in `semi_join()`:
      ! `...` must be empty.

---

    Code
      current$collect()
    Condition
      Warning in `semi_join()`:
      Argument `copy` is not supported by tidypolars.
      Error in `semi_join()`:
      ! `...` must be empty.

