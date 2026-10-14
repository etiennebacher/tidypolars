# weights are validated before expansion

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! conversion from `f64` to `u32` failed in column '__tidypolars_uncount__' for 1 out of 2 values: [-1.0]

# weights must be supplied and cannot evaluate to NULL

    Code
      compute(current)
    Condition
      Error in `uncount()`:
      ! `weights` is absent but must be supplied.

---

    Code
      compute(current)
    Condition
      Error in `uncount()`:
      ! `weights` must be numeric or logical.

# control arguments are validated

    Code
      compute(current)
    Condition
      Error in `uncount()`:
      ! `.remove` must be `TRUE` or `FALSE`, not `NA`.

---

    Code
      compute(current)
    Condition
      Error in `uncount()`:
      ! `.id` must be a valid name or `NULL`, not the empty string "".

