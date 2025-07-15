# argument .groups works

    Code
      current$collect()
    Condition
      Error in `summarise()`:
      ! tidypolars doesn't support `.groups = "rowwise"` for now.

---

    Code
      current$collect()
    Condition
      Error in `summarise()`:
      ! `.groups` must be one of "drop_last", "drop", "keep", or "rowwise", not "foobar".

