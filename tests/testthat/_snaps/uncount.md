# weights are validated before expansion

    Code
      uncount(test_pl, missing)
    Condition
      Error in `uncount()`:
      ! User function raised an error

---

    Code
      uncount(test_pl, fraction)
    Condition
      Error in `uncount()`:
      ! User function raised an error

---

    Code
      uncount(test_pl, negative)
    Condition
      Error in `uncount()`:
      ! User function raised an error

---

    Code
      uncount(test_pl, infinite)
    Condition
      Error in `uncount()`:
      ! User function raised an error

---

    Code
      uncount(test_pl, nan)
    Condition
      Error in `uncount()`:
      ! User function raised an error

---

    Code
      uncount(test_pl, text)
    Condition
      Error in `uncount()`:
      ! User function raised an error

---

    Code
      uncount(test_pl, oversized)
    Condition
      Error in `uncount()`:
      ! User function raised an error

---

    Code
      uncount(test_pl, c(1L, 2L, 3L))
    Condition
      Error:
      ! lengths don't match: can't broadcast Series '__tidypolars_uncount__' of length 3 to length 2

# control arguments are validated

    Code
      uncount(test_pl, n, .remove = NA)
    Condition
      Error in `uncount()`:
      ! `.remove` must be `TRUE` or `FALSE`, not `NA`.

---

    Code
      uncount(test_pl, n, .remove = 1)
    Condition
      Error in `uncount()`:
      ! `.remove` must be `TRUE` or `FALSE`, not the number 1.

---

    Code
      uncount(test_pl, n, .id = "")
    Condition
      Error in `uncount()`:
      ! `.id` must be a valid name or `NULL`, not the empty string "".

---

    Code
      uncount(test_pl, n, .id = c("a", "b"))
    Condition
      Error in `uncount()`:
      ! `.id` must be a valid name or `NULL`, not a character vector.

