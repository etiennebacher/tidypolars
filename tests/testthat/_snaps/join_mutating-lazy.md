# error if no common variables and and `by` no provided

    Code
      current$collect()
    Condition
      Error in `left_join()`:
      ! `by` must be supplied when `x` and `y` have no common variables.
      i Use `cross_join()` to perform a cross-join.

# argument suffix works

    Code
      current$collect()
    Condition
      Error in `left_join()`:
      ! `suffix` must be of length 2.

# suffix + join_by works

    Code
      current$collect()
    Condition
      Error in `left_join()`:
      ! `suffix` must be of length 2.

# argument relationship works

    Code
      current$collect()
    Condition
      Error in `left_join()`:
      ! `x` and `y` must be either two DataFrames or two LazyFrames.

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill 1:1 validation

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill m:1 validation

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill 1:1 validation

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill m:1 validation

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill 1:1 validation

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill m:1 validation

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill 1:1 validation

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill 1:m validation

# argument na_matches works

    Code
      current$collect()
    Condition
      Error in `left_join()`:
      ! `na_matches` must be one of "na" or "never", not "foo".

# error if two inputs don't have the same class

    Code
      current$collect()
    Condition
      Error in `left_join()`:
      ! `x` and `y` must be either two DataFrames or two LazyFrames.

# unsupported args throw warning

    Code
      current$collect()
    Condition
      Error in `left_join()`:
      ! Argument `keep` is not supported by tidypolars.
      i Use `options(tidypolars_unknown_args = "warn")` to warn when this happens instead of throwing an error.

# dots must be empty

    Code
      current$collect()
    Condition
      Error in `left_join()`:
      ! `...` must be empty.
      x Problematic argument:
      * foo = TRUE

---

    Code
      current$collect()
    Condition
      Warning in `left_join()`:
      Argument `copy` is not supported by tidypolars.
      Error in `left_join()`:
      ! `...` must be empty.
      x Problematic argument:
      * foo = TRUE

