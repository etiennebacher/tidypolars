# scalar value works

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! lengths don't match: can't broadcast Series 'Sepal.Width' of length 2 to length 150

---

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! lengths don't match: can't broadcast Series 'Sepal.Width' of length 2 to length 150

# custom function that doesn't return Polars expression

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `foo()` in Polars.
      x non-numeric argument to mathematical function

# argument .keep works

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! `.keep` must be one of "all", "used", "unused", or "none", not "foo".

# arguments .before and .after error consistently

    Code
      compute(current)
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `missing_col` doesn't exist.

---

    Code
      compute(current)
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `missing_col` doesn't exist.

---

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
      x Column `missing_col` doesn't exist.

