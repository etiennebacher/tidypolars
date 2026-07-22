# argument .groups works

    Code
      summarise(group_by(test_pl, am, cyl, vs), cyl_n = n(), .groups = "rowwise")
    Condition
      Error in `summarise()`:
      ! tidypolars doesn't support `.groups = "rowwise"` for now.

---

    Code
      summarise(group_by(test_pl, am, cyl, vs), cyl_n = n(), .groups = "foobar")
    Condition
      Error in `summarise()`:
      ! `.groups` must be one of "drop_last", "drop", "keep", or "rowwise", not "foobar".

# Polars runtime errors only show the root message

    Code
      summarize(group_by(test_pl, g), s = sum(x))
    Condition
      Error in `summarize()`:
      ! `sum` operation not supported for dtype `str` Resolved plan until failure: ---> FAILED HERE RESOLVING 'group_by' <--- DF ["x", "g"]; PROJECT */2 COLUMNS: 'group_by'

