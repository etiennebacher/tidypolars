# errors for durations

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `weeks()` in Polars.
      x `x` must be a whole number, not the number 1.2.

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `days()` in Polars.
      x `x` must be a whole number, not the number 1.2.

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `hours()` in Polars.
      x `x` must be a whole number, not the number 1.2.

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `minutes()` in Polars.
      x `x` must be a whole number, not the number 1.2.

# errors for rolling functions

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `rollbackward()` in Polars.
      x `roll_to_first` must be `TRUE` or `FALSE`, not the string "a".

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `rollbackward()` in Polars.
      x `preserve_hms` must be `TRUE` or `FALSE`, not the string "a".

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `rollforward()` in Polars.
      x `roll_to_first` must be `TRUE` or `FALSE`, not the string "a".

---

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `rollforward()` in Polars.
      x `preserve_hms` must be `TRUE` or `FALSE`, not the string "a".

