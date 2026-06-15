# basic behavior works

    Code
      mutate(test_pl, char1 = as.integer(char1))
    Condition
      Error in `.data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! conversion from `str` to `i32` failed in column 'char1' for 3 out of 3 values: ["a", "a", "b"]

---

    Code
      mutate(test_pl, char2 = as.integer(char2))
    Condition
      Error in `.data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! conversion from `str` to `i32` failed in column 'char2' for 1 out of 3 values: ["3.5"]

# as.Date() works for character columns

    Code
      mutate(test_pl, a = as.Date(a, format = c("%Y-%m-%d", "%Y-%m-%d", "%Y-%m-%d")))
    Condition
      Error in `mutate()`:
      ! Error while running function `as.Date()` in Polars.
      x tidypolars only supports `format` of length 1.

