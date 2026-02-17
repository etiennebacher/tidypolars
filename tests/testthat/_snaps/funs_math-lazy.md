# log() works with base

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! Column(s) not found: unable to find column "3"; valid columns: ["x"]
      
      Resolved plan until failure:
      
      	---> FAILED HERE RESOLVING 'sink' <---
      DF ["x"]; PROJECT */1 COLUMNS

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

# rank error when na.last is not in TRUE/FALSE/keep

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

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `rank()` in Polars.
      x `na.last` must be `TRUE`, `FALSE`, or `"keep"`.

