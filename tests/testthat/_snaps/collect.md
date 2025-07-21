# deprecated arguments in collect()

    Code
      x <- collect(test, streaming = TRUE)
    Condition
      Warning:
      The `streaming` argument of `collect()` is deprecated as of tidypolars 0.14.0.
      i Use `engine = "streaming"` for the new streaming mode.
      i Use `engine = "in-memory"` for non-streaming mode.

# can't collect non-LazyFrame object

    Code
      collect(pl_iris)
    Condition
      Error in `UseMethod()`:
      ! no applicable method for 'collect' applied to an object of class "c('polars_data_frame', 'polars_object')"

# error on unknown args

    Code
      collect(pl_iris, foo = TRUE)
    Condition
      Error in `collect()`:
      ! `...` must be empty.
      x Problematic argument:
      * foo = TRUE

