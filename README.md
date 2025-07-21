
# tidypolars <a href="https://tidypolars.etiennebacher.com/"><img src="man/figures/logo.png" align="right" height="160" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/etiennebacher/tidypolars/actions/workflows/R-CMD-check.yml/badge.svg)](https://github.com/etiennebacher/tidypolars/actions/workflows/R-CMD-check.yml)
[![tidypolars status
badge](https://etiennebacher.r-universe.dev/badges/tidypolars)](https://etiennebacher.r-universe.dev/tidypolars)
[![Codecov test
coverage](https://codecov.io/gh/etiennebacher/tidypolars/branch/main/graph/badge.svg)](https://app.codecov.io/gh/etiennebacher/tidypolars?branch=main)
<!-- badges: end -->

------------------------------------------------------------------------

:information_source: This is the R package “tidypolars”. The Python one
is here:
[markfairbanks/tidypolars](https://github.com/markfairbanks/tidypolars)

------------------------------------------------------------------------

<!-- * [Motivation](#motivation) -->
<!-- * [Installation](#installation) -->
<!-- * [Example](#example) -->
<!-- * [Contributing](#contributing) -->

## Overview

`tidypolars` provides a [`polars`](https://rpolars.github.io/) backend
for the `tidyverse`. The aim of `tidypolars` is to enable users to keep
their existing `tidyverse` code while using `polars` in the background
to benefit from large performance gains. The only thing that needs to
change is the way data is imported in the R session.

See the [“Getting started”
vignette](https://tidypolars.etiennebacher.com/articles/tidypolars) for
a gentle introduction to `tidypolars`.

Since most of the work is rewriting `tidyverse` code into `polars`
syntax, `tidypolars` and `polars` have very similar performance.

<details>
<summary>
Click to see a small benchmark
</summary>

The main purpose of this benchmark is to show that `polars` and
`tidypolars` are close and to give an idea of the performance. For more
thorough, representative benchmarks about `polars`, take a look at
[DuckDB benchmarks](https://duckdblabs.github.io/db-benchmark/) instead.

``` r
suppressPackageStartupMessages({
  library(collapse, warn.conflicts = FALSE)
  library(dplyr, warn.conflicts = FALSE)
  library(dtplyr)
  library(duckplyr)
  library(polars)
  library(tidypolars)
})
#> Warning: package 'collapse' was built under R version 4.4.3
#> Warning: package 'dplyr' was built under R version 4.4.3
#> Warning: package 'dtplyr' was built under R version 4.4.3
#> Warning: package 'duckplyr' was built under R version 4.4.3
#> Warning: package 'polars' was built under R version 4.4.3

duckplyr::methods_restore()
#> ℹ Restoring dplyr methods.

# as_duckdb_tibble() cannot convert factor variables
large_iris <- data.table::rbindlist(rep(list(iris), 100000)) |> 
  mutate(Species = as.character(Species))

large_iris_pl <- as_polars_lf(large_iris)
large_iris_dt <- lazy_dt(large_iris)
large_iris_duck <- as_duckdb_tibble(large_iris)

format(nrow(large_iris), big.mark = ",")
#> [1] "15,000,000"

bench::mark(
  polars = {
    large_iris_pl$
      select(c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"))$
      with_columns(
        pl$when(
          (pl$col("Petal.Length") / pl$col("Petal.Width") > 3)
        )$then(pl$lit("long"))$
          otherwise(pl$lit("large"))$
          alias("petal_type")
      )$
      filter(pl$col("Sepal.Length")$is_between(4.5, 5.5))$
      collect() |> 
      as.data.frame()
  },
  tidypolars = {
    large_iris_pl |>
      select(starts_with(c("Sep", "Pet"))) |>
      mutate(
        petal_type = if_else((Petal.Length / Petal.Width) > 3, "long", "large")
      ) |> 
      filter(between(Sepal.Length, 4.5, 5.5)) |> 
      collect()
  },
  dplyr = {
    large_iris |>
      select(starts_with(c("Sep", "Pet"))) |>
      mutate(
        petal_type = if_else((Petal.Length / Petal.Width) > 3, "long", "large")
      ) |>
      filter(between(Sepal.Length, 4.5, 5.5))
  },
  dtplyr = {
    large_iris_dt |>
      select(starts_with(c("Sep", "Pet"))) |>
      mutate(
        petal_type = if_else((Petal.Length / Petal.Width) > 3, "long", "large")
      ) |>
      filter(between(Sepal.Length, 4.5, 5.5)) |> 
      as.data.frame()
  },
  duckplyr = {
    large_iris_duck |>
      select(starts_with(c("Sep", "Pet"))) |>
      mutate(
        petal_type = if_else((Petal.Length / Petal.Width) > 3, "long", "large")
      ) |>
      filter(Sepal.Length >= 4.5 & Sepal.Length <= 5.5) |> 
      collect()
  },
  collapse = {
    large_iris |>
      fselect(c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")) |>
      fmutate(
        petal_type = data.table::fifelse((Petal.Length / Petal.Width) > 3, "long", "large")
      ) |>
      fsubset(Sepal.Length >= 4.5 & Sepal.Length <= 5.5)
  },
  check = FALSE,
  iterations = 40
)
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
#> # A tibble: 6 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 polars     343.16ms 505.19ms     1.87   211.95MB   0.608 
#> 2 tidypolars 488.82ms 630.83ms     1.36   211.56MB   0.272 
#> 3 dplyr         1.34s    1.58s     0.633    1.68GB   1.77  
#> 4 dtplyr      911.8ms    1.22s     0.862    1.72GB   1.81  
#> 5 duckplyr   396.66ms 744.03ms     1.49     1.21MB   0.0745
#> 6 collapse   325.75ms 440.17ms     2.16   745.96MB   2.22

# NOTE: do NOT take the "mem_alloc" results into account.
# `bench::mark()` doesn't report the accurate memory usage for packages calling
# Rust code.
```

</details>

## Installation

`tidypolars` is built on `polars`, which is not available on CRAN. This
means that `tidypolars` also can’t be on CRAN. However, you can install
it from R-universe.

``` r
Sys.setenv(NOT_CRAN = "true")
install.packages("tidypolars", repos = c("https://community.r-multiverse.org", 'https://cloud.r-project.org'))
```

The development version contains the latest improvements and bug fixes:

``` r
# install.packages("remotes")
remotes::install_github("etiennebacher/tidypolars")
```

## Contributing

Did you find some bugs or some errors in the documentation? Do you want
`tidypolars` to support more functions?

Take a look at the [contributing
guide](https://tidypolars.etiennebacher.com/CONTRIBUTING.html) for
instructions on bug report and pull requests.

## Acknowledgements

The website theme was heavily inspired by Matthew Kay’s `ggblend`
package: <https://mjskay.github.io/ggblend/>.

The package hex logo was created by Hubert Hałun as part of the Appsilon
Hex Contest.
