# argument names_prefix works

    Code
      collect(current)
    Condition
      Error in `pivot_longer()`:
      ! `names_prefix` must be a single string or `NULL`, not a character vector.

# dots must be empty

    Code
      collect(current)
    Condition
      Error in `pivot_longer()`:
      ! `...` must be empty.
      Error in `pivot_longer()`:
      ! Arguments in `...` must be used.
      x Problematic argument:
      * foo = TRUE
      i Did you misspell an argument name?

