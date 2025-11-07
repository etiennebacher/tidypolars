# Summary statistics for a Polars DataFrame

**\[deprecated\]**

This function is deprecated as of tidypolars 0.10.0, it will be removed
in a future update. Use
[`summary()`](https://rdrr.io/r/base/summary.html) with the same
arguments instead.

## Usage

``` r
describe(.data, percentiles = c(0.25, 0.5, 0.75))
```

## Arguments

- .data:

  A Polars DataFrame.

- percentiles:

  One or more percentiles to include in the summary statistics. All
  values must be between 0 and 1 (`NULL` are ignored).
