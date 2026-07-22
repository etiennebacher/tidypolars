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
        with_columns(mpg_std = pl_standardize(pl$col("mpg")))$
        select("mpg_std")

# long vectors are truncated in the query

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
        with_columns(
          foo = pl$col("mpg")$is_in(pl$lit(large)$implode(), nulls_equal = TRUE)
        )

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
      Error in `mutate()`:
      ! conversion from `str` to `i32` failed in column 'char1' for 2 out of 2 values: ["a", "b"]

# option tidypolars_record_query = FALSE disables the recording

    Code
      show_query(query)
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object.
      i The query is only recorded when the option `tidypolars_record_query` is `TRUE` (the default) while the tidypolars functions are applied.
      i See `?tidypolars_options`.

# vignette 'Getting started': who pipeline

    Code
      show_query(query)
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

# vignette 'R and Polars expressions': unsupported argument is dropped

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
        with_columns(
          x = pl$when(pl$col("mpg")$has_nulls())$
            then(NA)$
            otherwise(pl$col("mpg")$mean())
        )

# vignette 'R and Polars expressions': external object in filter

    Code
      show_query(query)
    Output
      pl$DataFrame(foo = c(2, 1, 2))$
        filter(pl$col("foo") >= pl$lit(1:3))

# show_query() example: grouped mutate with .by

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
        filter(pl$col("cyl") == pl$lit(4))$
        with_columns(mpg2 = (pl$col("mpg") * pl$lit(2))$over("am"))

