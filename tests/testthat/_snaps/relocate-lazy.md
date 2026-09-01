# error cases work

    Code
      collect(current)
    Condition
      Error in `relocate()`:
      ! You can specify either `.before` or `.after` but not both.

---

    Code
      collect(current)
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `foo` doesn't exist.

---

    Code
      collect(current)
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `foo` doesn't exist.

