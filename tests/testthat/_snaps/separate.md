# sep must be a valid regex

    Code
      separate(test_pl, x, into = c("foo", "foo2"), sep = "(")
    Condition
      Error in `data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! invalid regex pattern in str.split_regex: (

# tidypolars only supports character separator

    Code
      separate(test_df, x, into = c("foo", "foo2"), sep = 1)
    Condition
      Error:
      ! object 'test_df' not found

