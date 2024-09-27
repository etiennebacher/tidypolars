# error cases work

    Code
      relocate(test, mpg, .before = cyl, .after = drat)
    Condition
      Error in `relocate()`:
      ! You can specify either `.before` or `.after` but not both.

---

    Code
      relocate(test, mpg, .before = foo)
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `foo` doesn't exist.

---

    Code
      relocate(test, mpg, .after = foo)
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `foo` doesn't exist.

