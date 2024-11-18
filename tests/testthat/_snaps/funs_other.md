# n_distinct() works

    Code
      summarize(test, foo = n_distinct())
    Condition
      Error in `summarize()`:
      ! Error while running function `n_distinct()` in Polars.
      x `...` is absent, but must be supplied.

# unique() works

    Code
      mutate(test, foo = unique(y))
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $with_columns()
         1: Encountered the following error in Rust-Polars:
            	lengths don't match: unable to add a column of length 4 to a DataFrame of height 5

# nth() work

    Code
      summarize(test, foo = nth(x, 2:3))
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` must have size 1, not size 2.

---

    Code
      summarize(test, foo = nth(x, NA))
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` can't be `NA`.

---

    Code
      summarize(test, foo = nth(x, 1.5))
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` must be an integer.

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

