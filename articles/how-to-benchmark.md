# How to benchmark tidypolars

Several blog posts and GitHub repos try to benchmark packages for
dataframe manipulation (`data.table`, `dplyr`, `duckplyr`, etc.). When
it comes to benchmarking `tidypolars`, I have seen several
implementation mistakes that make the results quite unreliable. This is
not to say that `tidypolars` will always be faster than alternatives. In
fact, there is rarely one tool that is better than all the others in all
aspects of dataframe manipulation. The goal of this vignette is to give
some advice on how best to benchmark `tidypolars`.

**Summary:** instead of this code:

``` r
my_function <- function(dat) {
  my_polars_data <- as_polars_df(dat)
  my_polars_data |>
    <some slow operation>
}

bench::mark(
  my_function(my_r_data_frame)
)
```

use this code:

``` r
my_polars_data <- as_polars_lf(my_r_data_frame)

my_function <- function(dat) {
  my_polars_data |>
    <some slow operation> |>
    compute() # or compute(engine = "streaming")
}

bench::mark(
  my_function(my_polars_data)
)
```

## Do not include `as_polars_df()` or `as_polars_lf()` in the timing

Some benchmarks do something like the following:

``` r
my_function <- function(dat) {
  dat <- as_polars_df(dat)
  dat |>
    <some slow operation>
}

bench::mark(
  my_function(my_r_data_frame)
)
```

The issue with this approach is that
[`as_polars_df()`](https://pola-rs.github.io/r-polars/man/as_polars_df.html)
converts the R `data.frame` to a Polars DataFrame, which takes some
time. As
[highlighted](https://www.tidypolars.etiennebacher.com/articles/tidypolars#importing-data)
in the “Getting started” vignette,
[`as_polars_df()`](https://pola-rs.github.io/r-polars/man/as_polars_df.html)
and
[`as_polars_lf()`](https://pola-rs.github.io/r-polars/man/as_polars_lf.html)
are convenience functions for demo and testing purposes. The recommended
way to use `tidypolars` is by using the dedicated readers
([`scan_parquet_polars()`](https://tidypolars.etiennebacher.com/reference/from_parquet.md),
[`read_parquet_polars()`](https://tidypolars.etiennebacher.com/reference/from_parquet.md),
etc.) to import the data directly as a Polars DataFrame or LazyFrame.

Using
[`as_polars_df()`](https://pola-rs.github.io/r-polars/man/as_polars_df.html)
and
[`as_polars_lf()`](https://pola-rs.github.io/r-polars/man/as_polars_lf.html)
is fine to get the data ready to be benchmarked, but those operations
should not be included in the timing.

## Use lazy execution when possible

Polars provides DataFrames and LazyFrames. Operations on DataFrames are
executed in “eager mode”, meaning that there is no optimization
happening behind the scenes, for instance to efficiently reorder
operations. In real-life workflows, it is strongly recommended to use
LazyFrames since they allow for a large number of optimizations.

In benchmarks or demos, you should therefore prefer
[`as_polars_lf()`](https://pola-rs.github.io/r-polars/man/as_polars_lf.html)
over
[`as_polars_df()`](https://pola-rs.github.io/r-polars/man/as_polars_df.html).
Using LazyFrames means that you also need to collect results to trigger
computation. This can be done using
[`compute()`](https://dplyr.tidyverse.org/reference/compute.html) (to
return a Polars DataFrame),
[`collect()`](https://dplyr.tidyverse.org/reference/compute.html) (to
return an R `data.frame`), or
[`as_tibble()`](https://tibble.tidyverse.org/reference/as_tibble.html)
(to return a `tibble`).

Depending on the objective of the benchmark, each of the three options
can be valid.
[`compute()`](https://dplyr.tidyverse.org/reference/compute.html) is
faster because it avoids the extra step of converting a Polars DataFrame
to R. However, the output of
[`compute()`](https://dplyr.tidyverse.org/reference/compute.html) cannot
be passed directly to `ggplot2`, for example.

In summary, instead of doing:

``` r
my_polars_data <- as_polars_df(my_r_data_frame)

my_function <- function(dat) {
  my_polars_data |>
    <some slow operation>
}

bench::mark(
  my_function(my_polars_data)
)
```

you should do:

``` r
my_polars_data <- as_polars_lf(my_r_data_frame) # Use as_polars_lf()

my_function <- function(dat) {
  my_polars_data |>
    <some slow operation> |>
    compute() # Or collect() or as_tibble()
}

bench::mark(
  my_function(my_polars_data)
)
```

## Use streaming mode when possible

In addition to lazy execution, Polars comes with a streaming engine that
is able to perform operations on larger-than-RAM data. It is also faster
than the default engine in many cases, not just with larger-than-RAM
data.

**Note:** at the time of writing (August 2025), the streaming engine is
not yet used by default, but it should become the default in the next
few months.

Using it is extremely simple: pass `engine = "streaming"` in
[`compute()`](https://dplyr.tidyverse.org/reference/compute.html),
[`collect()`](https://dplyr.tidyverse.org/reference/compute.html) or
[`as_tibble()`](https://tibble.tidyverse.org/reference/as_tibble.html).

## Do not try to run tidypolars in parallel

Some benchmarks take advantage of tools such as `future` or `mirai` to
run code in parallel. However, `tidypolars` shouldn’t be used with such
tools. All `polars` code that is used internally is already optimized to
run on all cores and isn’t guaranteed to play well with other parallel
frameworks.

In [some
cases](https://pola-rs.github.io/r-polars/vignettes/custom-functions.html#using-purrr),
you may want to use those frameworks on Polars objects, but this should
be the exception rather than the rule.
