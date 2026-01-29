# can only be used on LazyFrame

    Code
      fetch(as_polars_df(iris))
    Condition
      Error in `fetch()`:
      ! `fetch()` can only be used on a LazyFrame.

# is deprecated

    Code
      fetch(as_polars_lf(iris))
    Condition
      Warning:
      `fetch()` was deprecated in tidypolars 0.14.0.
      i Please use `head()` before `collect()` instead.
    Output
      shape: (150, 5)
      ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┐
      │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   │
      │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       │
      │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ enum      │
      ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╡
      │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ setosa    │
      │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa    │
      │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa    │
      │ 4.6          ┆ 3.1         ┆ 1.5          ┆ 0.2         ┆ setosa    │
      │ 5.0          ┆ 3.6         ┆ 1.4          ┆ 0.2         ┆ setosa    │
      │ …            ┆ …           ┆ …            ┆ …           ┆ …         │
      │ 6.7          ┆ 3.0         ┆ 5.2          ┆ 2.3         ┆ virginica │
      │ 6.3          ┆ 2.5         ┆ 5.0          ┆ 1.9         ┆ virginica │
      │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica │
      │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica │
      │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica │
      └──────────────┴─────────────┴──────────────┴─────────────┴───────────┘

