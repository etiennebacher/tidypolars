# only works on polars dataframe

    Code
      write_csv_polars(mtcars)
    Condition
      Error in `write_csv_polars()`:
      ! `write_csv_polars()` can only be used on a DataFrame.

---

    Code
      write_ipc_polars(mtcars)
    Condition
      Error in `write_ipc_polars()`:
      ! `write_ipc_polars()` can only be used on a DataFrame.

---

    Code
      write_json_polars(mtcars)
    Condition
      Error in `write_json_polars()`:
      ! `write_json_polars()` can only be used on a DataFrame.

---

    Code
      write_ndjson_polars(mtcars)
    Condition
      Error in `write_ndjson_polars()`:
      ! `write_ndjson_polars()` can only be used on a DataFrame.

---

    Code
      write_parquet_polars(mtcars)
    Condition
      Error in `write_parquet_polars()`:
      ! `write_parquet_polars()` can only be used on a DataFrame.

# deprecated args in write_csv_polars()

    Code
      x <- write_csv_polars(dat, dest, null_value = "a")

---

    Code
      x <- write_csv_polars(dat, dest, quote = "a")
    Condition
      Warning:
      The `quote` argument of `write_csv_polars()` is deprecated as of tidypolars 0.14.0.
      i Use `quote_char` instead.

# deprecated args in write_ipc_polars()

    Code
      x <- write_ipc_polars(dat, dest, future = TRUE)
    Condition
      Warning:
      The `future` argument of `write_ipc_polars()` is deprecated as of tidypolars 0.14.0.
      i Use `compat_level` instead.

