# can't collect non-LazyFrame object

    Code
      compute(pl_iris)
    Condition
      Error in `UseMethod()`:
      ! no applicable method for 'compute' applied to an object of class "RPolarsDataFrame"

# error on unknown args

    Code
      compute(pl_iris, foo = TRUE)
    Condition
      Error in `compute()`:
      ! `...` must be empty.
      x Problematic argument:
      * foo = TRUE

