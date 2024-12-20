# argument names_prefix works

    Code
      pivot_longer(pl_billboard, cols = starts_with("wk"), names_to = "week",
      names_prefix = c("wk", "foo"), )
    Condition
      Error in `pivot_longer()`:
      ! `names_prefix` must be of length 1.

# dots must be empty

    Code
      pivot_longer(pl_billboard, foo = TRUE, cols_vary = "fastest")
    Condition
      Warning in `pivot_longer()`:
      Argument `cols_vary` is not supported by tidypolars.
      Error in `pivot_longer()`:
      ! `...` must be empty.
      Error in `pivot_longer()`:
      ! Arguments in `...` must be used.
      x Problematic argument:
      * foo = TRUE
      i Did you misspell an argument name?

