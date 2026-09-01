# errors on non-polars data

    Code
      collect(current)
    Condition
      Error in `separate_longer_delim_polars()`:
      ! The data must be a Polars DataFrame or LazyFrame.

---

    Code
      collect(current)
    Condition
      Error in `separate_longer_position_polars()`:
      ! The data must be a Polars DataFrame or LazyFrame.

# errors on non-existent column

    Code
      collect(current)
    Condition
      Error in `separate_longer_delim_polars()`:
      ! Can't select columns that don't exist.
      x Column `nonexistent` doesn't exist.

---

    Code
      collect(current)
    Condition
      Error in `separate_longer_position_polars()`:
      ! Can't select columns that don't exist.
      x Column `nonexistent` doesn't exist.

# errors when cols is missing

    Code
      collect(current)
    Condition
      Error in `separate_longer_delim_polars()`:
      ! `cols` is absent but must be supplied.

---

    Code
      collect(current)
    Condition
      Error in `separate_longer_position_polars()`:
      ! `cols` is absent but must be supplied.

# errors when delim is missing

    Code
      collect(current)
    Condition
      Error in `separate_longer_delim_polars()`:
      ! `delim` must be a single string, not absent.

# errors when width is missing

    Code
      collect(current)
    Condition
      Error in `separate_longer_position_polars()`:
      ! `width` must be a whole number, not absent.

# errors when width is invalid

    Code
      collect(current)
    Condition
      Error in `separate_longer_position_polars()`:
      ! `width` must be a whole number larger than or equal to 1, not the number 0.

---

    Code
      collect(current)
    Condition
      Error in `separate_longer_position_polars()`:
      ! `width` must be a whole number, not the number 1.5.

# errors when ... is not empty

    Code
      collect(current)
    Condition
      Error in `separate_longer_delim_polars()`:
      ! `...` must be empty.
      x Problematic argument:
      * extra = TRUE

---

    Code
      collect(current)
    Condition
      Error in `separate_longer_position_polars()`:
      ! `...` must be empty.
      x Problematic argument:
      * extra = TRUE

# separate_longer_delim_polars errors on incompatible lengths

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! lengths don't match: exploded columns must have matching element counts

# separate_longer_position_polars errors on incompatible lengths

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! lengths don't match: exploded columns must have matching element counts

