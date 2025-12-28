# Split a string column into rows

Each of these functions takes a string and splits it into multiple rows:

- `separate_longer_delim_polars()` splits by delimiter. It is the
  `polars` equivalent of
  [`tidyr::separate_longer_delim()`](https://tidyr.tidyverse.org/reference/separate_longer_delim.html).

- `separate_longer_position_polars()` splits by fixed width. It is the
  `polars` equivalent of
  [`tidyr::separate_longer_position()`](https://tidyr.tidyverse.org/reference/separate_longer_delim.html).

## Usage

``` r
separate_longer_delim_polars(data, cols, delim, ...)

separate_longer_position_polars(data, cols, width, ..., keep_empty = FALSE)
```

## Arguments

- data:

  A Polars DataFrame or LazyFrame.

- cols:

  \<[`tidy-select`](https://tidyr.tidyverse.org/reference/tidyr_tidy_select.html)\>
  Column(s) to separate.

- delim:

  The delimiter string to split on. For `separate_longer_delim_polars()`
  only.

- ...:

  These dots are for future extensions and must be empty.

- width:

  The width of each piece. For `separate_longer_position_polars()` only.

- keep_empty:

  If `TRUE`, empty strings are kept in the output. If `FALSE` (the
  default), empty strings are dropped. `NA` values are always kept.

## Value

A Polars DataFrame or LazyFrame with the specified column(s) split into
rows.

## See also

[`tidyr::separate_longer_delim()`](https://tidyr.tidyverse.org/reference/separate_longer_delim.html),
[`tidyr::separate_longer_position()`](https://tidyr.tidyverse.org/reference/separate_longer_delim.html)

## Examples

``` r
library(polars)
library(tidypolars)

# separate_longer_delim_polars: split by delimiter
df <- pl$DataFrame(
  id = 1:3,
  x = c("a,b,c", "d,e", "f")
)
separate_longer_delim_polars(df, x, delim = ",")
#> shape: (6, 2)
#> ┌─────┬─────┐
#> │ id  ┆ x   │
#> │ --- ┆ --- │
#> │ i32 ┆ str │
#> ╞═════╪═════╡
#> │ 1   ┆ a   │
#> │ 1   ┆ b   │
#> │ 1   ┆ c   │
#> │ 2   ┆ d   │
#> │ 2   ┆ e   │
#> │ 3   ┆ f   │
#> └─────┴─────┘

# Multiple columns with broadcasting, the same as `tidyr` behavior
df2 <- pl$DataFrame(
  id = 1:2,
  x = c("a,b", "c,d"),
  y = c("1,2", "3,4")
)
separate_longer_delim_polars(df2, c(x, y), delim = ",")
#> shape: (4, 3)
#> ┌─────┬─────┬─────┐
#> │ id  ┆ x   ┆ y   │
#> │ --- ┆ --- ┆ --- │
#> │ i32 ┆ str ┆ str │
#> ╞═════╪═════╪═════╡
#> │ 1   ┆ a   ┆ 1   │
#> │ 1   ┆ b   ┆ 2   │
#> │ 2   ┆ c   ┆ 3   │
#> │ 2   ┆ d   ┆ 4   │
#> └─────┴─────┴─────┘

# Multiple columns with broadcasting
df3 <- pl$DataFrame(
  id = 1:5,
  x = c("a,b", NA, "", "c", ""),
  y = c("1", "2,3", "4,5", NA, "")
)
separate_longer_delim_polars(df3, c(x, y), delim = ",")
#> shape: (8, 3)
#> ┌─────┬──────┬──────┐
#> │ id  ┆ x    ┆ y    │
#> │ --- ┆ ---  ┆ ---  │
#> │ i32 ┆ str  ┆ str  │
#> ╞═════╪══════╪══════╡
#> │ 1   ┆ a    ┆ 1    │
#> │ 1   ┆ b    ┆ 1    │
#> │ 2   ┆ null ┆ 2    │
#> │ 2   ┆ null ┆ 3    │
#> │ 3   ┆      ┆ 4    │
#> │ 3   ┆      ┆ 5    │
#> │ 4   ┆ c    ┆ null │
#> │ 5   ┆      ┆      │
#> └─────┴──────┴──────┘

# separate_longer_position_polars: split by fixed width
df4 <- pl$DataFrame(
  id = 1:3,
  x = c("abcd", "efg", "hi")
)
separate_longer_position_polars(df4, x, width = 2)
#> shape: (5, 2)
#> ┌─────┬─────┐
#> │ id  ┆ x   │
#> │ --- ┆ --- │
#> │ i32 ┆ str │
#> ╞═════╪═════╡
#> │ 1   ┆ ab  │
#> │ 1   ┆ cd  │
#> │ 2   ┆ ef  │
#> │ 2   ┆ g   │
#> │ 3   ┆ hi  │
#> └─────┴─────┘

# keep_empty example: control whether empty strings are preserved
df5 <- pl$DataFrame(
  id = 1:4,
  x = c("ab", "", "ef", NA)
)
separate_longer_position_polars(df5, x, width = 2)
#> shape: (3, 2)
#> ┌─────┬──────┐
#> │ id  ┆ x    │
#> │ --- ┆ ---  │
#> │ i32 ┆ str  │
#> ╞═════╪══════╡
#> │ 1   ┆ ab   │
#> │ 3   ┆ ef   │
#> │ 4   ┆ null │
#> └─────┴──────┘
separate_longer_position_polars(df5, x, width = 2, keep_empty = TRUE)
#> shape: (4, 2)
#> ┌─────┬──────┐
#> │ id  ┆ x    │
#> │ --- ┆ ---  │
#> │ i32 ┆ str  │
#> ╞═════╪══════╡
#> │ 1   ┆ ab   │
#> │ 2   ┆ null │
#> │ 3   ┆ ef   │
#> │ 4   ┆ null │
#> └─────┴──────┘

# Multiple columns with broadcasting
df6 <- pl$DataFrame(
  id = 1:3,
  x = c("a", "bc", "def"),
  y = c("12", "345", "67")
)
# Shorter strings are recycled to match the longest in each row
separate_longer_position_polars(df6, c(x, y), width = 2)
#> shape: (5, 3)
#> ┌─────┬─────┬─────┐
#> │ id  ┆ x   ┆ y   │
#> │ --- ┆ --- ┆ --- │
#> │ i32 ┆ str ┆ str │
#> ╞═════╪═════╪═════╡
#> │ 1   ┆ a   ┆ 12  │
#> │ 2   ┆ bc  ┆ 34  │
#> │ 2   ┆ bc  ┆ 5   │
#> │ 3   ┆ de  ┆ 67  │
#> │ 3   ┆ f   ┆ 67  │
#> └─────┴─────┴─────┘
```
