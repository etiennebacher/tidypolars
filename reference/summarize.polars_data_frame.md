# Summarize each group down to one row

[`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
returns one row for each combination of grouping variables (one
difference with
[`dplyr::summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
is that
[`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
only accepts grouped data). It will contain one column for each grouping
variable and one column for each of the summary statistics that you have
specified.

## Usage

``` r
# S3 method for class 'polars_data_frame'
summarize(.data, ..., .by = NULL, .groups = "drop_last")

# S3 method for class 'polars_data_frame'
summarise(.data, ..., .by = NULL, .groups = "drop_last")

# S3 method for class 'polars_lazy_frame'
summarize(.data, ..., .by = NULL, .groups = "drop_last")

# S3 method for class 'polars_lazy_frame'
summarise(.data, ..., .by = NULL, .groups = "drop_last")
```

## Arguments

- .data:

  A Polars Data/LazyFrame

- ...:

  Name-value pairs. The name gives the name of the column in the output.
  The value can be:

  - A vector the same length as the current group (or the whole data
    frame if ungrouped).

  - NULL, to remove the column.

  [`across()`](https://dplyr.tidyverse.org/reference/across.html) is
  mostly supported, except in a few cases. In particular, if the `.cols`
  argument is `where(...)`, it will *not* select variables that were
  created before
  [`across()`](https://dplyr.tidyverse.org/reference/across.html). Other
  select helpers are supported. See the examples.

- .by:

  Optionally, a selection of columns to group by for just this
  operation, functioning as an alternative to
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html).
  The group order is not maintained, use
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) if
  you want more control over it.

- .groups:

  Grouping structure of the result. Must be one of:

  - `"drop_last"` (default): drop the last level of grouping;

  - `"drop"`: all levels of grouping are dropped;

  - `"keep"`: keep the same grouping structure as `.data`.

  For now, `"rowwise"` is not supported. Note that `dplyr` uses
  `.groups = NULL` by default, whose behavior depends on the number of
  rows by group in the output. However, returning several rows by group
  in
  [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
  is deprecated (one should use
  [`reframe()`](https://dplyr.tidyverse.org/reference/reframe.html)
  instead), which is why `.groups = NULL` is not supported by
  `tidypolars`.

## Examples

``` r
mtcars |>
  as_polars_df() |>
  group_by(cyl) |>
  summarize(m_gear = mean(gear), sd_gear = sd(gear))
#> shape: (3, 3)
#> ┌─────┬──────────┬──────────┐
#> │ cyl ┆ m_gear   ┆ sd_gear  │
#> │ --- ┆ ---      ┆ ---      │
#> │ f64 ┆ f64      ┆ f64      │
#> ╞═════╪══════════╪══════════╡
#> │ 6.0 ┆ 3.857143 ┆ 0.690066 │
#> │ 4.0 ┆ 4.090909 ┆ 0.53936  │
#> │ 8.0 ┆ 3.285714 ┆ 0.726273 │
#> └─────┴──────────┴──────────┘

# an alternative syntax is to use `.by`
mtcars |>
  as_polars_df() |>
  summarize(m_gear = mean(gear), sd_gear = sd(gear), .by = cyl)
#> shape: (3, 3)
#> ┌─────┬──────────┬──────────┐
#> │ cyl ┆ m_gear   ┆ sd_gear  │
#> │ --- ┆ ---      ┆ ---      │
#> │ f64 ┆ f64      ┆ f64      │
#> ╞═════╪══════════╪══════════╡
#> │ 6.0 ┆ 3.857143 ┆ 0.690066 │
#> │ 4.0 ┆ 4.090909 ┆ 0.53936  │
#> │ 8.0 ┆ 3.285714 ┆ 0.726273 │
#> └─────┴──────────┴──────────┘
```
