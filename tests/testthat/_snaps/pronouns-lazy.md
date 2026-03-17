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
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! not found: unable to find column "bar"; valid columns: ["x", "y", "z"]
      
      Resolved plan until failure:
      
      	---> FAILED HERE RESOLVING 'with_columns' <---
      DF ["x", "y", "z"]; PROJECT */3 COLUMNS: 'with_columns'

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
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! not found: unable to find column "bar"; valid columns: ["x", "y", "z"]
      
      Resolved plan until failure:
      
      	---> FAILED HERE RESOLVING 'with_columns' <---
      DF ["x", "y", "z"]; PROJECT */3 COLUMNS: 'with_columns'

