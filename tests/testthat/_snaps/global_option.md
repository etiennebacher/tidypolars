# tidypolars_unknown_args: basic behavior works

    Code
      mutate(test, x2 = sample(x, prob = 0.5))
    Condition
      Error in `mutate()`:
      ! Error while running function `sample()` in Polars.
      x Package tidypolars doesn't know how to use some arguments of `sample()`: `prob`.
      i Use `options(tidypolars_unknown_args = "warn")` to warn when this happens instead of throwing an error.

# tidypolars_fallback_to_r: basic behavior works

    Code
      mutate(test, y = 1, x2 = mad(x), z = mad(y))
    Condition
      Error:
      ! object 'y' not found

