
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidypolars

------------------------------------------------------------------------

:warning: If you’re looking for the Python package “tidypolars”, you’re
on the wrong repo. The right one is here:
[markfairbanks/tidypolars](https://github.com/markfairbanks/tidypolars)
:warning:

------------------------------------------------------------------------

<!-- * [Motivation](#motivation)  -->
<!-- * [General syntax](#general-syntax)  -->
<!-- * [Example](#example) -->

## Motivation

`polars` (both the Rust source and the R implementation) are amazing
packages. I won’t argue here for the interest of using `polars`, there
are already a lot of resources on [its
website](https://rpolars.github.io/).

One characteristic of `polars` is that its syntax is 1) extremely
verbose, and 2) very close to the `pandas` syntax in Python. While this
makes it quite easy to read, it is **yet another syntax to learn** for R
users that are accustomed so far to either base R, `data.table` or the
`tidyverse`.

The objective of `tidypolars` is to **provide functions that are very
close to the `tidyverse` ones** but that call the `polars` functions
under the hood so that we don’t lose any of its capacities. Moreover,
the objective is to keep `tidypolars` **dependency-free** with the
exception of `polars` itself (which has no dependencies).

## Example

Suppose you already have some code that uses `dplyr`:

``` r
library(dplyr, warn.conflicts = FALSE)

iris |> 
  select(starts_with(c("Sep", "Pet"))) |> 
  mutate(
    petal_type = ifelse((Petal.Length / Petal.Width) > 3, "long", "large")
  ) |> 
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
  select(starts_with("Sep", "Pet")) |> 
  mutate(
    petal_type = ifelse((Petal.Length / Petal.Width) > 3, "long", "large")
  ) |> 
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
  )
#> shape: (150, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬────────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ petal_type │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---        │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ str        │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪════════════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ long       │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ long       │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ long       │
#> │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ long       │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …          │
#> │ 6.3          ┆ 2.5         ┆ 5.0          ┆ 1.9         ┆ large      │
#> │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ large      │
#> │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ large      │
#> │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ large      │
#> └──────────────┴─────────────┴──────────────┴─────────────┴────────────┘
```

<!-- Don't be worry about losing performance compared to the pure `polars` syntax, -->
<!-- `tidypolars` is just as fast: -->
<!-- ```{r} -->
<!-- library(dplyr, warn.conflicts = FALSE) -->
<!-- large_iris <- data.table::rbindlist(rep(list(iris), 100000)) -->
<!-- bench::mark( -->
<!--   polars = { -->
<!--     pl$DataFrame(large_iris)$ -->
<!--       select(c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"))$ -->
<!--       with_columns( -->
<!--         pl$when( -->
<!--           (pl$col("Petal.Length") / pl$col("Petal.Width") > 3) -->
<!--         )$then("long")$ -->
<!--           otherwise("large")$ -->
<!--           alias("petal_type") -->
<!--       ) -->
<!--   },  -->
<!--   tidypolars = { -->
<!--     large_iris |>  -->
<!--       as_polars() |>  -->
<!--       pl_select(starts_with("Sep", "Pet")) |>  -->
<!--       pl_mutate( -->
<!--         petal_type = ifelse((Petal.Length / Petal.Width) > 3, "long", "large") -->
<!--       ) -->
<!--   }, -->
<!--   dplyr = { -->
<!--     large_iris |>  -->
<!--       select(starts_with(c("Sep", "Pet"))) |>  -->
<!--       mutate( -->
<!--         petal_type = ifelse((Petal.Length / Petal.Width) > 3, "long", "large") -->
<!--       ) -->
<!--   }, -->
<!--   check = FALSE, -->
<!--   iterations = 10 -->
<!-- ) -->
<!-- ``` -->

Finally, if you want to use `polars` because it’s low-dependency
(regarding how many R packages it imports), then `tidypolars` is also
for you!

All functions above can be used separately from any `tidyverse` package
by adding the `pl_` prefix. For example, you can use `pl_mutate()` or
`pl_filter()` like the other functions without having to download and
import `tidyverse` packages.
