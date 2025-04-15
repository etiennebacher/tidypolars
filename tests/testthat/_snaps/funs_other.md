# n_distinct() works

    Code
      summarize(test, foo = n_distinct())
    Condition
      Error in `summarize()`:
      ! Error in `n_distinct()`.
      Caused by error in `n_distinct()`:
      ! `...` is absent, but must be supplied.

# unique() works

    Code
      mutate(test, foo = unique(y))
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $with_columns()
         1: Encountered the following error in Rust-Polars:
            	lengths don't match: unable to add a column of length 4 to a DataFrame of height 5

# na_if() works

    Code
      mutate(test, foo = na_if(x, 1:2))
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $with_columns()
         1: Encountered the following error in Rust-Polars:
            	lengths don't match: cannot evaluate two Series of different lengths (5 and 2)
      
            Error originated in expression: '[(col("x")) == (Series)]'

