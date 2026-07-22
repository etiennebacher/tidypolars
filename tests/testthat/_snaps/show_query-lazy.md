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
        with_columns(mpg_std = pl_standardize(pl$col("mpg")))$
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

# long vectors are truncated in the query

    Code
      current$collect()
    Output
      as_polars_lf(mtcars)$
        with_columns(
          foo = pl$col("mpg")$is_in(pl$lit(large)$implode(), nulls_equal = TRUE)
        )
      shape: (32, 12)
      ┌──────┬─────┬───────┬───────┬───┬─────┬──────┬──────┬───────┐
      │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ am  ┆ gear ┆ carb ┆ foo   │
      │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ ---  ┆ ---  ┆ ---   │
      │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64  ┆ f64  ┆ bool  │
      ╞══════╪═════╪═══════╪═══════╪═══╪═════╪══════╪══════╪═══════╡
      │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 4.0  ┆ false │
      │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 4.0  ┆ false │
      │ 22.8 ┆ 4.0 ┆ 108.0 ┆ 93.0  ┆ … ┆ 1.0 ┆ 4.0  ┆ 1.0  ┆ false │
      │ 21.4 ┆ 6.0 ┆ 258.0 ┆ 110.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 1.0  ┆ false │
      │ 18.7 ┆ 8.0 ┆ 360.0 ┆ 175.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 2.0  ┆ false │
      │ …    ┆ …   ┆ …     ┆ …     ┆ … ┆ …   ┆ …    ┆ …    ┆ …     │
      │ 30.4 ┆ 4.0 ┆ 95.1  ┆ 113.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 2.0  ┆ false │
      │ 15.8 ┆ 8.0 ┆ 351.0 ┆ 264.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 4.0  ┆ false │
      │ 19.7 ┆ 6.0 ┆ 145.0 ┆ 175.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 6.0  ┆ false │
      │ 15.0 ┆ 8.0 ┆ 301.0 ┆ 335.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 8.0  ┆ false │
      │ 21.4 ┆ 4.0 ┆ 121.0 ┆ 109.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 2.0  ┆ false │
      └──────┴─────┴───────┴───────┴───┴─────┴──────┴──────┴───────┘

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

# vignette 'Getting started': who pipeline

    Code
      current$collect()
    Output
      who_pl$filter(pl$col("year") > pl$lit(1990))$
        drop_nulls("newrel_f3544")$
        select(
          "iso3",
          "year",
          "newrel_f014",
          "newrel_f1524",
          "newrel_f2534",
          "newrel_f3544",
          "newrel_f4554",
          "newrel_f5564",
          "newrel_f65"
        )$
        with_columns(
          pl$col("iso3")$alias("__TIDYPOLARS_TEMP_SORT__1"),
          pl$col("year")$alias("__TIDYPOLARS_TEMP_SORT__2")
        )$
        sort(
          "__TIDYPOLARS_TEMP_SORT__1",
          "__TIDYPOLARS_TEMP_SORT__2",
          descending = c(FALSE, FALSE),
          nulls_last = TRUE
        )$
        drop("__TIDYPOLARS_TEMP_SORT__1", "__TIDYPOLARS_TEMP_SORT__2")$
        rename(
          iso3 = "ISO3",
          year = "YEAR",
          newrel_f014 = "NEWREL_F014",
          newrel_f1524 = "NEWREL_F1524",
          newrel_f2534 = "NEWREL_F2534",
          newrel_f3544 = "NEWREL_F3544",
          newrel_f4554 = "NEWREL_F4554",
          newrel_f5564 = "NEWREL_F5564",
          newrel_f65 = "NEWREL_F65"
        )$
        head(n = 6L)
      shape: (6, 9)
      ┌──────┬────────┬─────────────┬────────────┬───┬────────────┬────────────┬────────────┬────────────┐
      │ ISO3 ┆ YEAR   ┆ NEWREL_F014 ┆ NEWREL_F15 ┆ … ┆ NEWREL_F35 ┆ NEWREL_F45 ┆ NEWREL_F55 ┆ NEWREL_F65 │
      │ ---  ┆ ---    ┆ ---         ┆ 24         ┆   ┆ 44         ┆ 54         ┆ 64         ┆ ---        │
      │ str  ┆ f64    ┆ f64         ┆ ---        ┆   ┆ ---        ┆ ---        ┆ ---        ┆ f64        │
      │      ┆        ┆             ┆ f64        ┆   ┆ f64        ┆ f64        ┆ f64        ┆            │
      ╞══════╪════════╪═════════════╪════════════╪═══╪════════════╪════════════╪════════════╪════════════╡
      │ AGO  ┆ 2013.0 ┆ 626.0       ┆ 2644.0     ┆ … ┆ 1671.0     ┆ 991.0      ┆ 481.0      ┆ 314.0      │
      │ AIA  ┆ 2013.0 ┆ 0.0         ┆ 0.0        ┆ … ┆ 0.0        ┆ 0.0        ┆ 0.0        ┆ 0.0        │
      │ ALB  ┆ 2013.0 ┆ 5.0         ┆ 28.0       ┆ … ┆ 13.0       ┆ 18.0       ┆ 14.0       ┆ 34.0       │
      │ AND  ┆ 2013.0 ┆ 0.0         ┆ 0.0        ┆ … ┆ 1.0        ┆ 0.0        ┆ 0.0        ┆ 0.0        │
      │ ARE  ┆ 2013.0 ┆ 5.0         ┆ 4.0        ┆ … ┆ 3.0        ┆ 3.0        ┆ 1.0        ┆ 6.0        │
      │ ARG  ┆ 2013.0 ┆ 431.0       ┆ 927.0      ┆ … ┆ 537.0      ┆ 395.0      ┆ 307.0      ┆ 374.0      │
      └──────┴────────┴─────────────┴────────────┴───┴────────────┴────────────┴────────────┴────────────┘

# vignette 'R and Polars expressions': unsupported argument is dropped

    Code
      current$collect()
    Output
      as_polars_lf(mtcars)$
        with_columns(
          x = pl$when(pl$col("mpg")$has_nulls())$
            then(NA)$
            otherwise(pl$col("mpg")$mean())
        )
      shape: (32, 12)
      ┌──────┬─────┬───────┬───────┬───┬─────┬──────┬──────┬───────────┐
      │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ am  ┆ gear ┆ carb ┆ x         │
      │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ ---  ┆ ---  ┆ ---       │
      │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64  ┆ f64  ┆ f64       │
      ╞══════╪═════╪═══════╪═══════╪═══╪═════╪══════╪══════╪═══════════╡
      │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 4.0  ┆ 20.090625 │
      │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 4.0  ┆ 20.090625 │
      │ 22.8 ┆ 4.0 ┆ 108.0 ┆ 93.0  ┆ … ┆ 1.0 ┆ 4.0  ┆ 1.0  ┆ 20.090625 │
      │ 21.4 ┆ 6.0 ┆ 258.0 ┆ 110.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 1.0  ┆ 20.090625 │
      │ 18.7 ┆ 8.0 ┆ 360.0 ┆ 175.0 ┆ … ┆ 0.0 ┆ 3.0  ┆ 2.0  ┆ 20.090625 │
      │ …    ┆ …   ┆ …     ┆ …     ┆ … ┆ …   ┆ …    ┆ …    ┆ …         │
      │ 30.4 ┆ 4.0 ┆ 95.1  ┆ 113.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 2.0  ┆ 20.090625 │
      │ 15.8 ┆ 8.0 ┆ 351.0 ┆ 264.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 4.0  ┆ 20.090625 │
      │ 19.7 ┆ 6.0 ┆ 145.0 ┆ 175.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 6.0  ┆ 20.090625 │
      │ 15.0 ┆ 8.0 ┆ 301.0 ┆ 335.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 8.0  ┆ 20.090625 │
      │ 21.4 ┆ 4.0 ┆ 121.0 ┆ 109.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 2.0  ┆ 20.090625 │
      └──────┴─────┴───────┴───────┴───┴─────┴──────┴──────┴───────────┘

# vignette 'R and Polars expressions': external object in filter

    Code
      current$collect()
    Output
      pl$LazyFrame(foo = c(2, 1, 2))$
        filter(pl$col("foo") >= pl$lit(1:3))
      shape: (1, 1)
      ┌─────┐
      │ foo │
      │ --- │
      │ f64 │
      ╞═════╡
      │ 2.0 │
      └─────┘

# show_query() example: grouped mutate with .by

    Code
      current$collect()
    Output
      as_polars_lf(mtcars)$
        filter(pl$col("cyl") == pl$lit(4))$
        with_columns(mpg2 = (pl$col("mpg") * pl$lit(2))$over("am"))
      shape: (11, 12)
      ┌──────┬─────┬───────┬───────┬───┬─────┬──────┬──────┬──────┐
      │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ am  ┆ gear ┆ carb ┆ mpg2 │
      │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ ---  ┆ ---  ┆ ---  │
      │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64  ┆ f64  ┆ f64  │
      ╞══════╪═════╪═══════╪═══════╪═══╪═════╪══════╪══════╪══════╡
      │ 22.8 ┆ 4.0 ┆ 108.0 ┆ 93.0  ┆ … ┆ 1.0 ┆ 4.0  ┆ 1.0  ┆ 45.6 │
      │ 24.4 ┆ 4.0 ┆ 146.7 ┆ 62.0  ┆ … ┆ 0.0 ┆ 4.0  ┆ 2.0  ┆ 48.8 │
      │ 22.8 ┆ 4.0 ┆ 140.8 ┆ 95.0  ┆ … ┆ 0.0 ┆ 4.0  ┆ 2.0  ┆ 45.6 │
      │ 32.4 ┆ 4.0 ┆ 78.7  ┆ 66.0  ┆ … ┆ 1.0 ┆ 4.0  ┆ 1.0  ┆ 64.8 │
      │ 30.4 ┆ 4.0 ┆ 75.7  ┆ 52.0  ┆ … ┆ 1.0 ┆ 4.0  ┆ 2.0  ┆ 60.8 │
      │ …    ┆ …   ┆ …     ┆ …     ┆ … ┆ …   ┆ …    ┆ …    ┆ …    │
      │ 21.5 ┆ 4.0 ┆ 120.1 ┆ 97.0  ┆ … ┆ 0.0 ┆ 3.0  ┆ 1.0  ┆ 43.0 │
      │ 27.3 ┆ 4.0 ┆ 79.0  ┆ 66.0  ┆ … ┆ 1.0 ┆ 4.0  ┆ 1.0  ┆ 54.6 │
      │ 26.0 ┆ 4.0 ┆ 120.3 ┆ 91.0  ┆ … ┆ 1.0 ┆ 5.0  ┆ 2.0  ┆ 52.0 │
      │ 30.4 ┆ 4.0 ┆ 95.1  ┆ 113.0 ┆ … ┆ 1.0 ┆ 5.0  ┆ 2.0  ┆ 60.8 │
      │ 21.4 ┆ 4.0 ┆ 121.0 ┆ 109.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 2.0  ┆ 42.8 │
      └──────┴─────┴───────┴───────┴───┴─────┴──────┴──────┴──────┘

