# errors with unknown vars

    Code
      current$collect()
    Condition
      Error:
      ! object 'foo' not found

---

    Code
      current$collect()
    Condition
      Error:
      ! object 'foo' not found

---

    Code
      current$collect()
    Condition
      Error in `arrange()`:
      ! Error in `desc()`.
      Caused by error in `translate()`:
      ! object 'foo' not found

