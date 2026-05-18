# scalar value works

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! lengths don't match: unable to add a column of length 2 to a DataFrame of height 150

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! lengths don't match: unable to add a column of length 2 to a DataFrame of height 150

# custom function that doesn't return Polars expression

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `foo()` in Polars.
      x non-numeric argument to mathematical function

# argument .keep works

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! `.keep` must be one of "all", "used", "unused", or "none", not "foo".

# arguments .before and .after error consistently

    Code
      current$collect()
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `missing_col` doesn't exist.

---

    Code
      current$collect()
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `missing_col` doesn't exist.

---

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
      x Column `missing_col` doesn't exist.

