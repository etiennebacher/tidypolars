# count works with expressions

    Code
      count(test_pl, foo = mpg > 20, vs == 1)
    Condition
      Error in `count()`:
      ! tidypolars doesn't support both named and unnamed inputs in `count()`.

