# Pivot a Data/LazyFrame from wide to long

Pivot a Data/LazyFrame from wide to long

## Usage

``` r
# S3 method for class 'polars_data_frame'
pivot_longer(
  data,
  cols,
  ...,
  names_to = "name",
  names_prefix = NULL,
  values_to = "value"
)

# S3 method for class 'polars_lazy_frame'
pivot_longer(
  data,
  cols,
  ...,
  names_to = "name",
  names_prefix = NULL,
  values_to = "value"
)
```

## Arguments

- data:

  A Polars Data/LazyFrame

- cols:

  Columns to pivot into longer format. Can be anything accepted by
  [`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html).

- ...:

  Dots which should be empty.

- names_to:

  The (quoted) name of the column that will contain the column names
  specified by `cols`.

- names_prefix:

  A regular expression used to remove matching text from the start of
  each variable name.

- values_to:

  A string specifying the name of the column to create from the data
  stored in cell values.

## Unknown arguments

Arguments that are supported by the original implementation in the
tidyverse but are not listed above will throw a warning by default if
they are specified. To change this behavior to error instead, use
`options(tidypolars_unknown_args = "error")`.

## Examples

``` r
pl_relig_income <- as_polars_df(tidyr::relig_income)
pl_relig_income
#> shape: (18, 11)
#> ┌────────────────────┬───────┬─────────┬─────────┬───┬──────────┬───────────┬───────┬──────────────┐
#> │ religion           ┆ <$10k ┆ $10-20k ┆ $20-30k ┆ … ┆ $75-100k ┆ $100-150k ┆ >150k ┆ Don't        │
#> │ ---                ┆ ---   ┆ ---     ┆ ---     ┆   ┆ ---      ┆ ---       ┆ ---   ┆ know/refused │
#> │ str                ┆ f64   ┆ f64     ┆ f64     ┆   ┆ f64      ┆ f64       ┆ f64   ┆ ---          │
#> │                    ┆       ┆         ┆         ┆   ┆          ┆           ┆       ┆ f64          │
#> ╞════════════════════╪═══════╪═════════╪═════════╪═══╪══════════╪═══════════╪═══════╪══════════════╡
#> │ Agnostic           ┆ 27.0  ┆ 34.0    ┆ 60.0    ┆ … ┆ 122.0    ┆ 109.0     ┆ 84.0  ┆ 96.0         │
#> │ Atheist            ┆ 12.0  ┆ 27.0    ┆ 37.0    ┆ … ┆ 73.0     ┆ 59.0      ┆ 74.0  ┆ 76.0         │
#> │ Buddhist           ┆ 27.0  ┆ 21.0    ┆ 30.0    ┆ … ┆ 62.0     ┆ 39.0      ┆ 53.0  ┆ 54.0         │
#> │ Catholic           ┆ 418.0 ┆ 617.0   ┆ 732.0   ┆ … ┆ 949.0    ┆ 792.0     ┆ 633.0 ┆ 1489.0       │
#> │ Don’t know/refused ┆ 15.0  ┆ 14.0    ┆ 15.0    ┆ … ┆ 21.0     ┆ 17.0      ┆ 18.0  ┆ 116.0        │
#> │ …                  ┆ …     ┆ …       ┆ …       ┆ … ┆ …        ┆ …         ┆ …     ┆ …            │
#> │ Orthodox           ┆ 13.0  ┆ 17.0    ┆ 23.0    ┆ … ┆ 38.0     ┆ 42.0      ┆ 46.0  ┆ 73.0         │
#> │ Other Christian    ┆ 9.0   ┆ 7.0     ┆ 11.0    ┆ … ┆ 18.0     ┆ 14.0      ┆ 12.0  ┆ 18.0         │
#> │ Other Faiths       ┆ 20.0  ┆ 33.0    ┆ 40.0    ┆ … ┆ 46.0     ┆ 40.0      ┆ 41.0  ┆ 71.0         │
#> │ Other World        ┆ 5.0   ┆ 2.0     ┆ 3.0     ┆ … ┆ 3.0      ┆ 4.0       ┆ 4.0   ┆ 8.0          │
#> │ Religions          ┆       ┆         ┆         ┆   ┆          ┆           ┆       ┆              │
#> │ Unaffiliated       ┆ 217.0 ┆ 299.0   ┆ 374.0   ┆ … ┆ 407.0    ┆ 321.0     ┆ 258.0 ┆ 597.0        │
#> └────────────────────┴───────┴─────────┴─────────┴───┴──────────┴───────────┴───────┴──────────────┘

pl_relig_income |>
  pivot_longer(!religion, names_to = "income", values_to = "count")
#> shape: (180, 3)
#> ┌──────────────┬────────────────────┬───────┐
#> │ religion     ┆ income             ┆ count │
#> │ ---          ┆ ---                ┆ ---   │
#> │ str          ┆ str                ┆ f64   │
#> ╞══════════════╪════════════════════╪═══════╡
#> │ Agnostic     ┆ <$10k              ┆ 27.0  │
#> │ Agnostic     ┆ $10-20k            ┆ 34.0  │
#> │ Agnostic     ┆ $20-30k            ┆ 60.0  │
#> │ Agnostic     ┆ $30-40k            ┆ 81.0  │
#> │ Agnostic     ┆ $40-50k            ┆ 76.0  │
#> │ …            ┆ …                  ┆ …     │
#> │ Unaffiliated ┆ $50-75k            ┆ 528.0 │
#> │ Unaffiliated ┆ $75-100k           ┆ 407.0 │
#> │ Unaffiliated ┆ $100-150k          ┆ 321.0 │
#> │ Unaffiliated ┆ >150k              ┆ 258.0 │
#> │ Unaffiliated ┆ Don't know/refused ┆ 597.0 │
#> └──────────────┴────────────────────┴───────┘

pl_billboard <- as_polars_df(tidyr::billboard)
pl_billboard
#> shape: (317, 79)
#> ┌──────────────────┬─────────────────────────┬──────────────┬──────┬───┬──────┬──────┬──────┬──────┐
#> │ artist           ┆ track                   ┆ date.entered ┆ wk1  ┆ … ┆ wk73 ┆ wk74 ┆ wk75 ┆ wk76 │
#> │ ---              ┆ ---                     ┆ ---          ┆ ---  ┆   ┆ ---  ┆ ---  ┆ ---  ┆ ---  │
#> │ str              ┆ str                     ┆ date         ┆ f64  ┆   ┆ bool ┆ bool ┆ bool ┆ bool │
#> ╞══════════════════╪═════════════════════════╪══════════════╪══════╪═══╪══════╪══════╪══════╪══════╡
#> │ 2 Pac            ┆ Baby Don't Cry (Keep... ┆ 2000-02-26   ┆ 87.0 ┆ … ┆ null ┆ null ┆ null ┆ null │
#> │ 2Ge+her          ┆ The Hardest Part Of ... ┆ 2000-09-02   ┆ 91.0 ┆ … ┆ null ┆ null ┆ null ┆ null │
#> │ 3 Doors Down     ┆ Kryptonite              ┆ 2000-04-08   ┆ 81.0 ┆ … ┆ null ┆ null ┆ null ┆ null │
#> │ 3 Doors Down     ┆ Loser                   ┆ 2000-10-21   ┆ 76.0 ┆ … ┆ null ┆ null ┆ null ┆ null │
#> │ 504 Boyz         ┆ Wobble Wobble           ┆ 2000-04-15   ┆ 57.0 ┆ … ┆ null ┆ null ┆ null ┆ null │
#> │ …                ┆ …                       ┆ …            ┆ …    ┆ … ┆ …    ┆ …    ┆ …    ┆ …    │
#> │ Yankee Grey      ┆ Another Nine Minutes    ┆ 2000-04-29   ┆ 86.0 ┆ … ┆ null ┆ null ┆ null ┆ null │
#> │ Yearwood, Trisha ┆ Real Live Woman         ┆ 2000-04-01   ┆ 85.0 ┆ … ┆ null ┆ null ┆ null ┆ null │
#> │ Ying Yang Twins  ┆ Whistle While You Tw... ┆ 2000-03-18   ┆ 95.0 ┆ … ┆ null ┆ null ┆ null ┆ null │
#> │ Zombie Nation    ┆ Kernkraft 400           ┆ 2000-09-02   ┆ 99.0 ┆ … ┆ null ┆ null ┆ null ┆ null │
#> │ matchbox twenty  ┆ Bent                    ┆ 2000-04-29   ┆ 60.0 ┆ … ┆ null ┆ null ┆ null ┆ null │
#> └──────────────────┴─────────────────────────┴──────────────┴──────┴───┴──────┴──────┴──────┴──────┘

pl_billboard |>
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    names_prefix = "wk",
    values_to = "rank",
  )
#> shape: (24_092, 5)
#> ┌─────────────────┬─────────────────────────┬──────────────┬──────┬──────┐
#> │ artist          ┆ track                   ┆ date.entered ┆ week ┆ rank │
#> │ ---             ┆ ---                     ┆ ---          ┆ ---  ┆ ---  │
#> │ str             ┆ str                     ┆ date         ┆ str  ┆ f64  │
#> ╞═════════════════╪═════════════════════════╪══════════════╪══════╪══════╡
#> │ 2 Pac           ┆ Baby Don't Cry (Keep... ┆ 2000-02-26   ┆ 2    ┆ 82.0 │
#> │ 2 Pac           ┆ Baby Don't Cry (Keep... ┆ 2000-02-26   ┆ 76   ┆ null │
#> │ 2 Pac           ┆ Baby Don't Cry (Keep... ┆ 2000-02-26   ┆ 75   ┆ null │
#> │ 2 Pac           ┆ Baby Don't Cry (Keep... ┆ 2000-02-26   ┆ 74   ┆ null │
#> │ 2 Pac           ┆ Baby Don't Cry (Keep... ┆ 2000-02-26   ┆ 73   ┆ null │
#> │ …               ┆ …                       ┆ …            ┆ …    ┆ …    │
#> │ matchbox twenty ┆ Bent                    ┆ 2000-04-29   ┆ 32   ┆ 28.0 │
#> │ matchbox twenty ┆ Bent                    ┆ 2000-04-29   ┆ 56   ┆ null │
#> │ matchbox twenty ┆ Bent                    ┆ 2000-04-29   ┆ 17   ┆ 2.0  │
#> │ matchbox twenty ┆ Bent                    ┆ 2000-04-29   ┆ 3    ┆ 29.0 │
#> │ matchbox twenty ┆ Bent                    ┆ 2000-04-29   ┆ 76   ┆ null │
#> └─────────────────┴─────────────────────────┴──────────────┴──────┴──────┘
```
