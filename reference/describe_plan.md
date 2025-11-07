# Show the optimized and non-optimized query plans

**\[deprecated\]**

Those functions are deprecated as of tidypolars 0.10.0, they will be
removed in a future update. Use
[`explain()`](https://dplyr.tidyverse.org/reference/explain.html) with
`optimized = FALSE` to recover the output of `describe_plan()`, and with
`optimized = TRUE` (the default) to get the output of
`describe_optimized_plan()`.

## Usage

``` r
describe_plan(.data)

describe_optimized_plan(.data)
```

## Arguments

- .data:

  A Polars LazyFrame
