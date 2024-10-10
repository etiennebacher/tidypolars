# can't overwrite existing column

    Code
      make_unique_id(test2, am, gear)
    Condition
      Error in `make_unique_id()`:
      ! Column "hash" already exists. Use a new name with the argument `new_col`.

---

    Code
      make_unique_id(mtcars)
    Condition
      Error in `make_unique_id()`:
      ! The data must be a Polars DataFrame or LazyFrame.

