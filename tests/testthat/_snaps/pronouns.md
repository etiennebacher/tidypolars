# using dollar sign works

    Code
      mutate(test, foo = x * .env$bar)
    Condition
      Error in `mutate()`:
      ! object 'bar' not found

---

    Code
      mutate(test, foo = x * .data$bar)
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $with_columns()
         1: Encountered the following error in Rust-Polars:
            	not found: bar: 'with_columns' failed

# using [[ sign works

    Code
      mutate(test, foo = x * .env[["bar"]])
    Condition
      Error in `mutate()`:
      ! object 'bar' not found

---

    Code
      mutate(test, foo = x * .data[["bar"]])
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $with_columns()
         1: Encountered the following error in Rust-Polars:
            	not found: bar: 'with_columns' failed

