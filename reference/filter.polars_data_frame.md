# Keep or drop rows that match a condition

These functions are used to subset a data frame, applying the
expressions in `...` to determine which rows should be kept (for
[`filter()`](https://dplyr.tidyverse.org/reference/filter.html)) or
dropped (for
[`filter_out()`](https://dplyr.tidyverse.org/reference/filter.html)).

Multiple conditions can be supplied separated by a comma. These will be
combined with the `&` operator.

Both [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) and
[`filter_out()`](https://dplyr.tidyverse.org/reference/filter.html)
treat `NA` like `FALSE`. This subtle behavior can impact how you write
your conditions when missing values are involved. See the section on
`Missing values` for important details and examples.

[`filter_out()`](https://dplyr.tidyverse.org/reference/filter.html) is
available for `dplyr` \>= 1.2.0.

## Usage

``` r
# S3 method for class 'polars_data_frame'
filter(.data, ..., .by = NULL)

# S3 method for class 'polars_lazy_frame'
filter(.data, ..., .by = NULL)

# S3 method for class 'polars_data_frame'
filter_out(.data, ..., .by = NULL)

# S3 method for class 'polars_lazy_frame'
filter_out(.data, ..., .by = NULL)
```

## Arguments

- .data:

  A Polars Data/LazyFrame

- ...:

  Expressions that return a logical value, and are defined in terms of
  the variables in the data. If multiple expressions are included, they
  will be combined with the & operator. Only rows for which all
  conditions evaluate to `TRUE` are kept (for
  [`filter()`](https://dplyr.tidyverse.org/reference/filter.html)) or
  dropped (for
  [`filter_out()`](https://dplyr.tidyverse.org/reference/filter.html)).

- .by:

  Optionally, a selection of columns to group by for just this
  operation, functioning as an alternative to
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html).
  The group order is not maintained, use
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) if
  you want more control over it.

## Missing values

Read this section in the [`dplyr`
documentation](https://dplyr.tidyverse.org/dev/reference/filter.html#missing-values).

## Examples

``` r
starwars <- as_polars_df(dplyr::starwars)

# Filtering for one criterion
filter(starwars, species == "Human")
#> shape: (35, 14)
#> ┌─────────────┬────────┬───────┬─────────────┬───┬─────────┬─────────────┬────────────┬────────────┐
#> │ name        ┆ height ┆ mass  ┆ hair_color  ┆ … ┆ species ┆ films       ┆ vehicles   ┆ starships  │
#> │ ---         ┆ ---    ┆ ---   ┆ ---         ┆   ┆ ---     ┆ ---         ┆ ---        ┆ ---        │
#> │ str         ┆ i32    ┆ f64   ┆ str         ┆   ┆ str     ┆ list[str]   ┆ list[str]  ┆ list[str]  │
#> ╞═════════════╪════════╪═══════╪═════════════╪═══╪═════════╪═════════════╪════════════╪════════════╡
#> │ Luke        ┆ 172    ┆ 77.0  ┆ blond       ┆ … ┆ Human   ┆ ["A New     ┆ ["Snowspee ┆ ["X-wing", │
#> │ Skywalker   ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆ der",      ┆ "Imperial  │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆ "Imperial  ┆ shuttle"]  │
#> │             ┆        ┆       ┆             ┆   ┆         ┆             ┆ Spee…      ┆            │
#> │ Darth Vader ┆ 202    ┆ 136.0 ┆ none        ┆ … ┆ Human   ┆ ["A New     ┆ []         ┆ ["TIE      │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆            ┆ Advanced   │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆            ┆ x1"]       │
#> │ Leia Organa ┆ 150    ┆ 49.0  ┆ brown       ┆ … ┆ Human   ┆ ["A New     ┆ ["Imperial ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆ Speeder    ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆ Bike"]     ┆            │
#> │ Owen Lars   ┆ 178    ┆ 120.0 ┆ brown, grey ┆ … ┆ Human   ┆ ["A New     ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope",      ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ "Attack of  ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ the …       ┆            ┆            │
#> │ Beru        ┆ 165    ┆ 75.0  ┆ brown       ┆ … ┆ Human   ┆ ["A New     ┆ []         ┆ []         │
#> │ Whitesun    ┆        ┆       ┆             ┆   ┆         ┆ Hope",      ┆            ┆            │
#> │ Lars        ┆        ┆       ┆             ┆   ┆         ┆ "Attack of  ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ the …       ┆            ┆            │
#> │ …           ┆ …      ┆ …     ┆ …           ┆ … ┆ …       ┆ …           ┆ …          ┆ …          │
#> │ Raymus      ┆ 188    ┆ 79.0  ┆ brown       ┆ … ┆ Human   ┆ ["A New     ┆ []         ┆ []         │
#> │ Antilles    ┆        ┆       ┆             ┆   ┆         ┆ Hope",      ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ "Revenge of ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ the…        ┆            ┆            │
#> │ Finn        ┆ null   ┆ null  ┆ black       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ Rey         ┆ null   ┆ null  ┆ brown       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ Poe Dameron ┆ null   ┆ null  ┆ brown       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ ["X-wing"] │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ Captain     ┆ null   ┆ null  ┆ none        ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ []         │
#> │ Phasma      ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> └─────────────┴────────┴───────┴─────────────┴───┴─────────┴─────────────┴────────────┴────────────┘

# Filtering for multiple criteria within a single logical expression
filter(starwars, hair_color == "none" & eye_color == "black")
#> shape: (9, 14)
#> ┌────────────┬────────┬──────┬────────────┬───┬───────────┬──────────────┬───────────┬─────────────┐
#> │ name       ┆ height ┆ mass ┆ hair_color ┆ … ┆ species   ┆ films        ┆ vehicles  ┆ starships   │
#> │ ---        ┆ ---    ┆ ---  ┆ ---        ┆   ┆ ---       ┆ ---          ┆ ---       ┆ ---         │
#> │ str        ┆ i32    ┆ f64  ┆ str        ┆   ┆ str       ┆ list[str]    ┆ list[str] ┆ list[str]   │
#> ╞════════════╪════════╪══════╪════════════╪═══╪═══════════╪══════════════╪═══════════╪═════════════╡
#> │ Nien Nunb  ┆ 160    ┆ 68.0 ┆ none       ┆ … ┆ Sullustan ┆ ["Return of  ┆ []        ┆ ["Millenniu │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ the Jedi"]   ┆           ┆ m Falcon"]  │
#> │ Gasgano    ┆ 122    ┆ null ┆ none       ┆ … ┆ Xexto     ┆ ["The        ┆ []        ┆ []          │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ Phantom      ┆           ┆             │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ Menace"]     ┆           ┆             │
#> │ Kit Fisto  ┆ 196    ┆ 87.0 ┆ none       ┆ … ┆ Nautolan  ┆ ["The        ┆ []        ┆ []          │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ Phantom      ┆           ┆             │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ Menace",     ┆           ┆             │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ "Attack…     ┆           ┆             │
#> │ Plo Koon   ┆ 188    ┆ 80.0 ┆ none       ┆ … ┆ Kel Dor   ┆ ["The        ┆ []        ┆ ["Jedi star │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ Phantom      ┆           ┆ fighter"]   │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ Menace",     ┆           ┆             │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ "Attack…     ┆           ┆             │
#> │ Lama Su    ┆ 229    ┆ 88.0 ┆ none       ┆ … ┆ Kaminoan  ┆ ["Attack of  ┆ []        ┆ []          │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ the Clones"] ┆           ┆             │
#> │ Taun We    ┆ 213    ┆ null ┆ none       ┆ … ┆ Kaminoan  ┆ ["Attack of  ┆ []        ┆ []          │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ the Clones"] ┆           ┆             │
#> │ Shaak Ti   ┆ 178    ┆ 57.0 ┆ none       ┆ … ┆ Togruta   ┆ ["Attack of  ┆ []        ┆ []          │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ the Clones", ┆           ┆             │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ "Reve…       ┆           ┆             │
#> │ Tion Medon ┆ 206    ┆ 80.0 ┆ none       ┆ … ┆ Pau'an    ┆ ["Revenge of ┆ []        ┆ []          │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ the Sith"]   ┆           ┆             │
#> │ BB8        ┆ null   ┆ null ┆ none       ┆ … ┆ Droid     ┆ ["The Force  ┆ []        ┆ []          │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ Awakens"]    ┆           ┆             │
#> └────────────┴────────┴──────┴────────────┴───┴───────────┴──────────────┴───────────┴─────────────┘
filter(starwars, hair_color == "none" | eye_color == "black")
#> shape: (39, 14)
#> ┌────────────┬────────┬───────┬────────────┬───┬────────────┬────────────┬────────────┬────────────┐
#> │ name       ┆ height ┆ mass  ┆ hair_color ┆ … ┆ species    ┆ films      ┆ vehicles   ┆ starships  │
#> │ ---        ┆ ---    ┆ ---   ┆ ---        ┆   ┆ ---        ┆ ---        ┆ ---        ┆ ---        │
#> │ str        ┆ i32    ┆ f64   ┆ str        ┆   ┆ str        ┆ list[str]  ┆ list[str]  ┆ list[str]  │
#> ╞════════════╪════════╪═══════╪════════════╪═══╪════════════╪════════════╪════════════╪════════════╡
#> │ Darth      ┆ 202    ┆ 136.0 ┆ none       ┆ … ┆ Human      ┆ ["A New    ┆ []         ┆ ["TIE      │
#> │ Vader      ┆        ┆       ┆            ┆   ┆            ┆ Hope",     ┆            ┆ Advanced   │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ "The       ┆            ┆ x1"]       │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Empire     ┆            ┆            │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Str…       ┆            ┆            │
#> │ Greedo     ┆ 173    ┆ 74.0  ┆ null       ┆ … ┆ Rodian     ┆ ["A New    ┆ []         ┆ []         │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Hope"]     ┆            ┆            │
#> │ IG-88      ┆ 200    ┆ 140.0 ┆ none       ┆ … ┆ Droid      ┆ ["The      ┆ []         ┆ []         │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Empire     ┆            ┆            │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Strikes    ┆            ┆            │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Back"]     ┆            ┆            │
#> │ Bossk      ┆ 190    ┆ 113.0 ┆ none       ┆ … ┆ Trandoshan ┆ ["The      ┆ []         ┆ []         │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Empire     ┆            ┆            │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Strikes    ┆            ┆            │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Back"]     ┆            ┆            │
#> │ Lobot      ┆ 175    ┆ 79.0  ┆ none       ┆ … ┆ Human      ┆ ["The      ┆ []         ┆ []         │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Empire     ┆            ┆            │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Strikes    ┆            ┆            │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Back"]     ┆            ┆            │
#> │ …          ┆ …      ┆ …     ┆ …          ┆ … ┆ …          ┆ …          ┆ …          ┆ …          │
#> │ Grievous   ┆ 216    ┆ 159.0 ┆ none       ┆ … ┆ Kaleesh    ┆ ["Revenge  ┆ ["Tsmeu-6  ┆ ["Belbulla │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ of the     ┆ personal   ┆ b-22 starf │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Sith"]     ┆ wheel      ┆ ighter"]   │
#> │            ┆        ┆       ┆            ┆   ┆            ┆            ┆ bike"…     ┆            │
#> │ Sly Moore  ┆ 178    ┆ 48.0  ┆ none       ┆ … ┆ null       ┆ ["Attack   ┆ []         ┆ []         │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ of the     ┆            ┆            │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Clones",   ┆            ┆            │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ "Reve…     ┆            ┆            │
#> │ Tion Medon ┆ 206    ┆ 80.0  ┆ none       ┆ … ┆ Pau'an     ┆ ["Revenge  ┆ []         ┆ []         │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ of the     ┆            ┆            │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Sith"]     ┆            ┆            │
#> │ BB8        ┆ null   ┆ null  ┆ none       ┆ … ┆ Droid      ┆ ["The      ┆ []         ┆ []         │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Force      ┆            ┆            │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Awakens"]  ┆            ┆            │
#> │ Captain    ┆ null   ┆ null  ┆ none       ┆ … ┆ Human      ┆ ["The      ┆ []         ┆ []         │
#> │ Phasma     ┆        ┆       ┆            ┆   ┆            ┆ Force      ┆            ┆            │
#> │            ┆        ┆       ┆            ┆   ┆            ┆ Awakens"]  ┆            ┆            │
#> └────────────┴────────┴───────┴────────────┴───┴────────────┴────────────┴────────────┴────────────┘

# When multiple expressions are used, they are combined using &
filter(starwars, hair_color == "none", eye_color == "black")
#> shape: (9, 14)
#> ┌────────────┬────────┬──────┬────────────┬───┬───────────┬──────────────┬───────────┬─────────────┐
#> │ name       ┆ height ┆ mass ┆ hair_color ┆ … ┆ species   ┆ films        ┆ vehicles  ┆ starships   │
#> │ ---        ┆ ---    ┆ ---  ┆ ---        ┆   ┆ ---       ┆ ---          ┆ ---       ┆ ---         │
#> │ str        ┆ i32    ┆ f64  ┆ str        ┆   ┆ str       ┆ list[str]    ┆ list[str] ┆ list[str]   │
#> ╞════════════╪════════╪══════╪════════════╪═══╪═══════════╪══════════════╪═══════════╪═════════════╡
#> │ Nien Nunb  ┆ 160    ┆ 68.0 ┆ none       ┆ … ┆ Sullustan ┆ ["Return of  ┆ []        ┆ ["Millenniu │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ the Jedi"]   ┆           ┆ m Falcon"]  │
#> │ Gasgano    ┆ 122    ┆ null ┆ none       ┆ … ┆ Xexto     ┆ ["The        ┆ []        ┆ []          │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ Phantom      ┆           ┆             │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ Menace"]     ┆           ┆             │
#> │ Kit Fisto  ┆ 196    ┆ 87.0 ┆ none       ┆ … ┆ Nautolan  ┆ ["The        ┆ []        ┆ []          │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ Phantom      ┆           ┆             │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ Menace",     ┆           ┆             │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ "Attack…     ┆           ┆             │
#> │ Plo Koon   ┆ 188    ┆ 80.0 ┆ none       ┆ … ┆ Kel Dor   ┆ ["The        ┆ []        ┆ ["Jedi star │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ Phantom      ┆           ┆ fighter"]   │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ Menace",     ┆           ┆             │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ "Attack…     ┆           ┆             │
#> │ Lama Su    ┆ 229    ┆ 88.0 ┆ none       ┆ … ┆ Kaminoan  ┆ ["Attack of  ┆ []        ┆ []          │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ the Clones"] ┆           ┆             │
#> │ Taun We    ┆ 213    ┆ null ┆ none       ┆ … ┆ Kaminoan  ┆ ["Attack of  ┆ []        ┆ []          │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ the Clones"] ┆           ┆             │
#> │ Shaak Ti   ┆ 178    ┆ 57.0 ┆ none       ┆ … ┆ Togruta   ┆ ["Attack of  ┆ []        ┆ []          │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ the Clones", ┆           ┆             │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ "Reve…       ┆           ┆             │
#> │ Tion Medon ┆ 206    ┆ 80.0 ┆ none       ┆ … ┆ Pau'an    ┆ ["Revenge of ┆ []        ┆ []          │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ the Sith"]   ┆           ┆             │
#> │ BB8        ┆ null   ┆ null ┆ none       ┆ … ┆ Droid     ┆ ["The Force  ┆ []        ┆ []          │
#> │            ┆        ┆      ┆            ┆   ┆           ┆ Awakens"]    ┆           ┆             │
#> └────────────┴────────┴──────┴────────────┴───┴───────────┴──────────────┴───────────┴─────────────┘

# Filtering out to drop rows
filter_out(starwars, hair_color == "none")
#> shape: (49, 14)
#> ┌─────────────┬────────┬───────┬─────────────┬───┬─────────┬─────────────┬────────────┬────────────┐
#> │ name        ┆ height ┆ mass  ┆ hair_color  ┆ … ┆ species ┆ films       ┆ vehicles   ┆ starships  │
#> │ ---         ┆ ---    ┆ ---   ┆ ---         ┆   ┆ ---     ┆ ---         ┆ ---        ┆ ---        │
#> │ str         ┆ i32    ┆ f64   ┆ str         ┆   ┆ str     ┆ list[str]   ┆ list[str]  ┆ list[str]  │
#> ╞═════════════╪════════╪═══════╪═════════════╪═══╪═════════╪═════════════╪════════════╪════════════╡
#> │ Luke        ┆ 172    ┆ 77.0  ┆ blond       ┆ … ┆ Human   ┆ ["A New     ┆ ["Snowspee ┆ ["X-wing", │
#> │ Skywalker   ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆ der",      ┆ "Imperial  │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆ "Imperial  ┆ shuttle"]  │
#> │             ┆        ┆       ┆             ┆   ┆         ┆             ┆ Spee…      ┆            │
#> │ C-3PO       ┆ 167    ┆ 75.0  ┆ null        ┆ … ┆ Droid   ┆ ["A New     ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆            ┆            │
#> │ R2-D2       ┆ 96     ┆ 32.0  ┆ null        ┆ … ┆ Droid   ┆ ["A New     ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆            ┆            │
#> │ Leia Organa ┆ 150    ┆ 49.0  ┆ brown       ┆ … ┆ Human   ┆ ["A New     ┆ ["Imperial ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆ Speeder    ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆ Bike"]     ┆            │
#> │ Owen Lars   ┆ 178    ┆ 120.0 ┆ brown, grey ┆ … ┆ Human   ┆ ["A New     ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope",      ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ "Attack of  ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ the …       ┆            ┆            │
#> │ …           ┆ …      ┆ …     ┆ …           ┆ … ┆ …       ┆ …           ┆ …          ┆ …          │
#> │ Tarfful     ┆ 234    ┆ 136.0 ┆ brown       ┆ … ┆ Wookiee ┆ ["Revenge   ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ of the      ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Sith"]      ┆            ┆            │
#> │ Raymus      ┆ 188    ┆ 79.0  ┆ brown       ┆ … ┆ Human   ┆ ["A New     ┆ []         ┆ []         │
#> │ Antilles    ┆        ┆       ┆             ┆   ┆         ┆ Hope",      ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ "Revenge of ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ the…        ┆            ┆            │
#> │ Finn        ┆ null   ┆ null  ┆ black       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ Rey         ┆ null   ┆ null  ┆ brown       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ Poe Dameron ┆ null   ┆ null  ┆ brown       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ ["X-wing"] │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> └─────────────┴────────┴───────┴─────────────┴───┴─────────┴─────────────┴────────────┴────────────┘

# When filtering out, it can be useful to first interactively filter for the
# rows you want to drop, just to double check that you've written the
# conditions correctly. Then, just change `filter()` to `filter_out()`.
filter(starwars, mass > 1000, eye_color == "orange")
#> shape: (1, 14)
#> ┌───────────┬────────┬────────┬────────────┬───┬─────────┬─────────────────┬───────────┬───────────┐
#> │ name      ┆ height ┆ mass   ┆ hair_color ┆ … ┆ species ┆ films           ┆ vehicles  ┆ starships │
#> │ ---       ┆ ---    ┆ ---    ┆ ---        ┆   ┆ ---     ┆ ---             ┆ ---       ┆ ---       │
#> │ str       ┆ i32    ┆ f64    ┆ str        ┆   ┆ str     ┆ list[str]       ┆ list[str] ┆ list[str] │
#> ╞═══════════╪════════╪════════╪════════════╪═══╪═════════╪═════════════════╪═══════════╪═══════════╡
#> │ Jabba     ┆ 175    ┆ 1358.0 ┆ null       ┆ … ┆ Hutt    ┆ ["A New Hope",  ┆ []        ┆ []        │
#> │ Desilijic ┆        ┆        ┆            ┆   ┆         ┆ "Return of the  ┆           ┆           │
#> │ Tiure     ┆        ┆        ┆            ┆   ┆         ┆ …               ┆           ┆           │
#> └───────────┴────────┴────────┴────────────┴───┴─────────┴─────────────────┴───────────┴───────────┘
filter_out(starwars, mass > 1000, eye_color == "orange")
#> shape: (86, 14)
#> ┌─────────────┬────────┬───────┬────────────┬───┬─────────┬─────────────┬─────────────┬────────────┐
#> │ name        ┆ height ┆ mass  ┆ hair_color ┆ … ┆ species ┆ films       ┆ vehicles    ┆ starships  │
#> │ ---         ┆ ---    ┆ ---   ┆ ---        ┆   ┆ ---     ┆ ---         ┆ ---         ┆ ---        │
#> │ str         ┆ i32    ┆ f64   ┆ str        ┆   ┆ str     ┆ list[str]   ┆ list[str]   ┆ list[str]  │
#> ╞═════════════╪════════╪═══════╪════════════╪═══╪═════════╪═════════════╪═════════════╪════════════╡
#> │ Luke        ┆ 172    ┆ 77.0  ┆ blond      ┆ … ┆ Human   ┆ ["A New     ┆ ["Snowspeed ┆ ["X-wing", │
#> │ Skywalker   ┆        ┆       ┆            ┆   ┆         ┆ Hope", "The ┆ er",        ┆ "Imperial  │
#> │             ┆        ┆       ┆            ┆   ┆         ┆ Empire Str… ┆ "Imperial   ┆ shuttle"]  │
#> │             ┆        ┆       ┆            ┆   ┆         ┆             ┆ Spee…       ┆            │
#> │ C-3PO       ┆ 167    ┆ 75.0  ┆ null       ┆ … ┆ Droid   ┆ ["A New     ┆ []          ┆ []         │
#> │             ┆        ┆       ┆            ┆   ┆         ┆ Hope", "The ┆             ┆            │
#> │             ┆        ┆       ┆            ┆   ┆         ┆ Empire Str… ┆             ┆            │
#> │ R2-D2       ┆ 96     ┆ 32.0  ┆ null       ┆ … ┆ Droid   ┆ ["A New     ┆ []          ┆ []         │
#> │             ┆        ┆       ┆            ┆   ┆         ┆ Hope", "The ┆             ┆            │
#> │             ┆        ┆       ┆            ┆   ┆         ┆ Empire Str… ┆             ┆            │
#> │ Darth Vader ┆ 202    ┆ 136.0 ┆ none       ┆ … ┆ Human   ┆ ["A New     ┆ []          ┆ ["TIE      │
#> │             ┆        ┆       ┆            ┆   ┆         ┆ Hope", "The ┆             ┆ Advanced   │
#> │             ┆        ┆       ┆            ┆   ┆         ┆ Empire Str… ┆             ┆ x1"]       │
#> │ Leia Organa ┆ 150    ┆ 49.0  ┆ brown      ┆ … ┆ Human   ┆ ["A New     ┆ ["Imperial  ┆ []         │
#> │             ┆        ┆       ┆            ┆   ┆         ┆ Hope", "The ┆ Speeder     ┆            │
#> │             ┆        ┆       ┆            ┆   ┆         ┆ Empire Str… ┆ Bike"]      ┆            │
#> │ …           ┆ …      ┆ …     ┆ …          ┆ … ┆ …       ┆ …           ┆ …           ┆ …          │
#> │ Finn        ┆ null   ┆ null  ┆ black      ┆ … ┆ Human   ┆ ["The Force ┆ []          ┆ []         │
#> │             ┆        ┆       ┆            ┆   ┆         ┆ Awakens"]   ┆             ┆            │
#> │ Rey         ┆ null   ┆ null  ┆ brown      ┆ … ┆ Human   ┆ ["The Force ┆ []          ┆ []         │
#> │             ┆        ┆       ┆            ┆   ┆         ┆ Awakens"]   ┆             ┆            │
#> │ Poe Dameron ┆ null   ┆ null  ┆ brown      ┆ … ┆ Human   ┆ ["The Force ┆ []          ┆ ["X-wing"] │
#> │             ┆        ┆       ┆            ┆   ┆         ┆ Awakens"]   ┆             ┆            │
#> │ BB8         ┆ null   ┆ null  ┆ none       ┆ … ┆ Droid   ┆ ["The Force ┆ []          ┆ []         │
#> │             ┆        ┆       ┆            ┆   ┆         ┆ Awakens"]   ┆             ┆            │
#> │ Captain     ┆ null   ┆ null  ┆ none       ┆ … ┆ Human   ┆ ["The Force ┆ []          ┆ []         │
#> │ Phasma      ┆        ┆       ┆            ┆   ┆         ┆ Awakens"]   ┆             ┆            │
#> └─────────────┴────────┴───────┴────────────┴───┴─────────┴─────────────┴─────────────┴────────────┘

# The filtering operation may yield different results on grouped
# tibbles because the expressions are computed within groups.
#
# The following keeps rows where `mass` is greater than the
# global average:
starwars |> filter(mass > mean(mass, na.rm = TRUE))
#> shape: (10, 14)
#> ┌────────────┬────────┬────────┬────────────┬───┬────────────┬────────────┬────────────┬───────────┐
#> │ name       ┆ height ┆ mass   ┆ hair_color ┆ … ┆ species    ┆ films      ┆ vehicles   ┆ starships │
#> │ ---        ┆ ---    ┆ ---    ┆ ---        ┆   ┆ ---        ┆ ---        ┆ ---        ┆ ---       │
#> │ str        ┆ i32    ┆ f64    ┆ str        ┆   ┆ str        ┆ list[str]  ┆ list[str]  ┆ list[str] │
#> ╞════════════╪════════╪════════╪════════════╪═══╪════════════╪════════════╪════════════╪═══════════╡
#> │ Darth      ┆ 202    ┆ 136.0  ┆ none       ┆ … ┆ Human      ┆ ["A New    ┆ []         ┆ ["TIE     │
#> │ Vader      ┆        ┆        ┆            ┆   ┆            ┆ Hope",     ┆            ┆ Advanced  │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ "The       ┆            ┆ x1"]      │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ Empire     ┆            ┆           │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ Str…       ┆            ┆           │
#> │ Owen Lars  ┆ 178    ┆ 120.0  ┆ brown,     ┆ … ┆ Human      ┆ ["A New    ┆ []         ┆ []        │
#> │            ┆        ┆        ┆ grey       ┆   ┆            ┆ Hope",     ┆            ┆           │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ "Attack of ┆            ┆           │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ the …      ┆            ┆           │
#> │ Chewbacca  ┆ 228    ┆ 112.0  ┆ brown      ┆ … ┆ Wookiee    ┆ ["A New    ┆ ["AT-ST"]  ┆ ["Millenn │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ Hope",     ┆            ┆ ium       │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ "The       ┆            ┆ Falcon",  │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ Empire     ┆            ┆ "Imperia… │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ Str…       ┆            ┆           │
#> │ Jabba      ┆ 175    ┆ 1358.0 ┆ null       ┆ … ┆ Hutt       ┆ ["A New    ┆ []         ┆ []        │
#> │ Desilijic  ┆        ┆        ┆            ┆   ┆            ┆ Hope",     ┆            ┆           │
#> │ Tiure      ┆        ┆        ┆            ┆   ┆            ┆ "Return of ┆            ┆           │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ the …      ┆            ┆           │
#> │ Jek Tono   ┆ 180    ┆ 110.0  ┆ brown      ┆ … ┆ null       ┆ ["A New    ┆ []         ┆ ["X-wing" │
#> │ Porkins    ┆        ┆        ┆            ┆   ┆            ┆ Hope"]     ┆            ┆ ]         │
#> │ IG-88      ┆ 200    ┆ 140.0  ┆ none       ┆ … ┆ Droid      ┆ ["The      ┆ []         ┆ []        │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ Empire     ┆            ┆           │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ Strikes    ┆            ┆           │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ Back"]     ┆            ┆           │
#> │ Bossk      ┆ 190    ┆ 113.0  ┆ none       ┆ … ┆ Trandoshan ┆ ["The      ┆ []         ┆ []        │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ Empire     ┆            ┆           │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ Strikes    ┆            ┆           │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ Back"]     ┆            ┆           │
#> │ Dexter     ┆ 198    ┆ 102.0  ┆ none       ┆ … ┆ Besalisk   ┆ ["Attack   ┆ []         ┆ []        │
#> │ Jettster   ┆        ┆        ┆            ┆   ┆            ┆ of the     ┆            ┆           │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ Clones"]   ┆            ┆           │
#> │ Grievous   ┆ 216    ┆ 159.0  ┆ none       ┆ … ┆ Kaleesh    ┆ ["Revenge  ┆ ["Tsmeu-6  ┆ ["Belbull │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ of the     ┆ personal   ┆ ab-22 sta │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ Sith"]     ┆ wheel      ┆ rfighter" │
#> │            ┆        ┆        ┆            ┆   ┆            ┆            ┆ bike"…     ┆ ]         │
#> │ Tarfful    ┆ 234    ┆ 136.0  ┆ brown      ┆ … ┆ Wookiee    ┆ ["Revenge  ┆ []         ┆ []        │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ of the     ┆            ┆           │
#> │            ┆        ┆        ┆            ┆   ┆            ┆ Sith"]     ┆            ┆           │
#> └────────────┴────────┴────────┴────────────┴───┴────────────┴────────────┴────────────┴───────────┘

# Whereas this keeps rows with `mass` greater than the per `gender`
# average:
starwars |> filter(mass > mean(mass, na.rm = TRUE), .by = gender)
#> shape: (15, 14)
#> ┌─────────────┬────────┬────────┬────────────┬───┬──────────┬────────────┬────────────┬────────────┐
#> │ name        ┆ height ┆ mass   ┆ hair_color ┆ … ┆ species  ┆ films      ┆ vehicles   ┆ starships  │
#> │ ---         ┆ ---    ┆ ---    ┆ ---        ┆   ┆ ---      ┆ ---        ┆ ---        ┆ ---        │
#> │ str         ┆ i32    ┆ f64    ┆ str        ┆   ┆ str      ┆ list[str]  ┆ list[str]  ┆ list[str]  │
#> ╞═════════════╪════════╪════════╪════════════╪═══╪══════════╪════════════╪════════════╪════════════╡
#> │ Darth Vader ┆ 202    ┆ 136.0  ┆ none       ┆ … ┆ Human    ┆ ["A New    ┆ []         ┆ ["TIE      │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ Hope",     ┆            ┆ Advanced   │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ "The       ┆            ┆ x1"]       │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ Empire     ┆            ┆            │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ Str…       ┆            ┆            │
#> │ Owen Lars   ┆ 178    ┆ 120.0  ┆ brown,     ┆ … ┆ Human    ┆ ["A New    ┆ []         ┆ []         │
#> │             ┆        ┆        ┆ grey       ┆   ┆          ┆ Hope",     ┆            ┆            │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ "Attack of ┆            ┆            │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ the …      ┆            ┆            │
#> │ Beru        ┆ 165    ┆ 75.0   ┆ brown      ┆ … ┆ Human    ┆ ["A New    ┆ []         ┆ []         │
#> │ Whitesun    ┆        ┆        ┆            ┆   ┆          ┆ Hope",     ┆            ┆            │
#> │ Lars        ┆        ┆        ┆            ┆   ┆          ┆ "Attack of ┆            ┆            │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ the …      ┆            ┆            │
#> │ Chewbacca   ┆ 228    ┆ 112.0  ┆ brown      ┆ … ┆ Wookiee  ┆ ["A New    ┆ ["AT-ST"]  ┆ ["Millenni │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ Hope",     ┆            ┆ um         │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ "The       ┆            ┆ Falcon",   │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ Empire     ┆            ┆ "Imperia…  │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ Str…       ┆            ┆            │
#> │ Jabba       ┆ 175    ┆ 1358.0 ┆ null       ┆ … ┆ Hutt     ┆ ["A New    ┆ []         ┆ []         │
#> │ Desilijic   ┆        ┆        ┆            ┆   ┆          ┆ Hope",     ┆            ┆            │
#> │ Tiure       ┆        ┆        ┆            ┆   ┆          ┆ "Return of ┆            ┆            │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ the …      ┆            ┆            │
#> │ …           ┆ …      ┆ …      ┆ …          ┆ … ┆ …        ┆ …          ┆ …          ┆ …          │
#> │ Luminara    ┆ 170    ┆ 56.2   ┆ black      ┆ … ┆ Mirialan ┆ ["Attack   ┆ []         ┆ []         │
#> │ Unduli      ┆        ┆        ┆            ┆   ┆          ┆ of the     ┆            ┆            │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ Clones",   ┆            ┆            │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ "Reve…     ┆            ┆            │
#> │ Zam Wesell  ┆ 168    ┆ 55.0   ┆ blonde     ┆ … ┆ Clawdite ┆ ["Attack   ┆ ["Koro-2   ┆ []         │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ of the     ┆ Exodrive   ┆            │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ Clones"]   ┆ airspeeder ┆            │
#> │             ┆        ┆        ┆            ┆   ┆          ┆            ┆ "]         ┆            │
#> │ Shaak Ti    ┆ 178    ┆ 57.0   ┆ none       ┆ … ┆ Togruta  ┆ ["Attack   ┆ []         ┆ []         │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ of the     ┆            ┆            │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ Clones",   ┆            ┆            │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ "Reve…     ┆            ┆            │
#> │ Grievous    ┆ 216    ┆ 159.0  ┆ none       ┆ … ┆ Kaleesh  ┆ ["Revenge  ┆ ["Tsmeu-6  ┆ ["Belbulla │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ of the     ┆ personal   ┆ b-22 starf │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ Sith"]     ┆ wheel      ┆ ighter"]   │
#> │             ┆        ┆        ┆            ┆   ┆          ┆            ┆ bike"…     ┆            │
#> │ Tarfful     ┆ 234    ┆ 136.0  ┆ brown      ┆ … ┆ Wookiee  ┆ ["Revenge  ┆ []         ┆ []         │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ of the     ┆            ┆            │
#> │             ┆        ┆        ┆            ┆   ┆          ┆ Sith"]     ┆            ┆            │
#> └─────────────┴────────┴────────┴────────────┴───┴──────────┴────────────┴────────────┴────────────┘

# If you find yourself trying to use a `filter()` to drop rows, then
# you should consider if switching to `filter_out()` can simplify your
# conditions. For example, to drop blond individuals, you might try:
starwars |> filter(hair_color != "blond")
#> shape: (79, 14)
#> ┌─────────────┬────────┬───────┬─────────────┬───┬─────────┬─────────────┬────────────┬────────────┐
#> │ name        ┆ height ┆ mass  ┆ hair_color  ┆ … ┆ species ┆ films       ┆ vehicles   ┆ starships  │
#> │ ---         ┆ ---    ┆ ---   ┆ ---         ┆   ┆ ---     ┆ ---         ┆ ---        ┆ ---        │
#> │ str         ┆ i32    ┆ f64   ┆ str         ┆   ┆ str     ┆ list[str]   ┆ list[str]  ┆ list[str]  │
#> ╞═════════════╪════════╪═══════╪═════════════╪═══╪═════════╪═════════════╪════════════╪════════════╡
#> │ Darth Vader ┆ 202    ┆ 136.0 ┆ none        ┆ … ┆ Human   ┆ ["A New     ┆ []         ┆ ["TIE      │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆            ┆ Advanced   │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆            ┆ x1"]       │
#> │ Leia Organa ┆ 150    ┆ 49.0  ┆ brown       ┆ … ┆ Human   ┆ ["A New     ┆ ["Imperial ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆ Speeder    ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆ Bike"]     ┆            │
#> │ Owen Lars   ┆ 178    ┆ 120.0 ┆ brown, grey ┆ … ┆ Human   ┆ ["A New     ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope",      ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ "Attack of  ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ the …       ┆            ┆            │
#> │ Beru        ┆ 165    ┆ 75.0  ┆ brown       ┆ … ┆ Human   ┆ ["A New     ┆ []         ┆ []         │
#> │ Whitesun    ┆        ┆       ┆             ┆   ┆         ┆ Hope",      ┆            ┆            │
#> │ Lars        ┆        ┆       ┆             ┆   ┆         ┆ "Attack of  ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ the …       ┆            ┆            │
#> │ Biggs       ┆ 183    ┆ 84.0  ┆ black       ┆ … ┆ Human   ┆ ["A New     ┆ []         ┆ ["X-wing"] │
#> │ Darklighter ┆        ┆       ┆             ┆   ┆         ┆ Hope"]      ┆            ┆            │
#> │ …           ┆ …      ┆ …     ┆ …           ┆ … ┆ …       ┆ …           ┆ …          ┆ …          │
#> │ Finn        ┆ null   ┆ null  ┆ black       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ Rey         ┆ null   ┆ null  ┆ brown       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ Poe Dameron ┆ null   ┆ null  ┆ brown       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ ["X-wing"] │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ BB8         ┆ null   ┆ null  ┆ none        ┆ … ┆ Droid   ┆ ["The Force ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ Captain     ┆ null   ┆ null  ┆ none        ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ []         │
#> │ Phasma      ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> └─────────────┴────────┴───────┴─────────────┴───┴─────────┴─────────────┴────────────┴────────────┘

# But this also drops rows with an `NA` hair color! To retain those:
starwars |> filter(hair_color != "blond" | is.na(hair_color))
#> shape: (84, 14)
#> ┌─────────────┬────────┬───────┬─────────────┬───┬─────────┬─────────────┬────────────┬────────────┐
#> │ name        ┆ height ┆ mass  ┆ hair_color  ┆ … ┆ species ┆ films       ┆ vehicles   ┆ starships  │
#> │ ---         ┆ ---    ┆ ---   ┆ ---         ┆   ┆ ---     ┆ ---         ┆ ---        ┆ ---        │
#> │ str         ┆ i32    ┆ f64   ┆ str         ┆   ┆ str     ┆ list[str]   ┆ list[str]  ┆ list[str]  │
#> ╞═════════════╪════════╪═══════╪═════════════╪═══╪═════════╪═════════════╪════════════╪════════════╡
#> │ C-3PO       ┆ 167    ┆ 75.0  ┆ null        ┆ … ┆ Droid   ┆ ["A New     ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆            ┆            │
#> │ R2-D2       ┆ 96     ┆ 32.0  ┆ null        ┆ … ┆ Droid   ┆ ["A New     ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆            ┆            │
#> │ Darth Vader ┆ 202    ┆ 136.0 ┆ none        ┆ … ┆ Human   ┆ ["A New     ┆ []         ┆ ["TIE      │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆            ┆ Advanced   │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆            ┆ x1"]       │
#> │ Leia Organa ┆ 150    ┆ 49.0  ┆ brown       ┆ … ┆ Human   ┆ ["A New     ┆ ["Imperial ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆ Speeder    ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆ Bike"]     ┆            │
#> │ Owen Lars   ┆ 178    ┆ 120.0 ┆ brown, grey ┆ … ┆ Human   ┆ ["A New     ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope",      ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ "Attack of  ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ the …       ┆            ┆            │
#> │ …           ┆ …      ┆ …     ┆ …           ┆ … ┆ …       ┆ …           ┆ …          ┆ …          │
#> │ Finn        ┆ null   ┆ null  ┆ black       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ Rey         ┆ null   ┆ null  ┆ brown       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ Poe Dameron ┆ null   ┆ null  ┆ brown       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ ["X-wing"] │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ BB8         ┆ null   ┆ null  ┆ none        ┆ … ┆ Droid   ┆ ["The Force ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ Captain     ┆ null   ┆ null  ┆ none        ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ []         │
#> │ Phasma      ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> └─────────────┴────────┴───────┴─────────────┴───┴─────────┴─────────────┴────────────┴────────────┘

# But explicit `NA` handling like this can quickly get unwieldy, especially
# with multiple conditions. Since your intent was to specify rows to drop
# rather than rows to keep, use `filter_out()`. This also removes the need
# for any explicit `NA` handling.
starwars |> filter_out(hair_color == "blond")
#> shape: (84, 14)
#> ┌─────────────┬────────┬───────┬─────────────┬───┬─────────┬─────────────┬────────────┬────────────┐
#> │ name        ┆ height ┆ mass  ┆ hair_color  ┆ … ┆ species ┆ films       ┆ vehicles   ┆ starships  │
#> │ ---         ┆ ---    ┆ ---   ┆ ---         ┆   ┆ ---     ┆ ---         ┆ ---        ┆ ---        │
#> │ str         ┆ i32    ┆ f64   ┆ str         ┆   ┆ str     ┆ list[str]   ┆ list[str]  ┆ list[str]  │
#> ╞═════════════╪════════╪═══════╪═════════════╪═══╪═════════╪═════════════╪════════════╪════════════╡
#> │ C-3PO       ┆ 167    ┆ 75.0  ┆ null        ┆ … ┆ Droid   ┆ ["A New     ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆            ┆            │
#> │ R2-D2       ┆ 96     ┆ 32.0  ┆ null        ┆ … ┆ Droid   ┆ ["A New     ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆            ┆            │
#> │ Darth Vader ┆ 202    ┆ 136.0 ┆ none        ┆ … ┆ Human   ┆ ["A New     ┆ []         ┆ ["TIE      │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆            ┆ Advanced   │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆            ┆ x1"]       │
#> │ Leia Organa ┆ 150    ┆ 49.0  ┆ brown       ┆ … ┆ Human   ┆ ["A New     ┆ ["Imperial ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope", "The ┆ Speeder    ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Empire Str… ┆ Bike"]     ┆            │
#> │ Owen Lars   ┆ 178    ┆ 120.0 ┆ brown, grey ┆ … ┆ Human   ┆ ["A New     ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Hope",      ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ "Attack of  ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ the …       ┆            ┆            │
#> │ …           ┆ …      ┆ …     ┆ …           ┆ … ┆ …       ┆ …           ┆ …          ┆ …          │
#> │ Finn        ┆ null   ┆ null  ┆ black       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ Rey         ┆ null   ┆ null  ┆ brown       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ Poe Dameron ┆ null   ┆ null  ┆ brown       ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ ["X-wing"] │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ BB8         ┆ null   ┆ null  ┆ none        ┆ … ┆ Droid   ┆ ["The Force ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> │ Captain     ┆ null   ┆ null  ┆ none        ┆ … ┆ Human   ┆ ["The Force ┆ []         ┆ []         │
#> │ Phasma      ┆        ┆       ┆             ┆   ┆         ┆ Awakens"]   ┆            ┆            │
#> └─────────────┴────────┴───────┴─────────────┴───┴─────────┴─────────────┴────────────┴────────────┘

# To refer to column names that are stored as strings, use the `.data`
# pronoun:
vars <- c("mass", "height")
cond <- c(80, 150)
starwars |>
  filter(
    .data[[vars[[1]]]] > cond[[1]],
    .data[[vars[[2]]]] > cond[[2]]
  )
#> shape: (21, 14)
#> ┌─────────────┬────────┬───────┬─────────────┬───┬──────────┬────────────┬────────────┬────────────┐
#> │ name        ┆ height ┆ mass  ┆ hair_color  ┆ … ┆ species  ┆ films      ┆ vehicles   ┆ starships  │
#> │ ---         ┆ ---    ┆ ---   ┆ ---         ┆   ┆ ---      ┆ ---        ┆ ---        ┆ ---        │
#> │ str         ┆ i32    ┆ f64   ┆ str         ┆   ┆ str      ┆ list[str]  ┆ list[str]  ┆ list[str]  │
#> ╞═════════════╪════════╪═══════╪═════════════╪═══╪══════════╪════════════╪════════════╪════════════╡
#> │ Darth Vader ┆ 202    ┆ 136.0 ┆ none        ┆ … ┆ Human    ┆ ["A New    ┆ []         ┆ ["TIE      │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ Hope",     ┆            ┆ Advanced   │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ "The       ┆            ┆ x1"]       │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ Empire     ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ Str…       ┆            ┆            │
#> │ Owen Lars   ┆ 178    ┆ 120.0 ┆ brown, grey ┆ … ┆ Human    ┆ ["A New    ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ Hope",     ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ "Attack of ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ the …      ┆            ┆            │
#> │ Biggs       ┆ 183    ┆ 84.0  ┆ black       ┆ … ┆ Human    ┆ ["A New    ┆ []         ┆ ["X-wing"] │
#> │ Darklighter ┆        ┆       ┆             ┆   ┆          ┆ Hope"]     ┆            ┆            │
#> │ Anakin      ┆ 188    ┆ 84.0  ┆ blond       ┆ … ┆ Human    ┆ ["The      ┆ ["Zephyr-G ┆ ["Naboo    │
#> │ Skywalker   ┆        ┆       ┆             ┆   ┆          ┆ Phantom    ┆ swoop      ┆ fighter",  │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ Menace",   ┆ bike",     ┆ "Trade     │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ "Attack…   ┆ "XJ-6 …    ┆ Feder…     │
#> │ Chewbacca   ┆ 228    ┆ 112.0 ┆ brown       ┆ … ┆ Wookiee  ┆ ["A New    ┆ ["AT-ST"]  ┆ ["Millenni │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ Hope",     ┆            ┆ um         │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ "The       ┆            ┆ Falcon",   │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ Empire     ┆            ┆ "Imperia…  │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ Str…       ┆            ┆            │
#> │ …           ┆ …      ┆ …     ┆ …           ┆ … ┆ …        ┆ …          ┆ …          ┆ …          │
#> │ Gregar      ┆ 185    ┆ 85.0  ┆ black       ┆ … ┆ null     ┆ ["Attack   ┆ []         ┆ ["Naboo    │
#> │ Typho       ┆        ┆       ┆             ┆   ┆          ┆ of the     ┆            ┆ fighter"]  │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ Clones"]   ┆            ┆            │
#> │ Dexter      ┆ 198    ┆ 102.0 ┆ none        ┆ … ┆ Besalisk ┆ ["Attack   ┆ []         ┆ []         │
#> │ Jettster    ┆        ┆       ┆             ┆   ┆          ┆ of the     ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ Clones"]   ┆            ┆            │
#> │ Lama Su     ┆ 229    ┆ 88.0  ┆ none        ┆ … ┆ Kaminoan ┆ ["Attack   ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ of the     ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ Clones"]   ┆            ┆            │
#> │ Grievous    ┆ 216    ┆ 159.0 ┆ none        ┆ … ┆ Kaleesh  ┆ ["Revenge  ┆ ["Tsmeu-6  ┆ ["Belbulla │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ of the     ┆ personal   ┆ b-22 starf │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ Sith"]     ┆ wheel      ┆ ighter"]   │
#> │             ┆        ┆       ┆             ┆   ┆          ┆            ┆ bike"…     ┆            │
#> │ Tarfful     ┆ 234    ┆ 136.0 ┆ brown       ┆ … ┆ Wookiee  ┆ ["Revenge  ┆ []         ┆ []         │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ of the     ┆            ┆            │
#> │             ┆        ┆       ┆             ┆   ┆          ┆ Sith"]     ┆            ┆            │
#> └─────────────┴────────┴───────┴─────────────┴───┴──────────┴────────────┴────────────┴────────────┘
```
