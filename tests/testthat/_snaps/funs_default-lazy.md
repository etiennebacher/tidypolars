# var() doesn't work with `use = 'all.obs'`

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `var()` in Polars.
      x tidypolars doesn't support `use = "all.obs"`.

# unique() works

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! lengths don't match: can't broadcast Series 'foo' of length 4 to length 5

# trunc() works

    Code
      compute(current)
    Condition
      Error in `compute()`:
      ! truncation ('to_zero') can only be used on numeric types

# trunc() in tidypolars doesn't support Date/datetime

    Code
      compute(current)
    Condition
      Warning:
      tidypolars doesn't know how to use some arguments of `trunc()`.
      i The following argument(s) will be ignored: "units".
      Error in `compute()`:
      ! truncation ('to_zero') can only be used on numeric types

---

    Code
      compute(current)
    Condition
      Warning:
      tidypolars doesn't know how to use some arguments of `trunc()`.
      i The following argument(s) will be ignored: "units".
      Error in `compute()`:
      ! truncation ('to_zero') can only be used on numeric types

# sample() validates size

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `sample()` in Polars.
      x `size` must be a positive integer.

# seq_len() works

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `seq_len()` in Polars.
      x `length.out` must be a non-negative integer.

# anyNA() works

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `anyNA()` in Polars.
      x Argument `recursive` is not supported by tidypolars.

# duplicated() validates fromLast

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `duplicated()` in Polars.
      x `fromLast` must be `TRUE` or `FALSE`, not the number 1.

---

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `duplicated()` in Polars.
      x `fromLast` must be `TRUE` or `FALSE`, not the string "TRUE".

---

    Code
      compute(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `duplicated()` in Polars.
      x `fromLast` must be `TRUE` or `FALSE`, not a logical vector.

