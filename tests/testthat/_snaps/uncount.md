# weights are validated before expansion

    Code
      uncount(test_pl, missing)
    Condition
      Error in `uncount()`:
      ! conversion from `f64` to `u32` failed in column '__tidypolars_uncount__' for 1 out of 2 values: [-1.0]

# weights must be supplied and cannot evaluate to NULL

    Code
      uncount(test_pl)
    Condition
      Error in `uncount()`:
      ! `weights` is absent but must be supplied.

---

    Code
      uncount(test_pl, NULL)
    Condition
      Error in `uncount()`:
      ! `weights` must be numeric or logical.

# control arguments are validated

    Code
      uncount(test_pl, n, .remove = NA)
    Condition
      Error in `uncount()`:
      ! `.remove` must be `TRUE` or `FALSE`, not `NA`.

---

    Code
      uncount(test_pl, n, .id = "")
    Condition
      Error in `uncount()`:
      ! `.id` must be a valid name or `NULL`, not the empty string "".

