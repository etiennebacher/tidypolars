# non-translated functions error if they use data context

    Code
      mutate(test_pl, x = agrep("a", a))
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `agrep()` (from package base).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

---

    Code
      filter(test_pl, a >= agrep("a", a))
    Condition
      Error in `filter()`:
      ! tidypolars doesn't know how to translate this function: `agrep()` (from package base).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

# correct behavior when two expressions are identical but used in a different data context

    Code
      mutate(test_pl, a = "foo", x = agrep("aa", a))
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `agrep()` (from package base).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

---

    Code
      mutate(test_pl, x = agrep("aa", a), a = "foo", x = agrep("aa", a))
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `agrep()` (from package base).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

# correct behavior with nested functions

    Code
      mutate(test_pl, a = "a", x = identity(agrep("a", a)))
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `agrep()` (from package base).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

---

    Code
      mutate(test_pl, a = "a", x = mean(agrep("a", a)))
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `agrep()` (from package base).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

---

    Code
      mutate(test_pl, a = 1, x = agrep("a", mean(a)))
    Condition
      Error in `mutate()`:
      ! tidypolars doesn't know how to translate this function: `agrep()` (from package base).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.
      i See `?tidypolars_options` to set automatic fallback to R to handle unknown functions.

