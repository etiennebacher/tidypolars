# n_distinct() works

    Code
      current$collect()
    Condition
      Error in `summarize()`:
      ! Error while running function `n_distinct()` in Polars.
      x `...` is absent, but must be supplied.

# unique() works

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	lengths don't match: unable to add a column of length 4 to a DataFrame of height 5

# nth() work

    Code
      current$collect()
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` must have size 1, not size 2.

---

    Code
      current$collect()
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` cannot be `NA`.

---

    Code
      current$collect()
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` must be an integer.

# na_if() works

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	lengths don't match: cannot evaluate two Series of different lengths (5 and 2)
      
            Error originated in expression: '[(col("x")) == (Series)]'

