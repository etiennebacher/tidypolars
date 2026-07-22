# using dollar sign works

    Code
      mutate(test_pl, foo = x * .env$bar)
    Condition
      Error in `mutate()`:
      ! object 'bar' not found

---

    Code
      mutate(test_pl, foo = x * .data$bar)
    Condition
      Error in `mutate()`:
      ! Column(s) not found: unable to find column "bar"; valid columns: ["x", "y", "z"]

# using [[ sign works

    Code
      mutate(test_pl, foo = x * .env[["bar"]])
    Condition
      Error in `mutate()`:
      ! object 'bar' not found

---

    Code
      mutate(test_pl, foo = x * .data[["bar"]])
    Condition
      Error in `mutate()`:
      ! Column(s) not found: unable to find column "bar"; valid columns: ["x", "y", "z"]

