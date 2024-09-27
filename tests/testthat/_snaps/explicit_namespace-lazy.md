# error message when function exists but has no translation

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `data.table::shift()` (from package `data.table`).

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `year()` (from package `data.table`).

# error message when function doesn't exist in environment

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `foobar()`.

