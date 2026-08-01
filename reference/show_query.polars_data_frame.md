# Show the polars code equivalent to the tidypolars pipeline

[`show_query()`](https://dplyr.tidyverse.org/reference/explain.html)
prints the pure `polars` code that `tidypolars` runs in the background.
This code can be copy-pasted and run with `polars` only (the input data
must be assigned to the name displayed in the first line of the query).

Recording the query is **disabled** by default, meaning that
[`show_query()`](https://dplyr.tidyverse.org/reference/explain.html)
will error with an informative message. It can be enabled with
`options(tidypolars_record_query = TRUE)` (see
[tidypolars_options](https://tidypolars.etiennebacher.com/reference/tidypolars_options.md)).

## Usage

``` r
# S3 method for class 'polars_data_frame'
show_query(x, ...)

# S3 method for class 'polars_lazy_frame'
show_query(x, ...)
```

## Arguments

- x:

  A Polars Data/LazyFrame that went through `tidypolars` functions.

- ...:

  Dots which should be empty.

## Value

The input, invisibly. This function is called for its side effect of
printing the polars query.

## Details

To keep the output readable and close to hand-written `polars` code, R
operators are used instead of their method equivalent (e.g. `a$add(b)`
is shown as `a + b`), and user-defined functions are displayed as a call
rather than expanded into the operations they perform internally.

Long values coming from the calling environment are referred to by the
code they come from – the name of the object holding them, or the call
that produced them, e.g. `pl$lit(runif(200))` – so that the printed code
stays copy-pasteable. Values that are too long to display and whose
source code cannot be recovered are shown as a placeholder like
`` `<numeric of length 200>` ``.

The code is wrapped at the console width (`getOption("width")`).

If the package `cli` is installed, it provides syntax highlighting for
the output. This can be controlled with `options(cli.code_theme = )`
(see
[`cli::code_theme_list()`](https://cli.r-lib.org/reference/code_theme_list.html)
for the available themes).

## Examples

``` r
withr::with_options(
  list(tidypolars_record_query = TRUE),
  mtcars |>
    as_polars_lf() |>
    filter(cyl == 4) |>
    mutate(
      mpg2 = mpg * 2,
      mpg2_max = max(mpg2),
     .by = am
    ) |>
    show_query()
)
#> as_polars_lf(mtcars)$
#>   filter(pl$col("cyl") == pl$lit(4))$
#>   with_columns(mpg2 = (pl$col("mpg") * pl$lit(2))$over("am"))$
#>   with_columns(
#>     mpg2_max = pl$when(pl$col("mpg2")$has_nulls())$
#>       then(NA)$
#>       otherwise(pl$col("mpg2")$max())$
#>       over("am")
#>   )
```
