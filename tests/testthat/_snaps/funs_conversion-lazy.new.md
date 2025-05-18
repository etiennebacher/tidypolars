# as.Date() works for character columns

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `as.Date()` in Polars.
      x $ - syntax error: `to_r` is not a member of this polars object

---

    Code
      current$collect()
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
      current$collect()
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

