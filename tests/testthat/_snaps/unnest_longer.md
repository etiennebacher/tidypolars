# values_to errors with multiple columns without template

    Code
      unnest_longer_polars(test_pl, c(a, b), values_to = "val")
    Condition
      Error in `unnest_longer_polars()`:
      ! `values_to` must contain `{col}` when multiple columns are selected.
      i You provided 2 columns: "a" and "b".

# indices_to errors with multiple columns without template

    Code
      unnest_longer_polars(test_pl, c(a, b), indices_to = "idx")
    Condition
      Error in `unnest_longer_polars()`:
      ! `indices_to` must contain `{col}` when multiple columns are selected.
      i You provided 2 columns: "a" and "b".

# errors on non-polars data

    Code
      unnest_longer_polars(test, values)
    Condition
      Error in `unnest_longer_polars()`:
      ! The data must be a Polars DataFrame or LazyFrame.

# errors on non-existent column

    Code
      unnest_longer_polars(test_pl, nonexistent)
    Condition
      Error in `unnest_longer_polars()`:
      ! Can't select columns that don't exist.
      x Column `nonexistent` doesn't exist.

# errors when column names duplicate

    Code
      unnest_longer_polars(test_pl, y, indices_to = "y")
    Condition
      Error in `unnest_longer_polars()`:
      ! Column names in the output must be unique.
      x These names are duplicated: "y".

---

    Code
      unnest_longer_polars(test_pl, y, values_to = "z")
    Condition
      Error in `unnest_longer_polars()`:
      ! Column names in the output must be unique.
      x These names are duplicated: "z".

---

    Code
      unnest_longer_polars(test_pl, y, indices_to = "a", values_to = "a")
    Condition
      Error in `unnest_longer_polars()`:
      ! Column names in the output must be unique.
      x These names are duplicated: "a".

---

    Code
      unnest_longer_polars(test_pl, c(y, z), values_to = "{col}", indices_to = "{col}")
    Condition
      Error in `unnest_longer_polars()`:
      ! Column names in the output must be unique.
      x These names are duplicated: "y" and "z".

# errors when no column is provided

    Code
      unnest_longer_polars(test_pl)
    Condition
      Error in `unnest_longer_polars()`:
      ! `col` is absent but must be supplied.

# errors when ... is not empty

    Code
      unnest_longer_polars(test_pl, values, extra_arg = TRUE)
    Condition
      Error in `unnest_longer_polars()`:
      ! `...` must be empty.
      x Problematic argument:
      * extra_arg = TRUE

