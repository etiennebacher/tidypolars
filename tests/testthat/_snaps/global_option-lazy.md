# tidypolars_unknown_args: basic behavior works

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `sample()` in Polars.
      x tidypolars doesn't know how to use some arguments of `sample()`: "prob".
      i Use `options(tidypolars_unknown_args = "warn")` to warn when this happens instead of throwing an error.

# tidypolars_fallback_to_r: basic behavior works

    Code
      current$collect()
    Condition
      Error:
      ! object 'y' not found

