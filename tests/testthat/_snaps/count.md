# group_by() doesn't support named expressions, #233

    Code
      count(group_by(as_polars_df(iris), is_present = !is.na(Sepal.Length)))
    Condition
      Error in `group_by()`:
      ! tidypolars doesn't support named expressions in `group_by()`.

