# Getting started

## Eager and lazy evaluation

Before we start writing code, it is important to understand the data
structures in `polars` and hence in `tidypolars`. To use `tidypolars`,
you need to import data as Polars `DataFrame`s or `LazyFrame`s.

A `DataFrame` is very similar to the standard R `data.frame` (or
`tibble` in the `tidyverse`). All functions that are applied to a
`DataFrame` are **eagerly** evaluated. This means that they are executed
one after the other, without knowing where in the data pipeline they are
located. Therefore, applying a function on a `DataFrame` returns another
`DataFrame` that you can directly explore.

A `LazyFrame`, on the other hand, doesn’t immediately run the functions
applied to it. Instead, the data pipeline is built but isn’t executed
until some specific functions are called (see below). This is **lazy**
evaluation, and the advantage of this approach is that it allows for
*query optimizations*.

**Eager vs Lazy: a brief example**

Suppose you have some data on several countries and several years. You
might want to sort the data by country and year, but you are only
interested in a subset of countries.

If you sort the data and then filter it, you may waste some time and
energy as sorting is much slower than filtering. But keeping track of
the optimal order of operations is hard.

Using a LazyFrame allows to bypass that: before the query is executed,
it is optimized in various ways. In this case, polars detects that a
filter is called after a sort and rearranges the code to run the filter
as early as possible and the sort afterwards. This kind of optimization
is not possible with a DataFrame, since all functions are immediately
evaluated.

For optimal performance, **it is recommended to use `LazyFrame`s** so
that your code can take advantages of all optimizations made by
`polars`.

`DataFrame`s can be used on medium-sized datasets and in cases where you
frequently want to see the data. This can be the case when you only
explore a sample of the final data that you will use.

## Importing data

With `tidypolars`, you can read files with the [various
`read_*_polars()`
functions](https://tidypolars.etiennebacher.com/reference/#import-data)
(such as
[`read_parquet_polars()`](https://tidypolars.etiennebacher.com/reference/from_parquet.md))
to import them as `DataFrame`s, or with `scan_*_polars()` functions
(such as
[`scan_parquet_polars()`](https://tidypolars.etiennebacher.com/reference/from_parquet.md))
to import them as `LazyFrame`s. There are several functions to import
various file formats, such as CSV, Parquet, or JSON.

**From R to Polars**

In some examples or some tutorials, the functions
[`as_polars_df()`](https://pola-rs.github.io/r-polars/man/as_polars_df.html)
and
[`as_polars_lf()`](https://pola-rs.github.io/r-polars/man/as_polars_lf.html)
are sometimes used to convert an existing R data.frame to a Polars
DataFrame or LazyFrame. Those are merely convenience functions to
quickly convert an existing dataset to Polars, which is useful for
showcase purposes. However, this conversion from R to Polars has some
cost and it hurts the performance.

In real-life usecases, be sure to load the data with the `read_*()` or
the `scan_*()` functions mentioned above.

## Example

Here, we’re going to use the `who` dataset that is available in the
`tidyr` package. I import it both as a classic R `data.frame` and as a
Polars `DataFrame` so that we can easily compare `dplyr` and
`tidypolars` functions.

``` r
library(polars)
library(tidypolars)
library(dplyr, warn.conflicts = FALSE)
library(tidyr, warn.conflicts = FALSE)

who_df <- tidyr::who
who_pl <- as_polars_df(tidyr::who)
```

`tidypolars` provides methods for `dplyr` and `tidyr` S3 generics. In
simpler words, it means that you can use the same functions on a Polars
`DataFrame` or `LazyFrame` as in a classic `tidyverse` workflow and it
should just work (if it doesn’t, please [open an
issue](https://github.com/etiennebacher/tidypolars/issues)). Note that
you still need to load `dplyr` and `tidyr` in your code.

Here’s an example of some `dplyr` and `tidyr` code on the classic R
`data.frame`:

``` r
who_df |>
  filter(year > 1990) |>
  drop_na(newrel_f3544) |>
  select(iso3, year, matches("^newrel(.*)_f")) |>
  arrange(iso3, year) |>
  rename_with(.fn = toupper) |>
  head()
#> # A tibble: 6 × 9
#>   ISO3   YEAR NEWREL_F014 NEWREL_F1524 NEWREL_F2534 NEWREL_F3544 NEWREL_F4554
#>   <chr> <dbl>       <dbl>        <dbl>        <dbl>        <dbl>        <dbl>
#> 1 AGO    2013         626         2644         2480         1671          991
#> 2 AIA    2013           0            0            0            0            0
#> 3 ALB    2013           5           28           34           13           18
#> 4 AND    2013           0            0            0            1            0
#> 5 ARE    2013           5            4            9            3            3
#> 6 ARG    2013         431          927          808          537          395
#> # ℹ 2 more variables: NEWREL_F5564 <dbl>, NEWREL_F65 <dbl>
```

We can simply use our Polars dataset instead:

``` r
who_pl |>
  filter(year > 1990) |>
  drop_na(newrel_f3544) |>
  select(iso3, year, matches("^newrel(.*)_f")) |>
  arrange(iso3, year) |>
  rename_with(.fn = toupper) |>
  head()
#> shape: (6, 9)
#> ┌──────┬────────┬─────────────┬────────────┬───┬────────────┬────────────┬────────────┬────────────┐
#> │ ISO3 ┆ YEAR   ┆ NEWREL_F014 ┆ NEWREL_F15 ┆ … ┆ NEWREL_F35 ┆ NEWREL_F45 ┆ NEWREL_F55 ┆ NEWREL_F65 │
#> │ ---  ┆ ---    ┆ ---         ┆ 24         ┆   ┆ 44         ┆ 54         ┆ 64         ┆ ---        │
#> │ str  ┆ f64    ┆ f64         ┆ ---        ┆   ┆ ---        ┆ ---        ┆ ---        ┆ f64        │
#> │      ┆        ┆             ┆ f64        ┆   ┆ f64        ┆ f64        ┆ f64        ┆            │
#> ╞══════╪════════╪═════════════╪════════════╪═══╪════════════╪════════════╪════════════╪════════════╡
#> │ AGO  ┆ 2013.0 ┆ 626.0       ┆ 2644.0     ┆ … ┆ 1671.0     ┆ 991.0      ┆ 481.0      ┆ 314.0      │
#> │ AIA  ┆ 2013.0 ┆ 0.0         ┆ 0.0        ┆ … ┆ 0.0        ┆ 0.0        ┆ 0.0        ┆ 0.0        │
#> │ ALB  ┆ 2013.0 ┆ 5.0         ┆ 28.0       ┆ … ┆ 13.0       ┆ 18.0       ┆ 14.0       ┆ 34.0       │
#> │ AND  ┆ 2013.0 ┆ 0.0         ┆ 0.0        ┆ … ┆ 1.0        ┆ 0.0        ┆ 0.0        ┆ 0.0        │
#> │ ARE  ┆ 2013.0 ┆ 5.0         ┆ 4.0        ┆ … ┆ 3.0        ┆ 3.0        ┆ 1.0        ┆ 6.0        │
#> │ ARG  ┆ 2013.0 ┆ 431.0       ┆ 927.0      ┆ … ┆ 537.0      ┆ 395.0      ┆ 307.0      ┆ 374.0      │
#> └──────┴────────┴─────────────┴────────────┴───┴────────────┴────────────┴────────────┴────────────┘
```

If you use a Polars `LazyFrame`, you need to call
[`compute()`](https://dplyr.tidyverse.org/reference/compute.html) at the
end of the chained expression to evaluate the query:

``` r
who_pl_lazy <- as_polars_lf(tidyr::who)

who_pl_lazy |>
  filter(year > 1990) |>
  drop_na(newrel_f3544) |>
  select(iso3, year, matches("^newrel(.*)_f")) |>
  arrange(iso3, year) |>
  rename_with(.fn = toupper) |>
  compute() |>
  head()
#> shape: (6, 9)
#> ┌──────┬────────┬─────────────┬────────────┬───┬────────────┬────────────┬────────────┬────────────┐
#> │ ISO3 ┆ YEAR   ┆ NEWREL_F014 ┆ NEWREL_F15 ┆ … ┆ NEWREL_F35 ┆ NEWREL_F45 ┆ NEWREL_F55 ┆ NEWREL_F65 │
#> │ ---  ┆ ---    ┆ ---         ┆ 24         ┆   ┆ 44         ┆ 54         ┆ 64         ┆ ---        │
#> │ str  ┆ f64    ┆ f64         ┆ ---        ┆   ┆ ---        ┆ ---        ┆ ---        ┆ f64        │
#> │      ┆        ┆             ┆ f64        ┆   ┆ f64        ┆ f64        ┆ f64        ┆            │
#> ╞══════╪════════╪═════════════╪════════════╪═══╪════════════╪════════════╪════════════╪════════════╡
#> │ AGO  ┆ 2013.0 ┆ 626.0       ┆ 2644.0     ┆ … ┆ 1671.0     ┆ 991.0      ┆ 481.0      ┆ 314.0      │
#> │ AIA  ┆ 2013.0 ┆ 0.0         ┆ 0.0        ┆ … ┆ 0.0        ┆ 0.0        ┆ 0.0        ┆ 0.0        │
#> │ ALB  ┆ 2013.0 ┆ 5.0         ┆ 28.0       ┆ … ┆ 13.0       ┆ 18.0       ┆ 14.0       ┆ 34.0       │
#> │ AND  ┆ 2013.0 ┆ 0.0         ┆ 0.0        ┆ … ┆ 1.0        ┆ 0.0        ┆ 0.0        ┆ 0.0        │
#> │ ARE  ┆ 2013.0 ┆ 5.0         ┆ 4.0        ┆ … ┆ 3.0        ┆ 3.0        ┆ 1.0        ┆ 6.0        │
#> │ ARG  ┆ 2013.0 ┆ 431.0       ┆ 927.0      ┆ … ┆ 537.0      ┆ 395.0      ┆ 307.0      ┆ 374.0      │
#> └──────┴────────┴─────────────┴────────────┴───┴────────────┴────────────┴────────────┴────────────┘
```

**Evaluate a lazy query**

Several functions trigger the evaluation of a lazy query:
[`compute()`](https://dplyr.tidyverse.org/reference/compute.html),
[`collect()`](https://dplyr.tidyverse.org/reference/compute.html),
[`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html), and
[`as_tibble()`](https://tibble.tidyverse.org/reference/as_tibble.html).
If you want to return a Polars DataFrame, use
[`compute()`](https://dplyr.tidyverse.org/reference/compute.html). If
you want to return a standard R data.frame, for example to use it in
statistical analysis, use any of the three other functions. Be aware
that if the dataset is too big compared to your available memory, this
will crash the R session.

`tidypolars` also supports many functions from `base`, `lubridate` or
`stringr`. When these are used inside
[`filter()`](https://dplyr.tidyverse.org/reference/filter.html),
[`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) or
[`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html),
`tidypolars` will automatically convert them to use the Polars engine
under the hood. Take a look at the vignette [“R and Polars
expressions”](https://tidypolars.etiennebacher.com/articles/r-and-polars-expressions)
for more information.
