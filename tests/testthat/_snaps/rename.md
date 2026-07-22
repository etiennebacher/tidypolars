# Polars runtime errors only show the root message

    Code
      rename(test_pl, y = nonexist)
    Condition
      Error in `rename()`:
      ! Column(s) not found: "nonexist" not found

