# values_to errors with multiple columns without template

    Code
      collect(current)
    Condition
      Error in `unnest_longer_polars()`:
      ! `values_to` must contain `{col}` when multiple columns are selected.
      i You provided 2 columns: "a" and "b".

# indices_to errors with multiple columns without template

    Code
      collect(current)
    Condition
      Error in `unnest_longer_polars()`:
      ! `indices_to` must contain `{col}` when multiple columns are selected.
      i You provided 2 columns: "a" and "b".

# errors on non-polars data

    Code
      collect(current)
    Condition
      Error in `unnest_longer_polars()`:
      ! The data must be a Polars DataFrame or LazyFrame.

# errors on non-existent column

    Code
      collect(current)
    Condition
      Error in `unnest_longer_polars()`:
      ! Can't select columns that don't exist.
      x Column `nonexistent` doesn't exist.

# errors when column names duplicate

    Code
      collect(current)
    Condition
      Error in `unnest_longer_polars()`:
      ! Column names in the output must be unique.
      x These names are duplicated: "y".

---

    Code
      collect(current)
    Condition
      Error in `unnest_longer_polars()`:
      ! Column names in the output must be unique.
      x These names are duplicated: "z".

---

    Code
      collect(current)
    Condition
      Error in `unnest_longer_polars()`:
      ! Column names in the output must be unique.
      x These names are duplicated: "a".

---

    Code
      collect(current)
    Condition
      Error in `unnest_longer_polars()`:
      ! Column names in the output must be unique.
      x These names are duplicated: "y" and "z".

# errors when no column is provided

    Code
      collect(current)
    Condition
      Error in `unnest_longer_polars()`:
      ! `col` is absent but must be supplied.

# errors when ... is not empty

    Code
      collect(current)
    Condition
      Error in `unnest_longer_polars()`:
      ! `...` must be empty.
      x Problematic argument:
      * extra_arg = TRUE

