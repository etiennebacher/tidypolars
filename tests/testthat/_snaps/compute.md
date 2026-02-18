# deprecated arguments in compute()

    Code
      x <- compute(test_pl, streaming = TRUE)
    Condition
      Warning:
      The `streaming` argument of `compute()` is deprecated as of tidypolars 0.14.0.
      i Use `engine = "streaming"` for the new streaming mode.
      i Use `engine = "in-memory"` for non-streaming mode.

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

