
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidypolars

------------------------------------------------------------------------

:warning: If you’re looking for the Python package “tidypolars” by Mark
Fairbanks, you’re on the wrong repo. The right one is here:
[markfairbanks/tidypolars](https://github.com/markfairbanks/tidypolars)
:warning:

------------------------------------------------------------------------

<!-- badges: start -->
<!-- badges: end -->

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
under the hood so that we don’t lose anything of its capacities.
Morevoer, the objective is to keep `tidypolars` **dependency-free** with
the exception of `polars` itself (which has no dependencies).

## General syntax

Overall, you only need to add `pl_` as a prefix to the `tidyverse`
function you’re used to. For example, `dplyr::mutate()` modifies classic
`R` dataframes, and `tidypolars::pl_mutate()` modifies `polars`’
`DataFrame`s and `LazyFrame`s.

## Example

``` r
library(polars)
library(tidypolars)

pl_test <- pl$DataFrame(iris)
pl_test
#> shape: (150, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat       │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ setosa    │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa    │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa    │
#> │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ setosa    │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …         │
#> │ 6.3          ┆ 2.5         ┆ 5.0          ┆ 1.9         ┆ virginica │
#> │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica │
#> │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica │
#> │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica │
#> └──────────────┴─────────────┴──────────────┴─────────────┴───────────┘

pl_test |> 
  pl_filter(Species == "setosa") |> 
  pl_arrange(Sepal.Width, -Sepal.Length)
#> shape: (50, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬─────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---     │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat     │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═════════╡
#> │ 4.5          ┆ 2.3         ┆ 1.3          ┆ 0.3         ┆ setosa  │
#> │ 4.4          ┆ 2.9         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> │ 5.0          ┆ 3.0         ┆ 1.6          ┆ 0.2         ┆ setosa  │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …       │
#> │ 5.8          ┆ 4.0         ┆ 1.2          ┆ 0.2         ┆ setosa  │
#> │ 5.2          ┆ 4.1         ┆ 1.5          ┆ 0.1         ┆ setosa  │
#> │ 5.5          ┆ 4.2         ┆ 1.4          ┆ 0.2         ┆ setosa  │
#> │ 5.7          ┆ 4.4         ┆ 1.5          ┆ 0.4         ┆ setosa  │
#> └──────────────┴─────────────┴──────────────┴─────────────┴─────────┘

pl_test |> 
  pl_mutate(
    Sepal.Total = Sepal.Length + Sepal.Width,
    Petal.Total = Petal.Length + Petal.Width
  ) |> 
  pl_select(ends_with("Total"))
#> shape: (150, 2)
#> ┌─────────────┬─────────────┐
#> │ Sepal.Total ┆ Petal.Total │
#> │ ---         ┆ ---         │
#> │ f64         ┆ f64         │
#> ╞═════════════╪═════════════╡
#> │ 8.6         ┆ 1.6         │
#> │ 7.9         ┆ 1.6         │
#> │ 7.9         ┆ 1.5         │
#> │ 7.7         ┆ 1.7         │
#> │ …           ┆ …           │
#> │ 8.8         ┆ 6.9         │
#> │ 9.5         ┆ 7.2         │
#> │ 9.6         ┆ 7.7         │
#> │ 8.9         ┆ 6.9         │
#> └─────────────┴─────────────┘
```

# FAQ

## Is `tidypolars` slower than `polars`?

No, or just marginally. The objective of `tidypolars` is *not* to modify
the data, simply to translate the `tidyverse` syntax to `polars` syntax.
`polars` is still in charge of doing all the data manipulations under
the hood.

Therefore, there might be minor overhead because we still need to parse
the expressions and rewrite them in `polars` syntax but this should be
extremely marginal.
