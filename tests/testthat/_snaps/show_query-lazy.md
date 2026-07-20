# basic behavior works

    Code
      current$collect()
    Output
      as_polars_lf(mtcars)$
        with_columns(
          pl$col("cyl")$alias("__TIDYPOLARS_TEMP_SORT__1"),
          pl$col("disp")$alias("__TIDYPOLARS_TEMP_SORT__2")
        )$
        sort(
          "__TIDYPOLARS_TEMP_SORT__1",
          "__TIDYPOLARS_TEMP_SORT__2",
          descending = c(FALSE, TRUE),
          nulls_last = TRUE
        )$
        drop("__TIDYPOLARS_TEMP_SORT__1", "__TIDYPOLARS_TEMP_SORT__2")$
        unique(
          "cyl",
          "am",
          keep = "first",
          maintain_order = TRUE
        )
      shape: (6, 11)
      ┌──────┬─────┬───────┬───────┬───┬─────┬─────┬──────┬──────┐
      │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ vs  ┆ am  ┆ gear ┆ carb │
      │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ --- ┆ ---  ┆ ---  │
      │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64 ┆ f64  ┆ f64  │
      ╞══════╪═════╪═══════╪═══════╪═══╪═════╪═════╪══════╪══════╡
      │ 24.4 ┆ 4.0 ┆ 146.7 ┆ 62.0  ┆ … ┆ 1.0 ┆ 0.0 ┆ 4.0  ┆ 2.0  │
      │ 21.4 ┆ 4.0 ┆ 121.0 ┆ 109.0 ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 2.0  │
      │ 21.4 ┆ 6.0 ┆ 258.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 0.0 ┆ 3.0  ┆ 1.0  │
      │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 0.0 ┆ 1.0 ┆ 4.0  ┆ 4.0  │
      │ 10.4 ┆ 8.0 ┆ 472.0 ┆ 205.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 4.0  │
      │ 15.8 ┆ 8.0 ┆ 351.0 ┆ 264.0 ┆ … ┆ 0.0 ┆ 1.0 ┆ 5.0  ┆ 4.0  │
      └──────┴─────┴───────┴───────┴───┴─────┴─────┴──────┴──────┘

# show_query() works with group_by() and summarize()

    Code
      current$collect()
    Output
      as_polars_lf(mtcars)$
        group_by(
          "cyl",
          .maintain_order = TRUE
        )$
        agg(
          mean_mpg = pl$when(pl$col("mpg")$has_nulls())$
            then(NA)$
            otherwise(pl$col("mpg")$mean())
        )
      shape: (3, 2)
      ┌─────┬───────────┐
      │ cyl ┆ mean_mpg  │
      │ --- ┆ ---       │
      │ f64 ┆ f64       │
      ╞═════╪═══════════╡
      │ 6.0 ┆ 19.742857 │
      │ 4.0 ┆ 26.663636 │
      │ 8.0 ┆ 15.1      │
      └─────┴───────────┘

# show_query() works with joins and shows the query of both inputs

    Code
      current$collect()
    Output
      as_polars_lf(mtcars)$
        select("cyl", "mpg")$
        join(
          other = as_polars_lf(mtcars)$
            group_by("cyl", .maintain_order = FALSE)$
            agg(
              mean_mpg = pl$when(pl$col("mpg")$has_nulls())$
                then(NA)$
                otherwise(pl$col("mpg")$mean())
            ),
          left_on = "cyl",
          right_on = "cyl",
          how = "left",
          nulls_equal = TRUE,
          validate = "m:m",
          coalesce = TRUE
        )$
        select("cyl", "mpg", "mean_mpg")
      shape: (32, 3)
      ┌─────┬──────┬───────────┐
      │ cyl ┆ mpg  ┆ mean_mpg  │
      │ --- ┆ ---  ┆ ---       │
      │ f64 ┆ f64  ┆ f64       │
      ╞═════╪══════╪═══════════╡
      │ 6.0 ┆ 21.0 ┆ 19.742857 │
      │ 6.0 ┆ 21.0 ┆ 19.742857 │
      │ 4.0 ┆ 22.8 ┆ 26.663636 │
      │ 6.0 ┆ 21.4 ┆ 19.742857 │
      │ 8.0 ┆ 18.7 ┆ 15.1      │
      │ …   ┆ …    ┆ …         │
      │ 4.0 ┆ 30.4 ┆ 26.663636 │
      │ 8.0 ┆ 15.8 ┆ 15.1      │
      │ 6.0 ┆ 19.7 ┆ 19.742857 │
      │ 8.0 ┆ 15.0 ┆ 15.1      │
      │ 4.0 ┆ 21.4 ┆ 26.663636 │
      └─────┴──────┴───────────┘

# show_query() works with across()

    Code
      current$collect()
    Output
      as_polars_lf(mtcars)$
        with_columns(
          mpg = pl$when(pl$col("mpg")$has_nulls())$
            then(NA)$
            otherwise(pl$col("mpg")$mean()),
          am = pl$when(pl$col("am")$has_nulls())$
            then(NA)$
            otherwise(pl$col("am")$mean())
        )
      shape: (32, 11)
      ┌───────────┬─────┬───────┬───────┬───┬─────┬─────────┬──────┬──────┐
      │ mpg       ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ vs  ┆ am      ┆ gear ┆ carb │
      │ ---       ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ ---     ┆ ---  ┆ ---  │
      │ f64       ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64     ┆ f64  ┆ f64  │
      ╞═══════════╪═════╪═══════╪═══════╪═══╪═════╪═════════╪══════╪══════╡
      │ 20.090625 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 0.0 ┆ 0.40625 ┆ 4.0  ┆ 4.0  │
      │ 20.090625 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 0.0 ┆ 0.40625 ┆ 4.0  ┆ 4.0  │
      │ 20.090625 ┆ 4.0 ┆ 108.0 ┆ 93.0  ┆ … ┆ 1.0 ┆ 0.40625 ┆ 4.0  ┆ 1.0  │
      │ 20.090625 ┆ 6.0 ┆ 258.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 0.40625 ┆ 3.0  ┆ 1.0  │
      │ 20.090625 ┆ 8.0 ┆ 360.0 ┆ 175.0 ┆ … ┆ 0.0 ┆ 0.40625 ┆ 3.0  ┆ 2.0  │
      │ …         ┆ …   ┆ …     ┆ …     ┆ … ┆ …   ┆ …       ┆ …    ┆ …    │
      │ 20.090625 ┆ 4.0 ┆ 95.1  ┆ 113.0 ┆ … ┆ 1.0 ┆ 0.40625 ┆ 5.0  ┆ 2.0  │
      │ 20.090625 ┆ 8.0 ┆ 351.0 ┆ 264.0 ┆ … ┆ 0.0 ┆ 0.40625 ┆ 5.0  ┆ 4.0  │
      │ 20.090625 ┆ 6.0 ┆ 145.0 ┆ 175.0 ┆ … ┆ 0.0 ┆ 0.40625 ┆ 5.0  ┆ 6.0  │
      │ 20.090625 ┆ 8.0 ┆ 301.0 ┆ 335.0 ┆ … ┆ 0.0 ┆ 0.40625 ┆ 5.0  ┆ 8.0  │
      │ 20.090625 ┆ 4.0 ┆ 121.0 ┆ 109.0 ┆ … ┆ 1.0 ┆ 0.40625 ┆ 4.0  ┆ 2.0  │
      └───────────┴─────┴───────┴───────┴───┴─────┴─────────┴──────┴──────┘

# user-defined functions returning polars expressions are recorded

    Code
      current$collect()
    Output
      as_polars_lf(mtcars)$
        with_columns(
          mpg_std = pl$col("mpg")$
            sub(pl$col("mpg")$mean())$
            true_div(pl$col("mpg")$std())
        )$
        select("mpg_std")
      shape: (32, 1)
      ┌───────────┐
      │ mpg_std   │
      │ ---       │
      │ f64       │
      ╞═══════════╡
      │ 0.150885  │
      │ 0.150885  │
      │ 0.449543  │
      │ 0.217253  │
      │ -0.230735 │
      │ …         │
      │ 1.710547  │
      │ -0.711907 │
      │ -0.064813 │
      │ -0.844644 │
      │ 0.217253  │
      └───────────┘

# the input data is not modified by the recording

    Code
      current$collect()
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object.
      i The query is only recorded when the option `tidypolars_record_query` is `TRUE` (the default) while the tidypolars functions are applied.
      i See `?tidypolars_options`.

# errors in the pipeline are not affected by the recording

    Code
      current$collect()
    Condition
      Error in `current$collect()`:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! conversion from `str` to `i32` failed in column 'char1' for 2 out of 2 values: ["a", "b"]

# option tidypolars_record_query = FALSE disables the recording

    Code
      current$collect()
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object.
      i The query is only recorded when the option `tidypolars_record_query` is `TRUE` (the default) while the tidypolars functions are applied.
      i See `?tidypolars_options`.

