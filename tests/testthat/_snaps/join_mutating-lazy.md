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
      ! `relationship` must be one of "one-to-one", "one-to-many", "many-to-one", or "many-to-many", not "foo".

---

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	join keys did not fulfill 1:1 validation

---

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	join keys did not fulfill m:1 validation

---

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	join keys did not fulfill 1:1 validation

---

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	join keys did not fulfill m:1 validation

---

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	join keys did not fulfill 1:1 validation

---

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	join keys did not fulfill m:1 validation

---

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	join keys did not fulfill 1:1 validation

---

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	join keys did not fulfill 1:m validation

# argument na_matches works

    Code
      current$collect()
    Condition
      Error in `left_join()`:
      ! `relationship` must be one of "na" or "never", not "foo".

# error if two inputs don't have the same class

    Code
      current$collect()
    Condition
      Error in `left_join()`:
      ! `x` and `y` must be either two DataFrames or two LazyFrames.

