# error message when using =

    Code
      filter(test_pl, x = 1)
    Condition
      Error in `filter()`:
      ! We detected a named input.
      i This usually means that you've used `=` instead of `==`.
      i Did you mean `x == 1`?

---

    Code
      filter(test_pl, !is.na(y), x = 1)
    Condition
      Error in `filter()`:
      ! We detected a named input.
      i This usually means that you've used `=` instead of `==`.
      i Did you mean `x == 1`?

---

    Code
      f_pl(mpg)
    Condition
      Error in `filter()`:
      ! We detected a named input.
      i This usually means that you've used `=` instead of `==`.
      i Did you mean `a == mpg`?

# Polars runtime errors only show the root message

    Code
      filter(test_pl, x > 1)
    Condition
      Error in `filter()`:
      ! cannot compare string with numeric type (f64)

---

    Code
      filter_out(test_pl, x > 1)
    Condition
      Error in `filter_out()`:
      ! cannot compare string with numeric type (f64)

---

    Code
      filter(test_pl, grepl("a{2,1}", x))
    Condition
      Error in `filter()`:
      ! regex error: regex parse error:
      a{2,1}
      ^^^^^
      error: invalid repetition count range, the start must be <= the end

