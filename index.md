# tidypolars

------------------------------------------------------------------------

ℹ️ This is the R package “tidypolars”. The Python one is here:
[markfairbanks/tidypolars](https://github.com/markfairbanks/tidypolars)

------------------------------------------------------------------------

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

Click to see a small benchmark

The main purpose of this benchmark is to show that `polars` and
`tidypolars` are close and to give an idea of the performance. For more
thorough, representative benchmarks about `polars`, take a look at
[DuckDB benchmarks](https://duckdblabs.github.io/db-benchmark/) instead.

``` r
library(collapse, warn.conflicts = FALSE)
#> collapse 2.1.5, see ?`collapse-package` or ?`collapse-documentation`
library(dplyr, warn.conflicts = FALSE)
library(dtplyr)
library(polars)
library(tidypolars)

large_iris <- data.table::rbindlist(rep(list(iris), 100000))
large_iris_pl <- as_polars_lf(large_iris)
large_iris_dt <- lazy_dt(large_iris)

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
      compute()
  },
  dplyr = {
    large_iris |>
      select(starts_with(c("Sep", "Pet"))) |>
      mutate(
        petal_type = ifelse((Petal.Length / Petal.Width) > 3, "long", "large")
      ) |>
      filter(between(Sepal.Length, 4.5, 5.5))
  },
  dtplyr = {
    large_iris_dt |>
      select(starts_with(c("Sep", "Pet"))) |>
      mutate(
        petal_type = ifelse((Petal.Length / Petal.Width) > 3, "long", "large")
      ) |>
      filter(between(Sepal.Length, 4.5, 5.5)) |>
      as.data.frame()
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
#> Warning: Some expressions had a GC in every iteration; so filtering is disabled.
#> # A tibble: 5 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 polars     140.93ms 151.97ms     6.34     2.32MB    0.158
#> 2 tidypolars 145.25ms 163.29ms     5.45     1.24MB    0.545
#> 3 dplyr         1.72s    1.88s     0.519    1.79GB    1.41
#> 4 dtplyr     751.04ms 920.18ms     1.10     1.72GB    2.97
#> 5 collapse   387.92ms 457.01ms     2.20   745.96MB    1.10

# NOTE: do NOT take the "mem_alloc" results into account.
# `bench::mark()` doesn't report the accurate memory usage for packages calling
# Rust code.
```

If you want to do your own benchmarks, please take a look at [How to
benchmark
tidypolars](https://tidypolars.etiennebacher.com/articles/how-to-benchmark)
first for some best practices.

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
remotes::install_github(
  "etiennebacher/tidypolars",
  repos = c("https://community.r-multiverse.org", 'https://cloud.r-project.org')
)
```

## Related work

Several packages have been developed to handle large data more
efficiently while keeping the `tidyverse` syntax:

- [`arrow`](https://arrow.apache.org/docs/r/): one of the closest
  alternatives to `tidypolars`. Also has lazy evaluation and query
  optimizations, uses Acero in the background to translate `dplyr` code
  and perform computations.
  - **How is tidypolars different?**: Polars (and therefore
    `tidypolars`) uses an unofficial Arrow memory specification. All
    operations are implemented (and optimized) from scratch, meaning
    that query optimizations can be very different from Acero. The list
    of R functions that are translated to the Arrow engine may also
    differ.
- [`collapse`](https://sebkrantz.github.io/collapse/): has very fast
  operations but still needs to import all data into memory, which
  prevents using larger-than-RAM datasets.
  - **How is tidypolars different?**: `tidypolars` provides lazy
    evaluation that is more memory-efficient since it doesn’t import all
    data in memory. It also provides a streaming engine to handle
    larger-than-RAM datasets.
- [`dbplyr`](https://dbplyr.tidyverse.org/): allows using `dplyr` for
  data stored in a relational database by translating R code to SQL
  queries. The performance will therefore depend on the SQL backend
  used.
  - **How is tidypolars different?**: `tidypolars` doesn’t translate R
    code to SQL but directly evaluates it with Polars.
- [`dtplyr`](https://dtplyr.tidyverse.org/): uses `data.table` in the
  background for better performance but needs to import all data in
  memory, which prevents using larger-than-RAM datasets.
  - **How is tidypolars different?**: same as for `collapse`.
- [`duckplyr`](https://duckplyr.tidyverse.org/): one of the closest
  alternatives to `tidypolars`. Uses DuckDB in the background, also
  provides lazy evaluation and query optimizations. Can perform
  operations directly on R `data.frame`s.
  - **How is tidypolars different?**: similar to `arrow`, the list of R
    functions that are optimized in Polars or DuckDB isn’t identical so
    the use case will determine which tool runs the fastest. `duckplyr`
    also relies on a fallback mechanism that will run the code in
    “standard R” if the function cannot be translated. `tidypolars` is
    more conservative and will error in this case, avoiding importing
    data that may crash the session because of its size.
- [`sparklyr`](https://spark.posit.co/): uses Apache Spark in the
  background, requires installing Spark. Can perform distributed
  processing.
  - **How is tidypolars different?**: `tidypolars` doesn’t need
    installing another tool and focuses on processing data on a single
    machine, not on distributed processing.

Therefore, if you need to handle data that is larger than memory, you
have three options: `arrow`, `duckplyr`, and `tidypolars`. The best one
will probably depend on the use case and on your constraints
(e.g. `tidypolars` is available via R-universe but isn’t on CRAN).
Regarding performance, one should refer to the [DuckDB
benchmarks](https://duckdblabs.github.io/db-benchmark/) to compare
tools. Keep in mind that accurately benchmarking data processing tools
is hard; those benchmarks give useful information but don’t necessarily
apply to all contexts.

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
