# Arg `.drop` is not supported in group_by()

    Code
      current$collect()
    Condition
      Error in `group_by()`:
      ! tidypolars doesn't support `.drop = FALSE` in `group_by()`.

# group_by() doesn't support named expressions, #233

    Code
      current$collect()
    Condition
      Error in `group_by()`:
      ! tidypolars doesn't support named expressions in `group_by()`.

