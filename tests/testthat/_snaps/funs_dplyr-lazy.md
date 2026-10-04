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

# nth() validates optional argument sizes and flags

    Code
      compute(current)
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `default` must have size 1, not size 2.

---

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! cannot reshape array of size 3 into shape (1)

---

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! lengths don't match: `sort_by` produced different length (1) than the Series that has to be sorted (3)
      Error originated in expression: 'col("x").sort_by(by=[.when([(1.0.is_null()) | ([(true) & (1.0.is_nan())])]).then(null.cast(Float64)).otherwise(1.0)], sort_option=SortMultipleOptions { descending: [false], nulls_last: [true], multithreaded: true, maintain_order: true, limit: None })'

---

    Code
      compute(current)
    Condition
      Error in `summarize()`:
      ! Error while running function `last()` in Polars.
      x `na_rm` must be `TRUE` or `FALSE`, not `NA`.

# na_if() works

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! lengths don't match: cannot evaluate two Series of different lengths (5 and 2)
      Error originated in expression: '[(col("x")) == (Series[literal])]'

# near() works

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! lengths don't match: cannot evaluate two Series of different lengths (3 and 2)
      Error originated in expression: '[(col("x")) - (Series[literal])]'

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

