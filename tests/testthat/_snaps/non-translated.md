# non-translated functions error if they use data context

    Code
      mutate(test, x = agrep("a", a))
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()`.

---

    Code
      filter(test, a >= agrep("a", a))
    Condition
      Error in `filter()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()`.

