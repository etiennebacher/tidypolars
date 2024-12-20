# can't collect non-LazyFrame object

    Code
      collect(pl_iris)
    Condition
      Error in `UseMethod()`:
      ! no applicable method for 'collect' applied to an object of class "RPolarsDataFrame"

# error on unknown args

    Code
      collect(pl_iris, foo = TRUE)
    Condition
      Error in `collect()`:
      ! `...` must be empty.
      x Problematic argument:
      * foo = TRUE

