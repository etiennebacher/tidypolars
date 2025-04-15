# errors with unknown vars

    Code
      arrange(test, foo)
    Condition
      Error:
      ! object 'foo' not found

---

    Code
      arrange(test, foo, x1)
    Condition
      Error:
      ! object 'foo' not found

---

    Code
      arrange(test, desc(foo))
    Condition
      Error in `arrange()`:
      ! Error in `desc()`.
      Caused by error in `translate()`:
      ! object 'foo' not found

