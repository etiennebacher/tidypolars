# non-translated functions error if they use data context

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `agrep()` (from package base).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

---

    Code
      current$collect()
    Condition
      Error in `filter()`:
      ! tidypolars doesn't know how to translate this function: `agrep()` (from package base).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

# correct behavior when two expressions are identical but used in a different data context

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `agrep()` (from package base).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `agrep()` (from package base).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

# correct behavior with nested functions

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `agrep()` (from package base).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `agrep()` (from package base).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `agrep()` (from package base).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

