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

