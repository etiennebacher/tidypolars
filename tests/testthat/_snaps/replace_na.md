# error if original values and replacement have no supertype

    Code
      replace_na(test_pl, list(x = "a"))
    Condition
      Error in `replace_na()`:
      ! conversion from `str` to `f64` failed in column 'literal' for 1 out of 1 values: ["a"]

---

    Code
      replace_na(test_pl, list(x = 1, y = "unknown"))
    Condition
      Error in `replace_na()`:
      ! conversion from `str` to `f64` failed in column 'literal' for 1 out of 1 values: ["unknown"]

