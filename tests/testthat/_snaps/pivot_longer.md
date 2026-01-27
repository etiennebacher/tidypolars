# argument names_prefix works

    Code
      pivot_longer(test_pl, cols = starts_with("wk"), names_to = "week",
      names_prefix = c("wk", "foo"))
    Condition
      Error in `pivot_longer()`:
      ! `names_prefix` must be a single string or `NULL`, not a character vector.

# dots must be empty

    Code
      pivot_longer(test_pl, foo = TRUE)
    Condition
      Error in `pivot_longer()`:
      ! `...` must be empty.
      Error in `pivot_longer()`:
      ! Arguments in `...` must be used.
      x Problematic argument:
      * foo = TRUE
      i Did you misspell an argument name?

