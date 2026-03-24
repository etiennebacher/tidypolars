# count works with expressions

    Code
      count(test_pl, foo = mpg > 20, vs == 1)
    Condition
      Error in `count()`:
      ! tidypolars doesn't support both named and unnamed inputs in `count()`.

# add_count works with expressions

    Code
      add_count(test_pl, foo = mpg > 20, vs == 1)
    Condition
      Error in `add_count()`:
      ! tidypolars doesn't support both named and unnamed inputs in `add_count()`.

