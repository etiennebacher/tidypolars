# basic behavior works

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
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

# show_query() works with group_by() and summarize()

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
        group_by(
          "cyl",
          .maintain_order = TRUE
        )$
        agg(
          mean_mpg = pl$when(pl$col("mpg")$has_nulls())$
            then(NA)$
            otherwise(pl$col("mpg")$mean())
        )

# show_query() works with joins and shows the query of both inputs

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
        select("cyl", "mpg")$
        join(
          other = as_polars_df(mtcars)$
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

# show_query() works with across()

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
        with_columns(
          mpg = pl$when(pl$col("mpg")$has_nulls())$
            then(NA)$
            otherwise(pl$col("mpg")$mean()),
          am = pl$when(pl$col("am")$has_nulls())$
            then(NA)$
            otherwise(pl$col("am")$mean())
        )

# user-defined functions returning polars expressions are recorded

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
        with_columns(
          mpg_std = pl$col("mpg")$
            sub(pl$col("mpg")$mean())$
            true_div(pl$col("mpg")$std())
        )$
        select("mpg_std")

# the input data is not modified by the recording

    Code
      show_query(test_pl)
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object.
      i The query is only recorded when the option `tidypolars_record_query` is `TRUE` (the default) while the tidypolars functions are applied.
      i See `?tidypolars_options`.

# errors in the pipeline are not affected by the recording

    Code
      mutate(test_pl, char1 = as.integer(char1))
    Condition
      Error in `.data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! conversion from `str` to `i32` failed in column 'char1' for 2 out of 2 values: ["a", "b"]

# option tidypolars_record_query = FALSE disables the recording

    Code
      show_query(query)
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object.
      i The query is only recorded when the option `tidypolars_record_query` is `TRUE` (the default) while the tidypolars functions are applied.
      i See `?tidypolars_options`.

