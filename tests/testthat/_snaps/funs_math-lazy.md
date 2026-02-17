# sort errors when na.last is absent or NA

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `sort()` in Polars.
      x `na.last` must be `TRUE` or `FALSE`, not absent.

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `sort()` in Polars.
      x `na.last` must be `TRUE` or `FALSE`, not `NA`.

# rank with na.last and ties.method

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `rank()` in Polars.
      x `na.last` must be `TRUE`, `FALSE`, or `"keep"`.

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `rank()` in Polars.
      x `na.last` must be `TRUE`, `FALSE`, or `"keep"`.

