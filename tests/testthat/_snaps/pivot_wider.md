# names_prefix works

    Code
      pivot_wider(pl_fish_encounters, names_from = station, values_from = seen,
        names_prefix = c("foo1", "foo2"))
    Condition
      Error in `pivot_wider()`:
      ! `names_prefix` must be of length 1.

# error when overwriting existing column

    Code
      pivot_wider(df, names_from = key, values_from = val)
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $pivot():
         1: Encountered the following error in Rust-Polars:
            	duplicate: column with name 'a' has more than one occurrences

# `names_from` must be supplied if `name` isn't in data

    Code
      pivot_wider(df, values_from = val)
    Condition
      Error in `pivot_wider()`:
      ! Can't select columns that don't exist.
      x Column `name` doesn't exist.

# `values_from` must be supplied if `value` isn't in data

    Code
      pivot_wider(df, names_from = key)
    Condition
      Error in `pivot_wider()`:
      ! Can't select columns that don't exist.
      x Column `value` doesn't exist.

# `names_from` must identify at least 1 column

    Code
      pivot_wider(df, names_from = starts_with("foo"), values_from = val)
    Condition
      Error in `pivot_wider()`:
      ! Must select at least one variable in `names_from`.

# `values_from` must identify at least 1 column

    Code
      pivot_wider(df, names_from = key, values_from = starts_with("foo"))
    Condition
      Error in `pivot_wider()`:
      ! Must select at least one variable in `values_from`.

# `id_cols` can't select columns from `names_from` or `values_from`

    Code
      pivot_wider(df, id_cols = name, names_from = name, values_from = value)
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $pivot():
         1: Encountered the following error in Rust-Polars:
            	index cannot be zero length

---

    Code
      pivot_wider(df, id_cols = value, names_from = name, values_from = value)
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $pivot():
         1: Encountered the following error in Rust-Polars:
            	index cannot be zero length

