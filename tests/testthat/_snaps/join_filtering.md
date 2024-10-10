# join_by() doesn't work with inequality

    Code
      semi_join(test, test2, by = join_by(x, y1 > y2))
    Condition
      Error in `semi_join()`:
      ! `tidypolars` doesn't support inequality conditions in `join_by()` yet.

---

    Code
      anti_join(test, test2, by = join_by(x, y1 > y2))
    Condition
      Error in `anti_join()`:
      ! `tidypolars` doesn't support inequality conditions in `join_by()` yet.

# fallback on dplyr error if wrong join_by specification

    Code
      semi_join(test, test2, by = join_by(x, y1 = y2))
    Condition
      Error in `join_by()`:
      ! Can't name join expressions.
      i Did you use `=` instead of `==`?

---

    Code
      anti_join(test, test2, by = join_by(x, y1 = y2))
    Condition
      Error in `join_by()`:
      ! Can't name join expressions.
      i Did you use `=` instead of `==`?

