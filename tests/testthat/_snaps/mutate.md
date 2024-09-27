# scalar value works

    Code
      mutate(pl_iris, Sepal.Width = 1:2)
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $with_columns()
         1: Encountered the following error in Rust-Polars:
            	lengths don't match: unable to add a column of length 2 to a DataFrame of height 150

---

    Code
      mutate(pl_iris, Sepal.Width = letters[1:2])
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $with_columns()
         1: Encountered the following error in Rust-Polars:
            	lengths don't match: unable to add a column of length 2 to a DataFrame of height 150

# custom function that doesn't return Polars expression

    Code
      mutate(pl_iris, x = foo(Sepal.Length, Petal.Length))
    Condition
      Error in `mutate()`:
      ! Error while running function `foo()` in Polars.
      x Non-numeric argument to mathematical function

# argument .keep works

    Code
      mutate(pl_iris, x = 1, .keep = "foo")
    Condition
      Error in `mutate()`:
      ! `.keep` must be one of "all", "used", "unused", or "none", not "foo".

