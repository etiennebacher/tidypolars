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
      ! Column(s) not found: bar
      
      Resolved plan until failure:
      
      	---> FAILED HERE RESOLVING 'sink' <---
      DF ["x", "y", "z"]; PROJECT */3 COLUMNS

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
      ! Column(s) not found: bar
      
      Resolved plan until failure:
      
      	---> FAILED HERE RESOLVING 'sink' <---
      DF ["x", "y", "z"]; PROJECT */3 COLUMNS

