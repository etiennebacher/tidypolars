# select helpers work

    Code
      current$collect()
    Condition
      Error in `select()`:
      i In argument: `all_of(bad_selection)`.
      Caused by error in `all_of()`:
      ! Can't subset elements that don't exist.
      x Element `foo` doesn't exist.

---

    Code
      current$collect()
    Condition
      Error in `select()`:
      ! `where()` can only take `is.*()` functions (like `is.numeric()`).

