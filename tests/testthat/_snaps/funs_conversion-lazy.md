# basic behavior works

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! conversion from `str` to `i32` failed in column 'char1' for 3 out of 3 values: ["a", "a", "b"]

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! conversion from `str` to `i32` failed in column 'char2' for 1 out of 3 values: ["3.5"]

# as.Date() works for character columns

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `as.Date()` in Polars.
      x tidypolars only supports `format` of length 1.

