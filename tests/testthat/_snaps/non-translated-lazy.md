# non-translated functions error if they use data context

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()`.

---

    Code
      current$collect()
    Condition
      Error in `filter()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()`.

