# log() works with base

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! not found: unable to find column "3"; valid columns: ["x"]
      Did you mean "x"?
      Resolved plan until failure:
      ---> FAILED HERE RESOLVING 'with_columns' <---
      DF ["x"]; PROJECT */1 COLUMNS
      This error occurred with the following context stack:
      [1] 'with_columns'

# sort errors when na.last is absent or NA

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `sort()` in Polars.
      x `na.last` must be `TRUE` or `FALSE`, not absent.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `sort()` in Polars.
      x `na.last` must be `TRUE` or `FALSE`, not `NA`.

# rank error when na.last is not in TRUE/FALSE/keep

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `rank()` in Polars.
      x `na.last` must be `TRUE`, `FALSE`, or `"keep"`.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `rank()` in Polars.
      x `na.last` must be `TRUE`, `FALSE`, or `"keep"`.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `rank()` in Polars.
      x `na.last` must be `TRUE`, `FALSE`, or `"keep"`.

