# scalar value works

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	lengths don't match: unable to add a column of length 2 to a DataFrame of height 150

---

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	lengths don't match: unable to add a column of length 2 to a DataFrame of height 150

# custom function that doesn't return Polars expression

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `foo()` in Polars.
      x Non-numeric argument to mathematical function

# argument .keep works

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! `.keep` must be one of "all", "used", "unused", or "none", not "foo".

