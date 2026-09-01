# error if original values and replacement have no supertype

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! conversion from `str` to `f64` failed in column 'literal' for 1 out of 1 values: ["a"]

---

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! conversion from `str` to `f64` failed in column 'literal' for 1 out of 1 values: ["unknown"]

