# can't overwrite existing column

    Code
      current$collect()
    Condition
      Error in `make_unique_id()`:
      ! Column "hash" already exists. Use a new name with the argument `new_col`.

---

    Code
      current$collect()
    Condition
      Error in `make_unique_id()`:
      ! The data must be a Polars DataFrame or LazyFrame.

