# Arg `.drop` is not supported in group_by()

    Code
      group_by(as_polars_df(iris), Species, .drop = FALSE)
    Condition
      Error in `group_by()`:
      ! tidypolars doesn't support `.drop = FALSE` in `group_by()`.

# group_by() doesn't support named expressions, #233

    Code
      count(group_by(as_polars_df(iris), is_present = !is.na(Sepal.Length)))
    Condition
      Error in `group_by()`:
      ! tidypolars doesn't support named expressions in `group_by()`.

