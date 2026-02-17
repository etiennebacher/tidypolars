# sort errors when na.last is absent or NA

    Code
      mutate(test_pl, foo = sort(x))
    Condition
      Error in `mutate()`:
      ! Error while running function `sort()` in Polars.
      x `na.last` must be `TRUE` or `FALSE`, not absent.

---

    Code
      mutate(test_pl, foo = sort(x, na.last = NA))
    Condition
      Error in `mutate()`:
      ! Error while running function `sort()` in Polars.
      x `na.last` must be `TRUE` or `FALSE`, not `NA`.

# rank with na.last and ties.method

    Code
      mutate(test_pl, foo = rank(x, na.last = NA))
    Condition
      Error in `mutate()`:
      ! Error while running function `rank()` in Polars.
      x `na.last` must be `TRUE`, `FALSE`, or `"keep"`.

---

    Code
      mutate(test_pl, foo = rank(x, na.last = "wrong"))
    Condition
      Error in `mutate()`:
      ! Error while running function `rank()` in Polars.
      x `na.last` must be `TRUE`, `FALSE`, or `"keep"`.

