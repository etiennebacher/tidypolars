# scalar value works

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! lengths don't match: can't broadcast Series 'Sepal.Width' of length 2 to length 150

---

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! lengths don't match: can't broadcast Series 'Sepal.Width' of length 2 to length 150

# custom function that doesn't return Polars expression

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `foo()` in Polars.
      x non-numeric argument to mathematical function

# argument .keep works

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! `.keep` must be one of "all", "used", "unused", or "none", not "foo".

# arguments .before and .after error consistently

    Code
      collect(current)
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `missing_col` doesn't exist.

---

    Code
      collect(current)
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `missing_col` doesn't exist.

---

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
      x Column `missing_col` doesn't exist.

