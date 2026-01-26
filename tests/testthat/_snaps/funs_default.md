# unique() works

    Code
      mutate(test_pl, foo = unique(y))
    Condition
      Error in `.data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! lengths don't match: unable to add a column of length 4 to a DataFrame of height 5

# seq_len() works

    Code
      mutate(test_pl, y = seq_len(-1))
    Condition
      Error in `mutate()`:
      ! Error while running function `seq_len()` in Polars.
      x `length.out` must be a non-negative integer.

