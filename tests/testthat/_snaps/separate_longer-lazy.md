# errors on non-polars data

    Code
      current$collect()
    Condition
      Error in `separate_longer_delim_polars()`:
      ! The data must be a Polars DataFrame or LazyFrame.

---

    Code
      current$collect()
    Condition
      Error in `separate_longer_position_polars()`:
      ! The data must be a Polars DataFrame or LazyFrame.

# errors on non-existent column

    Code
      current$collect()
    Condition
      Error in `separate_longer_delim_polars()`:
      ! Can't select columns that don't exist.
      x Column `nonexistent` doesn't exist.

---

    Code
      current$collect()
    Condition
      Error in `separate_longer_position_polars()`:
      ! Can't select columns that don't exist.
      x Column `nonexistent` doesn't exist.

# errors when cols is missing

    Code
      current$collect()
    Condition
      Error in `separate_longer_delim_polars()`:
      ! `cols` is absent but must be supplied.

---

    Code
      current$collect()
    Condition
      Error in `separate_longer_position_polars()`:
      ! `cols` is absent but must be supplied.

# errors when delim is missing

    Code
      current$collect()
    Condition
      Error in `separate_longer_delim_polars()`:
      ! `delim` must be a single string, not absent.

# errors when width is missing

    Code
      current$collect()
    Condition
      Error in `separate_longer_position_polars()`:
      ! `width` must be a whole number, not absent.

# errors when width is invalid

    Code
      current$collect()
    Condition
      Error in `separate_longer_position_polars()`:
      ! `width` must be a whole number larger than or equal to 1, not the number 0.

---

    Code
      current$collect()
    Condition
      Error in `separate_longer_position_polars()`:
      ! `width` must be a whole number, not the number 1.5.

# errors when ... is not empty

    Code
      current$collect()
    Condition
      Error in `separate_longer_delim_polars()`:
      ! `...` must be empty.
      x Problematic argument:
      * extra = TRUE

---

    Code
      current$collect()
    Condition
      Error in `separate_longer_position_polars()`:
      ! `...` must be empty.
      x Problematic argument:
      * extra = TRUE

# separate_longer_delim_polars errors on incompatible lengths

    Code
      current$collect()
    Condition
      Error in `handle_multi_column_explode()`:
      ! Can't recycle input of size 2 to size 3.

# separate_longer_position_polars errors on incompatible lengths

    Code
      current$collect()
    Condition
      Error in `handle_multi_column_explode()`:
      ! Can't recycle input of size 2 to size 4.

