# errors for durations

    Code
      mutate(test, x = weeks(1.2))
    Condition
      Error in `mutate()`:
      ! Error in `weeks()`.
      Caused by error in `validObject()`:
      ! invalid class "Period" object: periods must have integer values

---

    Code
      mutate(test, x = days(1.2))
    Condition
      Error in `mutate()`:
      ! Error in `days()`.
      Caused by error in `validObject()`:
      ! invalid class "Period" object: periods must have integer values

---

    Code
      mutate(test, x = hours(1.2))
    Condition
      Error in `mutate()`:
      ! Error in `hours()`.
      Caused by error in `validObject()`:
      ! invalid class "Period" object: periods must have integer values

---

    Code
      mutate(test, x = minutes(1.2))
    Condition
      Error in `mutate()`:
      ! Error in `minutes()`.
      Caused by error in `validObject()`:
      ! invalid class "Period" object: periods must have integer values

