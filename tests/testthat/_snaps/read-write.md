# deprecated arguments in scan/read_csv_polars

    Code
      new_dat <- scan_csv_polars(dest, dtypes = list(drat = pl$Float32))
    Condition
      Warning:
      The `dtypes` argument of `scan_csv_polars()` is deprecated as of tidypolars 0.14.0.
      i Use `schema_overrides` instead.

---

    Code
      x <- scan_csv_polars(dest, reuse_downloaded = TRUE)
    Condition
      Warning:
      The `reuse_downloaded` argument of `scan_csv_polars()` is deprecated as of tidypolars 0.14.0.
      i This argument has no replacement.

---

    Code
      new_dat <- read_csv_polars(dest, dtypes = list(drat = pl$Float32))
    Condition
      Warning:
      The `dtypes` argument of `read_csv_polars()` is deprecated as of tidypolars 0.14.0.
      i Use `schema_overrides` instead.

---

    Code
      x <- read_csv_polars(dest, reuse_downloaded = TRUE)
    Condition
      Warning:
      The `reuse_downloaded` argument of `read_csv_polars()` is deprecated as of tidypolars 0.14.0.
      i This argument has no replacement.

# deprecated arguments in scan/read_ipc_polars

    Code
      new_dat <- scan_ipc_polars(dest, memory_map = TRUE)
    Condition
      Warning:
      The `memory_map` argument of `scan_ipc_polars()` is deprecated as of tidypolars 0.14.0.
      i This argument has no replacement.

---

    Code
      new_dat <- read_ipc_polars(dest, memory_map = TRUE)
    Condition
      Warning:
      The `memory_map` argument of `read_ipc_polars()` is deprecated as of tidypolars 0.14.0.
      i This argument has no replacement.

# deprecated arguments in scan/read_ndjson_polars

    Code
      new_dat <- scan_ndjson_polars(dest, reuse_downloaded = TRUE)
    Condition
      Warning:
      The `reuse_downloaded` argument of `scan_ndjson_polars()` is deprecated as of tidypolars 0.14.0.
      i This argument has no replacement.

---

    Code
      new_dat <- read_ndjson_polars(dest, reuse_downloaded = TRUE)
    Condition
      Warning:
      The `reuse_downloaded` argument of `read_ndjson_polars()` is deprecated as of tidypolars 0.14.0.
      i This argument has no replacement.

