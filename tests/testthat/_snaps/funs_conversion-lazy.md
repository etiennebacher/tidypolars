# basic behavior works

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! conversion from `str` to `i32` failed in column 'char1' for 3 out of 3 values: ["a", "a", "b"]

---

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! conversion from `str` to `i32` failed in column 'char2' for 1 out of 3 values: ["3.5"]

# as.Date() works for character columns

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `as.Date()` in Polars.
      x tidypolars only supports `format` of length 1.

