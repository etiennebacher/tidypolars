# Stack multiple Data/LazyFrames on top of each other

Stack multiple Data/LazyFrames on top of each other

## Usage

``` r
bind_rows_polars(..., .id = NULL)
```

## Arguments

- ...:

  Polars DataFrames or LazyFrames to combine. Each argument can either
  be a Data/LazyFrame, or a list of Data/LazyFrames. Columns are matched
  by name, and any missing columns will be filled with `NA`.

- .id:

  The name of an optional identifier column. Provide a string to create
  an output column that identifies each input. If all elements in `...`
  are named, the identifier will use their names. Otherwise, it will be
  a simple count.

## Examples

``` r
library(polars)
p1 <- pl$DataFrame(
  x = c("a", "b"),
  y = 1:2
)
p2 <- pl$DataFrame(
  y = 3:4,
  z = c("c", "d")
)$with_columns(pl$col("y")$cast(pl$Int16))

bind_rows_polars(p1, p2)
#> shape: (4, 3)
#> ┌──────┬─────┬──────┐
#> │ x    ┆ y   ┆ z    │
#> │ ---  ┆ --- ┆ ---  │
#> │ str  ┆ i32 ┆ str  │
#> ╞══════╪═════╪══════╡
#> │ a    ┆ 1   ┆ null │
#> │ b    ┆ 2   ┆ null │
#> │ null ┆ 3   ┆ c    │
#> │ null ┆ 4   ┆ d    │
#> └──────┴─────┴──────┘

# this is equivalent
bind_rows_polars(list(p1, p2))
#> shape: (4, 3)
#> ┌──────┬─────┬──────┐
#> │ x    ┆ y   ┆ z    │
#> │ ---  ┆ --- ┆ ---  │
#> │ str  ┆ i32 ┆ str  │
#> ╞══════╪═════╪══════╡
#> │ a    ┆ 1   ┆ null │
#> │ b    ┆ 2   ┆ null │
#> │ null ┆ 3   ┆ c    │
#> │ null ┆ 4   ┆ d    │
#> └──────┴─────┴──────┘

# create an id colum
bind_rows_polars(p1, p2, .id = "id")
#> shape: (4, 4)
#> ┌─────┬──────┬─────┬──────┐
#> │ id  ┆ x    ┆ y   ┆ z    │
#> │ --- ┆ ---  ┆ --- ┆ ---  │
#> │ str ┆ str  ┆ i32 ┆ str  │
#> ╞═════╪══════╪═════╪══════╡
#> │ 1   ┆ a    ┆ 1   ┆ null │
#> │ 1   ┆ b    ┆ 2   ┆ null │
#> │ 2   ┆ null ┆ 3   ┆ c    │
#> │ 2   ┆ null ┆ 4   ┆ d    │
#> └─────┴──────┴─────┴──────┘

# create an id colum with named elements
bind_rows_polars(p1 = p1, p2 = p2, .id = "id")
#> shape: (4, 4)
#> ┌─────┬──────┬─────┬──────┐
#> │ id  ┆ x    ┆ y   ┆ z    │
#> │ --- ┆ ---  ┆ --- ┆ ---  │
#> │ str ┆ str  ┆ i32 ┆ str  │
#> ╞═════╪══════╪═════╪══════╡
#> │ p1  ┆ a    ┆ 1   ┆ null │
#> │ p1  ┆ b    ┆ 2   ┆ null │
#> │ p2  ┆ null ┆ 3   ┆ c    │
#> │ p2  ┆ null ┆ 4   ┆ d    │
#> └─────┴──────┴─────┴──────┘
```
