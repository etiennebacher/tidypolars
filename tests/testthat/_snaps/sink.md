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

