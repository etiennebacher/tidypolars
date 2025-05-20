# deprecated arguments in scan/read_csv_polars

    Code
      new_dat <- scan_csv_polars(dest, dtypes = list(drat = pl$Float32))
    Condition
      Warning:
      The `dtypes` argument of `pl$scan_csv()` is deprecated as of tidypolars 0.14.0.
      i Use `schema_overrides` instead.

---

    Code
      x <- scan_csv_polars(dest, reuse_downloaded = TRUE)
    Condition
      Warning:
      The `reuse_downloaded` argument of `pl$scan_csv()` is deprecated as of tidypolars 0.14.0.
      i This argument has no replacement.

---

    Code
      new_dat <- read_csv_polars(dest, dtypes = list(drat = pl$Float32))
    Condition
      Warning:
      The `dtypes` argument of `pl$scan_csv()` is deprecated as of tidypolars 0.14.0.
      i Use `schema_overrides` instead.

---

    Code
      x <- read_csv_polars(dest, reuse_downloaded = TRUE)
    Condition
      Warning:
      The `reuse_downloaded` argument of `pl$scan_csv()` is deprecated as of tidypolars 0.14.0.
      i This argument has no replacement.

