# error message when function exists but has no translation

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `data.table::shift()`.
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

---

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `year()` (from package data.table).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

# error message when function doesn't exist in environment

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `foobar()`.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

