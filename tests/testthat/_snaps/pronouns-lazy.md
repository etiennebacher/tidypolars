# using dollar sign works

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! object 'bar' not found

---

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	not found: bar: 'with_columns' failed

# using [[ sign works

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! object 'bar' not found

---

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	not found: bar: 'with_columns' failed

