# Run computations on a LazyFrame

[`collect()`](https://dplyr.tidyverse.org/reference/compute.html) and
[`compute()`](https://dplyr.tidyverse.org/reference/compute.html) can be
applied on a LazyFrame only. They both check the validity of the query
(for instance raising an error if a string operation would be applied on
a numeric column), optimize it in the background, and perform
computations.

These two functions differ in their output type:

- [`compute()`](https://dplyr.tidyverse.org/reference/compute.html)
  returns a [Polars
  DataFrame](https://pola-rs.github.io/r-polars/man/pl__DataFrame.html);

- [`collect()`](https://dplyr.tidyverse.org/reference/compute.html)
  returns an R [data.frame](https://rdrr.io/r/base/data.frame.html).
  Converting the output to an R `data.frame` can be expensive, so
  [`collect()`](https://dplyr.tidyverse.org/reference/compute.html) may
  consume more memory and take longer.

## Usage

``` r
# S3 method for class 'polars_lazy_frame'
compute(
  x,
  ...,
  type_coercion = TRUE,
  predicate_pushdown = TRUE,
  projection_pushdown = TRUE,
  simplify_expression = TRUE,
  slice_pushdown = TRUE,
  comm_subplan_elim = TRUE,
  comm_subexpr_elim = TRUE,
  cluster_with_columns = TRUE,
  no_optimization = FALSE,
  engine = c("auto", "in-memory", "streaming"),
  streaming = FALSE
)

# S3 method for class 'polars_lazy_frame'
collect(
  x,
  ...,
  type_coercion = TRUE,
  predicate_pushdown = TRUE,
  projection_pushdown = TRUE,
  simplify_expression = TRUE,
  slice_pushdown = TRUE,
  comm_subplan_elim = TRUE,
  comm_subexpr_elim = TRUE,
  cluster_with_columns = TRUE,
  no_optimization = FALSE,
  engine = c("auto", "in-memory", "streaming"),
  streaming = FALSE,
  .name_repair = "check_unique",
  uint8 = "integer",
  int64 = "double",
  date = "Date",
  time = "hms",
  decimal = "double",
  as_clock_class = FALSE,
  ambiguous = "raise",
  non_existent = "raise"
)
```

## Arguments

- x:

  A Polars LazyFrame

- ...:

  Dots which should be empty.

- type_coercion:

  Coerce types such that operations succeed and run on minimal required
  memory (default is `TRUE`).

- predicate_pushdown:

  Applies filters as early as possible at scan level (default is
  `TRUE`).

- projection_pushdown:

  Select only the columns that are needed at the scan level (default is
  `TRUE`).

- simplify_expression:

  Various optimizations, such as constant folding and replacing
  expensive operations with faster alternatives (default is `TRUE`).

- slice_pushdown:

  Only load the required slice from the scan. Don't materialize sliced
  outputs level. Don't materialize sliced outputs (default is `TRUE`).

- comm_subplan_elim:

  Cache branching subplans that occur on self-joins or unions (default
  is `TRUE`).

- comm_subexpr_elim:

  Cache common subexpressions (default is `TRUE`).

- cluster_with_columns:

  Combine sequential independent calls to `$with_columns()`.

- no_optimization:

  Sets the following optimizations to `FALSE`: `predicate_pushdown`,
  `projection_pushdown`, `slice_pushdown`, `simplify_expression`.
  Default is `FALSE`.

- engine:

  The engine name to use for processing the query. One of the
  followings:

  - `"auto"` (default): Select the engine automatically. The
    `"in-memory"` engine will be selected for most cases.

  - `"in-memory"`: Use the in-memory engine.

  - `"streaming"`: Use the streaming engine, usually faster and can
    handle larger-than-memory data.

- streaming:

  **\[deprecated\]** Deprecated, use `engine` instead.

- .name_repair, uint8, int64, date, time, decimal, as_clock_class,
  ambiguous, non_existent:

  Parameters to control the conversion from polars types to R. See
  `?polars:::as.data.frame.polars_lazy_frame` for explanations and
  accepted values.

## See also

[`fetch()`](https://tidypolars.etiennebacher.com/reference/fetch.md) for
applying a lazy query on a subset of the data.

## Examples

``` r
dat_lazy <- polars::as_polars_df(iris)$lazy()

compute(dat_lazy)
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
#> │ 5.0          ┆ 3.6         ┆ 1.4          ┆ 0.2         ┆ setosa    │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …         │
#> │ 6.7          ┆ 3.0         ┆ 5.2          ┆ 2.3         ┆ virginica │
#> │ 6.3          ┆ 2.5         ┆ 5.0          ┆ 1.9         ┆ virginica │
#> │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica │
#> │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica │
#> │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica │
#> └──────────────┴─────────────┴──────────────┴─────────────┴───────────┘

# you can build a query and add compute() as the last piece
dat_lazy |>
  select(starts_with("Sepal")) |>
  filter(between(Sepal.Length, 5, 6)) |>
  compute()
#> shape: (67, 2)
#> ┌──────────────┬─────────────┐
#> │ Sepal.Length ┆ Sepal.Width │
#> │ ---          ┆ ---         │
#> │ f64          ┆ f64         │
#> ╞══════════════╪═════════════╡
#> │ 5.1          ┆ 3.5         │
#> │ 5.0          ┆ 3.6         │
#> │ 5.4          ┆ 3.9         │
#> │ 5.0          ┆ 3.4         │
#> │ 5.4          ┆ 3.7         │
#> │ …            ┆ …           │
#> │ 6.0          ┆ 2.2         │
#> │ 5.6          ┆ 2.8         │
#> │ 6.0          ┆ 3.0         │
#> │ 5.8          ┆ 2.7         │
#> │ 5.9          ┆ 3.0         │
#> └──────────────┴─────────────┘

# call collect() instead to return a data.frame (note that this is more
# expensive than compute())
dat_lazy |>
  select(starts_with("Sepal")) |>
  filter(between(Sepal.Length, 5, 6)) |>
  collect()
#>    Sepal.Length Sepal.Width
#> 1           5.1         3.5
#> 2           5.0         3.6
#> 3           5.4         3.9
#> 4           5.0         3.4
#> 5           5.4         3.7
#> 6           5.8         4.0
#> 7           5.7         4.4
#> 8           5.4         3.9
#> 9           5.1         3.5
#> 10          5.7         3.8
#> 11          5.1         3.8
#> 12          5.4         3.4
#> 13          5.1         3.7
#> 14          5.1         3.3
#> 15          5.0         3.0
#> 16          5.0         3.4
#> 17          5.2         3.5
#> 18          5.2         3.4
#> 19          5.4         3.4
#> 20          5.2         4.1
#> 21          5.5         4.2
#> 22          5.0         3.2
#> 23          5.5         3.5
#> 24          5.1         3.4
#> 25          5.0         3.5
#> 26          5.0         3.5
#> 27          5.1         3.8
#> 28          5.1         3.8
#> 29          5.3         3.7
#> 30          5.0         3.3
#> 31          5.5         2.3
#> 32          5.7         2.8
#> 33          5.2         2.7
#> 34          5.0         2.0
#> 35          5.9         3.0
#> 36          6.0         2.2
#> 37          5.6         2.9
#> 38          5.6         3.0
#> 39          5.8         2.7
#> 40          5.6         2.5
#> 41          5.9         3.2
#> 42          6.0         2.9
#> 43          5.7         2.6
#> 44          5.5         2.4
#> 45          5.5         2.4
#> 46          5.8         2.7
#> 47          6.0         2.7
#> 48          5.4         3.0
#> 49          6.0         3.4
#> 50          5.6         3.0
#> 51          5.5         2.5
#> 52          5.5         2.6
#> 53          5.8         2.6
#> 54          5.0         2.3
#> 55          5.6         2.7
#> 56          5.7         3.0
#> 57          5.7         2.9
#> 58          5.1         2.5
#> 59          5.7         2.8
#> 60          5.8         2.7
#> 61          5.7         2.5
#> 62          5.8         2.8
#> 63          6.0         2.2
#> 64          5.6         2.8
#> 65          6.0         3.0
#> 66          5.8         2.7
#> 67          5.9         3.0
```
