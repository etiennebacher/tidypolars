# Mutating joins

Mutating joins add columns from `y` to `x`, matching observations based
on the keys.

## Usage

``` r
# S3 method for class 'polars_data_frame'
left_join(
  x,
  y,
  by = NULL,
  copy = FALSE,
  suffix = c(".x", ".y"),
  ...,
  keep = NULL,
  na_matches = "na",
  relationship = NULL
)

# S3 method for class 'polars_data_frame'
right_join(
  x,
  y,
  by = NULL,
  copy = FALSE,
  suffix = c(".x", ".y"),
  ...,
  keep = NULL,
  na_matches = "na",
  relationship = NULL
)

# S3 method for class 'polars_data_frame'
full_join(
  x,
  y,
  by = NULL,
  copy = FALSE,
  suffix = c(".x", ".y"),
  ...,
  keep = NULL,
  na_matches = "na",
  relationship = NULL
)

# S3 method for class 'polars_data_frame'
inner_join(
  x,
  y,
  by = NULL,
  copy = FALSE,
  suffix = c(".x", ".y"),
  ...,
  keep = NULL,
  na_matches = "na",
  relationship = NULL
)

# S3 method for class 'polars_lazy_frame'
left_join(
  x,
  y,
  by = NULL,
  copy = FALSE,
  suffix = c(".x", ".y"),
  ...,
  keep = NULL,
  na_matches = "na",
  relationship = NULL
)

# S3 method for class 'polars_lazy_frame'
right_join(
  x,
  y,
  by = NULL,
  copy = FALSE,
  suffix = c(".x", ".y"),
  ...,
  keep = NULL,
  na_matches = "na",
  relationship = NULL
)

# S3 method for class 'polars_lazy_frame'
full_join(
  x,
  y,
  by = NULL,
  copy = FALSE,
  suffix = c(".x", ".y"),
  ...,
  keep = NULL,
  na_matches = "na",
  relationship = NULL
)

# S3 method for class 'polars_lazy_frame'
inner_join(
  x,
  y,
  by = NULL,
  copy = FALSE,
  suffix = c(".x", ".y"),
  ...,
  keep = NULL,
  na_matches = "na",
  relationship = NULL
)
```

## Arguments

- x, y:

  Two Polars Data/LazyFrames

- by:

  Variables to join by. If `NULL` (default), `*_join()` will perform a
  natural join, using all variables in common across `x` and `y`. A
  message lists the variables so that you can check they're correct;
  suppress the message by supplying `by` explicitly.

  `by` can take a character vector, like `c("x", "y")` if `x` and `y`
  are in both datasets. To join on variables that don't have the same
  name, use equalities in the character vector, like
  `c("x1" = "x2", "y")`. If you use a character vector, the join can
  only be done using strict equality.

  `by` can also be a specification created by
  [`dplyr::join_by()`](https://dplyr.tidyverse.org/reference/join_by.html).
  Contrary to the input as character vector shown above,
  [`join_by()`](https://dplyr.tidyverse.org/reference/join_by.html) uses
  unquoted column names, e.g `join_by(x1 == x2, y)`.

  Finally,
  [`inner_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html)
  also supports inequality joins, e.g. `join_by(x1 >= x2)`, and the
  helpers
  [`between()`](https://dplyr.tidyverse.org/reference/between.html),
  `overlaps()`, and [`within()`](https://rdrr.io/r/base/with.html). See
  the documentation of
  [`dplyr::join_by()`](https://dplyr.tidyverse.org/reference/join_by.html)
  for more information. Other join types will likely support inequality
  joins in the future.

- copy, keep:

  Not supported.

- suffix:

  If there are non-joined duplicate variables in `x` and `y`, these
  suffixes will be added to the output to disambiguate them. Should be a
  character vector of length 2.

- ...:

  Dots which should be empty.

- na_matches:

  Should two `NA` values match?

  - `"na"`, the default, treats two `NA` values as equal.

  - `"never"` treats two `NA` values as different and will never match
    them together or to any other values.

  Note that when joining Polars Data/LazyFrames, `NaN` are always
  considered equal, no matter the value of `na_matches`. This differs
  from the original `dplyr` implementation.

- relationship:

  Handling of the expected relationship between the keys of `x` and `y`.
  Must be one of the following:

  - `NULL`, the default, is equivalent to `"many-to-many"`. It doesn't
    expect any relationship between `x` and `y`.

  - `"one-to-one"` expects each row in `x` to match at most 1 row in `y`
    and each row in `y` to match at most 1 row in `x`.

  - `"one-to-many"` expects each row in `y` to match at most 1 row in
    `x`.

  - `"many-to-one"` expects each row in `x` matches at most 1 row in
    `y`.

## Unknown arguments

Arguments that are supported by the original implementation in the
tidyverse but are not listed above will throw a warning by default if
they are specified. To change this behavior to error instead, use
`options(tidypolars_unknown_args = "error")`.

## Examples

``` r
test <- polars::pl$DataFrame(
  x = c(1, 2, 3),
  y1 = c(1, 2, 3),
  z = c(1, 2, 3)
)

test2 <- polars::pl$DataFrame(
  x = c(1, 2, 4),
  y2 = c(1, 2, 4),
  z2 = c(4, 5, 7)
)

test
#> shape: (3, 3)
#> ┌─────┬─────┬─────┐
#> │ x   ┆ y1  ┆ z   │
#> │ --- ┆ --- ┆ --- │
#> │ f64 ┆ f64 ┆ f64 │
#> ╞═════╪═════╪═════╡
#> │ 1.0 ┆ 1.0 ┆ 1.0 │
#> │ 2.0 ┆ 2.0 ┆ 2.0 │
#> │ 3.0 ┆ 3.0 ┆ 3.0 │
#> └─────┴─────┴─────┘

test2
#> shape: (3, 3)
#> ┌─────┬─────┬─────┐
#> │ x   ┆ y2  ┆ z2  │
#> │ --- ┆ --- ┆ --- │
#> │ f64 ┆ f64 ┆ f64 │
#> ╞═════╪═════╪═════╡
#> │ 1.0 ┆ 1.0 ┆ 4.0 │
#> │ 2.0 ┆ 2.0 ┆ 5.0 │
#> │ 4.0 ┆ 4.0 ┆ 7.0 │
#> └─────┴─────┴─────┘

# default is to use common columns, here "x" only
left_join(test, test2)
#> Joining by `x`
#> shape: (3, 5)
#> ┌─────┬─────┬─────┬──────┬──────┐
#> │ x   ┆ y1  ┆ z   ┆ y2   ┆ z2   │
#> │ --- ┆ --- ┆ --- ┆ ---  ┆ ---  │
#> │ f64 ┆ f64 ┆ f64 ┆ f64  ┆ f64  │
#> ╞═════╪═════╪═════╪══════╪══════╡
#> │ 1.0 ┆ 1.0 ┆ 1.0 ┆ 1.0  ┆ 4.0  │
#> │ 2.0 ┆ 2.0 ┆ 2.0 ┆ 2.0  ┆ 5.0  │
#> │ 3.0 ┆ 3.0 ┆ 3.0 ┆ null ┆ null │
#> └─────┴─────┴─────┴──────┴──────┘

# we can specify the columns on which to join with join_by()...
left_join(test, test2, by = join_by(x, y1 == y2))
#> shape: (3, 4)
#> ┌─────┬─────┬─────┬──────┐
#> │ x   ┆ y1  ┆ z   ┆ z2   │
#> │ --- ┆ --- ┆ --- ┆ ---  │
#> │ f64 ┆ f64 ┆ f64 ┆ f64  │
#> ╞═════╪═════╪═════╪══════╡
#> │ 1.0 ┆ 1.0 ┆ 1.0 ┆ 4.0  │
#> │ 2.0 ┆ 2.0 ┆ 2.0 ┆ 5.0  │
#> │ 3.0 ┆ 3.0 ┆ 3.0 ┆ null │
#> └─────┴─────┴─────┴──────┘

# ... or with a character vector
left_join(test, test2, by = c("x", "y1" = "y2"))
#> shape: (3, 4)
#> ┌─────┬─────┬─────┬──────┐
#> │ x   ┆ y1  ┆ z   ┆ z2   │
#> │ --- ┆ --- ┆ --- ┆ ---  │
#> │ f64 ┆ f64 ┆ f64 ┆ f64  │
#> ╞═════╪═════╪═════╪══════╡
#> │ 1.0 ┆ 1.0 ┆ 1.0 ┆ 4.0  │
#> │ 2.0 ┆ 2.0 ┆ 2.0 ┆ 5.0  │
#> │ 3.0 ┆ 3.0 ┆ 3.0 ┆ null │
#> └─────┴─────┴─────┴──────┘

# we can customize the suffix of common column names not used to join
test2 <- polars::pl$DataFrame(
  x = c(1, 2, 4),
  y1 = c(1, 2, 4),
  z = c(4, 5, 7)
)

left_join(test, test2, by = "x", suffix = c("_left", "_right"))
#> shape: (3, 5)
#> ┌─────┬─────────┬────────┬──────────┬─────────┐
#> │ x   ┆ y1_left ┆ z_left ┆ y1_right ┆ z_right │
#> │ --- ┆ ---     ┆ ---    ┆ ---      ┆ ---     │
#> │ f64 ┆ f64     ┆ f64    ┆ f64      ┆ f64     │
#> ╞═════╪═════════╪════════╪══════════╪═════════╡
#> │ 1.0 ┆ 1.0     ┆ 1.0    ┆ 1.0      ┆ 4.0     │
#> │ 2.0 ┆ 2.0     ┆ 2.0    ┆ 2.0      ┆ 5.0     │
#> │ 3.0 ┆ 3.0     ┆ 3.0    ┆ null     ┆ null    │
#> └─────┴─────────┴────────┴──────────┴─────────┘

# the argument "relationship" ensures the join matches the expectation
country <- polars::pl$DataFrame(
  iso = c("FRA", "DEU"),
  value = 1:2
)
country
#> shape: (2, 2)
#> ┌─────┬───────┐
#> │ iso ┆ value │
#> │ --- ┆ ---   │
#> │ str ┆ i32   │
#> ╞═════╪═══════╡
#> │ FRA ┆ 1     │
#> │ DEU ┆ 2     │
#> └─────┴───────┘

country_year <- polars::pl$DataFrame(
  iso = rep(c("FRA", "DEU"), each = 2),
  year = rep(2019:2020, 2),
  value2 = 3:6
)
country_year
#> shape: (4, 3)
#> ┌─────┬──────┬────────┐
#> │ iso ┆ year ┆ value2 │
#> │ --- ┆ ---  ┆ ---    │
#> │ str ┆ i32  ┆ i32    │
#> ╞═════╪══════╪════════╡
#> │ FRA ┆ 2019 ┆ 3      │
#> │ FRA ┆ 2020 ┆ 4      │
#> │ DEU ┆ 2019 ┆ 5      │
#> │ DEU ┆ 2020 ┆ 6      │
#> └─────┴──────┴────────┘

# We expect that each row in "x" matches only one row in "y" but, it's not
# true as each row of "x" matches two rows of "y"
tryCatch(
  left_join(country, country_year, join_by(iso), relationship = "one-to-one"),
  error = function(e) e
)
#> <error/rlang_error>
#> Error in `x$join()`:
#> ! Evaluation failed in `$join()`.
#> Caused by error:
#> ! Evaluation failed in `$collect()`.
#> Caused by error:
#> ! join keys did not fulfill 1:1 validation
#> ---
#> Backtrace:
#>      ▆
#>   1. └─pkgdown::build_site_github_pages(new_process = FALSE, install = TRUE)
#>   2.   └─pkgdown::build_site(...)
#>   3.     └─pkgdown:::build_site_local(...)
#>   4.       └─pkgdown::build_reference(...)
#>   5.         ├─pkgdown:::unwrap_purrr_error(...)
#>   6.         │ └─base::withCallingHandlers(...)
#>   7.         └─purrr::map(...)
#>   8.           └─purrr:::map_("list", .x, .f, ..., .progress = .progress)
#>   9.             ├─purrr:::with_indexed_errors(...)
#>  10.             │ └─base::withCallingHandlers(...)
#>  11.             ├─purrr:::call_with_cleanup(...)
#>  12.             └─pkgdown (local) .f(.x[[i]], ...)
#>  13.               ├─base::withCallingHandlers(...)
#>  14.               └─pkgdown:::data_reference_topic(...)
#>  15.                 └─pkgdown:::run_examples(...)
#>  16.                   └─pkgdown:::highlight_examples(code, topic, env = env)
#>  17.                     └─downlit::evaluate_and_highlight(...)
#>  18.                       └─evaluate::evaluate(code, child_env(env), new_device = TRUE, output_handler = output_handler)
#>  19.                         ├─base::withRestarts(...)
#>  20.                         │ └─base (local) withRestartList(expr, restarts)
#>  21.                         │   ├─base (local) withOneRestart(withRestartList(expr, restarts[-nr]), restarts[[nr]])
#>  22.                         │   │ └─base (local) doWithOneRestart(return(expr), restart)
#>  23.                         │   └─base (local) withRestartList(expr, restarts[-nr])
#>  24.                         │     └─base (local) withOneRestart(expr, restarts[[1L]])
#>  25.                         │       └─base (local) doWithOneRestart(return(expr), restart)
#>  26.                         ├─evaluate:::with_handlers(...)
#>  27.                         │ ├─base::eval(call)
#>  28.                         │ │ └─base::eval(call)
#>  29.                         │ └─base::withCallingHandlers(...)
#>  30.                         ├─base::withVisible(eval(expr, envir))
#>  31.                         └─base::eval(expr, envir)
#>  32.                           └─base::eval(expr, envir)
#>  33.                             ├─base::tryCatch(...)
#>  34.                             │ └─base (local) tryCatchList(expr, classes, parentenv, handlers)
#>  35.                             │   └─base (local) tryCatchOne(expr, names, parentenv, handlers[[1L]])
#>  36.                             │     └─base (local) doTryCatch(return(expr), name, parentenv, handler)
#>  37.                             ├─dplyr::left_join(country, country_year, join_by(iso), relationship = "one-to-one")
#>  38.                             └─tidypolars:::left_join.polars_data_frame(...)
#>  39.                               └─tidypolars:::join_(...)
#>  40.                                 └─x$join(...)
#>  41.                                   ├─polars:::wrap(...)
#>  42.                                   │ └─rlang::try_fetch(...)
#>  43.                                   │   ├─base::tryCatch(...)
#>  44.                                   │   │ └─base (local) tryCatchList(expr, classes, parentenv, handlers)
#>  45.                                   │   │   └─base (local) tryCatchOne(expr, names, parentenv, handlers[[1L]])
#>  46.                                   │   │     └─base (local) doTryCatch(return(expr), name, parentenv, handler)
#>  47.                                   │   └─base::withCallingHandlers(...)
#>  48.                                   └─self$lazy()$join(other = other$lazy(), left_on = left_on, right_on = right_on, ...
#>  49.                                     ├─polars:::wrap(...)
#>  50.                                     │ └─rlang::try_fetch(...)
#>  51.                                     │   ├─base::tryCatch(...)
#>  52.                                     │   │ └─base (local) tryCatchList(expr, classes, parentenv, handlers)
#>  53.                                     │   │   └─base (local) tryCatchOne(expr, names, parentenv, handlers[[1L]])
#>  54.                                     │   │     └─base (local) doTryCatch(return(expr), name, parentenv, handler)
#>  55.                                     │   └─base::withCallingHandlers(...)
#>  56.                                     └─ldf$collect(engine)
#>  57.                                       └─polars:::.savvy_wrap_PlRDataFrame(...)

# A correct expectation would be "one-to-many":
left_join(country, country_year, join_by(iso), relationship = "one-to-many")
#> shape: (4, 4)
#> ┌─────┬───────┬──────┬────────┐
#> │ iso ┆ value ┆ year ┆ value2 │
#> │ --- ┆ ---   ┆ ---  ┆ ---    │
#> │ str ┆ i32   ┆ i32  ┆ i32    │
#> ╞═════╪═══════╪══════╪════════╡
#> │ FRA ┆ 1     ┆ 2019 ┆ 3      │
#> │ FRA ┆ 1     ┆ 2020 ┆ 4      │
#> │ DEU ┆ 2     ┆ 2019 ┆ 5      │
#> │ DEU ┆ 2     ┆ 2020 ┆ 6      │
#> └─────┴───────┴──────┴────────┘
```
