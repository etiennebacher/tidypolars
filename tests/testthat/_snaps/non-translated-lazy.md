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

# correct behavior when two expressions are identical but used in a different data context

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()`.

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()`.

# correct behavior with nested functions

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()`.

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()`.

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()`.

