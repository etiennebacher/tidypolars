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

