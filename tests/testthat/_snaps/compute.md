# can't collect non-LazyFrame object

    Code
      compute(test_pl)
    Condition
      Error in `UseMethod()`:
      ! no applicable method for 'compute' applied to an object of class "c('polars_data_frame', 'polars_object')"

# error on unknown args

    Code
      compute(test_pl, foo = TRUE)
    Condition
      Error in `compute()`:
      ! `...` must be empty.
      x Problematic argument:
      * foo = TRUE

