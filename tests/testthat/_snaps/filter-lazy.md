# error message when using =

    Code
      collect(current)
    Condition
      Error in `filter()`:
      ! We detected a named input.
      i This usually means that you've used `=` instead of `==`.
      i Did you mean `x == 1`?

---

    Code
      collect(current)
    Condition
      Error in `filter()`:
      ! We detected a named input.
      i This usually means that you've used `=` instead of `==`.
      i Did you mean `x == 1`?

---

    Code
      collect(current)
    Condition
      Error in `filter()`:
      ! We detected a named input.
      i This usually means that you've used `=` instead of `==`.
      i Did you mean `a == mpg`?

# Polars runtime errors only show the root message

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! cannot compare string with numeric type (f64)

---

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! cannot compare string with numeric type (f64)

---

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! regex error: regex parse error:
      a{2,1}
      ^^^^^
      error: invalid repetition count range, the start must be <= the end

