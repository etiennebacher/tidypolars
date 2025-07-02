# error if original values and replacement have no supertype

    Code
      replace_na(pl_test, "a")
    Condition
      Error in `replace_na()`:
      ! Execution halted with the following contexts 0: In R: in $with_columns() 1: Encountered the following error in Rust-Polars: conversion from `str` to `f64` failed in column 'literal' for 1 out of 1 values: ["a"]

---

    Code
      replace_na(pl_test, list(x = 1, y = "unknown"))
    Condition
      Error in `replace_na()`:
      ! Execution halted with the following contexts 0: In R: in $with_columns() 1: Encountered the following error in Rust-Polars: conversion from `str` to `f64` failed in column 'literal' for 1 out of 1 values: ["unknown"]

