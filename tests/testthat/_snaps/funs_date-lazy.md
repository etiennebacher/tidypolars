# weekday works

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `wday()` in Polars.
      x `week_start` must be a whole number between 1 and 7, not the number 0.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `wday()` in Polars.
      x `week_start` must be a whole number between 1 and 7, not the number 8.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `wday()` in Polars.
      x `week_start` must be a whole number, not the number 1.5.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `wday()` in Polars.
      x `week_start` must be a whole number, not the string "Monday".

# strptime() works

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `strptime()` in Polars.
      x Unrecognized time zone: NULL

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `strptime()` in Polars.
      x Unrecognized time zone: "Not/A_Zone"

# make_datetime() works

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `make_datetime()` in Polars.
      x Evaluation failed in `$datetime()`.

# ISOdatetime() works

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `ISOdatetime()` in Polars.
      x Evaluation failed in `$datetime()`.

# now() errors on invalid timezones

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `now()` in Polars.
      x Evaluation failed.

# errors for durations

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `weeks()` in Polars.
      x `x` must be a whole number or `NA`, not the number 1.2.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `days()` in Polars.
      x `x` must be a whole number or `NA`, not the number 1.2.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `hours()` in Polars.
      x `x` must be a whole number or `NA`, not the number 1.2.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `minutes()` in Polars.
      x `x` must be a whole number or `NA`, not the number 1.2.

# errors for rolling functions

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `rollbackward()` in Polars.
      x `roll_to_first` must be `TRUE` or `FALSE`, not the string "a".

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `rollbackward()` in Polars.
      x `preserve_hms` must be `TRUE` or `FALSE`, not the string "a".

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `rollforward()` in Polars.
      x `roll_to_first` must be `TRUE` or `FALSE`, not the string "a".

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `rollforward()` in Polars.
      x `preserve_hms` must be `TRUE` or `FALSE`, not the string "a".

