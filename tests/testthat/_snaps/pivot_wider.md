# names_prefix works

    Code
      pivot_wider(test_pl, names_from = station, values_from = seen, names_prefix = c(
        "foo1", "foo2"))
    Condition
      Error in `pivot_wider()`:
      ! `names_prefix` must be a single string or `NULL`, not a character vector.

# error when overwriting existing column

    Code
      pivot_wider(test_pl, names_from = key, values_from = val)
    Condition
      Error in `data$pivot()`:
      ! Evaluation failed in `$pivot()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! Duplicated column(s): could not create a new DataFrame: column with name 'a' has more than one occurrence

# `names_from` must be supplied if `name` isn't in data

    Code
      pivot_wider(test_pl, values_from = val)
    Condition
      Error in `pivot_wider()`:
      ! Can't select columns that don't exist.
      x Column `name` doesn't exist.

# `values_from` must be supplied if `value` isn't in data

    Code
      pivot_wider(test_pl, names_from = key)
    Condition
      Error in `pivot_wider()`:
      ! Can't select columns that don't exist.
      x Column `value` doesn't exist.

# `names_from` must identify at least 1 column

    Code
      pivot_wider(test_pl, names_from = starts_with("foo"), values_from = val)
    Condition
      Error in `pivot_wider()`:
      ! Must select at least one variable in `names_from`.

# `values_from` must identify at least 1 column

    Code
      pivot_wider(test_pl, names_from = key, values_from = starts_with("foo"))
    Condition
      Error in `pivot_wider()`:
      ! Must select at least one variable in `values_from`.

# `id_cols` can't select columns from `names_from` or `values_from`

    Code
      pivot_wider(test_pl, id_cols = name, names_from = name, values_from = value)
    Condition
      Error in `data$pivot()`:
      ! Evaluation failed in `$pivot()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! at least one key is required in a group_by operation

---

    Code
      pivot_wider(test_pl, id_cols = value, names_from = name, values_from = value)
    Condition
      Error in `data$pivot()`:
      ! Evaluation failed in `$pivot()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! at least one key is required in a group_by operation

# dots must be empty

    Code
      pivot_wider(test_pl, names_from = station, values_from = seen, foo = TRUE)
    Condition
      Error in `pivot_wider()`:
      ! `...` must be empty.

