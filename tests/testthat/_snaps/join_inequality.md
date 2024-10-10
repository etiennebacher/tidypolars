# inequality joins only work in inner joins for now

    Code
      left_join(a, b, join_by(x > y))
    Condition
      Error in `left_join()`:
      ! Inequality joins are only supported in `inner_join()` for now.

---

    Code
      left_join(a, b, join_by(within(x, y, z)))
    Condition
      Error:
      ! Expressions using `within()` can't contain missing arguments.
      x Argument `y_upper` is missing.

