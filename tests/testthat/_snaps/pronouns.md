# using dollar sign works

    Code
      mutate(test, foo = x * .env$bar)
    Condition
      Error in `mutate()`:
      ! object 'bar' not found

---

    Code
      mutate(test, foo = x * .data$bar)
    Condition
      Error in `.data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! Column(s) not found: unable to find column "bar"; valid columns: ["x", "y", "z"]

# using [[ sign works

    Code
      mutate(test, foo = x * .env[["bar"]])
    Condition
      Error in `mutate()`:
      ! object 'bar' not found

---

    Code
      mutate(test, foo = x * .data[["bar"]])
    Condition
      Error in `.data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! Column(s) not found: unable to find column "bar"; valid columns: ["x", "y", "z"]

