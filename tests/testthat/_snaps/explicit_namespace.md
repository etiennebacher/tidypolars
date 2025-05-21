# error message when function exists but has no translation

    Code
      mutate(test, y = data.table::shift(x))
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `data.table::shift()`.
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.

---

    Code
      mutate(test, y = year(x))
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `year()` (from package `data.table`).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.

# error message when function doesn't exist in environment

    Code
      mutate(test, y = foobar(x))
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `foobar()`.

