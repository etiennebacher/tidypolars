# sep must be a valid regex

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! invalid regex pattern in str.split_regex: (

# tidypolars only supports character separator

    Code
      collect(current)
    Condition
      Error in `separate()`:
      ! tidypolars only supports a character for argument `sep` in `separate()`.

