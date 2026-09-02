# error cases work

    Code
      compute(current)
    Condition
      Error in `relocate()`:
      ! You can specify either `.before` or `.after` but not both.

---

    Code
      compute(current)
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `foo` doesn't exist.

---

    Code
      compute(current)
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `foo` doesn't exist.

