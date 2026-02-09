# sep must be a valid regex

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! invalid regex pattern in str.split_regex: (

# tidypolars only supports character separator

    Code
      current$collect()
    Condition
      Error in `separate()`:
      ! tidypolars only supports a character for argument `sep` in `separate()`.

