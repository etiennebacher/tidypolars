# error if original values and replacement have no supertype

    Code
      replace_na(pl_test, "a")
    Condition
      Error in `replace_na()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error in `data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! Invalid operation: conversion from `str` to `f64` failed in column 'literal' for 1 out of 1 values: ["a"]

---

    Code
      replace_na(pl_test, list(x = 1, y = "unknown"))
    Condition
      Error in `replace_na()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error in `data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! Invalid operation: conversion from `str` to `f64` failed in column 'literal' for 1 out of 1 values: ["unknown"]

