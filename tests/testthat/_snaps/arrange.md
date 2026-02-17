# errors with unknown vars

    Code
      arrange(test_pl, foo)
    Condition
      Error:
      ! object 'foo' not found

---

    Code
      arrange(test_pl, foo, x1)
    Condition
      Error:
      ! object 'foo' not found

---

    Code
      arrange(test_pl, desc(foo))
    Condition
      Error:
      ! object 'foo' not found

