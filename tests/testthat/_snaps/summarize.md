# argument .groups works

    Code
      summarise(group_by(pl_mtcars, am, cyl, vs), cyl_n = n(), .groups = "rowwise")
    Condition
      Error in `summarise()`:
      ! `tidypolars` doesn't support `.groups = "rowwise"` for now.

---

    Code
      summarise(group_by(pl_mtcars, am, cyl, vs), cyl_n = n(), .groups = "foobar")
    Condition
      Error in `summarise()`:
      ! `.groups` must be one of "drop_last", "drop", "keep", or "rowwise", not "foobar".

