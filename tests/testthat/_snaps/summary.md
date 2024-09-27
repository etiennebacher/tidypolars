# check percentiles

    Code
      summary(test, percentiles = c(0.2, 0.4, NA))
    Condition
      Error in `summary()`:
      ! All values of `percentiles` must be between 0 and 1.

---

    Code
      summary(test, percentiles = -1)
    Condition
      Error in `summary()`:
      ! All values of `percentiles` must be between 0 and 1.

