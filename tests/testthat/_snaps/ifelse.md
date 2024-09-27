# error when different types

    Code
      mutate(test, y = ifelse(x1 == 1, "foo", "bar"))
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $with_columns()
         1: Encountered the following error in Rust-Polars:
            	cannot compare string with numeric type (f64)

---

    Code
      mutate(test, y = if_else(x1 == 1, "foo", "bar"))
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $with_columns()
         1: Encountered the following error in Rust-Polars:
            	cannot compare string with numeric type (f64)

