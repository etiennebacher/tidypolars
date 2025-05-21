# non-translated functions error if they use data context

    Code
      mutate(test, x = agrep("a", a))
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()` (from package `base`).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.

---

    Code
      filter(test, a >= agrep("a", a))
    Condition
      Error in `filter()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()` (from package `base`).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.

# correct behavior when two expressions are identical but used in a different data context

    Code
      mutate(test, a = "foo", x = agrep("aa", a))
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()` (from package `base`).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.

---

    Code
      mutate(test, x = agrep("aa", a), a = "foo", x = agrep("aa", a))
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()` (from package `base`).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.

# correct behavior with nested functions

    Code
      mutate(test, a = "a", x = identity(agrep("a", a)))
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()` (from package `base`).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.

---

    Code
      mutate(test, a = "a", x = mean(agrep("a", a)))
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()` (from package `base`).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.

---

    Code
      mutate(test, a = 1, x = agrep("a", mean(a)))
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()` (from package `base`).
      i You can ask for it to be translated here: <https://github.com/etiennebacher/tidypolars/issues>.

