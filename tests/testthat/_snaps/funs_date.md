# errors for durations

    Code
      mutate(test, x = weeks(1.2))
    Condition
      Error in `mutate()`:
      ! Error while running function `weeks()` in Polars.
      x `x` must be a whole number or `NA`, not the number 1.2.

---

    Code
      mutate(test, x = days(1.2))
    Condition
      Error in `mutate()`:
      ! Error while running function `days()` in Polars.
      x `x` must be a whole number or `NA`, not the number 1.2.

---

    Code
      mutate(test, x = hours(1.2))
    Condition
      Error in `mutate()`:
      ! Error while running function `hours()` in Polars.
      x `x` must be a whole number or `NA`, not the number 1.2.

---

    Code
      mutate(test, x = minutes(1.2))
    Condition
      Error in `mutate()`:
      ! Error while running function `minutes()` in Polars.
      x `x` must be a whole number or `NA`, not the number 1.2.

# errors for rolling functions

    Code
      mutate(test, x = rollbackward(x, roll_to_first = "a"))
    Condition
      Error in `mutate()`:
      ! Error while running function `rollbackward()` in Polars.
      x `roll_to_first` must be `TRUE` or `FALSE`, not the string "a".

---

    Code
      mutate(test, x = rollbackward(x, preserve_hms = "a"))
    Condition
      Error in `mutate()`:
      ! Error while running function `rollbackward()` in Polars.
      x `preserve_hms` must be `TRUE` or `FALSE`, not the string "a".

---

    Code
      mutate(test, x = rollforward(x, roll_to_first = "a"))
    Condition
      Error in `mutate()`:
      ! Error while running function `rollforward()` in Polars.
      x `roll_to_first` must be `TRUE` or `FALSE`, not the string "a".

---

    Code
      mutate(test, x = rollforward(x, preserve_hms = "a"))
    Condition
      Error in `mutate()`:
      ! Error while running function `rollforward()` in Polars.
      x `preserve_hms` must be `TRUE` or `FALSE`, not the string "a".

