# using dollar sign works

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! object 'bar' not found

---

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! not found: unable to find column "bar"; valid columns: ["x", "y", "z"]
      Resolved plan until failure:
      ---> FAILED HERE RESOLVING 'with_columns' <---
      DF ["x", "y", "z"]; PROJECT */3 COLUMNS
      This error occurred with the following context stack:
      [1] 'with_columns'

# using [[ sign works

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! object 'bar' not found

---

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! not found: unable to find column "bar"; valid columns: ["x", "y", "z"]
      Resolved plan until failure:
      ---> FAILED HERE RESOLVING 'with_columns' <---
      DF ["x", "y", "z"]; PROJECT */3 COLUMNS
      This error occurred with the following context stack:
      [1] 'with_columns'

