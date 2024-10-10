# error cases work

    Code
      current$collect()
    Condition
      Error in `relocate()`:
      ! You can specify either `.before` or `.after` but not both.

---

    Code
      current$collect()
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `foo` doesn't exist.

---

    Code
      current$collect()
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `foo` doesn't exist.

