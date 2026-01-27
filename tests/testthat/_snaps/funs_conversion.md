# as.Date() works for character columns

    Code
      mutate(test_pl, a = as.Date(a, format = c("%Y-%m-%d", "%Y-%m-%d", "%Y-%m-%d")))
    Condition
      Error in `mutate()`:
      ! Error while running function `as.Date()` in Polars.
      x tidypolars only supports `format` of length 1.

