
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidypolars

------------------------------------------------------------------------

:warning: If you’re looking for the Python package “tidypolars”, you’re
on the wrong repo. The right one is here:
[markfairbanks/tidypolars](https://github.com/markfairbanks/tidypolars)
:warning:

------------------------------------------------------------------------

## Installation

`tidypolars` is built on `polars`, which is not available on CRAN for
now. This means that `tidypolars` can’t be on CRAN for now.

That said, you can install `tidypolars` with `remotes` or `pak`.
Depending on your OS, the procedure is slightly different.

### Windows or macOS

``` r
# install.packages("remotes")
remotes::install_github(
  "etiennebacher/tidypolars", 
  repos = c("https://rpolars.r-universe.dev", getOption("repos"))
)

# OR 

# install.packages("pak")
pak::repo_add("https://rpolars.r-universe.dev")
pak::pkg_install("etiennebacher/tidypolars")
```

### Linux

``` r
# install.packages("remotes")
remotes::install_github(
  "etiennebacher/tidypolars", 
  repos = c("https://rpolars.r-universe.dev/bin/linux/jammy/4.3", getOption("repos"))
)

# OR 

# install.packages("pak")
pak::repo_add("https://rpolars.r-universe.dev/bin/linux/jammy/4.3")
pak::pkg_install("etiennebacher/tidypolars")
```

## Motivation

`polars` (both the Rust source and the R implementation) are amazing
packages. I won’t argue here for the interest of using `polars`, there
are already a lot of resources on [its
website](https://rpolars.github.io/).

One characteristic of `polars` is that its syntax is 1) quite verbose,
and 2) very close to the `pandas` syntax in Python. While this makes it
easy to read, it is **yet another syntax to learn** for R users that are
accustomed so far to either base R, `data.table` or the `tidyverse`.

The objective of `tidypolars` is to **provide functions that are very
close to the `tidyverse` ones** but that call the `polars` functions
under the hood so that we don’t lose any of its capacities.

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

iris |> 
  as_polars() |> 
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
#> Warning: le package 'polars' a été compilé avec la version R 4.3.1

# polars syntax
pl$DataFrame(iris)$
  select(c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"))$
  with_columns(
    pl$when(
      (pl$col("Petal.Length") / pl$col("Petal.Width") > 3)
    )$then("long")$
      otherwise("large")$
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

Don’t worry about losing performance compared to the pure `polars`
syntax, `tidypolars` is just as fast:

``` r
large_iris <- data.table::rbindlist(rep(list(iris), 50000))
large_iris_pl <- as_polars(large_iris, lazy = TRUE)

bench::mark(
  polars = {
    large_iris_pl$
      select(c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"))$
      with_columns(
        pl$when(
          (pl$col("Petal.Length") / pl$col("Petal.Width") > 3)
        )$then("long")$
          otherwise("large")$
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
  check = FALSE,
  iterations = 10
)
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 polars     163.43ms 172.99ms     5.68     25.6KB     0   
#> 2 tidypolars  192.9ms  227.7ms     4.15     96.2KB     0   
#> 3 dplyr         1.15s    1.29s     0.731   916.7MB     2.78
```
