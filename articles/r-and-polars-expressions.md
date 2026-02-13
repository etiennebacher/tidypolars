# R and Polars expressions

When we use the `tidyverse`, we use R expressions in mainly three
places: [`filter()`](https://dplyr.tidyverse.org/reference/filter.html),
[`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html), and
[`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html).

``` r
library(dplyr, warn.conflicts = FALSE)

filter(mtcars, am + gear > carb)
mutate(mtcars, x = (qsec - mean(qsec)) / sd(qsec))
mtcars |>
  group_by(cyl) |>
  summarize(x = mean(qsec) / sd(qsec))
```

This is very convenient but creates a challenge for `tidypolars`. While
it is possible to convert a Polars Data/LazyFrame to an R `data.frame`,
apply functions on it and then convert it back to Polars, it is strongly
discouraged to do so because it doesn’t take advantage of Polars
optimizations.

Indeed, Polars comes with dozens of built-in functions for maths
(`median`, `var`, `arccos`, …), string manipulation (`len_chars`,
`starts`, …), and date-time (`hour`, `quarter`, `ordinal_day`, …). All
of these functions are optimized internally and are ran in parallel
under the hood, which will not be the case if we pass R functions.

However, using these Polars expressions would imply that we need to
learn these new functions and this new syntax. To avoid doing that,
`tidypolars` will automatically translate R expressions into Polars
ones. Basically, **you can keep writing R expressions in most
situations**, and they will automatically be translated to Polars
syntax.

However, there are some situations where this might not work, so this
vignette explains the process and the limitations.

## How does `tidypolars` translate R expressions into Polars expressions?

When `tidypolars` receives an expression, it runs a function
`translate()` several times until all components are translated to their
Polars equivalent. There are four possible components: single values,
column names, external objects, and functions.

### Single values, column names, and external objects

If you pass a single value, like `x = 1` or `x = "a"`, it is wrapped
into `pl$lit()`. This is also the case for external objects with the
difference that these need to be wrapped in `{{ }}` and are evaluated
before being wrapped into `pl$lit()`.

Column names, like `x = mpg`, are wrapped into `pl$col()`.

    x = "a"               ->  x = pl$lit("a")
    x = {{ some_value }}  ->  x = pl$lit(*value*)
    x = mpg               ->  x = pl$col("mpg")

### Functions

Functions are split into two categories: built-in functions (i.e
functions provided by base R or by other packages), and user-defined
functions (UDF) that are written by the user (you).

#### Built-in functions

In the first case, `tidypolars` checks the function name and whether it
has already been translated internally. For example, if we call the R
function `mean(x, trim = 2)`, then it looks for a translation of
[`mean()`](https://rdrr.io/r/base/mean.html). You can see the list of
supported R functions at the bottom of this vignette. Note that most of
essential base R functions are supported, as well as many functions from
`dplyr` or from `stringr` for example.

Now that `tidypolars` knows that a translation of
[`mean()`](https://rdrr.io/r/base/mean.html) exists, it parses the
arguments in the call to translate them to the Polars syntax:
internally, `x` is converted to `pl$col("x")` if there is a column `"x"`
in the data. Sometimes, additional arguments do not have an equivalent
in Polars. This is the case for the argument `trim` here. In this case,
`tidypolars` ignores this argument and warns the user:

``` r
library(tidypolars)
library(polars)

mtcars |>
  as_polars_df() |>
  mutate(x = mean(mpg, trim = 2))
#> Warning: tidypolars doesn't know how to use some arguments of `mean()`.
#> ℹ The following argument(s) will be ignored: "trim".
#> shape: (32, 12)
#> ┌──────┬─────┬───────┬───────┬───┬─────┬──────┬──────┬───────────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ am  ┆ gear ┆ carb ┆ x         │
#> │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ ---  ┆ ---  ┆ ---       │
#> │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64  ┆ f64  ┆ f64       │
#> ╞══════╪═════╪═══════╪═══════╪═══╪═════╪══════╪══════╪═══════════╡
#> │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 4.0  ┆ 20.090625 │
#> │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 4.0  ┆ 20.090625 │
#> │ 22.8 ┆ 4.0 ┆ 108.0 ┆ 93.0  ┆ … ┆ 1.0 ┆ 4.0  ┆ 1.0  ┆ 20.090625 │
#> │ 21.4 ┆ 6.0 ┆ 258.0 ┆ 110.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 1.0  ┆ 20.090625 │
#> │ 18.7 ┆ 8.0 ┆ 360.0 ┆ 175.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 2.0  ┆ 20.090625 │
#> │ …    ┆ …   ┆ …     ┆ …     ┆ … ┆ …   ┆ …    ┆ …    ┆ …         │
#> │ 30.4 ┆ 4.0 ┆ 95.1  ┆ 113.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 2.0  ┆ 20.090625 │
#> │ 15.8 ┆ 8.0 ┆ 351.0 ┆ 264.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 4.0  ┆ 20.090625 │
#> │ 19.7 ┆ 6.0 ┆ 145.0 ┆ 175.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 6.0  ┆ 20.090625 │
#> │ 15.0 ┆ 8.0 ┆ 301.0 ┆ 335.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 8.0  ┆ 20.090625 │
#> │ 21.4 ┆ 4.0 ┆ 121.0 ┆ 109.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 2.0  ┆ 20.090625 │
#> └──────┴─────┴───────┴───────┴───┴─────┴──────┴──────┴───────────┘
```

This behavior [can be
changed](https://tidypolars.etiennebacher.com/reference/tidypolars-options.html)
to throw an error instead.

#### User-defined functions

User-defined functions (UDF) are more challenging. Indeed, it is
technically possible to inspect the code inside a UDF, but rewriting it
to match Polars syntax would be extremely complicated. In this
situation, you will have to rewrite your custom function using Polars
syntax so that it returns a Polars expression. For example, we could
make a function to standardize a column like this:

``` r
pl_standardize <- function(x) {
  (x - x$mean()) / x$std()
}
```

Remember that the column name used as `x` will end up wrapped into
`pl$col()`, so to check that your function returns a Polars expression,
you have to provide a `pl$col()` call:

``` r
pl_standardize(pl$col("mpg"))
#> [([(col("mpg")) - (col("mpg").mean())]) / (col("mpg").std())]
```

This function correctly returns a Polars expression, so we can now use
it like any other function:

``` r
mtcars |>
  as_polars_df() |>
  mutate(x = pl_standardize(mpg))
#> shape: (32, 12)
#> ┌──────┬─────┬───────┬───────┬───┬─────┬──────┬──────┬───────────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ am  ┆ gear ┆ carb ┆ x         │
#> │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ ---  ┆ ---  ┆ ---       │
#> │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64  ┆ f64  ┆ f64       │
#> ╞══════╪═════╪═══════╪═══════╪═══╪═════╪══════╪══════╪═══════════╡
#> │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 4.0  ┆ 0.150885  │
#> │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 4.0  ┆ 0.150885  │
#> │ 22.8 ┆ 4.0 ┆ 108.0 ┆ 93.0  ┆ … ┆ 1.0 ┆ 4.0  ┆ 1.0  ┆ 0.449543  │
#> │ 21.4 ┆ 6.0 ┆ 258.0 ┆ 110.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 1.0  ┆ 0.217253  │
#> │ 18.7 ┆ 8.0 ┆ 360.0 ┆ 175.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 2.0  ┆ -0.230735 │
#> │ …    ┆ …   ┆ …     ┆ …     ┆ … ┆ …   ┆ …    ┆ …    ┆ …         │
#> │ 30.4 ┆ 4.0 ┆ 95.1  ┆ 113.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 2.0  ┆ 1.710547  │
#> │ 15.8 ┆ 8.0 ┆ 351.0 ┆ 264.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 4.0  ┆ -0.711907 │
#> │ 19.7 ┆ 6.0 ┆ 145.0 ┆ 175.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 6.0  ┆ -0.064813 │
#> │ 15.0 ┆ 8.0 ┆ 301.0 ┆ 335.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 8.0  ┆ -0.844644 │
#> │ 21.4 ┆ 4.0 ┆ 121.0 ┆ 109.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 2.0  ┆ 0.217253  │
#> └──────┴─────┴───────┴───────┴───┴─────┴──────┴──────┴───────────┘
```

#### Special case: `across()`

[`across()`](https://dplyr.tidyverse.org/reference/across.html) is a
very useful function that applies a function (or a list of functions) to
a selection of columns. It accepts built-in functions, UDFs, and
anonymous functions.

``` r
mtcars |>
  as_polars_df() |>
  mutate(
    across(
      .cols = contains("a"),
      list(mean = mean, stand = pl_standardize, ~ sd(.x))
    )
  )
#> shape: (32, 23)
#> ┌──────┬─────┬───────┬───────┬───┬──────────┬───────────┬────────────┬────────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ gear_3   ┆ carb_mean ┆ carb_stand ┆ carb_3 │
#> │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ ---      ┆ ---       ┆ ---        ┆ ---    │
#> │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64      ┆ f64       ┆ f64        ┆ f64    │
#> ╞══════╪═════╪═══════╪═══════╪═══╪══════════╪═══════════╪════════════╪════════╡
#> │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 0.737804 ┆ 2.8125    ┆ 0.735203   ┆ 1.6152 │
#> │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 0.737804 ┆ 2.8125    ┆ 0.735203   ┆ 1.6152 │
#> │ 22.8 ┆ 4.0 ┆ 108.0 ┆ 93.0  ┆ … ┆ 0.737804 ┆ 2.8125    ┆ -1.122152  ┆ 1.6152 │
#> │ 21.4 ┆ 6.0 ┆ 258.0 ┆ 110.0 ┆ … ┆ 0.737804 ┆ 2.8125    ┆ -1.122152  ┆ 1.6152 │
#> │ 18.7 ┆ 8.0 ┆ 360.0 ┆ 175.0 ┆ … ┆ 0.737804 ┆ 2.8125    ┆ -0.503034  ┆ 1.6152 │
#> │ …    ┆ …   ┆ …     ┆ …     ┆ … ┆ …        ┆ …         ┆ …          ┆ …      │
#> │ 30.4 ┆ 4.0 ┆ 95.1  ┆ 113.0 ┆ … ┆ 0.737804 ┆ 2.8125    ┆ -0.503034  ┆ 1.6152 │
#> │ 15.8 ┆ 8.0 ┆ 351.0 ┆ 264.0 ┆ … ┆ 0.737804 ┆ 2.8125    ┆ 0.735203   ┆ 1.6152 │
#> │ 19.7 ┆ 6.0 ┆ 145.0 ┆ 175.0 ┆ … ┆ 0.737804 ┆ 2.8125    ┆ 1.97344    ┆ 1.6152 │
#> │ 15.0 ┆ 8.0 ┆ 301.0 ┆ 335.0 ┆ … ┆ 0.737804 ┆ 2.8125    ┆ 3.211677   ┆ 1.6152 │
#> │ 21.4 ┆ 4.0 ┆ 121.0 ┆ 109.0 ┆ … ┆ 0.737804 ┆ 2.8125    ┆ -0.503034  ┆ 1.6152 │
#> └──────┴─────┴───────┴───────┴───┴──────────┴───────────┴────────────┴────────┘
```

Similarly, UDFs and anonymous functions will error if they don’t return
a Polars expression:

``` r
mtcars |>
  as_polars_df() |>
  mutate(
    across(
      .cols = contains("a"),
      .fns = list(
        mean = mean,
        function(x) {
          (x - mean(x)) / sd(x)
        },
        ~ sd(.x)
      )
    )
  )
#> Error in `mutate()`:
#> ! Could not evaluate an anonymous function in `across()`.
#> ℹ Are you sure the anonymous function returns a Polars expression?
```

#### Non-translated functions

When a function provided in base R or in another package cannot be
translated, `tidypolars` usually throws an error (it’s not necessary to
understand what [`agrep()`](https://rdrr.io/r/base/agrep.html) does
here, you should only know that it is not translated by `tidypolars`):

``` r
dat <- pl$DataFrame(a = c("d", "e", "f"), foo = c(2, 1, 2))

dat |>
  filter(foo >= agrep("a", a))
#> Error in `filter()`:
#> ! tidypolars doesn't know how to translate this function: `agrep()`
#>   (from package base).
#> ℹ You can ask for it to be translated here:
#>   <https://github.com/etiennebacher/tidypolars/issues>.
#> ℹ See `?tidypolars_options` to set automatic fallback to R to handle unknown
#>   functions.
```

This is because `foo >= agrep("a", a)` uses the values from the columns
`a` and `foo`, which are stored in the `polars` DataFrame. Therefore,
`polars` needs a translation of
[`agrep()`](https://rdrr.io/r/base/agrep.html), which doesn’t exist.

Now, let’s assume that we have this data instead:

``` r
dat <- pl$DataFrame(foo = c(2, 1, 2))
a <- c("d", "e", "f")

dat |>
  filter(foo >= agrep("a", a))
#> shape: (1, 1)
#> ┌─────┐
#> │ foo │
#> │ --- │
#> │ f64 │
#> ╞═════╡
#> │ 2.0 │
#> └─────┘
```

Starting from `tidypolars` 0.14.0, this doesn’t error anymore. Why is
that? The reason is that while `foo >= agrep("a", a)` uses a column from
the data (`foo`), `agrep("a", a)` no longer does since `a` is an object
in the environment and not in the data anymore. Therefore, we can
evaluate `agrep("a", a)` first and then use its result when evaluating
`foo >= agrep("a", a)`.

More generally, `tidypolars` checks whether a function uses columns from
the data and skips the translation part if it doesn’t, allowing us to
use more functions than what is translated by `tidypolars` (only if they
don’t use columns as inputs).

Note that expressions that don’t use the data are evaluated before
running `polars` in the background so they don’t benefit from `polars`
parallel evaluation for instance.

## A note on performance

As we saw above, a large part of the work of `tidypolars` is to
translate existing R code to its `polars` equivalent. This takes some
time, especially when translating R expressions used in
[`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) or
[`filter()`](https://dplyr.tidyverse.org/reference/filter.html) for
instance, and it might be noticeable if you run `tidypolars` many times
on small datasets.

This translation process takes more time as the number of expressions
increases but it doesn’t depend on the size of the data. In other words,
translating the code from R to `polars` takes about the same time when
applied on a dataset of 1M or 10M observations. Therefore, this drawback
should become less and less noticeable as the size of the dataset
increases since most of the time will then be taken by the actual
computation performed by `polars`.
