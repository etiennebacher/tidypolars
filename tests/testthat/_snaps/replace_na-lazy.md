# error if original values and replacement have no supertype

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! conversion from `str` to `f64` failed in column 'literal' for 1 out of 1 values: ["a"]

---

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! conversion from `str` to `f64` failed in column 'literal' for 1 out of 1 values: ["unknown"]

