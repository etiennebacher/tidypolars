# basic behavior works

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! conversion from `str` to `i32` failed in column 'char1' for 3 out of 3 values: ["a", "a", "b"]

---

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! conversion from `str` to `i32` failed in column 'char2' for 1 out of 3 values: ["3.5"]

# as.Date() works for character columns

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `as.Date()` in Polars.
      x tidypolars only supports `format` of length 1.

