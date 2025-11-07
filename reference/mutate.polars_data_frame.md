# Create, modify, and delete columns

This creates new columns that are functions of existing variables. It
can also modify (if the name is the same as an existing column) and
delete columns (by setting their value to NULL).

## Usage

``` r
# S3 method for class 'polars_data_frame'
mutate(.data, ..., .by = NULL, .keep = c("all", "used", "unused", "none"))

# S3 method for class 'polars_lazy_frame'
mutate(.data, ..., .by = NULL, .keep = c("all", "used", "unused", "none"))
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

- .keep:

  Control which columns from `.data` are retained in the output.
  Grouping columns and columns created by `...` are always kept.

  - `"all"` retains all columns from .data. This is the default.

  - `"used"` retains only the columns used in ... to create new columns.
    This is useful for checking your work, as it displays inputs and
    outputs side-by- side.

  - `"unused"` retains only the columns not used in `...` to create new
    columns. This is useful if you generate new columns, but no longer
    need the columns used to generate them.

  - `"none"` doesn't retain any extra columns from `.data`. Only the
    grouping variables and columns created by `...` are kept.

## Details

A lot of functions available in base R (cos, mean, multiplying, etc.) or
in other packages (dplyr::lag(), etc.) are implemented in an efficient
way in Polars. These functions are automatically translated to Polars
syntax under the hood so that you can continue using the classic R
syntax and functions.

If a Polars built-in replacement doesn't exist (for example for custom
functions), then `tidypolars` will throw an error. See the vignette on
Polars expressions to know how to write custom functions that are
accepted by `tidypolars`.

## Examples

``` r
pl_iris <- polars::as_polars_df(iris)

# classic operation
mutate(pl_iris, x = Sepal.Width + Sepal.Length)
#> shape: (150, 6)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┬─────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   ┆ x   │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       ┆ --- │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat       ┆ f64 │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╪═════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 8.6 │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 7.9 │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa    ┆ 7.9 │
#> │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ setosa    ┆ 7.7 │
#> │ 5.0          ┆ 3.6         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 8.6 │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …         ┆ …   │
#> │ 6.7          ┆ 3.0         ┆ 5.2          ┆ 2.3         ┆ virginica ┆ 9.7 │
#> │ 6.3          ┆ 2.5         ┆ 5.0          ┆ 1.9         ┆ virginica ┆ 8.8 │
#> │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica ┆ 9.5 │
#> │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica ┆ 9.6 │
#> │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica ┆ 8.9 │
#> └──────────────┴─────────────┴──────────────┴─────────────┴───────────┴─────┘

# logical operation
mutate(pl_iris, x = Sepal.Width > Sepal.Length & Petal.Width > Petal.Length)
#> shape: (150, 6)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┬───────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   ┆ x     │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       ┆ ---   │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat       ┆ bool  │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╪═══════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ false │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ false │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa    ┆ false │
#> │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ setosa    ┆ false │
#> │ 5.0          ┆ 3.6         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ false │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …         ┆ …     │
#> │ 6.7          ┆ 3.0         ┆ 5.2          ┆ 2.3         ┆ virginica ┆ false │
#> │ 6.3          ┆ 2.5         ┆ 5.0          ┆ 1.9         ┆ virginica ┆ false │
#> │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica ┆ false │
#> │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica ┆ false │
#> │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica ┆ false │
#> └──────────────┴─────────────┴──────────────┴─────────────┴───────────┴───────┘

# overwrite existing variable
mutate(pl_iris, Sepal.Width = Sepal.Width * 2)
#> shape: (150, 5)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat       │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╡
#> │ 5.1          ┆ 7.0         ┆ 1.4          ┆ 0.2         ┆ setosa    │
#> │ 4.9          ┆ 6.0         ┆ 1.4          ┆ 0.2         ┆ setosa    │
#> │ 4.7          ┆ 6.4         ┆ 1.3          ┆ 0.2         ┆ setosa    │
#> │ 4.6          ┆ 6.2         ┆ 1.5          ┆ 0.2         ┆ setosa    │
#> │ 5.0          ┆ 7.2         ┆ 1.4          ┆ 0.2         ┆ setosa    │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …         │
#> │ 6.7          ┆ 6.0         ┆ 5.2          ┆ 2.3         ┆ virginica │
#> │ 6.3          ┆ 5.0         ┆ 5.0          ┆ 1.9         ┆ virginica │
#> │ 6.5          ┆ 6.0         ┆ 5.2          ┆ 2.0         ┆ virginica │
#> │ 6.2          ┆ 6.8         ┆ 5.4          ┆ 2.3         ┆ virginica │
#> │ 5.9          ┆ 6.0         ┆ 5.1          ┆ 1.8         ┆ virginica │
#> └──────────────┴─────────────┴──────────────┴─────────────┴───────────┘

# grouped computation
pl_iris |>
  group_by(Species) |>
  mutate(foo = mean(Sepal.Length))
#> shape: (150, 6)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┬───────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   ┆ foo   │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       ┆ ---   │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat       ┆ f64   │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╪═══════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 5.006 │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 5.006 │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa    ┆ 5.006 │
#> │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ setosa    ┆ 5.006 │
#> │ 5.0          ┆ 3.6         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 5.006 │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …         ┆ …     │
#> │ 6.7          ┆ 3.0         ┆ 5.2          ┆ 2.3         ┆ virginica ┆ 6.588 │
#> │ 6.3          ┆ 2.5         ┆ 5.0          ┆ 1.9         ┆ virginica ┆ 6.588 │
#> │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica ┆ 6.588 │
#> │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica ┆ 6.588 │
#> │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica ┆ 6.588 │
#> └──────────────┴─────────────┴──────────────┴─────────────┴───────────┴───────┘
#> Groups [3]: Species
#> Maintain order: FALSE

# an alternative syntax for grouping is to use `.by`
pl_iris |>
  mutate(foo = mean(Sepal.Length), .by = Species)
#> shape: (150, 6)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┬───────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   ┆ foo   │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       ┆ ---   │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat       ┆ f64   │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╪═══════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 5.006 │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 5.006 │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa    ┆ 5.006 │
#> │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ setosa    ┆ 5.006 │
#> │ 5.0          ┆ 3.6         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 5.006 │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …         ┆ …     │
#> │ 6.7          ┆ 3.0         ┆ 5.2          ┆ 2.3         ┆ virginica ┆ 6.588 │
#> │ 6.3          ┆ 2.5         ┆ 5.0          ┆ 1.9         ┆ virginica ┆ 6.588 │
#> │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica ┆ 6.588 │
#> │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica ┆ 6.588 │
#> │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica ┆ 6.588 │
#> └──────────────┴─────────────┴──────────────┴─────────────┴───────────┴───────┘

# across() is available
pl_iris |>
  mutate(
    across(.cols = contains("Sepal"), .fns = mean, .names = "{.fn}_of_{.col}")
  )
#> shape: (150, 7)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┬──────────────┬─────────────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   ┆ mean_of_Sepa ┆ mean_of_Sep │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       ┆ l.Length     ┆ al.Width    │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat       ┆ ---          ┆ ---         │
#> │              ┆             ┆              ┆             ┆           ┆ f64          ┆ f64         │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╪══════════════╪═════════════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 5.843333     ┆ 3.057333    │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 5.843333     ┆ 3.057333    │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa    ┆ 5.843333     ┆ 3.057333    │
#> │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ setosa    ┆ 5.843333     ┆ 3.057333    │
#> │ 5.0          ┆ 3.6         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 5.843333     ┆ 3.057333    │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …         ┆ …            ┆ …           │
#> │ 6.7          ┆ 3.0         ┆ 5.2          ┆ 2.3         ┆ virginica ┆ 5.843333     ┆ 3.057333    │
#> │ 6.3          ┆ 2.5         ┆ 5.0          ┆ 1.9         ┆ virginica ┆ 5.843333     ┆ 3.057333    │
#> │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica ┆ 5.843333     ┆ 3.057333    │
#> │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica ┆ 5.843333     ┆ 3.057333    │
#> │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica ┆ 5.843333     ┆ 3.057333    │
#> └──────────────┴─────────────┴──────────────┴─────────────┴───────────┴──────────────┴─────────────┘
#
# It can receive several types of functions:
pl_iris |>
  mutate(
    across(
      .cols = contains("Sepal"),
      .fns = list(mean = mean, sd = ~ sd(.x)),
      .names = "{.fn}_of_{.col}"
    )
  )
#> shape: (150, 9)
#> ┌───────────┬───────────┬───────────┬───────────┬───┬───────────┬───────────┬───────────┬──────────┐
#> │ Sepal.Len ┆ Sepal.Wid ┆ Petal.Len ┆ Petal.Wid ┆ … ┆ mean_of_S ┆ sd_of_Sep ┆ mean_of_S ┆ sd_of_Se │
#> │ gth       ┆ th        ┆ gth       ┆ th        ┆   ┆ epal.Leng ┆ al.Length ┆ epal.Widt ┆ pal.Widt │
#> │ ---       ┆ ---       ┆ ---       ┆ ---       ┆   ┆ th        ┆ ---       ┆ h         ┆ h        │
#> │ f64       ┆ f64       ┆ f64       ┆ f64       ┆   ┆ ---       ┆ f64       ┆ ---       ┆ ---      │
#> │           ┆           ┆           ┆           ┆   ┆ f64       ┆           ┆ f64       ┆ f64      │
#> ╞═══════════╪═══════════╪═══════════╪═══════════╪═══╪═══════════╪═══════════╪═══════════╪══════════╡
#> │ 5.1       ┆ 3.5       ┆ 1.4       ┆ 0.2       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
#> │ 4.9       ┆ 3.0       ┆ 1.4       ┆ 0.2       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
#> │ 4.7       ┆ 3.2       ┆ 1.3       ┆ 0.2       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
#> │ 4.6       ┆ 3.1       ┆ 1.5       ┆ 0.2       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
#> │ 5.0       ┆ 3.6       ┆ 1.4       ┆ 0.2       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
#> │ …         ┆ …         ┆ …         ┆ …         ┆ … ┆ …         ┆ …         ┆ …         ┆ …        │
#> │ 6.7       ┆ 3.0       ┆ 5.2       ┆ 2.3       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
#> │ 6.3       ┆ 2.5       ┆ 5.0       ┆ 1.9       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
#> │ 6.5       ┆ 3.0       ┆ 5.2       ┆ 2.0       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
#> │ 6.2       ┆ 3.4       ┆ 5.4       ┆ 2.3       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
#> │ 5.9       ┆ 3.0       ┆ 5.1       ┆ 1.8       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
#> └───────────┴───────────┴───────────┴───────────┴───┴───────────┴───────────┴───────────┴──────────┘

# Be careful when using across(.cols = where(...), ...) as it will not include
# variables created in the same `...` (this is only the case for `where()`):
if (FALSE) { # \dontrun{
pl_iris |>
  mutate(
    foo = 1,
    across(
      .cols = where(is.numeric),
      \(x) x - 1000 # <<<<<<<<< this will not be applied on variable "foo"
    )
  )
} # }
# Warning message:
# In `across()`, the argument `.cols = where(is.numeric)` will not take into account
# variables created in the same `mutate()`/`summarize` call.

# Embracing an external variable works
some_value <- 1
mutate(pl_iris, x = {{ some_value }})
#> shape: (150, 6)
#> ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┬─────┐
#> │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   ┆ x   │
#> │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       ┆ --- │
#> │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat       ┆ f64 │
#> ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╪═════╡
#> │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 1.0 │
#> │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 1.0 │
#> │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa    ┆ 1.0 │
#> │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ setosa    ┆ 1.0 │
#> │ 5.0          ┆ 3.6         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ 1.0 │
#> │ …            ┆ …           ┆ …            ┆ …           ┆ …         ┆ …   │
#> │ 6.7          ┆ 3.0         ┆ 5.2          ┆ 2.3         ┆ virginica ┆ 1.0 │
#> │ 6.3          ┆ 2.5         ┆ 5.0          ┆ 1.9         ┆ virginica ┆ 1.0 │
#> │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica ┆ 1.0 │
#> │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica ┆ 1.0 │
#> │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica ┆ 1.0 │
#> └──────────────┴─────────────┴──────────────┴─────────────┴───────────┴─────┘
```
