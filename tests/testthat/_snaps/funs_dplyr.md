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

# na_if() works

    Code
      mutate(test_pl, foo = na_if(x, 1:2))
    Condition
      Error in `.data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! lengths don't match: cannot evaluate two Series of different lengths (5 and 2)
      
      Error originated in expression: '[(col("x")) == (Series[literal])]'

# near() works

    Code
      mutate(test_pl, z = near(x, 1:2))
    Condition
      Error in `.data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
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

