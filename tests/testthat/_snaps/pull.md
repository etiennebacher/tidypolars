# error cases work

    Code
      pull(test, dplyr::all_of(c("mpg", "drat")))
    Condition
      Error in `pull()`:
      ! `pull()` can only extract one column. You tried to extract 2.

---

    Code
      pull(test, mpg, drat, hp)
    Condition
      Error in `pull()`:
      ! Arguments in `...` must be used.
      x Problematic argument:
      * ..1 = hp
      i Did you misspell an argument name?

