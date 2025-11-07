# Cross join

Cross joins match each row in `x` to every row in `y`, resulting in a
dataset with `nrow(x) * nrow(y)` rows.

## Usage

``` r
# S3 method for class 'polars_data_frame'
cross_join(x, y, ..., suffix = c(".x", ".y"))

# S3 method for class 'polars_lazy_frame'
cross_join(x, y, ..., suffix = c(".x", ".y"))
```

## Arguments

- x, y:

  Two Polars Data/LazyFrames

- ...:

  Dots which should be empty.

- suffix:

  If there are non-joined duplicate variables in `x` and `y`, these
  suffixes will be added to the output to disambiguate them. Should be a
  character vector of length 2.

## Unknown arguments

Arguments that are supported by the original implementation in the
tidyverse but are not listed above will throw a warning by default if
they are specified. To change this behavior to error instead, use
`options(tidypolars_unknown_args = "error")`.

## Examples

``` r
test <- polars::pl$DataFrame(
  origin = c("ALG", "FRA", "GER"),
  year = c(2020, 2020, 2021)
)

test2 <- polars::pl$DataFrame(
  destination = c("USA", "JPN", "BRA"),
  language = c("english", "japanese", "portuguese")
)

test
#> shape: (3, 2)
#> ┌────────┬────────┐
#> │ origin ┆ year   │
#> │ ---    ┆ ---    │
#> │ str    ┆ f64    │
#> ╞════════╪════════╡
#> │ ALG    ┆ 2020.0 │
#> │ FRA    ┆ 2020.0 │
#> │ GER    ┆ 2021.0 │
#> └────────┴────────┘

test2
#> shape: (3, 2)
#> ┌─────────────┬────────────┐
#> │ destination ┆ language   │
#> │ ---         ┆ ---        │
#> │ str         ┆ str        │
#> ╞═════════════╪════════════╡
#> │ USA         ┆ english    │
#> │ JPN         ┆ japanese   │
#> │ BRA         ┆ portuguese │
#> └─────────────┴────────────┘

cross_join(test, test2)
#> shape: (9, 4)
#> ┌────────┬────────┬─────────────┬────────────┐
#> │ origin ┆ year   ┆ destination ┆ language   │
#> │ ---    ┆ ---    ┆ ---         ┆ ---        │
#> │ str    ┆ f64    ┆ str         ┆ str        │
#> ╞════════╪════════╪═════════════╪════════════╡
#> │ ALG    ┆ 2020.0 ┆ USA         ┆ english    │
#> │ ALG    ┆ 2020.0 ┆ JPN         ┆ japanese   │
#> │ ALG    ┆ 2020.0 ┆ BRA         ┆ portuguese │
#> │ FRA    ┆ 2020.0 ┆ USA         ┆ english    │
#> │ FRA    ┆ 2020.0 ┆ JPN         ┆ japanese   │
#> │ FRA    ┆ 2020.0 ┆ BRA         ┆ portuguese │
#> │ GER    ┆ 2021.0 ┆ USA         ┆ english    │
#> │ GER    ┆ 2021.0 ┆ JPN         ┆ japanese   │
#> │ GER    ┆ 2021.0 ┆ BRA         ┆ portuguese │
#> └────────┴────────┴─────────────┴────────────┘
```
