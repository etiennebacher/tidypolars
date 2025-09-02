# count() doesn't support named expressions, #233

    Code
      count(as_polars_df(iris), is_present = !is.na(Sepal.Length))
    Condition
      Error in `count()`:
      ! tidypolars doesn't support named expressions in `count()`.

