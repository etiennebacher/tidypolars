# sep must be a valid regex

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! invalid regex pattern in str.split_regex: (

# tidypolars only supports character separator

    Code
      compute(current)
    Condition
      Error in `separate()`:
      ! tidypolars only supports a character for argument `sep` in `separate()`.

