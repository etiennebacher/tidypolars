
# tidypolars

<!-- badges: start -->

[![check](https://github.com/etiennebacher/tidypolars/actions/workflows/check.yml/badge.svg)](https://github.com/etiennebacher/tidypolars/actions/workflows/check.yml)
[![tidypolars status
badge](https://etiennebacher.r-universe.dev/badges/tidypolars)](https://etiennebacher.r-universe.dev/tidypolars)
[![Codecov test
coverage](https://codecov.io/gh/etiennebacher/tidypolars/branch/main/graph/badge.svg)](https://app.codecov.io/gh/etiennebacher/tidypolars?branch=main)
<!-- badges: end -->

------------------------------------------------------------------------

:warning: This is the R package “tidypolars”. The Python one is here:
[markfairbanks/tidypolars](https://github.com/markfairbanks/tidypolars)
:warning:

------------------------------------------------------------------------

- [Motivation](#motivation)
- [Installation](#installation)
- [Example](#example)
- [Contributing](#contributing)

## Motivation

`polars` is a DataFrame library written in Rust and with bindings in
several languages, [including R](https://rpolars.github.io/). I won’t
argue here for the interest of using `polars`, there are already a lot
of resources on [its website](https://www.pola.rs/).

The R package `polars` was made to mimic very closely the original
Python syntax, which is quite verbose. While this makes it easy to read,
it is **yet another syntax to learn** for R users that are accustomed so
far to either base R, `data.table` or the `tidyverse`.

The objective of `tidypolars` is to **provide the power and speed of
`polars` while keeping the `tidyverse` syntax**.

## Installation

`tidypolars` is built on `polars`, which is not available on CRAN. This
means that `tidypolars` also can’t be on CRAN. However, you can install
it from R-universe.

### Windows or macOS

``` r
install.packages(
  'tidypolars', 
  repos = c('https://etiennebacher.r-universe.dev', getOption("repos"))
)
```

### Linux

``` r
install.packages(
  'tidypolars', 
  repos = c('https://etiennebacher.r-universe.dev/bin/linux/jammy/4.3', getOption("repos"))
)
```

## Example

Suppose that you already have some code that uses `dplyr`:

``` r
library(dplyr, warn.conflicts = FALSE)

iris |> 
  select(starts_with(c("Sep", "Pet"))) |> 
  mutate(
    petal_type = ifelse((Petal.Length / Petal.Width) > 3, "long", "large")
  ) |> 
  filter(between(Sepal.Length, 4.5, 5.5)) |> 
  head()
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width petal_type
#> 1          5.1         3.5          1.4         0.2       long
#> 2          4.9         3.0          1.4         0.2       long
#> 3          4.7         3.2          1.3         0.2       long
#> 4          4.6         3.1          1.5         0.2       long
#> 5          5.0         3.6          1.4         0.2       long
#> 6          5.4         3.9          1.7         0.4       long
```

With `tidypolars`, you can provide a Polars `DataFrame` or `LazyFrame`
and keep the exact same code:

``` r
library(tidypolars)
#> Registered S3 method overwritten by 'tidypolars':
#>   method                 from  
#>   print.RPolarsDataFrame polars

iris |> 
  as_polars_df() |> 
  select(starts_with(c("Sep", "Pet"))) |> 
  mutate(
    petal_type = ifelse((Petal.Length / Petal.Width) > 3, "long", "large")
  ) |> 
  filter(between(Sepal.Length, 4.5, 5.5)) |> 
  head()
#> shape: (6, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬────────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ petal_type │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---        │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ str        │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪════════════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ long       │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ long       │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ long       │
#> │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ long       │
#> │ 5.0          ┆ 3.6         ┆ 1.4          ┆ 0.2         ┆ long       │
#> │ 5.4          ┆ 3.9         ┆ 1.7          ┆ 0.4         ┆ long       │
#> └──────────────┴─────────────┴──────────────┴─────────────┴────────────┘
```

If you’re used to the `tidyverse` functions and syntax, this will feel
much easier to read than the pure `polars` syntax:

``` r
library(polars)

# polars syntax
pl$DataFrame(iris)$
  select(c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"))$
  with_columns(
    pl$when(
      (pl$col("Petal.Length") / pl$col("Petal.Width") > 3)
    )$then(pl$lit("long"))$
      otherwise(pl$lit("large"))$
      alias("petal_type")
  )$
  filter(pl$col("Sepal.Length")$is_between(4.5, 5.5))$
  head(6)
#> shape: (6, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬────────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ petal_type │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---        │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ str        │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪════════════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ long       │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ long       │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ long       │
#> │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ long       │
#> │ 5.0          ┆ 3.6         ┆ 1.4          ┆ 0.2         ┆ long       │
#> │ 5.4          ┆ 3.9         ┆ 1.7          ┆ 0.4         ┆ long       │
#> └──────────────┴─────────────┴──────────────┴─────────────┴────────────┘
```

Since most of the work is rewriting `tidyverse` code into `polars`
syntax, `tidypolars` and `polars` have very similar performance.

<details>
<summary>
Click to see a small benchmark
</summary>

For more serious benchmarks about `polars`, take a look at [DuckDB
benchmarks](https://duckdblabs.github.io/db-benchmark/).

``` r
library(collapse, warn.conflicts = FALSE)
#> collapse 2.0.7, see ?`collapse-package` or ?`collapse-documentation`

large_iris <- data.table::rbindlist(rep(list(iris), 100000))
large_iris_pl <- as_polars_lf(large_iris)

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
      collect()
  },
  tidypolars = {
    large_iris_pl |>
      select(starts_with(c("Sep", "Pet"))) |>
      mutate(
        petal_type = ifelse((Petal.Length / Petal.Width) > 3, "long", "large")
      ) |> 
      filter(between(Sepal.Length, 4.5, 5.5)) |> 
      collect()
  },
  dplyr = {
    large_iris |>
      select(starts_with(c("Sep", "Pet"))) |>
      mutate(
        petal_type = ifelse((Petal.Length / Petal.Width) > 3, "long", "large")
      ) |>
      filter(between(Sepal.Length, 4.5, 5.5))
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
#> # A tibble: 4 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 polars     114.03ms  139.3ms     5.71    27.78KB    0    
#> 2 tidypolars 188.24ms 232.54ms     3.28    290.7KB    0.246
#> 3 dplyr         3.31s    3.52s     0.271    1.79GB    0.786
#> 4 collapse   326.57ms 405.23ms     2.50   745.96MB    2.38

# NOTE: do NOT take the "mem_alloc" results into account.
# `bench::mark()` doesn't report the accurate memory usage for packages calling
# Rust code.
```

</details>

## Contributing

Did you find some errors in the documentation? Do you want `tidypolars`
to support more functions?

Take a look at the [contributing
guide](https://tidypolars.etiennebacher.com/CONTRIBUTING.html)!
