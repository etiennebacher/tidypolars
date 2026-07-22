# error message when using =

    Code
      current$collect()
    Condition
      Error in `filter()`:
      ! We detected a named input.
      i This usually means that you've used `=` instead of `==`.
      i Did you mean `x == 1`?

---

    Code
      current$collect()
    Condition
      Error in `filter()`:
      ! We detected a named input.
      i This usually means that you've used `=` instead of `==`.
      i Did you mean `x == 1`?

---

    Code
      current$collect()
    Condition
      Error in `filter()`:
      ! We detected a named input.
      i This usually means that you've used `=` instead of `==`.
      i Did you mean `a == mpg`?

# Polars runtime errors only show the root message

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! cannot compare string with numeric type (f64)

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! cannot compare string with numeric type (f64)

---

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! regex error: regex parse error:
          a{2,1}
           ^^^^^
      error: invalid repetition count range, the start must be <= the end

