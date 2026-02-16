# sort default behavior

    Code
      current$collect()
    Message
      `sort()`: using Polars default `na.last = FALSE`.
      i base::sort() defaults to `na.last = NA` (drops missing values).
      i Set `na.last = TRUE/FALSE` explicitly to control behavior.
      This message is displayed once per session.
    Output
      shape: (5, 2)
      ┌──────┬──────┐
      │ x    ┆ foo  │
      │ ---  ┆ ---  │
      │ f64  ┆ f64  │
      ╞══════╪══════╡
      │ 3.0  ┆ null │
      │ null ┆ null │
      │ 1.0  ┆ 1.0  │
      │ 2.0  ┆ 2.0  │
      │ null ┆ 3.0  │
      └──────┴──────┘

# sort error when na.last = NA

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Error while running function `sort()` in Polars.
      x `na.last` does not support `NA` in tidypolars.
      i In `mutate()`, dropping missing values would change output length.

