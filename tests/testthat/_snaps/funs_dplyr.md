# n_distinct() works

    Code
      summarize(test_pl, foo = n_distinct())
    Condition
      Error in `summarize()`:
      ! Error while running function `n_distinct()` in Polars.
      x `...` is absent, but must be supplied.

# nth() work

    Code
      summarize(test_pl, foo = nth(x, 2:3))
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` must have size 1, not size 2.

---

    Code
      summarize(test_pl, foo = nth(x, NA))
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` must be a whole number, not `NA`.

---

    Code
      summarize(test_pl, foo = nth(x, 1.5))
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` must be a whole number, not the number 1.5.

# nth() validates optional argument sizes and flags

    Code
      summarize(test_pl, y = nth(x, 1, default = 1:2))
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `default` must have size 1, not size 2.

---

    Code
      summarize(test_pl, y = nth(x, 1, default = x))
    Condition
      Error in `summarize()`:
      ! cannot reshape array of size 3 into shape (1)

---

    Code
      summarize(test_pl, y = first(x, order_by = 1))
    Condition
      Error in `summarize()`:
      ! Error while running function `first()` in Polars.
      x `order_by` must have the same size as `x`, not size 1.

---

    Code
      summarize(test_pl, y = last(x, na_rm = NA))
    Condition
      Error in `summarize()`:
      ! Error while running function `last()` in Polars.
      x `na_rm` must be `TRUE` or `FALSE`, not `NA`.

# na_if() works

    Code
      mutate(test_pl, foo = na_if(x, 1:2))
    Condition
      Error in `mutate()`:
      ! lengths don't match: cannot evaluate two Series of different lengths (5 and 2)
      Error originated in expression: '[(col("x")) == (Series[literal])]'

# near() works

    Code
      mutate(test_pl, z = near(x, 1:2))
    Condition
      Error in `mutate()`:
      ! lengths don't match: cannot evaluate two Series of different lengths (3 and 2)
      Error originated in expression: '[(col("x")) - (Series[literal])]'

#  when_all() and when_any() work

    Code
      mutate(test_pl, any_propagate = when_any(x, y, na_rm = TRUE))
    Condition
      Error in `mutate()`:
      ! Error while running function `when_any()` in Polars.
      x Argument `na_rm` is not supported by tidypolars.

---

    Code
      mutate(test_pl, any_propagate = when_any(x, y, size = TRUE))
    Condition
      Error in `mutate()`:
      ! Error while running function `when_any()` in Polars.
      x Argument `size` is not supported by tidypolars.

---

    Code
      mutate(test_pl, all_propagate = when_all(x, y, na_rm = TRUE))
    Condition
      Error in `mutate()`:
      ! Error while running function `when_all()` in Polars.
      x Argument `na_rm` is not supported by tidypolars.

---

    Code
      mutate(test_pl, all_propagate = when_all(x, y, size = TRUE))
    Condition
      Error in `mutate()`:
      ! Error while running function `when_all()` in Polars.
      x Argument `size` is not supported by tidypolars.

# replace_values() - basic usage

    Code
      mutate(test_pl, y = replace_values(x, "NYC" ~ "NY", from = "a"))
    Condition
      Error in `mutate()`:
      ! Error while running function `replace_values()` in Polars.
      x Can't supply both `...` and `from` / `to`.

---

    Code
      mutate(test_pl, y = replace_values(x, "NYC" ~ "NY", to = "a"))
    Condition
      Error in `mutate()`:
      ! Error while running function `replace_values()` in Polars.
      x Can't supply both `...` and `from` / `to`.

---

    Code
      mutate(test_pl, y = replace_values(x, from = "a"))
    Condition
      Error in `mutate()`:
      ! Error while running function `replace_values()` in Polars.
      x Specified `from` but not `to`.

---

    Code
      mutate(test_pl, y = replace_values(x, to = "a"))
    Condition
      Error in `mutate()`:
      ! Error while running function `replace_values()` in Polars.
      x Specified `to` but not `from`.

# recode_values() - basic usage

    Code
      mutate(test_pl, y = recode_values(x, "NYC" ~ "NY", from = "a"))
    Condition
      Error in `mutate()`:
      ! Error while running function `recode_values()` in Polars.
      x Can't supply both `...` and `from` / `to`.

---

    Code
      mutate(test_pl, y = recode_values(x, "NYC" ~ "NY", to = "a"))
    Condition
      Error in `mutate()`:
      ! Error while running function `recode_values()` in Polars.
      x Can't supply both `...` and `from` / `to`.

---

    Code
      mutate(test_pl, y = recode_values(x, from = "a"))
    Condition
      Error in `mutate()`:
      ! Error while running function `recode_values()` in Polars.
      x Specified `from` but not `to`.

---

    Code
      mutate(test_pl, y = recode_values(x, to = "a"))
    Condition
      Error in `mutate()`:
      ! Error while running function `recode_values()` in Polars.
      x Specified `to` but not `from`.

