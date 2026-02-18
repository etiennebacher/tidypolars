# values_to errors with multiple columns without template

    Code
      current$collect()
    Condition
      Error in `unnest_longer_polars()`:
      ! `values_to` must contain `{col}` when multiple columns are selected.
      i You provided 2 columns: "a" and "b".

# indices_to errors with multiple columns without template

    Code
      current$collect()
    Condition
      Error in `unnest_longer_polars()`:
      ! `indices_to` must contain `{col}` when multiple columns are selected.
      i You provided 2 columns: "a" and "b".

# errors on non-polars data

    Code
      current$collect()
    Condition
      Error in `unnest_longer_polars()`:
      ! The data must be a Polars DataFrame or LazyFrame.

# errors on non-existent column

    Code
      current$collect()
    Condition
      Error in `unnest_longer_polars()`:
      ! Can't select columns that don't exist.
      x Column `nonexistent` doesn't exist.

# errors when column names duplicate

    Code
      current$collect()
    Condition
      Error in `unnest_longer_polars()`:
      ! Column names in the output must be unique.
      x These names are duplicated: "y".

---

    Code
      current$collect()
    Condition
      Error in `unnest_longer_polars()`:
      ! Column names in the output must be unique.
      x These names are duplicated: "z".

---

    Code
      current$collect()
    Condition
      Error in `unnest_longer_polars()`:
      ! Column names in the output must be unique.
      x These names are duplicated: "a".

---

    Code
      current$collect()
    Condition
      Error in `unnest_longer_polars()`:
      ! Column names in the output must be unique.
      x These names are duplicated: "y" and "z".

# errors when no column is provided

    Code
      current$collect()
    Condition
      Error in `unnest_longer_polars()`:
      ! `col` is absent but must be supplied.

# errors when ... is not empty

    Code
      current$collect()
    Condition
      Error in `unnest_longer_polars()`:
      ! `...` must be empty.
      x Problematic argument:
      * extra_arg = TRUE

