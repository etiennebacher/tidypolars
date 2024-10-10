# select helpers work

    Code
      select(pl_iris, all_of(bad_selection))
    Condition
      Error in `select()`:
      i In argument: `all_of(bad_selection)`.
      Caused by error in `all_of()`:
      ! Can't subset elements that don't exist.
      x Element `foo` doesn't exist.

---

    Code
      select(pl_iris, where(~ mean(.x) > 3.5))
    Condition
      Error in `select()`:
      ! `where()` can only take `is.*` functions (like `is.numeric`).

