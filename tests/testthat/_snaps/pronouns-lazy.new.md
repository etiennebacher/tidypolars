# using dollar sign works

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! object 'bar' not found

---

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	not found: bar
      
            Resolved plan until failure:
      
            	---> FAILED HERE RESOLVING 'with_columns' <---
            DF ["x", "y", "z"]; PROJECT */3 COLUMNS; SELECTION: None

# using [[ sign works

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! object 'bar' not found

---

    Code
      current$collect()
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         1: Encountered the following error in Rust-Polars:
            	not found: bar
      
            Resolved plan until failure:
      
            	---> FAILED HERE RESOLVING 'with_columns' <---
            DF ["x", "y", "z"]; PROJECT */3 COLUMNS; SELECTION: None

