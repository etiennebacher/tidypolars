# n_distinct() works

    Code
      compute(current)
    Condition
      Error in `summarize()`:
      ! Error while running function `n_distinct()` in Polars.
      x `...` is absent, but must be supplied.

# nth() work

    Code
      compute(current)
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` must have size 1, not size 2.

---

    Code
      compute(current)
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` must be a whole number, not `NA`.

---

    Code
      compute(current)
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` must be a whole number, not the number 1.5.

# na_if() works

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! lengths don't match: zip node received non-equal length inputs

# near() works

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! lengths don't match: zip node received non-equal length inputs

#  when_all() and when_any() work

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `when_any()` in Polars.
      x Argument `na_rm` is not supported by tidypolars.

---

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `when_any()` in Polars.
      x Argument `size` is not supported by tidypolars.

---

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `when_all()` in Polars.
      x Argument `na_rm` is not supported by tidypolars.

---

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `when_all()` in Polars.
      x Argument `size` is not supported by tidypolars.

# replace_values() - basic usage

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `replace_values()` in Polars.
      x Can't supply both `...` and `from` / `to`.

---

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `replace_values()` in Polars.
      x Can't supply both `...` and `from` / `to`.

---

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `replace_values()` in Polars.
      x Specified `from` but not `to`.

---

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `replace_values()` in Polars.
      x Specified `to` but not `from`.

# recode_values() - basic usage

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `recode_values()` in Polars.
      x Can't supply both `...` and `from` / `to`.

---

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `recode_values()` in Polars.
      x Can't supply both `...` and `from` / `to`.

---

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `recode_values()` in Polars.
      x Specified `from` but not `to`.

---

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `recode_values()` in Polars.
      x Specified `to` but not `from`.

