# error if original values and replacement have no supertype

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! Invalid operation: conversion from `str` to `f64` failed in column 'literal' for 1 out of 1 values: ["a"]

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! Invalid operation: conversion from `str` to `f64` failed in column 'literal' for 1 out of 1 values: ["unknown"]

