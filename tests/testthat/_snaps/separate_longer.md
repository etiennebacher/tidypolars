# errors on non-polars data

    Code
      separate_longer_delim_polars(df, x, delim = ",")
    Condition
      Error in `separate_longer_delim_polars()`:
      ! The data must be a Polars DataFrame or LazyFrame.

---

    Code
      separate_longer_position_polars(df, x, width = 2)
    Condition
      Error in `separate_longer_position_polars()`:
      ! The data must be a Polars DataFrame or LazyFrame.

# errors on non-existent column

    Code
      separate_longer_delim_polars(df, nonexistent, delim = ",")
    Condition
      Error in `separate_longer_delim_polars()`:
      ! Can't select columns that don't exist.
      x Column `nonexistent` doesn't exist.

---

    Code
      separate_longer_position_polars(df, nonexistent, width = 2)
    Condition
      Error in `separate_longer_position_polars()`:
      ! Can't select columns that don't exist.
      x Column `nonexistent` doesn't exist.

# errors when cols is missing

    Code
      separate_longer_delim_polars(df, delim = ",")
    Condition
      Error in `separate_longer_delim_polars()`:
      ! `cols` is absent but must be supplied.

---

    Code
      separate_longer_position_polars(df, width = 2)
    Condition
      Error in `separate_longer_position_polars()`:
      ! `cols` is absent but must be supplied.

# errors when delim is missing

    Code
      separate_longer_delim_polars(df, x)
    Condition
      Error in `separate_longer_delim_polars()`:
      ! `delim` must be a single string, not absent.

# errors when width is missing

    Code
      separate_longer_position_polars(df, x)
    Condition
      Error in `separate_longer_position_polars()`:
      ! `width` must be a whole number, not absent.

# errors when width is invalid

    Code
      separate_longer_position_polars(df, x, width = 0)
    Condition
      Error in `separate_longer_position_polars()`:
      ! `width` must be a whole number larger than or equal to 1, not the number 0.

---

    Code
      separate_longer_position_polars(df, x, width = -1)
    Condition
      Error in `separate_longer_position_polars()`:
      ! `width` must be a whole number larger than or equal to 1, not the number -1.

---

    Code
      separate_longer_position_polars(df, x, width = 1.5)
    Condition
      Error in `separate_longer_position_polars()`:
      ! `width` must be a whole number, not the number 1.5.

# errors when ... is not empty

    Code
      separate_longer_delim_polars(df, x, delim = ",", extra = TRUE)
    Condition
      Error in `separate_longer_delim_polars()`:
      ! `...` must be empty.
      x Problematic argument:
      * extra = TRUE

---

    Code
      separate_longer_position_polars(df, x, width = 2, extra = TRUE)
    Condition
      Error in `separate_longer_position_polars()`:
      ! `...` must be empty.
      x Problematic argument:
      * extra = TRUE

