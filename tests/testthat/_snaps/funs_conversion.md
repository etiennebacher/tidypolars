# as.Date() works for character columns

    Code
      mutate(test, a = as.Date(a, format = c("%Y-%m-%d", "%Y-%m-%d", "%Y-%m-%d")))
    Condition
      Error in `mutate()`:
      ! Error while running function `as.Date()` in Polars.
      x `tidypolars` only supports `format` of length 1.

---

    Code
      mutate(test, a = as.Date(a, tryFormats = c("%Y-%m-%d", "%Y-%m-%d", "%Y-%m-%d")))
    Condition
      Warning:
      
      Package tidypolars doesn't know how to use some arguments of `as.Date()`.
      The following argument(s) will be ignored: `tryFormats`.
    Output
      shape: (2, 1)
      ┌────────────┐
      │ a          │
      │ ---        │
      │ date       │
      ╞════════════╡
      │ 2020-01-01 │
      │ null       │
      └────────────┘

---

    Code
      mutate(test, a = as.Date(a, optional = TRUE))
    Condition
      Warning:
      
      Package tidypolars doesn't know how to use some arguments of `as.Date()`.
      The following argument(s) will be ignored: `optional`.
    Output
      shape: (2, 1)
      ┌────────────┐
      │ a          │
      │ ---        │
      │ date       │
      ╞════════════╡
      │ 2020-01-01 │
      │ null       │
      └────────────┘

