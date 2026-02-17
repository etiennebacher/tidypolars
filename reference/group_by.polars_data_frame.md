# Group by one or more variables

Most data operations are done on groups defined by variables.
[`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
takes an existing Polars Data/LazyFrame and converts it into a grouped
one where operations are performed "by group".
[`ungroup()`](https://dplyr.tidyverse.org/reference/group_by.html)
removes grouping.

## Usage

``` r
# S3 method for class 'polars_data_frame'
group_by(.data, ..., maintain_order = FALSE, .add = FALSE, .drop = TRUE)

# S3 method for class 'polars_data_frame'
ungroup(x, ...)

# S3 method for class 'polars_lazy_frame'
group_by(.data, ..., maintain_order = FALSE, .add = FALSE, .drop = TRUE)

# S3 method for class 'polars_lazy_frame'
ungroup(x, ...)
```

## Arguments

- .data:

  A Polars Data/LazyFrame

- ...:

  Variables to group by (used in
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
  only). Not used in
  [`ungroup()`](https://dplyr.tidyverse.org/reference/group_by.html).

- maintain_order:

  Maintain row order. For performance reasons, this is `FALSE` by
  default). Setting it to `TRUE` can slow down the process with large
  datasets and prevents the use of streaming.

- .add:

  When `FALSE` (default),
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
  will override existing groups. To add to the existing groups, use
  `.add = TRUE`.

- .drop:

  Unsupported. It is only present to provide a good error message if
  specified by the user.

- x:

  A Polars Data/LazyFrame

## Examples

``` r
by_cyl <- mtcars |>
  as_polars_df() |>
  group_by(cyl)

by_cyl
#> shape: (32, 11)
#> ┌──────┬─────┬───────┬───────┬───┬─────┬─────┬──────┬──────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ vs  ┆ am  ┆ gear ┆ carb │
#> │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ --- ┆ ---  ┆ ---  │
#> │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64 ┆ f64  ┆ f64  │
#> ╞══════╪═════╪═══════╪═══════╪═══╪═════╪═════╪══════╪══════╡
#> │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 0.0 ┆ 1.0 ┆ 4.0  ┆ 4.0  │
#> │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 0.0 ┆ 1.0 ┆ 4.0  ┆ 4.0  │
#> │ 22.8 ┆ 4.0 ┆ 108.0 ┆ 93.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> │ 21.4 ┆ 6.0 ┆ 258.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 0.0 ┆ 3.0  ┆ 1.0  │
#> │ 18.7 ┆ 8.0 ┆ 360.0 ┆ 175.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 2.0  │
#> │ …    ┆ …   ┆ …     ┆ …     ┆ … ┆ …   ┆ …   ┆ …    ┆ …    │
#> │ 30.4 ┆ 4.0 ┆ 95.1  ┆ 113.0 ┆ … ┆ 1.0 ┆ 1.0 ┆ 5.0  ┆ 2.0  │
#> │ 15.8 ┆ 8.0 ┆ 351.0 ┆ 264.0 ┆ … ┆ 0.0 ┆ 1.0 ┆ 5.0  ┆ 4.0  │
#> │ 19.7 ┆ 6.0 ┆ 145.0 ┆ 175.0 ┆ … ┆ 0.0 ┆ 1.0 ┆ 5.0  ┆ 6.0  │
#> │ 15.0 ┆ 8.0 ┆ 301.0 ┆ 335.0 ┆ … ┆ 0.0 ┆ 1.0 ┆ 5.0  ┆ 8.0  │
#> │ 21.4 ┆ 4.0 ┆ 121.0 ┆ 109.0 ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 2.0  │
#> └──────┴─────┴───────┴───────┴───┴─────┴─────┴──────┴──────┘
#> Groups [3]: cyl
#> Maintain order: FALSE

by_cyl |> summarise(
  disp = mean(disp),
  hp = mean(hp)
)
#> shape: (3, 3)
#> ┌─────┬────────────┬────────────┐
#> │ cyl ┆ disp       ┆ hp         │
#> │ --- ┆ ---        ┆ ---        │
#> │ f64 ┆ f64        ┆ f64        │
#> ╞═════╪════════════╪════════════╡
#> │ 6.0 ┆ 183.314286 ┆ 122.285714 │
#> │ 4.0 ┆ 105.136364 ┆ 82.636364  │
#> │ 8.0 ┆ 353.1      ┆ 209.214286 │
#> └─────┴────────────┴────────────┘
by_cyl |> filter(disp == max(disp))
#> shape: (3, 11)
#> ┌──────┬─────┬───────┬───────┬───┬─────┬─────┬──────┬──────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ vs  ┆ am  ┆ gear ┆ carb │
#> │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ --- ┆ ---  ┆ ---  │
#> │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64 ┆ f64  ┆ f64  │
#> ╞══════╪═════╪═══════╪═══════╪═══╪═════╪═════╪══════╪══════╡
#> │ 21.4 ┆ 6.0 ┆ 258.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 0.0 ┆ 3.0  ┆ 1.0  │
#> │ 24.4 ┆ 4.0 ┆ 146.7 ┆ 62.0  ┆ … ┆ 1.0 ┆ 0.0 ┆ 4.0  ┆ 2.0  │
#> │ 10.4 ┆ 8.0 ┆ 472.0 ┆ 205.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
#> └──────┴─────┴───────┴───────┴───┴─────┴─────┴──────┴──────┘
#> Groups [3]: cyl
#> Maintain order: FALSE
```
