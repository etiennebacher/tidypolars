# errors for durations

    Code
      mutate(test, x = weeks(1.2))
    Condition
      Error in `mutate()`:
      ! Error while running function `weeks()` in Polars.
      x `x` must be integerish.

---

    Code
      mutate(test, x = days(1.2))
    Condition
      Error in `mutate()`:
      ! Error while running function `days()` in Polars.
      x `x` must be integerish.

---

    Code
      mutate(test, x = hours(1.2))
    Condition
      Error in `mutate()`:
      ! Error while running function `hours()` in Polars.
      x `x` must be integerish.

---

    Code
      mutate(test, x = minutes(1.2))
    Condition
      Error in `mutate()`:
      ! Error while running function `minutes()` in Polars.
      x `x` must be integerish.

