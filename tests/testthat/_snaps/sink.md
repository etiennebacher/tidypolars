# can only be used on a lazyframe

    Code
      sink_csv(mtcars)
    Condition
      Error in `sink_csv()`:
      ! `sink_csv()` can only be used on a LazyFrame.

---

    Code
      sink_parquet(mtcars)
    Condition
      Error in `sink_parquet()`:
      ! `sink_parquet()` can only be used on a LazyFrame.

