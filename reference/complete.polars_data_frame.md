# Complete a data frame with missing combinations of data

Turns implicit missing values into explicit missing values. This is
useful for completing missing combinations of data.

## Usage

``` r
# S3 method for class 'polars_data_frame'
complete(data, ..., fill = list(), explicit = TRUE)

# S3 method for class 'polars_lazy_frame'
complete(data, ..., fill = list(), explicit = TRUE)
```

## Arguments

- data:

  A Polars Data/LazyFrame

- ...:

  Any expression accepted by
  [`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html):
  variable names, column numbers, select helpers, etc.

  When used with continuous variables, you may need to fill in values
  that do not appear in the data: to do so use expressions like
  `year = 2010:2020` or `year = full_seq(year, 1)`.

- fill:

  A named list that for each variable supplies a single value to use
  instead of `NA` for missing combinations.

- explicit:

  Should both implicit (newly created) and explicit (pre-existing)
  missing values be filled by `fill`? By default, this is `TRUE`, but if
  set to `FALSE` this will limit the fill to only implicit missing
  values.

## Examples

``` r
df <- polars::pl$DataFrame(
  group = c(1:2, 1, 2),
  item_id = c(1:2, 2, 3),
  item_name = c("a", "a", "b", "b"),
  value1 = c(1, NA, 3, 4),
  value2 = 4:7
)
df
#> shape: (4, 5)
#> ┌───────┬─────────┬───────────┬────────┬────────┐
#> │ group ┆ item_id ┆ item_name ┆ value1 ┆ value2 │
#> │ ---   ┆ ---     ┆ ---       ┆ ---    ┆ ---    │
#> │ f64   ┆ f64     ┆ str       ┆ f64    ┆ i32    │
#> ╞═══════╪═════════╪═══════════╪════════╪════════╡
#> │ 1.0   ┆ 1.0     ┆ a         ┆ 1.0    ┆ 4      │
#> │ 2.0   ┆ 2.0     ┆ a         ┆ null   ┆ 5      │
#> │ 1.0   ┆ 2.0     ┆ b         ┆ 3.0    ┆ 6      │
#> │ 2.0   ┆ 3.0     ┆ b         ┆ 4.0    ┆ 7      │
#> └───────┴─────────┴───────────┴────────┴────────┘

df |> complete(group, item_id, item_name)
#> shape: (12, 5)
#> ┌───────┬─────────┬───────────┬────────┬────────┐
#> │ group ┆ item_id ┆ item_name ┆ value1 ┆ value2 │
#> │ ---   ┆ ---     ┆ ---       ┆ ---    ┆ ---    │
#> │ f64   ┆ f64     ┆ str       ┆ f64    ┆ i32    │
#> ╞═══════╪═════════╪═══════════╪════════╪════════╡
#> │ 1.0   ┆ 1.0     ┆ a         ┆ 1.0    ┆ 4      │
#> │ 1.0   ┆ 1.0     ┆ b         ┆ null   ┆ null   │
#> │ 1.0   ┆ 2.0     ┆ a         ┆ null   ┆ null   │
#> │ 1.0   ┆ 2.0     ┆ b         ┆ 3.0    ┆ 6      │
#> │ 1.0   ┆ 3.0     ┆ a         ┆ null   ┆ null   │
#> │ …     ┆ …       ┆ …         ┆ …      ┆ …      │
#> │ 2.0   ┆ 1.0     ┆ b         ┆ null   ┆ null   │
#> │ 2.0   ┆ 2.0     ┆ a         ┆ null   ┆ 5      │
#> │ 2.0   ┆ 2.0     ┆ b         ┆ null   ┆ null   │
#> │ 2.0   ┆ 3.0     ┆ a         ┆ null   ┆ null   │
#> │ 2.0   ┆ 3.0     ┆ b         ┆ 4.0    ┆ 7      │
#> └───────┴─────────┴───────────┴────────┴────────┘

# Use `fill` to replace NAs with some value. By default, affects both new
# (implicit) and pre-existing (explicit) missing values.
df |>
  complete(
    group, item_id, item_name,
    fill = list(value1 = 0, value2 = 99)
  )
#> shape: (12, 5)
#> ┌───────┬─────────┬───────────┬────────┬────────┐
#> │ group ┆ item_id ┆ item_name ┆ value1 ┆ value2 │
#> │ ---   ┆ ---     ┆ ---       ┆ ---    ┆ ---    │
#> │ f64   ┆ f64     ┆ str       ┆ f64    ┆ f64    │
#> ╞═══════╪═════════╪═══════════╪════════╪════════╡
#> │ 1.0   ┆ 1.0     ┆ a         ┆ 1.0    ┆ 4.0    │
#> │ 1.0   ┆ 1.0     ┆ b         ┆ 0.0    ┆ 99.0   │
#> │ 1.0   ┆ 2.0     ┆ a         ┆ 0.0    ┆ 99.0   │
#> │ 1.0   ┆ 2.0     ┆ b         ┆ 3.0    ┆ 6.0    │
#> │ 1.0   ┆ 3.0     ┆ a         ┆ 0.0    ┆ 99.0   │
#> │ …     ┆ …       ┆ …         ┆ …      ┆ …      │
#> │ 2.0   ┆ 1.0     ┆ b         ┆ 0.0    ┆ 99.0   │
#> │ 2.0   ┆ 2.0     ┆ a         ┆ 0.0    ┆ 5.0    │
#> │ 2.0   ┆ 2.0     ┆ b         ┆ 0.0    ┆ 99.0   │
#> │ 2.0   ┆ 3.0     ┆ a         ┆ 0.0    ┆ 99.0   │
#> │ 2.0   ┆ 3.0     ┆ b         ┆ 4.0    ┆ 7.0    │
#> └───────┴─────────┴───────────┴────────┴────────┘

# Limit the fill to only the newly created (i.e. previously implicit)
# missing values with `explicit = FALSE`
df |>
  complete(
    group, item_id, item_name,
    fill = list(value1 = 0, value2 = 99),
    explicit = FALSE
  )
#> shape: (12, 5)
#> ┌───────┬─────────┬───────────┬────────┬────────┐
#> │ group ┆ item_id ┆ item_name ┆ value1 ┆ value2 │
#> │ ---   ┆ ---     ┆ ---       ┆ ---    ┆ ---    │
#> │ f64   ┆ f64     ┆ str       ┆ f64    ┆ f64    │
#> ╞═══════╪═════════╪═══════════╪════════╪════════╡
#> │ 1.0   ┆ 1.0     ┆ a         ┆ 1.0    ┆ 4.0    │
#> │ 1.0   ┆ 2.0     ┆ b         ┆ 3.0    ┆ 6.0    │
#> │ 2.0   ┆ 2.0     ┆ a         ┆ null   ┆ 5.0    │
#> │ 2.0   ┆ 3.0     ┆ b         ┆ 4.0    ┆ 7.0    │
#> │ 1.0   ┆ 1.0     ┆ b         ┆ 0.0    ┆ 99.0   │
#> │ …     ┆ …       ┆ …         ┆ …      ┆ …      │
#> │ 1.0   ┆ 3.0     ┆ b         ┆ 0.0    ┆ 99.0   │
#> │ 2.0   ┆ 1.0     ┆ a         ┆ 0.0    ┆ 99.0   │
#> │ 2.0   ┆ 1.0     ┆ b         ┆ 0.0    ┆ 99.0   │
#> │ 2.0   ┆ 2.0     ┆ b         ┆ 0.0    ┆ 99.0   │
#> │ 2.0   ┆ 3.0     ┆ a         ┆ 0.0    ┆ 99.0   │
#> └───────┴─────────┴───────────┴────────┴────────┘

df |>
  group_by(group, maintain_order = TRUE) |>
  complete(item_id, item_name)
#> shape: (8, 5)
#> ┌───────┬─────────┬───────────┬────────┬────────┐
#> │ group ┆ item_id ┆ item_name ┆ value1 ┆ value2 │
#> │ ---   ┆ ---     ┆ ---       ┆ ---    ┆ ---    │
#> │ f64   ┆ f64     ┆ str       ┆ f64    ┆ i32    │
#> ╞═══════╪═════════╪═══════════╪════════╪════════╡
#> │ 1.0   ┆ 1.0     ┆ a         ┆ 1.0    ┆ 4      │
#> │ 1.0   ┆ 1.0     ┆ b         ┆ null   ┆ null   │
#> │ 1.0   ┆ 2.0     ┆ a         ┆ null   ┆ null   │
#> │ 1.0   ┆ 2.0     ┆ b         ┆ 3.0    ┆ 6      │
#> │ 2.0   ┆ 2.0     ┆ a         ┆ null   ┆ 5      │
#> │ 2.0   ┆ 2.0     ┆ b         ┆ null   ┆ null   │
#> │ 2.0   ┆ 3.0     ┆ a         ┆ null   ┆ null   │
#> │ 2.0   ┆ 3.0     ┆ b         ┆ 4.0    ┆ 7      │
#> └───────┴─────────┴───────────┴────────┴────────┘
#> Groups [2]: group
#> Maintain order: TRUE
```
