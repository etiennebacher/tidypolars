# inequality joins only work in inner joins for now

    Code
      left_join(a, b, join_by(x > y))
    Condition
      Error in `join_()`:
      ! Inequality joins only supported for `inner_join()` for now.

