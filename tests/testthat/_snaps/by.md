# .by doesn't work on already grouped data

    Code
      mutate(group_by(as_polars_df(iris), Species), foo = 1, .by = Species)
    Condition
      Error in `mutate()`:
      ! Can't supply `.by` when `.data` is a grouped DataFrame or LazyFrame.

