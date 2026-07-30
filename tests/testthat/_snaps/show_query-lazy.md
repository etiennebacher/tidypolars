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

# head()/tail() start recording when they are the first verb

    Code
      current$collect()
    Output
      as_polars_lf(mtcars)$
        head(n = 6L)
      shape: (6, 11)
      ┌──────┬─────┬───────┬───────┬───┬─────┬─────┬──────┬──────┐
      │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ vs  ┆ am  ┆ gear ┆ carb │
      │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ --- ┆ ---  ┆ ---  │
      │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64 ┆ f64  ┆ f64  │
      ╞══════╪═════╪═══════╪═══════╪═══╪═════╪═════╪══════╪══════╡
      │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 0.0 ┆ 1.0 ┆ 4.0  ┆ 4.0  │
      │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 0.0 ┆ 1.0 ┆ 4.0  ┆ 4.0  │
      │ 22.8 ┆ 4.0 ┆ 108.0 ┆ 93.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
      │ 21.4 ┆ 6.0 ┆ 258.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 0.0 ┆ 3.0  ┆ 1.0  │
      │ 18.7 ┆ 8.0 ┆ 360.0 ┆ 175.0 ┆ … ┆ 0.0 ┆ 0.0 ┆ 3.0  ┆ 2.0  │
      │ 18.1 ┆ 6.0 ┆ 225.0 ┆ 105.0 ┆ … ┆ 1.0 ┆ 0.0 ┆ 3.0  ┆ 1.0  │
      └──────┴─────┴───────┴───────┴───┴─────┴─────┴──────┴──────┘

---

    Code
      current$collect()
    Output
      as_polars_lf(mtcars)$
        tail(n = 3)
      shape: (3, 11)
      ┌──────┬─────┬───────┬───────┬───┬─────┬─────┬──────┬──────┐
      │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ vs  ┆ am  ┆ gear ┆ carb │
      │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ --- ┆ ---  ┆ ---  │
      │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64 ┆ f64  ┆ f64  │
      ╞══════╪═════╪═══════╪═══════╪═══╪═════╪═════╪══════╪══════╡
      │ 19.7 ┆ 6.0 ┆ 145.0 ┆ 175.0 ┆ … ┆ 0.0 ┆ 1.0 ┆ 5.0  ┆ 6.0  │
      │ 15.0 ┆ 8.0 ┆ 301.0 ┆ 335.0 ┆ … ┆ 0.0 ┆ 1.0 ┆ 5.0  ┆ 8.0  │
      │ 21.4 ┆ 4.0 ┆ 121.0 ┆ 109.0 ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 2.0  │
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

---

    Code
      current$collect()
    Output
      as_polars_lf(mtcars)$
        with_columns(
          foo = pl$col("mpg")$is_in(pl$lit(runif(200))$implode(), nulls_equal = TRUE)
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

# count() doesn't record a `NULL` in sort() when input isn't grouped

    Code
      current$collect()
    Output
      as_polars_lf(mtcars)$
        group_by(am = pl$col("am"))$
        len()$
        rename(len = "n")$
        sort("am")
      shape: (2, 2)
      ┌─────┬─────┐
      │ am  ┆ n   │
      │ --- ┆ --- │
      │ f64 ┆ u32 │
      ╞═════╪═════╡
      │ 0.0 ┆ 19  │
      │ 1.0 ┆ 13  │
      └─────┴─────┘

# non-syntactic argument names are backquoted in the query

    Code
      current$collect()
    Output
      as_polars_lf(mtcars)$
        filter(pl$col("cyl") > pl$lit(4))$
        group_by(`__tidypolars_grp__` = pl$lit(1))$
        len()$
        drop("__tidypolars_grp__")$
        rename(len = "n")
      shape: (1, 1)
      ┌─────┐
      │ n   │
      │ --- │
      │ u32 │
      ╞═════╡
      │ 21  │
      └─────┘

---

    Code
      current$collect()
    Output
      test_pl$pivot(
        values = "v",
        on = "k",
        on_columns = data.frame(k = c(4, 5)),
        index = "id",
        separator = "_"
      )$
        rename(
          `4.0` = "4",
          `5.0` = "5"
        )
      shape: (1, 3)
      ┌─────┬──────┬──────┐
      │ id  ┆ 4    ┆ 5    │
      │ --- ┆ ---  ┆ ---  │
      │ f64 ┆ f64  ┆ f64  │
      ╞═════╪══════╪══════╡
      │ 1.0 ┆ 10.0 ┆ 20.0 │
      └─────┴──────┴──────┘

# the input data is not modified by the recording

    Code
      current$collect()
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object because it didn't go through tidypolars functions.
      i Recording only starts when a tidypolars function is applied to the data.

# the error mentions recording only when the option is FALSE

    Code
      current$collect()
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object because it didn't go through tidypolars functions.
      i Recording only starts when a tidypolars function is applied to the data.

---

    Code
      current$collect()
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object because the option `tidypolars_record_query` is `FALSE`.
      i Run `options(tidypolars_record_query = TRUE)` and re-run your query to show the equivalent polars code.
      i More info with `?tidypolars_options`.

# show_query() rejects extra arguments

    Code
      current$collect()
    Condition
      Error in `show_query()`:
      ! `...` must be empty.
      x Problematic argument:
      * foo = 1

---

    Code
      current$collect()
    Condition
      Error in `show_query()`:
      ! `...` must be empty.
      x Problematic argument:
      * ..1 = 2
      i Did you forget to name an argument?

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
      ! No polars query was recorded for this object because the option `tidypolars_record_query` is `FALSE`.
      i Run `options(tidypolars_record_query = TRUE)` and re-run your query to show the equivalent polars code.
      i More info with `?tidypolars_options`.

# vignette 'Getting started': who pipeline

    Code
      current$collect()
    Output
      who_pl$filter(pl$col("year") > pl$lit(1990))$
        drop_nulls("newrel_f3544")$
        select(
          "iso3", "year", "newrel_f014", "newrel_f1524", "newrel_f2534",
          "newrel_f3544", "newrel_f4554", "newrel_f5564", "newrel_f65"
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

# mutate() example: logical operation and overwriting a column

    Code
      current$collect()
    Output
      as_polars_lf(iris)$
        with_columns(
          big = pl$col("Sepal.Width") > pl$col("Sepal.Length"),
          Sepal.Width = pl$col("Sepal.Width") * pl$lit(2)
        )
      shape: (150, 6)
      ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┬───────┐
      │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   ┆ big   │
      │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       ┆ ---   │
      │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat       ┆ bool  │
      ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╪═══════╡
      │ 5.1          ┆ 7.0         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ false │
      │ 4.9          ┆ 6.0         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ false │
      │ 4.7          ┆ 6.4         ┆ 1.3          ┆ 0.2         ┆ setosa    ┆ false │
      │ 4.6          ┆ 6.2         ┆ 1.5          ┆ 0.2         ┆ setosa    ┆ false │
      │ 5.0          ┆ 7.2         ┆ 1.4          ┆ 0.2         ┆ setosa    ┆ false │
      │ …            ┆ …           ┆ …            ┆ …           ┆ …         ┆ …     │
      │ 6.7          ┆ 6.0         ┆ 5.2          ┆ 2.3         ┆ virginica ┆ false │
      │ 6.3          ┆ 5.0         ┆ 5.0          ┆ 1.9         ┆ virginica ┆ false │
      │ 6.5          ┆ 6.0         ┆ 5.2          ┆ 2.0         ┆ virginica ┆ false │
      │ 6.2          ┆ 6.8         ┆ 5.4          ┆ 2.3         ┆ virginica ┆ false │
      │ 5.9          ┆ 6.0         ┆ 5.1          ┆ 1.8         ┆ virginica ┆ false │
      └──────────────┴─────────────┴──────────────┴─────────────┴───────────┴───────┘

# mutate() example: across() with a list of functions and .names

    Code
      current$collect()
    Output
      as_polars_lf(iris)$
        with_columns(
          mean_of_Sepal.Length = pl$when(pl$col("Sepal.Length")$has_nulls())$
            then(NA)$
            otherwise(pl$col("Sepal.Length")$mean()),
          sd_of_Sepal.Length = pl$when(pl$col("Sepal.Length")$has_nulls())$
            then(NA)$
            otherwise(pl$col("Sepal.Length")$std(ddof = 1)),
          mean_of_Sepal.Width = pl$when(pl$col("Sepal.Width")$has_nulls())$
            then(NA)$
            otherwise(pl$col("Sepal.Width")$mean()),
          sd_of_Sepal.Width = pl$when(pl$col("Sepal.Width")$has_nulls())$
            then(NA)$
            otherwise(pl$col("Sepal.Width")$std(ddof = 1))
        )
      shape: (150, 9)
      ┌───────────┬───────────┬───────────┬───────────┬───┬───────────┬───────────┬───────────┬──────────┐
      │ Sepal.Len ┆ Sepal.Wid ┆ Petal.Len ┆ Petal.Wid ┆ … ┆ mean_of_S ┆ sd_of_Sep ┆ mean_of_S ┆ sd_of_Se │
      │ gth       ┆ th        ┆ gth       ┆ th        ┆   ┆ epal.Leng ┆ al.Length ┆ epal.Widt ┆ pal.Widt │
      │ ---       ┆ ---       ┆ ---       ┆ ---       ┆   ┆ th        ┆ ---       ┆ h         ┆ h        │
      │ f64       ┆ f64       ┆ f64       ┆ f64       ┆   ┆ ---       ┆ f64       ┆ ---       ┆ ---      │
      │           ┆           ┆           ┆           ┆   ┆ f64       ┆           ┆ f64       ┆ f64      │
      ╞═══════════╪═══════════╪═══════════╪═══════════╪═══╪═══════════╪═══════════╪═══════════╪══════════╡
      │ 5.1       ┆ 3.5       ┆ 1.4       ┆ 0.2       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
      │ 4.9       ┆ 3.0       ┆ 1.4       ┆ 0.2       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
      │ 4.7       ┆ 3.2       ┆ 1.3       ┆ 0.2       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
      │ 4.6       ┆ 3.1       ┆ 1.5       ┆ 0.2       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
      │ 5.0       ┆ 3.6       ┆ 1.4       ┆ 0.2       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
      │ …         ┆ …         ┆ …         ┆ …         ┆ … ┆ …         ┆ …         ┆ …         ┆ …        │
      │ 6.7       ┆ 3.0       ┆ 5.2       ┆ 2.3       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
      │ 6.3       ┆ 2.5       ┆ 5.0       ┆ 1.9       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
      │ 6.5       ┆ 3.0       ┆ 5.2       ┆ 2.0       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
      │ 6.2       ┆ 3.4       ┆ 5.4       ┆ 2.3       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
      │ 5.9       ┆ 3.0       ┆ 5.1       ┆ 1.8       ┆ … ┆ 5.843333  ┆ 0.828066  ┆ 3.057333  ┆ 0.435866 │
      └───────────┴───────────┴───────────┴───────────┴───┴───────────┴───────────┴───────────┴──────────┘

# filter() example: grouped filter with .by

    Code
      current$collect()
    Output
      as_polars_lf(dplyr::starwars)$
        select("name", "mass", "gender")$
        filter((pl$col("mass") > pl$col("mass")$mean())$over("gender"))
      shape: (15, 3)
      ┌───────────────────────┬────────┬───────────┐
      │ name                  ┆ mass   ┆ gender    │
      │ ---                   ┆ ---    ┆ ---       │
      │ str                   ┆ f64    ┆ str       │
      ╞═══════════════════════╪════════╪═══════════╡
      │ Darth Vader           ┆ 136.0  ┆ masculine │
      │ Owen Lars             ┆ 120.0  ┆ masculine │
      │ Beru Whitesun Lars    ┆ 75.0   ┆ feminine  │
      │ Chewbacca             ┆ 112.0  ┆ masculine │
      │ Jabba Desilijic Tiure ┆ 1358.0 ┆ masculine │
      │ …                     ┆ …      ┆ …         │
      │ Luminara Unduli       ┆ 56.2   ┆ feminine  │
      │ Zam Wesell            ┆ 55.0   ┆ feminine  │
      │ Shaak Ti              ┆ 57.0   ┆ feminine  │
      │ Grievous              ┆ 159.0  ┆ masculine │
      │ Tarfful               ┆ 136.0  ┆ masculine │
      └───────────────────────┴────────┴───────────┘

# pivot_longer() example: relig_income

    Code
      current$collect()
    Output
      as_polars_lf(tidyr::relig_income)$
        unpivot(
          index = "religion",
          on = c(
            "<$10k", "$10-20k", "$20-30k", "$30-40k", "$40-50k", "$50-75k",
            "$75-100k", "$100-150k", ">150k", "Don't know/refused"
          ),
          variable_name = "income",
          value_name = "count"
        )$
        sort("religion")
      shape: (180, 3)
      ┌──────────────┬────────────────────┬───────┐
      │ religion     ┆ income             ┆ count │
      │ ---          ┆ ---                ┆ ---   │
      │ str          ┆ str                ┆ f64   │
      ╞══════════════╪════════════════════╪═══════╡
      │ Agnostic     ┆ <$10k              ┆ 27.0  │
      │ Agnostic     ┆ $10-20k            ┆ 34.0  │
      │ Agnostic     ┆ $20-30k            ┆ 60.0  │
      │ Agnostic     ┆ $30-40k            ┆ 81.0  │
      │ Agnostic     ┆ $40-50k            ┆ 76.0  │
      │ …            ┆ …                  ┆ …     │
      │ Unaffiliated ┆ $50-75k            ┆ 528.0 │
      │ Unaffiliated ┆ $75-100k           ┆ 407.0 │
      │ Unaffiliated ┆ $100-150k          ┆ 321.0 │
      │ Unaffiliated ┆ >150k              ┆ 258.0 │
      │ Unaffiliated ┆ Don't know/refused ┆ 597.0 │
      └──────────────┴────────────────────┴───────┘

# separate() example: split on a dot

    Code
      current$collect()
    Output
      polars::pl$LazyFrame(x = c(NA, "x.y", "x.z", "y.z"))$
        with_columns(
          pl$col("x")$
            cast(pl$String)$
            str$split("\\.", literal = FALSE)$
            list$to_struct(upper_bound = 2L)$
            struct$rename_fields(c("foo", "foo2"))$
            struct$unnest()
        )$
        drop("x")
      shape: (4, 2)
      ┌──────┬──────┐
      │ foo  ┆ foo2 │
      │ ---  ┆ ---  │
      │ str  ┆ str  │
      ╞══════╪══════╡
      │ null ┆ null │
      │ x    ┆ y    │
      │ x    ┆ z    │
      │ y    ┆ z    │
      └──────┴──────┘

# unite() example: combine columns with a separator

    Code
      current$collect()
    Output
      polars::pl$LazyFrame(
        year = 2009:2011,
        month = 10:12,
        day = c(11L, 22L, 28L)
      )$
        with_columns(
          pl$concat_str(
            pl$col("year", "month", "day")$fill_null("NA"),
            separator = "-",
            ignore_nulls = TRUE
          )$
            alias("date")
        )$
        drop(c("year", "month", "day"))$
        select("date")
      shape: (3, 1)
      ┌────────────┐
      │ date       │
      │ ---        │
      │ str        │
      ╞════════════╡
      │ 2009-10-11 │
      │ 2010-11-22 │
      │ 2011-12-28 │
      └────────────┘

# relocate() example: move columns with .after

    Code
      current$collect()
    Output
      as_polars_lf(mtcars)$
        select(
          "mpg", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "hp", "vs", "carb"
        )
      shape: (32, 11)
      ┌──────┬─────┬───────┬──────┬───┬──────┬───────┬─────┬──────┐
      │ mpg  ┆ cyl ┆ disp  ┆ drat ┆ … ┆ gear ┆ hp    ┆ vs  ┆ carb │
      │ ---  ┆ --- ┆ ---   ┆ ---  ┆   ┆ ---  ┆ ---   ┆ --- ┆ ---  │
      │ f64  ┆ f64 ┆ f64   ┆ f64  ┆   ┆ f64  ┆ f64   ┆ f64 ┆ f64  │
      ╞══════╪═════╪═══════╪══════╪═══╪══════╪═══════╪═════╪══════╡
      │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 3.9  ┆ … ┆ 4.0  ┆ 110.0 ┆ 0.0 ┆ 4.0  │
      │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 3.9  ┆ … ┆ 4.0  ┆ 110.0 ┆ 0.0 ┆ 4.0  │
      │ 22.8 ┆ 4.0 ┆ 108.0 ┆ 3.85 ┆ … ┆ 4.0  ┆ 93.0  ┆ 1.0 ┆ 1.0  │
      │ 21.4 ┆ 6.0 ┆ 258.0 ┆ 3.08 ┆ … ┆ 3.0  ┆ 110.0 ┆ 1.0 ┆ 1.0  │
      │ 18.7 ┆ 8.0 ┆ 360.0 ┆ 3.15 ┆ … ┆ 3.0  ┆ 175.0 ┆ 0.0 ┆ 2.0  │
      │ …    ┆ …   ┆ …     ┆ …    ┆ … ┆ …    ┆ …     ┆ …   ┆ …    │
      │ 30.4 ┆ 4.0 ┆ 95.1  ┆ 3.77 ┆ … ┆ 5.0  ┆ 113.0 ┆ 1.0 ┆ 2.0  │
      │ 15.8 ┆ 8.0 ┆ 351.0 ┆ 4.22 ┆ … ┆ 5.0  ┆ 264.0 ┆ 0.0 ┆ 4.0  │
      │ 19.7 ┆ 6.0 ┆ 145.0 ┆ 3.62 ┆ … ┆ 5.0  ┆ 175.0 ┆ 0.0 ┆ 6.0  │
      │ 15.0 ┆ 8.0 ┆ 301.0 ┆ 3.54 ┆ … ┆ 5.0  ┆ 335.0 ┆ 0.0 ┆ 8.0  │
      │ 21.4 ┆ 4.0 ┆ 121.0 ┆ 4.11 ┆ … ┆ 4.0  ┆ 109.0 ┆ 1.0 ┆ 2.0  │
      └──────┴─────┴───────┴──────┴───┴──────┴───────┴─────┴──────┘

# slice example: slice_head() and slice_tail()

    Code
      current$collect()
    Output
      as_polars_lf(iris)$
        head(3)
      shape: (3, 5)
      ┌──────────────┬─────────────┬──────────────┬─────────────┬─────────┐
      │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species │
      │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---     │
      │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat     │
      ╞══════════════╪═════════════╪══════════════╪═════════════╪═════════╡
      │ 5.1          ┆ 3.5         ┆ 1.4          ┆ 0.2         ┆ setosa  │
      │ 4.9          ┆ 3.0         ┆ 1.4          ┆ 0.2         ┆ setosa  │
      │ 4.7          ┆ 3.2         ┆ 1.3          ┆ 0.2         ┆ setosa  │
      └──────────────┴─────────────┴──────────────┴─────────────┴─────────┘

---

    Code
      current$collect()
    Output
      as_polars_lf(iris)$
        tail(3)
      shape: (3, 5)
      ┌──────────────┬─────────────┬──────────────┬─────────────┬───────────┐
      │ Sepal.Length ┆ Sepal.Width ┆ Petal.Length ┆ Petal.Width ┆ Species   │
      │ ---          ┆ ---         ┆ ---          ┆ ---         ┆ ---       │
      │ f64          ┆ f64         ┆ f64          ┆ f64         ┆ cat       │
      ╞══════════════╪═════════════╪══════════════╪═════════════╪═══════════╡
      │ 6.5          ┆ 3.0         ┆ 5.2          ┆ 2.0         ┆ virginica │
      │ 6.2          ┆ 3.4         ┆ 5.4          ┆ 2.3         ┆ virginica │
      │ 5.9          ┆ 3.0         ┆ 5.1          ┆ 1.8         ┆ virginica │
      └──────────────┴─────────────┴──────────────┴─────────────┴───────────┘

# translated base functions: maths and rounding

    Code
      current$collect()
    Output
      dat$with_columns(
        a = pl$col("num")$abs(),
        b = pl$col("int")$sqrt(),
        c = pl$col("num")$exp(),
        d = pl$col("int")$log(base = 2.71828182845905),
        e = pl$col("int")$log10(),
        f = pl$col("num")$round(decimals = 1),
        g = pl$col("num")$ceil(),
        h = pl$col("num")$floor(),
        i = pl$col("num")$truncate(decimals = 0)
      )
      shape: (5, 17)
      ┌──────┬─────┬─────┬─────────────┬───┬──────┬──────┬──────┬──────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ f    ┆ g    ┆ h    ┆ i    │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---  ┆ ---  ┆ ---  ┆ ---  │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ f64  ┆ f64  ┆ f64  ┆ f64  │
      ╞══════╪═════╪═════╪═════════════╪═══╪══════╪══════╪══════╪══════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 1.5  ┆ 2.0  ┆ 1.0  ┆ 1.0  │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ -2.3 ┆ -2.0 ┆ -3.0 ┆ -2.0 │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 4.0  ┆ 4.0  ┆ 4.0  ┆ 4.0  │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ null ┆ null ┆ null ┆ null │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 6.7  ┆ 7.0  ┆ 6.0  ┆ 6.0  │
      └──────┴─────┴─────┴─────────────┴───┴──────┴──────┴──────┴──────┘

# translated base functions: trigonometry

    Code
      current$collect()
    Output
      dat$with_columns(
        a = pl$col("num")$cos(),
        b = pl$col("num")$sin(),
        c = pl$col("num")$tan(),
        d = (pl$col("num")/pl$lit(10))$arccos(),
        e = (pl$col("num")/pl$lit(10))$arcsin(),
        f = pl$col("num")$arctan(),
        g = pl$col("num")$cosh(),
        h = pl$col("num")$sinh(),
        i = pl$col("num")$tanh()
      )
      shape: (5, 17)
      ┌──────┬─────┬─────┬─────────────┬───┬───────────┬────────────┬────────────┬───────────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ f         ┆ g          ┆ h          ┆ i         │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---       ┆ ---        ┆ ---        ┆ ---       │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ f64       ┆ f64        ┆ f64        ┆ f64       │
      ╞══════╪═════╪═════╪═════════════╪═══╪═══════════╪════════════╪════════════╪═══════════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 0.982794  ┆ 2.35241    ┆ 2.129279   ┆ 0.905148  │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ -1.160669 ┆ 5.037221   ┆ -4.936962  ┆ -0.980096 │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 1.325818  ┆ 27.308233  ┆ 27.289917  ┆ 0.999329  │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ null      ┆ null       ┆ null       ┆ null      │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 1.422636  ┆ 406.203528 ┆ 406.202297 ┆ 0.999997  │
      └──────┴─────┴─────┴─────────────┴───┴───────────┴────────────┴────────────┴───────────┘

# translated base functions: cumulative and diff

    Code
      current$collect()
    Output
      dat$with_columns(
        cs = pl$when(pl$col("int")$is_null()$cum_max())$
          then(pl$lit(NA))$
          otherwise(pl$col("int")$cum_sum()),
        cmin = pl$when(pl$col("int")$is_null()$cum_max())$
          then(pl$lit(NA))$
          otherwise(pl$col("int")$cum_min()),
        cmax = pl$when(pl$col("int")$is_null()$cum_max())$
          then(pl$lit(NA))$
          otherwise(pl$col("int")$cum_max()),
        rv = pl$col("int")$reverse(),
        df = pl$col("int") - pl$col("int")$shift(1)
      )
      shape: (5, 13)
      ┌──────┬─────┬─────┬─────────────┬───┬──────┬──────┬─────┬──────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ cmin ┆ cmax ┆ rv  ┆ df   │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---  ┆ ---  ┆ --- ┆ ---  │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ i32  ┆ i32  ┆ i32 ┆ i32  │
      ╞══════╪═════╪═════╪═════════════╪═══╪══════╪══════╪═════╪══════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 2    ┆ 2    ┆ 4   ┆ null │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ 2    ┆ 3    ┆ 5   ┆ 1    │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 1    ┆ 3    ┆ 1   ┆ -2   │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ 1    ┆ 5    ┆ 3   ┆ 4    │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 1    ┆ 5    ┆ 2   ┆ -1   │
      └──────┴─────┴─────┴─────────────┴───┴──────┴──────┴─────┴──────┘

# translated base functions: aggregations in summarize()

    Code
      current$collect()
    Output
      dat$select(
        al = (pl$col("int") > pl$lit(0))$all(ignore_nulls = FALSE),
        an = (pl$col("int") > pl$lit(4))$any(ignore_nulls = FALSE),
        na = pl$col("num")$has_nulls(),
        wmn = (pl$col("num")$arg_min() + 1)$first(),
        wmx = (pl$col("num")$arg_max() + 1)$first()
      )
      shape: (1, 5)
      ┌──────┬──────┬──────┬─────┬─────┐
      │ al   ┆ an   ┆ na   ┆ wmn ┆ wmx │
      │ ---  ┆ ---  ┆ ---  ┆ --- ┆ --- │
      │ bool ┆ bool ┆ bool ┆ f64 ┆ f64 │
      ╞══════╪══════╪══════╪═════╪═════╡
      │ true ┆ true ┆ true ┆ 2.0 ┆ 5.0 │
      └──────┴──────┴──────┴─────┴─────┘

# translated base functions: string manipulation

    Code
      current$collect()
    Output
      dat$with_columns(
        n = pl$col("txt")$str$len_chars(),
        up = pl$col("txt")$str$to_uppercase(),
        lo = pl$col("txt")$str$to_lowercase(),
        p0 = pl$concat_str(
          pl$col("grp")$fill_null(pl$lit("NA")),
          pl$lit("_")$fill_null(pl$lit("NA")),
          pl$col("int")$fill_null(pl$lit("NA")),
          separator = ""
        ),
        p = pl$concat_str(
          pl$col("grp")$fill_null(pl$lit("NA")),
          pl$col("int")$fill_null(pl$lit("NA")),
          separator = "-"
        )
      )
      shape: (5, 13)
      ┌──────┬─────┬─────┬─────────────┬───┬─────────────┬─────────────┬─────┬─────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ up          ┆ lo          ┆ p0  ┆ p   │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---         ┆ ---         ┆ --- ┆ --- │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ str         ┆ str         ┆ str ┆ str │
      ╞══════╪═════╪═════╪═════════════╪═══╪═════════════╪═════════════╪═════╪═════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ HELLO WORLD ┆ hello world ┆ a_2 ┆ a-2 │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ FOO BAR     ┆ foo bar     ┆ a_3 ┆ a-3 │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ BAZ         ┆ baz         ┆ b_1 ┆ b-1 │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ null        ┆ null        ┆ b_5 ┆ b-5 │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ A1B2        ┆ a1b2        ┆ a_4 ┆ a-4 │
      └──────┴─────┴─────┴─────────────┴───┴─────────────┴─────────────┴─────┴─────┘

# translated base functions: type conversions

    Code
      current$collect()
    Output
      dat$with_columns(
        ch = pl$col("int")$cast(pl$String, strict = FALSE),
        nu = (pl$col("grp") == pl$lit("a"))$cast(pl$Float64, strict = FALSE),
        lg = (pl$col("int") - pl$lit(1))$cast(pl$Boolean, strict = FALSE)
      )
      shape: (5, 11)
      ┌──────┬─────┬─────┬─────────────┬───┬─────────────────────────┬─────┬─────┬───────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ time                    ┆ ch  ┆ nu  ┆ lg    │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---                     ┆ --- ┆ --- ┆ ---   │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ datetime[ms, UTC]       ┆ str ┆ f64 ┆ bool  │
      ╞══════╪═════╪═════╪═════════════╪═══╪═════════════════════════╪═════╪═════╪═══════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 2020-01-15 08:30:00 UTC ┆ 2   ┆ 1.0 ┆ true  │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ 2021-06-30 14:00:00 UTC ┆ 3   ┆ 1.0 ┆ true  │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 2019-12-01 23:59:00 UTC ┆ 1   ┆ 0.0 ┆ false │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ 2022-03-10 00:00:00 UTC ┆ 5   ┆ 0.0 ┆ true  │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 2020-07-04 12:15:00 UTC ┆ 4   ┆ 1.0 ┆ true  │
      └──────┴─────┴─────┴─────────────┴───┴─────────────────────────┴─────┴─────┴───────┘

# translated base functions: is.* checks

    Code
      current$collect()
    Output
      dat$with_columns(
        na = pl$col("num")$is_null(),
        fin = pl$when(pl$col("num")$is_null())$
          then(pl$lit(FALSE))$
          otherwise(pl$col("num")$is_finite()),
        inf = pl$when(pl$col("num")$is_null())$
          then(pl$lit(FALSE))$
          otherwise(pl$col("num")$is_infinite()),
        nan = pl$when(pl$col("num")$is_null())$
          then(pl$lit(FALSE))$
          otherwise(pl$col("num")$is_nan())
      )
      shape: (5, 12)
      ┌──────┬─────┬─────┬─────────────┬───┬───────┬───────┬───────┬───────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ na    ┆ fin   ┆ inf   ┆ nan   │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---   ┆ ---   ┆ ---   ┆ ---   │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ bool  ┆ bool  ┆ bool  ┆ bool  │
      ╞══════╪═════╪═════╪═════════════╪═══╪═══════╪═══════╪═══════╪═══════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ false ┆ true  ┆ false ┆ false │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ false ┆ true  ┆ false ┆ false │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ false ┆ true  ┆ false ┆ false │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ true  ┆ false ┆ false ┆ false │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ false ┆ true  ┆ false ┆ false │
      └──────┴─────┴─────┴─────────────┴───┴───────┴───────┴───────┴───────┘

# translated base functions: %in% and %notin%

    Code
      current$collect()
    Output
      dat$with_columns(
        ins = pl$col("grp")$is_in(pl$lit("a")$implode(), nulls_equal = TRUE),
        notin = pl$col("grp")$is_in(pl$lit("a")$implode(), nulls_equal = TRUE)$not()
      )
      shape: (5, 10)
      ┌──────┬─────┬─────┬─────────────┬───┬────────────┬─────────────────────────┬───────┬───────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ date       ┆ time                    ┆ ins   ┆ notin │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---        ┆ ---                     ┆ ---   ┆ ---   │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ date       ┆ datetime[ms, UTC]       ┆ bool  ┆ bool  │
      ╞══════╪═════╪═════╪═════════════╪═══╪════════════╪═════════════════════════╪═══════╪═══════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 2020-01-15 ┆ 2020-01-15 08:30:00 UTC ┆ true  ┆ false │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ 2021-06-30 ┆ 2021-06-30 14:00:00 UTC ┆ true  ┆ false │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 2019-12-01 ┆ 2019-12-01 23:59:00 UTC ┆ false ┆ true  │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ 2022-03-10 ┆ 2022-03-10 00:00:00 UTC ┆ false ┆ true  │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 2020-07-04 ┆ 2020-07-04 12:15:00 UTC ┆ true  ┆ false │
      └──────┴─────┴─────┴─────────────┴───┴────────────┴─────────────────────────┴───────┴───────┘

# translated dplyr functions: between, coalesce, near, if_else

    Code
      current$collect()
    Output
      dat$with_columns(
        bt = pl$col("int")$
          is_between(lower_bound = 2, upper_bound = 4, closed = "both"),
        co = pl$coalesce(pl$col("num"), pl$lit(0)),
        nr = (pl$col("num") - pl$lit(4))$abs() < 1.49011611938477e-08,
        ie = pl$when(pl$col("num") > pl$lit(0))$
          then(pl$lit("pos"))$
          otherwise(pl$lit("neg"))
      )
      shape: (5, 12)
      ┌──────┬─────┬─────┬─────────────┬───┬───────┬──────┬───────┬─────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ bt    ┆ co   ┆ nr    ┆ ie  │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---   ┆ ---  ┆ ---   ┆ --- │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ bool  ┆ f64  ┆ bool  ┆ str │
      ╞══════╪═════╪═════╪═════════════╪═══╪═══════╪══════╪═══════╪═════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ true  ┆ 1.5  ┆ false ┆ pos │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ true  ┆ -2.3 ┆ false ┆ neg │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ false ┆ 4.0  ┆ true  ┆ pos │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ false ┆ 0.0  ┆ null  ┆ neg │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ true  ┆ 6.7  ┆ false ┆ pos │
      └──────┴─────┴─────┴─────────────┴───┴───────┴──────┴───────┴─────┘

# translated dplyr functions: case_when (with and without default)

    Code
      current$collect()
    Output
      dat$with_columns(
        with_default = pl$when(pl$col("int") > pl$lit(3))$
          then(pl$lit("hi"))$
          otherwise(pl$lit("lo")),
        no_default = pl$when(pl$col("int") > pl$lit(3))$
          then(pl$lit("hi"))$
          when(pl$col("int") > pl$lit(1))$
          then(pl$lit("mid"))$
          otherwise(pl$lit(NA))
      )
      shape: (5, 10)
      ┌──────┬─────┬─────┬─────────────┬───┬────────────┬────────────────────┬──────────────┬────────────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ date       ┆ time               ┆ with_default ┆ no_default │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---        ┆ ---                ┆ ---          ┆ ---        │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ date       ┆ datetime[ms, UTC]  ┆ str          ┆ str        │
      ╞══════╪═════╪═════╪═════════════╪═══╪════════════╪════════════════════╪══════════════╪════════════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 2020-01-15 ┆ 2020-01-15         ┆ lo           ┆ mid        │
      │      ┆     ┆     ┆             ┆   ┆            ┆ 08:30:00 UTC       ┆              ┆            │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ 2021-06-30 ┆ 2021-06-30         ┆ lo           ┆ mid        │
      │      ┆     ┆     ┆             ┆   ┆            ┆ 14:00:00 UTC       ┆              ┆            │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 2019-12-01 ┆ 2019-12-01         ┆ lo           ┆ null       │
      │      ┆     ┆     ┆             ┆   ┆            ┆ 23:59:00 UTC       ┆              ┆            │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ 2022-03-10 ┆ 2022-03-10         ┆ hi           ┆ hi         │
      │      ┆     ┆     ┆             ┆   ┆            ┆ 00:00:00 UTC       ┆              ┆            │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 2020-07-04 ┆ 2020-07-04         ┆ hi           ┆ hi         │
      │      ┆     ┆     ┆             ┆   ┆            ┆ 12:15:00 UTC       ┆              ┆            │
      └──────┴─────┴─────┴─────────────┴───┴────────────┴────────────────────┴──────────────┴────────────┘

# translated dplyr functions: case_match (with and without default)

    Code
      current$collect()
    Output
      dat$with_columns(
        with_default = pl$when(pl$col("grp")$is_in(pl$lit("a")$implode()))$
          then(pl$lit("A"))$
          otherwise(pl$lit("Z")),
        no_default = pl$when(pl$col("grp")$is_in(pl$lit("a")$implode()))$
          then(pl$lit("A"))$
          when(pl$col("grp")$is_in(pl$lit("b")$implode()))$
          then(pl$lit("B"))$
          otherwise(pl$lit(NA))
      )
      shape: (5, 10)
      ┌──────┬─────┬─────┬─────────────┬───┬────────────┬────────────────────┬──────────────┬────────────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ date       ┆ time               ┆ with_default ┆ no_default │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---        ┆ ---                ┆ ---          ┆ ---        │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ date       ┆ datetime[ms, UTC]  ┆ str          ┆ str        │
      ╞══════╪═════╪═════╪═════════════╪═══╪════════════╪════════════════════╪══════════════╪════════════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 2020-01-15 ┆ 2020-01-15         ┆ A            ┆ A          │
      │      ┆     ┆     ┆             ┆   ┆            ┆ 08:30:00 UTC       ┆              ┆            │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ 2021-06-30 ┆ 2021-06-30         ┆ A            ┆ A          │
      │      ┆     ┆     ┆             ┆   ┆            ┆ 14:00:00 UTC       ┆              ┆            │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 2019-12-01 ┆ 2019-12-01         ┆ Z            ┆ B          │
      │      ┆     ┆     ┆             ┆   ┆            ┆ 23:59:00 UTC       ┆              ┆            │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ 2022-03-10 ┆ 2022-03-10         ┆ Z            ┆ B          │
      │      ┆     ┆     ┆             ┆   ┆            ┆ 00:00:00 UTC       ┆              ┆            │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 2020-07-04 ┆ 2020-07-04         ┆ A            ┆ A          │
      │      ┆     ┆     ┆             ┆   ┆            ┆ 12:15:00 UTC       ┆              ┆            │
      └──────┴─────┴─────┴─────────────┴───┴────────────┴────────────────────┴──────────────┴────────────┘

# translated dplyr functions: recode_values, replace_values, replace_when

    Code
      current$collect()
    Output
      dat$with_columns(
        rc = pl$col("grp")$replace_strict(old = "a", new = "AA", default = NA),
        rv = pl$col("grp")$replace(old = "b", new = "BB"),
        rw = pl$when(pl$col("int") > pl$lit(3))$
          then(pl$lit(0L))$
          otherwise(pl$col("int"))
      )
      shape: (5, 11)
      ┌──────┬─────┬─────┬─────────────┬───┬─────────────────────────┬──────┬─────┬─────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ time                    ┆ rc   ┆ rv  ┆ rw  │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---                     ┆ ---  ┆ --- ┆ --- │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ datetime[ms, UTC]       ┆ str  ┆ str ┆ i32 │
      ╞══════╪═════╪═════╪═════════════╪═══╪═════════════════════════╪══════╪═════╪═════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 2020-01-15 08:30:00 UTC ┆ AA   ┆ a   ┆ 2   │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ 2021-06-30 14:00:00 UTC ┆ AA   ┆ a   ┆ 3   │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 2019-12-01 23:59:00 UTC ┆ null ┆ BB  ┆ 1   │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ 2022-03-10 00:00:00 UTC ┆ null ┆ BB  ┆ 0   │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 2020-07-04 12:15:00 UTC ┆ AA   ┆ a   ┆ 0   │
      └──────┴─────┴─────┴─────────────┴───┴─────────────────────────┴──────┴─────┴─────┘

# translated dplyr functions: when_all and when_any

    Code
      current$collect()
    Output
      dat$with_columns(
        wall = pl$all_horizontal(pl$col("lgl1"), pl$col("lgl2")),
        wany = pl$any_horizontal(pl$col("lgl1"), pl$col("lgl2"))
      )
      shape: (5, 10)
      ┌──────┬─────┬─────┬─────────────┬───┬────────────┬─────────────────────────┬───────┬──────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ date       ┆ time                    ┆ wall  ┆ wany │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---        ┆ ---                     ┆ ---   ┆ ---  │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ date       ┆ datetime[ms, UTC]       ┆ bool  ┆ bool │
      ╞══════╪═════╪═════╪═════════════╪═══╪════════════╪═════════════════════════╪═══════╪══════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 2020-01-15 ┆ 2020-01-15 08:30:00 UTC ┆ true  ┆ true │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ 2021-06-30 ┆ 2021-06-30 14:00:00 UTC ┆ false ┆ true │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 2019-12-01 ┆ 2019-12-01 23:59:00 UTC ┆ false ┆ true │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ 2022-03-10 ┆ 2022-03-10 00:00:00 UTC ┆ false ┆ null │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 2020-07-04 ┆ 2020-07-04 12:15:00 UTC ┆ false ┆ true │
      └──────┴─────┴─────┴─────────────┴───┴────────────┴─────────────────────────┴───────┴──────┘

# translated dplyr functions: window functions

    Code
      current$collect()
    Output
      dat$with_columns(
        lg = pl$col("int")$shift(1),
        ld = pl$col("int")$shift(-2),
        rn = pl$int_range(start = 1, pl$len() + 1),
        dr = pl$col("int")$rank(method = "dense"),
        mr = pl$col("int")$rank(method = "min"),
        ci = pl$struct(pl$col("grp"))$rle_id() + 1
      )
      shape: (5, 14)
      ┌──────┬─────┬─────┬─────────────┬───┬─────┬─────┬─────┬─────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ rn  ┆ dr  ┆ mr  ┆ ci  │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ --- ┆ --- ┆ --- ┆ --- │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ i64 ┆ u32 ┆ u32 ┆ f64 │
      ╞══════╪═════╪═════╪═════════════╪═══╪═════╪═════╪═════╪═════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 1   ┆ 2   ┆ 2   ┆ 1.0 │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ 2   ┆ 3   ┆ 3   ┆ 1.0 │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 3   ┆ 1   ┆ 1   ┆ 2.0 │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ 4   ┆ 5   ┆ 5   ┆ 2.0 │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 5   ┆ 4   ┆ 4   ┆ 3.0 │
      └──────┴─────┴─────┴─────────────┴───┴─────┴─────┴─────┴─────┘

# translated dplyr functions: reducers in summarize()

    Code
      current$collect()
    Output
      dat$select(
        f = pl$col("grp")$first(),
        l = pl$col("grp")$last(),
        nt = pl$col("grp")$gather(1),
        cnt = pl$len(),
        nd = pl$struct(pl$col("grp"))$n_unique()
      )
      shape: (1, 5)
      ┌─────┬─────┬─────┬─────┬─────┐
      │ f   ┆ l   ┆ nt  ┆ cnt ┆ nd  │
      │ --- ┆ --- ┆ --- ┆ --- ┆ --- │
      │ str ┆ str ┆ str ┆ u32 ┆ u32 │
      ╞═════╪═════╪═════╪═════╪═════╡
      │ a   ┆ a   ┆ a   ┆ 5   ┆ 2   │
      └─────┴─────┴─────┴─────┴─────┘

# translated stats functions: median, sd, var

    Code
      current$collect()
    Output
      dat$select(
        md = pl$col("num")$median(),
        s = pl$when(pl$col("int")$has_nulls())$
          then(NA)$
          otherwise(pl$col("int")$std(ddof = 1)),
        v = pl$when(pl$col("int")$has_nulls())$
          then(NA)$
          otherwise(pl$col("int")$var(ddof = 1))
      )
      shape: (1, 3)
      ┌──────┬──────────┬─────┐
      │ md   ┆ s        ┆ v   │
      │ ---  ┆ ---      ┆ --- │
      │ f64  ┆ f64      ┆ f64 │
      ╞══════╪══════════╪═════╡
      │ 2.75 ┆ 1.581139 ┆ 2.5 │
      └──────┴──────────┴─────┘

# translated stringr functions: detection

    Code
      current$collect()
    Output
      dat$with_columns(
        det = pl$col("txt")$str$contains("o", literal = FALSE),
        len = pl$col("txt")$str$len_chars(),
        ct = pl$col("txt")$str$count_matches("o", literal = FALSE),
        st = pl$col("txt")$str$contains("^(H)"),
        en = pl$col("txt")$str$contains("(d)$")
      )
      shape: (5, 13)
      ┌──────┬─────┬─────┬─────────────┬───┬──────┬──────┬───────┬───────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ len  ┆ ct   ┆ st    ┆ en    │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---  ┆ ---  ┆ ---   ┆ ---   │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ u32  ┆ u32  ┆ bool  ┆ bool  │
      ╞══════╪═════╪═════╪═════════════╪═══╪══════╪══════╪═══════╪═══════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 11   ┆ 2    ┆ true  ┆ true  │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ 7    ┆ 2    ┆ false ┆ false │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 3    ┆ 0    ┆ false ┆ false │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ null ┆ null ┆ null  ┆ null  │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 4    ┆ 0    ┆ false ┆ false │
      └──────┴─────┴─────┴─────────────┴───┴──────┴──────┴───────┴───────┘

# translated stringr functions: replacement

    Code
      current$collect()
    Output
      dat$with_columns(
        rp = pl$col("txt")$str$replace("o", "0", literal = FALSE),
        rpa = pl$col("txt")$str$replace_all("o", "0", literal = FALSE),
        rm = pl$col("txt")$str$replace("o", "")
      )
      shape: (5, 11)
      ┌──────┬─────┬─────┬─────────────┬───┬────────────────────┬─────────────┬─────────────┬────────────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ time               ┆ rp          ┆ rpa         ┆ rm         │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---                ┆ ---         ┆ ---         ┆ ---        │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ datetime[ms, UTC]  ┆ str         ┆ str         ┆ str        │
      ╞══════╪═════╪═════╪═════════════╪═══╪════════════════════╪═════════════╪═════════════╪════════════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 2020-01-15         ┆ Hell0 World ┆ Hell0 W0rld ┆ Hell World │
      │      ┆     ┆     ┆             ┆   ┆ 08:30:00 UTC       ┆             ┆             ┆            │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ 2021-06-30         ┆ f0o bar     ┆ f00 bar     ┆ fo bar     │
      │      ┆     ┆     ┆             ┆   ┆ 14:00:00 UTC       ┆             ┆             ┆            │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 2019-12-01         ┆ BAZ         ┆ BAZ         ┆ BAZ        │
      │      ┆     ┆     ┆             ┆   ┆ 23:59:00 UTC       ┆             ┆             ┆            │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ 2022-03-10         ┆ null        ┆ null        ┆ null       │
      │      ┆     ┆     ┆             ┆   ┆ 00:00:00 UTC       ┆             ┆             ┆            │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 2020-07-04         ┆ a1b2        ┆ a1b2        ┆ a1b2       │
      │      ┆     ┆     ┆             ┆   ┆ 12:15:00 UTC       ┆             ┆             ┆            │
      └──────┴─────┴─────┴─────────────┴───┴────────────────────┴─────────────┴─────────────┴────────────┘

# translated stringr functions: case

    Code
      current$collect()
    Output
      dat$with_columns(
        up = pl$col("txt")$str$to_uppercase(),
        lo = pl$col("txt")$str$to_lowercase(),
        ti = pl$col("txt")$str$to_titlecase()
      )
      shape: (5, 11)
      ┌──────┬─────┬─────┬─────────────┬───┬───────────────────┬─────────────┬─────────────┬─────────────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ time              ┆ up          ┆ lo          ┆ ti          │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---               ┆ ---         ┆ ---         ┆ ---         │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ datetime[ms, UTC] ┆ str         ┆ str         ┆ str         │
      ╞══════╪═════╪═════╪═════════════╪═══╪═══════════════════╪═════════════╪═════════════╪═════════════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 2020-01-15        ┆ HELLO WORLD ┆ hello world ┆ Hello World │
      │      ┆     ┆     ┆             ┆   ┆ 08:30:00 UTC      ┆             ┆             ┆             │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ 2021-06-30        ┆ FOO BAR     ┆ foo bar     ┆ Foo Bar     │
      │      ┆     ┆     ┆             ┆   ┆ 14:00:00 UTC      ┆             ┆             ┆             │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 2019-12-01        ┆ BAZ         ┆ baz         ┆ Baz         │
      │      ┆     ┆     ┆             ┆   ┆ 23:59:00 UTC      ┆             ┆             ┆             │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ 2022-03-10        ┆ null        ┆ null        ┆ null        │
      │      ┆     ┆     ┆             ┆   ┆ 00:00:00 UTC      ┆             ┆             ┆             │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 2020-07-04        ┆ A1B2        ┆ a1b2        ┆ A1B2        │
      │      ┆     ┆     ┆             ┆   ┆ 12:15:00 UTC      ┆             ┆             ┆             │
      └──────┴─────┴─────┴─────────────┴───┴───────────────────┴─────────────┴─────────────┴─────────────┘

# translated stringr functions: padding and trimming

    Code
      current$collect()
    Output
      dat$with_columns(
        pd = pl$col("txt")$str$pad_start(length = 10, fill_char = " "),
        tr = pl$col("txt")$str$strip_chars(),
        sq = pl$col("txt")$str$replace_all("\\s+", " ")$str$strip_chars()
      )
      shape: (5, 11)
      ┌──────┬─────┬─────┬─────────────┬───┬───────────────────┬─────────────┬─────────────┬─────────────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ time              ┆ pd          ┆ tr          ┆ sq          │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---               ┆ ---         ┆ ---         ┆ ---         │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ datetime[ms, UTC] ┆ str         ┆ str         ┆ str         │
      ╞══════╪═════╪═════╪═════════════╪═══╪═══════════════════╪═════════════╪═════════════╪═════════════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 2020-01-15        ┆ Hello World ┆ Hello World ┆ Hello World │
      │      ┆     ┆     ┆             ┆   ┆ 08:30:00 UTC      ┆             ┆             ┆             │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ 2021-06-30        ┆    foo bar  ┆ foo bar     ┆ foo bar     │
      │      ┆     ┆     ┆             ┆   ┆ 14:00:00 UTC      ┆             ┆             ┆             │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 2019-12-01        ┆        BAZ  ┆ BAZ         ┆ BAZ         │
      │      ┆     ┆     ┆             ┆   ┆ 23:59:00 UTC      ┆             ┆             ┆             │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ 2022-03-10        ┆ null        ┆ null        ┆ null        │
      │      ┆     ┆     ┆             ┆   ┆ 00:00:00 UTC      ┆             ┆             ┆             │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 2020-07-04        ┆       a1b2  ┆ a1b2        ┆ a1b2        │
      │      ┆     ┆     ┆             ┆   ┆ 12:15:00 UTC      ┆             ┆             ┆             │
      └──────┴─────┴─────┴─────────────┴───┴───────────────────┴─────────────┴─────────────┴─────────────┘

# translated stringr functions: extraction

    Code
      current$collect()
    Output
      dat$with_columns(
        ex = pl$col("txt")$str$extract(pl$lit("[a-z]+"), group_index = 0),
        spi = pl$col("txt")$
          str$split(by = " ", inclusive = FALSE)$
          list$get(0, null_on_oob = TRUE),
        wd = pl$col("txt")$str$split(" ")$list$gather(list(0L))$list$join(" ")
      )
      shape: (5, 11)
      ┌──────┬─────┬─────┬─────────────┬───┬─────────────────────────┬──────┬───────┬───────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ time                    ┆ ex   ┆ spi   ┆ wd    │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---                     ┆ ---  ┆ ---   ┆ ---   │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ datetime[ms, UTC]       ┆ str  ┆ str   ┆ str   │
      ╞══════╪═════╪═════╪═════════════╪═══╪═════════════════════════╪══════╪═══════╪═══════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 2020-01-15 08:30:00 UTC ┆ ello ┆ Hello ┆ Hello │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ 2021-06-30 14:00:00 UTC ┆ foo  ┆ foo   ┆ foo   │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 2019-12-01 23:59:00 UTC ┆ null ┆ BAZ   ┆ BAZ   │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ 2022-03-10 00:00:00 UTC ┆ null ┆ null  ┆ null  │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 2020-07-04 12:15:00 UTC ┆ a    ┆ a1b2  ┆ a1b2  │
      └──────┴─────┴─────┴─────────────┴───┴─────────────────────────┴──────┴───────┴───────┘

# translated lubridate functions: date components

    Code
      current$collect()
    Output
      dat$with_columns(
        yr = pl$col("date")$dt$year(),
        mo = pl$col("date")$dt$month(),
        dy = pl$col("date")$dt$day(),
        md = pl$col("date")$dt$day(),
        wd = (pl$col("date")$dt$weekday() - 7L + 7L)%%7L + 1L,
        yd = pl$col("date")$dt$ordinal_day(),
        q = pl$col("date")$dt$quarter(),
        ly = pl$col("date")$dt$is_leap_year(),
        dim = pl$when(pl$col("date")$is_null())$
          then(NA)$
          when(pl$col("date")$dt$month()$is_in(list(c(1, 3, 5, 7, 8, 10, 12))))$
          then(31)$
          when(pl$col("date")$dt$month()$is_in(list(c(4, 6, 9, 11))))$
          then(30)$
          when(pl$col("date")$dt$month() == 2 & pl$col("date")$dt$is_leap_year())$
          then(29)$
          otherwise(28)$
          cast(pl$Int32),
        nd = pl$date(year = 2020, month = pl$col("int"), day = 1)
      )
      shape: (5, 18)
      ┌──────┬─────┬─────┬─────────────┬───┬─────┬───────┬─────┬────────────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ q   ┆ ly    ┆ dim ┆ nd         │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ --- ┆ ---   ┆ --- ┆ ---        │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ i8  ┆ bool  ┆ i32 ┆ date       │
      ╞══════╪═════╪═════╪═════════════╪═══╪═════╪═══════╪═════╪════════════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ 1   ┆ true  ┆ 31  ┆ 2020-02-01 │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ 2   ┆ false ┆ 30  ┆ 2020-03-01 │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ 4   ┆ false ┆ 31  ┆ 2020-01-01 │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ 1   ┆ false ┆ 31  ┆ 2020-05-01 │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ 3   ┆ true  ┆ 31  ┆ 2020-04-01 │
      └──────┴─────┴─────┴─────────────┴───┴─────┴───────┴─────┴────────────┘

# translated lubridate functions: datetime handling

    Code
      current$collect()
    Output
      dat$with_columns(
        dte = pl$col("time")$dt$date(),
        am_ = pl$col("time")$dt$hour() < 12,
        pm_ = pl$col("time")$dt$hour() >= 12,
        w = pl$col("time")$dt$convert_time_zone("Europe/Paris"),
        f = pl$col("time")$dt$replace_time_zone("Europe/Paris")
      )
      shape: (5, 13)
      ┌──────┬─────┬─────┬─────────────┬───┬───────┬───────┬──────────────────────┬──────────────────────┐
      │ num  ┆ int ┆ grp ┆ txt         ┆ … ┆ am_   ┆ pm_   ┆ w                    ┆ f                    │
      │ ---  ┆ --- ┆ --- ┆ ---         ┆   ┆ ---   ┆ ---   ┆ ---                  ┆ ---                  │
      │ f64  ┆ i32 ┆ str ┆ str         ┆   ┆ bool  ┆ bool  ┆ datetime[ms,         ┆ datetime[ms,         │
      │      ┆     ┆     ┆             ┆   ┆       ┆       ┆ Europe/Paris]        ┆ Europe/Paris]        │
      ╞══════╪═════╪═════╪═════════════╪═══╪═══════╪═══════╪══════════════════════╪══════════════════════╡
      │ 1.5  ┆ 2   ┆ a   ┆ Hello World ┆ … ┆ true  ┆ false ┆ 2020-01-15 09:30:00  ┆ 2020-01-15 08:30:00  │
      │      ┆     ┆     ┆             ┆   ┆       ┆       ┆ CET                  ┆ CET                  │
      │ -2.3 ┆ 3   ┆ a   ┆ foo bar     ┆ … ┆ false ┆ true  ┆ 2021-06-30 16:00:00  ┆ 2021-06-30 14:00:00  │
      │      ┆     ┆     ┆             ┆   ┆       ┆       ┆ CEST                 ┆ CEST                 │
      │ 4.0  ┆ 1   ┆ b   ┆ BAZ         ┆ … ┆ false ┆ true  ┆ 2019-12-02 00:59:00  ┆ 2019-12-01 23:59:00  │
      │      ┆     ┆     ┆             ┆   ┆       ┆       ┆ CET                  ┆ CET                  │
      │ null ┆ 5   ┆ b   ┆ null        ┆ … ┆ true  ┆ false ┆ 2022-03-10 01:00:00  ┆ 2022-03-10 00:00:00  │
      │      ┆     ┆     ┆             ┆   ┆       ┆       ┆ CET                  ┆ CET                  │
      │ 6.7  ┆ 4   ┆ a   ┆ a1b2        ┆ … ┆ false ┆ true  ┆ 2020-07-04 14:15:00  ┆ 2020-07-04 12:15:00  │
      │      ┆     ┆     ┆             ┆   ┆       ┆       ┆ CEST                 ┆ CEST                 │
      └──────┴─────┴─────┴─────────────┴───┴───────┴───────┴──────────────────────┴──────────────────────┘

# check query for fill, replace_na, drop_na

    Code
      current$collect()
    Output
      test_pl$with_columns(pl$col("x")$fill_null(strategy = "forward"))
      shape: (3, 2)
      ┌─────┬──────┐
      │ x   ┆ y    │
      │ --- ┆ ---  │
      │ f64 ┆ str  │
      ╞═════╪══════╡
      │ 1.0 ┆ a    │
      │ 1.0 ┆ null │
      │ 3.0 ┆ c    │
      └─────┴──────┘

---

    Code
      current$collect()
    Output
      test_pl$with_columns(
        pl$col("x")$fill_null(0),
        pl$col("y")$replace(NA, "z")
      )
      shape: (3, 2)
      ┌─────┬─────┐
      │ x   ┆ y   │
      │ --- ┆ --- │
      │ f64 ┆ str │
      ╞═════╪═════╡
      │ 1.0 ┆ a   │
      │ 0.0 ┆ z   │
      │ 3.0 ┆ c   │
      └─────┴─────┘

---

    Code
      current$collect()
    Output
      test_pl$drop_nulls()
      shape: (2, 2)
      ┌─────┬─────┐
      │ x   ┆ y   │
      │ --- ┆ --- │
      │ f64 ┆ str │
      ╞═════╪═════╡
      │ 1.0 ┆ a   │
      │ 3.0 ┆ c   │
      └─────┴─────┘

# check query for bind_rows_polars, bind_cols_polars

    Code
      current$collect()
    Output
      pl$concat(
        test_pl,
        test_pl,
        how = "diagonal_relaxed"
      )
      shape: (4, 1)
      ┌─────┐
      │ x   │
      │ --- │
      │ f64 │
      ╞═════╡
      │ 1.0 │
      │ 2.0 │
      │ 1.0 │
      │ 2.0 │
      └─────┘

---

    Code
      current$collect()
    Output
      pl$concat(
        test_pl,
        other_pl,
        how = "horizontal_extend"
      )
      shape: (2, 2)
      ┌─────┬─────┐
      │ x   ┆ y   │
      │ --- ┆ --- │
      │ f64 ┆ str │
      ╞═════╪═════╡
      │ 1.0 ┆ a   │
      │ 2.0 ┆ b   │
      └─────┴─────┘

---

    Code
      current$collect()
    Output
      pl$concat(
        test_pl,
        test_pl,
        how = "diagonal_relaxed"
      )
      shape: (4, 1)
      ┌─────┐
      │ x   │
      │ --- │
      │ f64 │
      ╞═════╡
      │ 1.0 │
      │ 2.0 │
      │ 1.0 │
      │ 2.0 │
      └─────┘

# check query for complete()

    Code
      current$collect()
    Output
      test_pl$select(pl$col("country", "year")$unique()$sort()$implode())$
        explode(
          "country",
          empty_as_null = TRUE
        )$
        explode(
          "year",
          empty_as_null = TRUE
        )$
        join(
          test_pl,
          on = c("country", "year"),
          how = "full",
          nulls_equal = TRUE,
          coalesce = TRUE
        )$
        with_columns(pl$col("value")$fill_null(99))$
        select("country", "year", "value")
      shape: (6, 3)
      ┌─────────┬────────┬───────┐
      │ country ┆ year   ┆ value │
      │ ---     ┆ ---    ┆ ---   │
      │ str     ┆ f64    ┆ f64   │
      ╞═════════╪════════╪═══════╡
      │ France  ┆ 2019.0 ┆ 99.0  │
      │ France  ┆ 2020.0 ┆ 1.0   │
      │ France  ┆ 2021.0 ┆ 2.0   │
      │ UK      ┆ 2019.0 ┆ 3.0   │
      │ UK      ┆ 2020.0 ┆ 99.0  │
      │ UK      ┆ 2021.0 ┆ 99.0  │
      └─────────┴────────┴───────┘

# check query for uncount()

    Code
      current$collect()
    Output
      test_pl$with_columns(pl$col("x")$repeat_by(pl$col("n")))$
        explode(
          pl$col("x"),
          empty_as_null = TRUE
        )$
        drop("n")
      shape: (3, 2)
      ┌─────┬─────┐
      │ x   ┆ y   │
      │ --- ┆ --- │
      │ str ┆ i32 │
      ╞═════╪═════╡
      │ a   ┆ 100 │
      │ b   ┆ 101 │
      │ b   ┆ 101 │
      └─────┴─────┘

---

    Code
      current$collect()
    Output
      test_pl$with_columns(pl$col("x")$repeat_by(pl$col("n")))$
        explode(
          pl$col("x"),
          empty_as_null = TRUE
        )$
        drop("n")$
        with_columns(pl$col("x")$cum_count()$over("x", "y")$alias("id"))
      shape: (3, 3)
      ┌─────┬─────┬─────┐
      │ x   ┆ y   ┆ id  │
      │ --- ┆ --- ┆ --- │
      │ str ┆ i32 ┆ u32 │
      ╞═════╪═════╪═════╡
      │ a   ┆ 100 ┆ 1   │
      │ b   ┆ 101 ┆ 1   │
      │ b   ┆ 101 ┆ 2   │
      └─────┴─────┴─────┘

# check query for rowwise()

    Code
      current$collect()
    Output
      test_pl$with_columns(
        total = pl$concat_list(pl$col("x"), pl$col("y"), pl$col("z"))$
          list$eval(
            pl$when(pl$element()$has_nulls())$then(NA)$otherwise(pl$element()$sum())
          )$
          explode(empty_as_null = TRUE),
        avg = pl$concat_list(pl$col("x"), pl$col("y"), pl$col("z"))$
          list$eval(pl$element()$mean())$
          explode(empty_as_null = TRUE)
      )
      shape: (2, 5)
      ┌─────┬─────┬──────┬───────┬─────┐
      │ x   ┆ y   ┆ z    ┆ total ┆ avg │
      │ --- ┆ --- ┆ ---  ┆ ---   ┆ --- │
      │ f64 ┆ f64 ┆ f64  ┆ f64   ┆ f64 │
      ╞═════╪═════╪══════╪═══════╪═════╡
      │ 2.0 ┆ 2.0 ┆ 5.0  ┆ 9.0   ┆ 3.0 │
      │ 2.0 ┆ 3.0 ┆ null ┆ null  ┆ 2.5 │
      └─────┴─────┴──────┴───────┴─────┘

# check query for unnest_longer_polars()

    Code
      current$collect()
    Output
      test_pl$explode(
        "values",
        empty_as_null = TRUE
      )$
        drop_nulls("values")
      shape: (6, 2)
      ┌─────┬────────┐
      │ id  ┆ values │
      │ --- ┆ ---    │
      │ i32 ┆ f64    │
      ╞═════╪════════╡
      │ 1   ┆ 1.0    │
      │ 1   ┆ 2.0    │
      │ 2   ┆ 3.0    │
      │ 2   ┆ 4.0    │
      │ 2   ┆ 5.0    │
      │ 3   ┆ 6.0    │
      └─────┴────────┘

---

    Code
      current$collect()
    Output
      test_pl$with_row_index(name = "__tidypolars_row_id__")$
        explode(
          "values",
          empty_as_null = TRUE
        )$
        with_columns(pl$struct("values"))$
        with_columns(
          pl$col("values")$
            struct$with_fields(pl$field("values")$cum_count()$alias("idx"))$
            over(pl$col("__tidypolars_row_id__"))
        )$
        with_columns(
          pl$struct(
            pl$col("values")$struct$field("idx"),
            pl$col("values")$struct$field("values")
          )$
            alias("values")
        )$
        unnest("values")$
        drop("__tidypolars_row_id__")$
        drop_nulls("values")$
        rename(values = "val")
      shape: (6, 3)
      ┌─────┬─────┬─────┐
      │ id  ┆ idx ┆ val │
      │ --- ┆ --- ┆ --- │
      │ i32 ┆ u32 ┆ f64 │
      ╞═════╪═════╪═════╡
      │ 1   ┆ 1   ┆ 1.0 │
      │ 1   ┆ 2   ┆ 2.0 │
      │ 2   ┆ 1   ┆ 3.0 │
      │ 2   ┆ 2   ┆ 4.0 │
      │ 2   ┆ 3   ┆ 5.0 │
      │ 3   ┆ 1   ┆ 6.0 │
      └─────┴─────┴─────┘

# check query for separate_longer_delim_polars() and separate_longer_position_polars()

    Code
      current$collect()
    Output
      test_pl$with_columns(pl$col("x")$cast(pl$String)$str$split(","))$
        explode(
          "x",
          empty_as_null = TRUE
        )
      shape: (6, 2)
      ┌─────┬─────┐
      │ id  ┆ x   │
      │ --- ┆ --- │
      │ i32 ┆ str │
      ╞═════╪═════╡
      │ 1   ┆ a   │
      │ 1   ┆ b   │
      │ 1   ┆ c   │
      │ 2   ┆ d   │
      │ 2   ┆ e   │
      │ 3   ┆ f   │
      └─────┴─────┘

---

    Code
      current$collect()
    Output
      test_pl$with_columns(pl$col("x")$cast(pl$String)$str$extract_all(".{1,2}"))$
        filter(pl$all_horizontal(pl$col("x")$is_null() | pl$col("x")$list$len() > 0))$
        explode(
          "x",
          empty_as_null = TRUE
        )
      shape: (6, 2)
      ┌─────┬─────┐
      │ id  ┆ x   │
      │ --- ┆ --- │
      │ i32 ┆ str │
      ╞═════╪═════╡
      │ 1   ┆ a,  │
      │ 1   ┆ b,  │
      │ 1   ┆ c   │
      │ 2   ┆ d,  │
      │ 2   ┆ e   │
      │ 3   ┆ f   │
      └─────┴─────┘

# check query for make_unique_id()

    Code
      current$collect()
    Output
      test_pl$with_columns(pl$struct(c("x", "y"))$hash()$alias("id"))
      shape: (2, 3)
      ┌─────┬─────┬─────────────────────┐
      │ x   ┆ y   ┆ id                  │
      │ --- ┆ --- ┆ ---                 │
      │ str ┆ f64 ┆ u64                 │
      ╞═════╪═════╪═════════════════════╡
      │ a   ┆ 1.0 ┆ 9401135652799850258 │
      │ b   ┆ 2.0 ┆ 6701719201758175205 │
      └─────┴─────┴─────────────────────┘

