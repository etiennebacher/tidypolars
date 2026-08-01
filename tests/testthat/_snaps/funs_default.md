# unique() works

    Code
      mutate(test_pl, foo = unique(y))
    Condition
      Error in `mutate()`:
      ! lengths don't match: unable to add a column of length 4 to a DataFrame of height 5

# trunc() works

    Code
      mutate(test_pl, foo = trunc("a"))
    Condition
      Error in `mutate()`:
      ! truncation ('to_zero') can only be used on numeric types

# trunc() in tidypolars doesn't support Date/datetime

    Code
      mutate(test_pl, x = trunc(date, units = "secs"))
    Condition
      Warning:
      tidypolars doesn't know how to use some arguments of `trunc()`.
      i The following argument(s) will be ignored: "units".
      Error in `mutate()`:
      ! truncation ('to_zero') can only be used on numeric types

---

    Code
      mutate(test_pl, x = trunc(datetime, units = "secs"))
    Condition
      Warning:
      tidypolars doesn't know how to use some arguments of `trunc()`.
      i The following argument(s) will be ignored: "units".
      Error in `mutate()`:
      ! truncation ('to_zero') can only be used on numeric types

# sample() validates size

    Code
      mutate(test_pl, y = sample(x, size = 1.5))
    Condition
      Error in `mutate()`:
      ! Error while running function `sample()` in Polars.
      x `size` must be a positive integer.

# seq_len() works

    Code
      mutate(test_pl, y = seq_len(-1))
    Condition
      Error in `mutate()`:
      ! Error while running function `seq_len()` in Polars.
      x `length.out` must be a non-negative integer.

# anyNA() works

    Code
      mutate(test_pl, y = anyNA(x, recursive = TRUE))
    Condition
      Error in `mutate()`:
      ! Error while running function `anyNA()` in Polars.
      x Argument `recursive` is not supported by tidypolars.

# duplicated() validates fromLast

    Code
      mutate(test_pl, dup = duplicated(x, fromLast = 1))
    Condition
      Error in `mutate()`:
      ! Error while running function `duplicated()` in Polars.
      x `fromLast` must be `TRUE` or `FALSE`, not the number 1.

---

    Code
      mutate(test_pl, dup = duplicated(x, fromLast = "TRUE"))
    Condition
      Error in `mutate()`:
      ! Error while running function `duplicated()` in Polars.
      x `fromLast` must be `TRUE` or `FALSE`, not the string "TRUE".

---

    Code
      mutate(test_pl, dup = duplicated(x, fromLast = c(TRUE, FALSE)))
    Condition
      Error in `mutate()`:
      ! Error while running function `duplicated()` in Polars.
      x `fromLast` must be `TRUE` or `FALSE`, not a logical vector.

