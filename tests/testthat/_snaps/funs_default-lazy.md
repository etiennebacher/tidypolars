# unique() works

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! lengths don't match: can't broadcast Series 'foo' of length 4 to length 5

# trunc() works

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! truncation ('to_zero') can only be used on numeric types

# trunc() in tidypolars doesn't support Date/datetime

    Code
      collect(current)
    Condition
      Warning:
      tidypolars doesn't know how to use some arguments of `trunc()`.
      i The following argument(s) will be ignored: "units".
      Error in `collect()`:
      ! truncation ('to_zero') can only be used on numeric types

---

    Code
      collect(current)
    Condition
      Warning:
      tidypolars doesn't know how to use some arguments of `trunc()`.
      i The following argument(s) will be ignored: "units".
      Error in `collect()`:
      ! truncation ('to_zero') can only be used on numeric types

# sample() validates size

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `sample()` in Polars.
      x `size` must be a positive integer.

# seq_len() works

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `seq_len()` in Polars.
      x `length.out` must be a non-negative integer.

# anyNA() works

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `anyNA()` in Polars.
      x Argument `recursive` is not supported by tidypolars.

# duplicated() validates fromLast

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `duplicated()` in Polars.
      x `fromLast` must be `TRUE` or `FALSE`, not the number 1.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `duplicated()` in Polars.
      x `fromLast` must be `TRUE` or `FALSE`, not the string "TRUE".

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `duplicated()` in Polars.
      x `fromLast` must be `TRUE` or `FALSE`, not a logical vector.

