# names_prefix works

    Code
      current$collect()
    Condition
      Error in `pivot_wider()`:
      ! `names_prefix` must be a single string or `NULL`, not a character vector.

# error when overwriting existing column

    Code
      current$collect()
    Condition
      Error in `pivot_wider()`:
      ! This operation would generate column name(s) that already exist: a.

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! Duplicated column(s): column 'a_c' is duplicate
      
      Resolved plan until failure:
      
      	---> FAILED HERE RESOLVING 'sink' <---
      AGGREGATE[maintain_order: false]
        [col("val").filter([(col("key")) == ("a")].all_horizontal([[(col("key_2")) == ("c")]])).item(allow_empty=true).alias("{"a","c"}"), col("val").filter([(col("key")) == ("b")].all_horizontal([[(col("key_2")) == ("d")]])).item(allow_empty=true).alias("{"b","d"}")] BY [col("a_c")]
        FROM
        DF ["a_c", "key", "key_2", "val"]; PROJECT */4 COLUMNS

# `names_from` must be supplied if `name` isn't in data

    Code
      current$collect()
    Condition
      Error in `pivot_wider()`:
      ! Can't select columns that don't exist.
      x Column `name` doesn't exist.

# `values_from` must be supplied if `value` isn't in data

    Code
      current$collect()
    Condition
      Error in `pivot_wider()`:
      ! Can't select columns that don't exist.
      x Column `value` doesn't exist.

# `names_from` must identify at least 1 column

    Code
      current$collect()
    Condition
      Error in `pivot_wider()`:
      ! Must select at least one variable in `names_from`.

# `values_from` must identify at least 1 column

    Code
      current$collect()
    Condition
      Error in `pivot_wider()`:
      ! Must select at least one variable in `values_from`.

# `id_cols` can't select columns from `names_from` or `values_from`

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! at least one key is required in a group_by operation

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! at least one key is required in a group_by operation

# dots must be empty

    Code
      current$collect()
    Condition
      Error in `pivot_wider()`:
      ! `...` must be empty.

