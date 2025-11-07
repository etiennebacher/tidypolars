# Pivot a DataFrame from long to wide

Pivot a DataFrame from long to wide

## Usage

``` r
# S3 method for class 'polars_data_frame'
pivot_wider(
  data,
  ...,
  id_cols = NULL,
  names_from = name,
  values_from = value,
  names_prefix = "",
  names_sep = "_",
  names_glue = NULL,
  values_fill = NULL
)
```

## Arguments

- data:

  A Polars DataFrame (LazyFrames are not supported).

- ...:

  Dots which should be empty.

- id_cols:

  A set of columns that uniquely identify each observation. Typically
  used when you have redundant variables, i.e. variables whose values
  are perfectly correlated with existing variables.

  Defaults to all columns in data except for the columns specified
  through `names_from` and `values_from`. If a tidyselect expression is
  supplied, it will be evaluated on data after removing the columns
  specified through `names_from` and `values_from`.

- names_from:

  The (quoted or unquoted) column names whose values will be used for
  the names of the new columns.

- values_from:

  The (quoted or unquoted) column names whose values will be used to
  fill the new columns.

- names_prefix:

  String added to the start of every variable name. This is particularly
  useful if `names_from` is a numeric vector and you want to create
  syntactic variable names.

- names_sep:

  If `names_from` or `values_from` contains multiple variables, this
  will be used to join their values together into a single string to use
  as a column name.

- names_glue:

  Instead of `names_sep` and `names_prefix`, you can supply a `glue`
  specification that uses the `names_from` columns to create custom
  column names.

- values_fill:

  A scalar that will be used to replace missing values in the new
  columns. Note that the type of this value will be applied to new
  columns. For example, if you provide a character value to fill numeric
  columns, then all these columns will be converted to character.

## Unknown arguments

Arguments that are supported by the original implementation in the
tidyverse but are not listed above will throw a warning by default if
they are specified. To change this behavior to error instead, use
`options(tidypolars_unknown_args = "error")`.

## Examples

``` r
pl_fish_encounters <- as_polars_df(tidyr::fish_encounters)

pl_fish_encounters |>
  pivot_wider(names_from = station, values_from = seen)
#> shape: (19, 12)
#> ┌──────┬─────────┬───────┬────────┬───┬──────┬──────┬──────┬──────┐
#> │ fish ┆ Release ┆ I80_1 ┆ Lisbon ┆ … ┆ BCE2 ┆ BCW2 ┆ MAE  ┆ MAW  │
#> │ ---  ┆ ---     ┆ ---   ┆ ---    ┆   ┆ ---  ┆ ---  ┆ ---  ┆ ---  │
#> │ cat  ┆ i32     ┆ i32   ┆ i32    ┆   ┆ i32  ┆ i32  ┆ i32  ┆ i32  │
#> ╞══════╪═════════╪═══════╪════════╪═══╪══════╪══════╪══════╪══════╡
#> │ 4842 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ 1    ┆ 1    ┆ 1    ┆ 1    │
#> │ 4843 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ 1    ┆ 1    ┆ 1    ┆ 1    │
#> │ 4844 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ 1    ┆ 1    ┆ 1    ┆ 1    │
#> │ 4845 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ null ┆ null ┆ null ┆ null │
#> │ 4847 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ null ┆ null ┆ null ┆ null │
#> │ …    ┆ …       ┆ …     ┆ …      ┆ … ┆ …    ┆ …    ┆ …    ┆ …    │
#> │ 4861 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ 1    ┆ 1    ┆ 1    ┆ 1    │
#> │ 4862 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ 1    ┆ 1    ┆ null ┆ null │
#> │ 4863 ┆ 1       ┆ 1     ┆ null   ┆ … ┆ null ┆ null ┆ null ┆ null │
#> │ 4864 ┆ 1       ┆ 1     ┆ null   ┆ … ┆ null ┆ null ┆ null ┆ null │
#> │ 4865 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ null ┆ null ┆ null ┆ null │
#> └──────┴─────────┴───────┴────────┴───┴──────┴──────┴──────┴──────┘

pl_fish_encounters |>
  pivot_wider(names_from = station, values_from = seen, values_fill = 0)
#> shape: (19, 12)
#> ┌──────┬─────────┬───────┬────────┬───┬──────┬──────┬─────┬─────┐
#> │ fish ┆ Release ┆ I80_1 ┆ Lisbon ┆ … ┆ BCE2 ┆ BCW2 ┆ MAE ┆ MAW │
#> │ ---  ┆ ---     ┆ ---   ┆ ---    ┆   ┆ ---  ┆ ---  ┆ --- ┆ --- │
#> │ cat  ┆ f64     ┆ f64   ┆ f64    ┆   ┆ f64  ┆ f64  ┆ f64 ┆ f64 │
#> ╞══════╪═════════╪═══════╪════════╪═══╪══════╪══════╪═════╪═════╡
#> │ 4842 ┆ 1.0     ┆ 1.0   ┆ 1.0    ┆ … ┆ 1.0  ┆ 1.0  ┆ 1.0 ┆ 1.0 │
#> │ 4843 ┆ 1.0     ┆ 1.0   ┆ 1.0    ┆ … ┆ 1.0  ┆ 1.0  ┆ 1.0 ┆ 1.0 │
#> │ 4844 ┆ 1.0     ┆ 1.0   ┆ 1.0    ┆ … ┆ 1.0  ┆ 1.0  ┆ 1.0 ┆ 1.0 │
#> │ 4845 ┆ 1.0     ┆ 1.0   ┆ 1.0    ┆ … ┆ 0.0  ┆ 0.0  ┆ 0.0 ┆ 0.0 │
#> │ 4847 ┆ 1.0     ┆ 1.0   ┆ 1.0    ┆ … ┆ 0.0  ┆ 0.0  ┆ 0.0 ┆ 0.0 │
#> │ …    ┆ …       ┆ …     ┆ …      ┆ … ┆ …    ┆ …    ┆ …   ┆ …   │
#> │ 4861 ┆ 1.0     ┆ 1.0   ┆ 1.0    ┆ … ┆ 1.0  ┆ 1.0  ┆ 1.0 ┆ 1.0 │
#> │ 4862 ┆ 1.0     ┆ 1.0   ┆ 1.0    ┆ … ┆ 1.0  ┆ 1.0  ┆ 0.0 ┆ 0.0 │
#> │ 4863 ┆ 1.0     ┆ 1.0   ┆ 0.0    ┆ … ┆ 0.0  ┆ 0.0  ┆ 0.0 ┆ 0.0 │
#> │ 4864 ┆ 1.0     ┆ 1.0   ┆ 0.0    ┆ … ┆ 0.0  ┆ 0.0  ┆ 0.0 ┆ 0.0 │
#> │ 4865 ┆ 1.0     ┆ 1.0   ┆ 1.0    ┆ … ┆ 0.0  ┆ 0.0  ┆ 0.0 ┆ 0.0 │
#> └──────┴─────────┴───────┴────────┴───┴──────┴──────┴─────┴─────┘

# be careful about the type of the replacement value!
pl_fish_encounters |>
  pivot_wider(names_from = station, values_from = seen, values_fill = "a")
#> shape: (19, 12)
#> ┌──────┬─────────┬───────┬────────┬───┬──────┬──────┬─────┬─────┐
#> │ fish ┆ Release ┆ I80_1 ┆ Lisbon ┆ … ┆ BCE2 ┆ BCW2 ┆ MAE ┆ MAW │
#> │ ---  ┆ ---     ┆ ---   ┆ ---    ┆   ┆ ---  ┆ ---  ┆ --- ┆ --- │
#> │ cat  ┆ str     ┆ str   ┆ str    ┆   ┆ str  ┆ str  ┆ str ┆ str │
#> ╞══════╪═════════╪═══════╪════════╪═══╪══════╪══════╪═════╪═════╡
#> │ 4842 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ 1    ┆ 1    ┆ 1   ┆ 1   │
#> │ 4843 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ 1    ┆ 1    ┆ 1   ┆ 1   │
#> │ 4844 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ 1    ┆ 1    ┆ 1   ┆ 1   │
#> │ 4845 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ a    ┆ a    ┆ a   ┆ a   │
#> │ 4847 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ a    ┆ a    ┆ a   ┆ a   │
#> │ …    ┆ …       ┆ …     ┆ …      ┆ … ┆ …    ┆ …    ┆ …   ┆ …   │
#> │ 4861 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ 1    ┆ 1    ┆ 1   ┆ 1   │
#> │ 4862 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ 1    ┆ 1    ┆ a   ┆ a   │
#> │ 4863 ┆ 1       ┆ 1     ┆ a      ┆ … ┆ a    ┆ a    ┆ a   ┆ a   │
#> │ 4864 ┆ 1       ┆ 1     ┆ a      ┆ … ┆ a    ┆ a    ┆ a   ┆ a   │
#> │ 4865 ┆ 1       ┆ 1     ┆ 1      ┆ … ┆ a    ┆ a    ┆ a   ┆ a   │
#> └──────┴─────────┴───────┴────────┴───┴──────┴──────┴─────┴─────┘

# using "names_glue" to specify the names of new columns
production <- expand.grid(
  product = c("A", "B"),
  country = c("AI", "EI"),
  year = 2000:2014
) |>
  filter((product == "A" & country == "AI") | product == "B") |>
  mutate(production = 1:45) |>
  as_polars_df()

production
#> shape: (45, 4)
#> ┌─────────┬─────────┬──────┬────────────┐
#> │ product ┆ country ┆ year ┆ production │
#> │ ---     ┆ ---     ┆ ---  ┆ ---        │
#> │ cat     ┆ cat     ┆ i32  ┆ i32        │
#> ╞═════════╪═════════╪══════╪════════════╡
#> │ A       ┆ AI      ┆ 2000 ┆ 1          │
#> │ B       ┆ AI      ┆ 2000 ┆ 2          │
#> │ B       ┆ EI      ┆ 2000 ┆ 3          │
#> │ A       ┆ AI      ┆ 2001 ┆ 4          │
#> │ B       ┆ AI      ┆ 2001 ┆ 5          │
#> │ …       ┆ …       ┆ …    ┆ …          │
#> │ B       ┆ AI      ┆ 2013 ┆ 41         │
#> │ B       ┆ EI      ┆ 2013 ┆ 42         │
#> │ A       ┆ AI      ┆ 2014 ┆ 43         │
#> │ B       ┆ AI      ┆ 2014 ┆ 44         │
#> │ B       ┆ EI      ┆ 2014 ┆ 45         │
#> └─────────┴─────────┴──────┴────────────┘

production |>
  pivot_wider(
    names_from = c(product, country),
    values_from = production,
    names_glue = "prod_{product}_{country}"
  )
#> shape: (15, 4)
#> ┌──────┬───────────┬───────────┬───────────┐
#> │ year ┆ prod_A_AI ┆ prod_B_AI ┆ prod_B_EI │
#> │ ---  ┆ ---       ┆ ---       ┆ ---       │
#> │ i32  ┆ i32       ┆ i32       ┆ i32       │
#> ╞══════╪═══════════╪═══════════╪═══════════╡
#> │ 2000 ┆ 1         ┆ 2         ┆ 3         │
#> │ 2001 ┆ 4         ┆ 5         ┆ 6         │
#> │ 2002 ┆ 7         ┆ 8         ┆ 9         │
#> │ 2003 ┆ 10        ┆ 11        ┆ 12        │
#> │ 2004 ┆ 13        ┆ 14        ┆ 15        │
#> │ …    ┆ …         ┆ …         ┆ …         │
#> │ 2010 ┆ 31        ┆ 32        ┆ 33        │
#> │ 2011 ┆ 34        ┆ 35        ┆ 36        │
#> │ 2012 ┆ 37        ┆ 38        ┆ 39        │
#> │ 2013 ┆ 40        ┆ 41        ┆ 42        │
#> │ 2014 ┆ 43        ┆ 44        ┆ 45        │
#> └──────┴───────────┴───────────┴───────────┘
```
