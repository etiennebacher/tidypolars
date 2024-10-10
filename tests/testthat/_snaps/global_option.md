# basic behavior works

    Code
      mutate(test, x2 = sample(x, prob = 0.5))
    Condition
      Error in `mutate()`:
      ! Error while running function `sample()` in Polars.
      x Package tidypolars doesn't know how to use some arguments of `sample()`: `prob`.
      i Use `options(tidypolars_unknown_args = "warn")` to warn when this happens instead of throwing an error.

