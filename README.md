
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidypolars

<!-- badges: start -->
<!-- badges: end -->

`polars` (both the Rust source and the R implementation) are amazing
packages. I won’t argue here for the interest of using `polars`, there
are already a lot of resources of [its website]().

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
  pl_arrange(Sepal.Width, -Sepal.Length) |> 
  pl_select(starts_with("Sepal"))
#> shape: (50, 2)
#> ┌──────────────┬─────────────┐
#> │ Sepal.Length ┆ Sepal.Width │
#> │ ---          ┆ ---         │
#> │ f64          ┆ f64         │
#> ╞══════════════╪═════════════╡
#> │ 4.5          ┆ 2.3         │
#> │ 4.4          ┆ 2.9         │
#> │ 5.0          ┆ 3.0         │
#> │ 4.9          ┆ 3.0         │
#> │ …            ┆ …           │
#> │ 5.8          ┆ 4.0         │
#> │ 5.2          ┆ 4.1         │
#> │ 5.5          ┆ 4.2         │
#> │ 5.7          ┆ 4.4         │
#> └──────────────┴─────────────┘
```
