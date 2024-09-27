# error if original values and replacement have no supertype

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	conversion from `str` to `i32` failed in column 'literal' for 1 out of 1 values: ["a"]

---

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	conversion from `str` to `i32` failed in column 'literal' for 1 out of 1 values: ["unknown"]

