# unique() works

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! lengths don't match: unable to add a column of length 4 to a DataFrame of height 5

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

