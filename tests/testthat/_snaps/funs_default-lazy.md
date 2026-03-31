# unique() works

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! lengths don't match: unable to add a column of length 4 to a DataFrame of height 5

# trunc() works

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! truncation ('to_zero') can only be used on numeric types

# trunc() in tidypolars doesn't support Date/datetime

    Code
      current$collect()
    Condition
      Warning:
      tidypolars doesn't know how to use some arguments of `trunc()`.
      i The following argument(s) will be ignored: "units".
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! truncation ('to_zero') can only be used on numeric types

---

    Code
      current$collect()
    Condition
      Warning:
      tidypolars doesn't know how to use some arguments of `trunc()`.
      i The following argument(s) will be ignored: "units".
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! truncation ('to_zero') can only be used on numeric types

# sample() validates size

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `sample()` in Polars.
      x `size` must be a positive integer.

# seq_len() works

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `seq_len()` in Polars.
      x `length.out` must be a non-negative integer.

# anyNA() works

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `anyNA()` in Polars.
      x Argument `recursive` is not supported by tidypolars.

