# error when different types

    Code
      mutate(test_pl, y = ifelse(x1 == 1, "foo", "bar"))
    Condition
      Error in `mutate()`:
      ! cannot compare string with numeric type (f64)

---

    Code
      mutate(test_pl, y = if_else(x1 == 1, "foo", "bar"))
    Condition
      Error in `mutate()`:
      ! cannot compare string with numeric type (f64)

