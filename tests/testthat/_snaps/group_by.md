# Arg `.drop` is not supported in group_by()

    Code
      group_by(as_polars_df(iris), Species, .drop = FALSE)
    Condition
      Error in `group_by()`:
      ! tidypolars doesn't support `.drop = FALSE` in `group_by()`.

