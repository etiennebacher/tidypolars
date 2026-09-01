# error if not all elements don't have the same class

    Code
      collect(current)
    Condition
      Error in `bind_cols_polars()`:
      ! All elements in `...` must be of the same class (either all Polars DataFrames or all Polars LazyFrames).

# arg .name_repair works

    Code
      collect(current)
    Condition
      Error in `bind_cols_polars()`:
      ! Names must be unique.
      x These names are duplicated (`variable` (locations)):
        `x` (2, 5), `y` (3, 6)

---

    Code
      collect(current)
    Condition
      Error in `bind_cols_polars()`:
      ! Argument `.name_repair = "minimal"` doesn't work on Polars Data/LazyFrames.
      i Either provide unique names or use `.name_repair = "universal"`.

---

    Code
      collect(current)
    Condition
      Error in `bind_cols_polars()`:
      ! `.name_repair` must be one of "unique", "universal", "check_unique", or "minimal", not "blahblah".

