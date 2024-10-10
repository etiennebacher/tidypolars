# argument names_prefix works

    Code
      pivot_longer(pl_billboard, cols = starts_with("wk"), names_to = "week",
      names_prefix = c("wk", "foo"), )
    Condition
      Error in `pivot_longer()`:
      ! `names_prefix` must be of length 1.

