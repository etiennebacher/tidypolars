# error when different types

    Code
      mutate(test_pl, y = ifelse(x1 == 1, "foo", "bar"))
    Condition
      Error in `.data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! cannot compare string with numeric type (f64)

---

    Code
      mutate(test_pl, y = if_else(x1 == 1, "foo", "bar"))
    Condition
      Error in `.data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! cannot compare string with numeric type (f64)

