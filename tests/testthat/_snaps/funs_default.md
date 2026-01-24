# unique() works

    Code
      mutate(test, foo = unique(y))
    Condition
      Error in `.data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! lengths don't match: unable to add a column of length 4 to a DataFrame of height 5

