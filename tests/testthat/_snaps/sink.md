# can only be used on a lazyframe

    Code
      sink_csv(mtcars)
    Condition
      Error in `sink_csv()`:
      ! `sink_csv()` can only be used on a Polars LazyFrame.

---

    Code
      sink_parquet(mtcars)
    Condition
      Error in `sink_parquet()`:
      ! `sink_parquet()` can only be used on a Polars LazyFrame.

---

    Code
      sink_ndjson(mtcars)
    Condition
      Error in `sink_ndjson()`:
      ! `sink_ndjson()` can only be used on a Polars LazyFrame.

---

    Code
      sink_ipc(mtcars)
    Condition
      Error in `sink_ipc()`:
      ! `sink_ipc()` can only be used on a Polars LazyFrame.

# deprecated args in sink_csv()

    Code
      x <- sink_csv(dat, dest, null_values = "a")
    Condition
      Warning:
      The `null_values` argument of `sink_csv_polars()` is deprecated as of tidypolars 0.14.0.
      i Use `null_value` instead.

---

    Code
      x <- sink_csv(dat, dest, quote = "a")
    Condition
      Warning:
      The `quote` argument of `sink_csv_polars()` is deprecated as of tidypolars 0.14.0.
      i Use `quote_char` instead.

