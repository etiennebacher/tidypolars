# Polars runtime errors only show the root message

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! Column(s) not found: "nonexist" not found
      
      Resolved plan until failure:
      
      	---> FAILED HERE RESOLVING THIS_NODE <---
      DF ["x"]; PROJECT */1 COLUMNS

