# error if not all elements don't have the same class

    Code
      bind_cols_polars(l)
    Condition
      Error in `bind_cols_polars()`:
      ! All elements in `...` must be either DataFrames or LazyFrames.

# arg .name_repair works

    Code
      bind_cols_polars(l, .name_repair = "check_unique")
    Condition
      Error in `bind_cols_polars()`:
      ! Names must be unique.
      x These names are duplicated (`variable` (locations)):
        `x` (2, 5), `y` (3, 6)

---

    Code
      bind_cols_polars(l, .name_repair = "minimal")
    Condition
      Error in `bind_cols_polars()`:
      ! Argument `.name_repair = "minimal"` doesn't work on Polars Data/LazyFrames.
      i Either provide unique names or use `.name_repair = "universal"`.

---

    Code
      bind_cols_polars(l, .name_repair = "blahblah")
    Condition
      Error in `bind_cols_polars()`:
      ! `.name_repair` must be one of "unique", "universal", "check_unique", or "minimal", not "blahblah".

