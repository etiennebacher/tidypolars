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

# head()/tail() start recording when they are the first verb

    Code
      show_query(query_head)
    Output
      as_polars_df(mtcars)$
        head(n = 6L)

---

    Code
      show_query(query_tail)
    Output
      as_polars_df(mtcars)$
        tail(n = 3)

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

---

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
        with_columns(
          foo = pl$col("mpg")$is_in(pl$lit(runif(200))$implode(), nulls_equal = TRUE)
        )

# `NULL` arguments are kept in the query

    Code
      show_query(query)
    Output
      pl$scan_csv(
        source = [TRUNCATED],
        has_header = TRUE,
        separator = ",",
        comment_prefix = NULL,
        quote_char = "\"",
        skip_rows = 0,
        schema = NULL,
        schema_overrides = NULL,
        null_values = NULL,
        ignore_errors = FALSE,
        cache = FALSE,
        infer_schema_length = 100,
        n_rows = NULL,
        encoding = "utf8",
        low_memory = FALSE,
        rechunk = TRUE,
        skip_rows_after_header = 0,
        row_index_name = NULL,
        row_index_offset = 0,
        try_parse_dates = FALSE,
        eol_char = "\n",
        raise_if_empty = TRUE,
        truncate_ragged_lines = FALSE,
        include_file_paths = NULL
      )$
        collect(
          optimizations = pl$QueryOptFlags(
            predicate_pushdown = TRUE,
            projection_pushdown = TRUE,
            simplify_expression = TRUE,
            slice_pushdown = TRUE,
            comm_subplan_elim = TRUE,
            comm_subexpr_elim = TRUE,
            cluster_with_columns = TRUE
          ),
          engine = c("auto", "in-memory", "streaming")
        )$
        filter(pl$col("cyl") > pl$lit(4))

# count() doesn't record a `NULL` in sort() when input isn't grouped

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
        group_by(am = pl$col("am"))$
        len()$
        rename(len = "n")$
        sort("am")

---

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
        group_by(am = pl$col("am"))$
        len()$
        rename(len = "n")$
        sort("am")

# non-syntactic argument names are backquoted in the query

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
        filter(pl$col("cyl") > pl$lit(4))$
        group_by(`__tidypolars_grp__` = pl$lit(1))$
        len()$
        drop("__tidypolars_grp__")$
        rename(len = "n")

---

    Code
      show_query(query)
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

# the input data is not modified by the recording

    Code
      show_query(test_pl)
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object because it didn't go through tidypolars functions.
      i Recording only starts when a tidypolars function is applied to the data.

# the error mentions recording only when the option is FALSE

    Code
      show_query(test_pl)
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object because it didn't go through tidypolars functions.
      i Recording only starts when a tidypolars function is applied to the data.

---

    Code
      show_query(test_pl)
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object because the option `tidypolars_record_query` is `FALSE`.
      i Run `options(tidypolars_record_query = TRUE)` and re-run your query to show the equivalent polars code.
      i More info with `?tidypolars_options`.

# show_query() rejects extra arguments

    Code
      show_query(query, foo = 1)
    Condition
      Error in `show_query()`:
      ! `...` must be empty.
      x Problematic argument:
      * foo = 1

---

    Code
      show_query(query, 2)
    Condition
      Error in `show_query()`:
      ! `...` must be empty.
      x Problematic argument:
      * ..1 = 2
      i Did you forget to name an argument?

# the query is wrapped at the console width

    Code
      withr::with_options(list(width = 120), show_query(query))
    Output
      as_polars_df(mtcars)$
        with_columns(
          mpg = pl$when(pl$col("mpg")$has_nulls())$then(NA)$otherwise(pl$col("mpg")$mean()),
          am = pl$when(pl$col("am")$has_nulls())$then(NA)$otherwise(pl$col("am")$mean())
        )$
        filter(pl$col("cyl") == pl$lit(4) & pl$col("am") == pl$lit(1))

---

    Code
      withr::with_options(list(width = 40), show_query(query))
    Output
      as_polars_df(mtcars)$
        with_columns(
          mpg = pl$when(
            pl$col("mpg")$has_nulls()
          )$
            then(NA)$
            otherwise(pl$col("mpg")$mean()),
          am = pl$when(
            pl$col("am")$has_nulls()
          )$
            then(NA)$
            otherwise(pl$col("am")$mean())
        )$
        filter(
          pl$col("cyl") == pl$lit(4) &
            pl$col("am") == pl$lit(1)
        )

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
      ! No polars query was recorded for this object because the option `tidypolars_record_query` is `FALSE`.
      i Run `options(tidypolars_record_query = TRUE)` and re-run your query to show the equivalent polars code.
      i More info with `?tidypolars_options`.

# the input name falls back to a placeholder when it is too long

    Code
      show_query(query)
    Output
      `<data>`$filter(pl$col("x") == pl$lit(1))

# polars objects built outside tidypolars are shown as a placeholder

    Code
      show_query(out)
    Output
      as_polars_lf(mtcars)$
        filter(pl$col("cyl") == pl$lit(4))$
        collect(optimizations = `<polars::QueryOptFlags>`)

# data.frame arguments with non-syntactic names are rebuilt faithfully

    Code
      show_query(query)
    Output
      as_polars_df(dat)$
        pivot(
          values = "v",
          on = "my col",
          on_columns = data.frame(`my col` = c("a", "b"), check.names = FALSE),
          index = "id",
          separator = "_"
        )$
        rename(
          a = "a",
          b = "b"
        )

# long vectors that deparse compactly are kept in the query

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
        with_columns(
          foo = pl$col("mpg")$is_in(pl$lit(1:200)$implode(), nulls_equal = TRUE)
        )

# values too long to display fall back to the code producing them

    Code
      show_query(query)
    Output
      as_polars_df(data.frame(txt = "a"))$
        filter(pl$col("txt") == pl$lit(strrep("a", 400)))

# the source of a value is only used when it is short enough

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
        with_columns(
          foo = pl$col("mpg")$
            is_in(pl$lit(`<numeric of length 200>`)$implode(), nulls_equal = TRUE)
        )

# arguments that don't fit on a line are wrapped too

    Code
      withr::with_options(list(width = 30), show_query(query))
    Output
      as_polars_df(mtcars)$
        with_columns(
          z = (
            pl$col("mpg") -
              pl$when(
                pl$col("mpg")$
                  has_nulls()
              )$
                then(NA)$
                otherwise(
                  pl$col("mpg")$
                    mean()
                )
          )/
            pl$when(
              pl$col("mpg")$
                has_nulls()
            )$
              then(NA)$
              otherwise(
                pl$col("mpg")$
                  std(ddof = 1)
              )
        )

# a long value that is not a method call is left on its own line

    Code
      withr::with_options(list(width = 40), show_query(query))
    Output
      as_polars_df(data.frame(txt = "x"))$
        filter(
          pl$col("txt") ==
            pl$lit(
              "abababababababababababababababababababababababababababababababababababababababababababababababababababababababababababab"
            )
        )

# vignette 'Getting started': who pipeline

    Code
      show_query(query)
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

# mutate() example: logical operation and overwriting a column

    Code
      show_query(query)
    Output
      as_polars_df(iris)$
        with_columns(
          big = pl$col("Sepal.Width") > pl$col("Sepal.Length"),
          Sepal.Width = pl$col("Sepal.Width") * pl$lit(2)
        )

# mutate() example: across() with a list of functions and .names

    Code
      show_query(query)
    Output
      as_polars_df(iris)$
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

# filter() example: grouped filter with .by

    Code
      show_query(query)
    Output
      as_polars_df(dplyr::starwars)$
        select("name", "mass", "gender")$
        filter((pl$col("mass") > pl$col("mass")$mean())$over("gender"))

# pivot_longer() example: relig_income

    Code
      show_query(query)
    Output
      as_polars_df(tidyr::relig_income)$
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

# separate() example: split on a dot

    Code
      show_query(query)
    Output
      polars::pl$DataFrame(x = c(NA, "x.y", "x.z", "y.z"))$
        with_columns(
          pl$col("x")$
            cast(pl$String)$
            str$split("\\.", literal = FALSE)$
            list$to_struct(upper_bound = 2L)$
            struct$rename_fields(c("foo", "foo2"))$
            struct$unnest()
        )$
        drop("x")

# unite() example: combine columns with a separator

    Code
      show_query(query)
    Output
      polars::pl$DataFrame(
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

# relocate() example: move columns with .after

    Code
      show_query(query)
    Output
      as_polars_df(mtcars)$
        select(
          "mpg", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "hp", "vs", "carb"
        )

# slice example: slice_head() and slice_tail()

    Code
      show_query(query_head)
    Output
      as_polars_df(iris)$
        head(3)

---

    Code
      show_query(query_tail)
    Output
      as_polars_df(iris)$
        tail(3)

# translated base functions: maths and rounding

    Code
      show_query(query)
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

# translated base functions: trigonometry

    Code
      show_query(query)
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

# translated base functions: cumulative and diff

    Code
      show_query(query)
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

# translated base functions: anyDuplicated and duplicated

    Code
      show_query(query)
    Output
      dat$with_columns(
        dup = pl$col("grp")$is_first_distinct()$not() &
          pl$col("grp")$is_in(pl$lit(list("a")), nulls_equal = TRUE)$not(),
        any_dup = (
          (
            pl$col("grp")$is_first_distinct()$not() &
              pl$col("grp")$is_in(pl$lit(list("a")), nulls_equal = TRUE)$not()
          )$
            arg_true()$
            first() +
            1
        )$
          fill_null(0)
      )

# translated base functions: aggregations in summarize()

    Code
      show_query(query)
    Output
      dat$select(
        al = (pl$col("int") > pl$lit(0))$all(ignore_nulls = FALSE),
        an = (pl$col("int") > pl$lit(4))$any(ignore_nulls = FALSE),
        na = pl$col("num")$has_nulls(),
        wmn = (pl$col("num")$arg_min() + 1)$first(),
        wmx = (pl$col("num")$arg_max() + 1)$first()
      )

# translated base functions: string manipulation

    Code
      show_query(query)
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

# translated base functions: type conversions

    Code
      show_query(query)
    Output
      dat$with_columns(
        ch = pl$col("int")$cast(pl$String, strict = FALSE),
        nu = (pl$col("grp") == pl$lit("a"))$cast(pl$Float64, strict = FALSE),
        lg = (pl$col("int") - pl$lit(1))$cast(pl$Boolean, strict = FALSE)
      )

# translated base functions: is.* checks

    Code
      show_query(query)
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

# translated base functions: %in% and %notin%

    Code
      show_query(query)
    Output
      dat$with_columns(
        ins = pl$col("grp")$is_in(pl$lit("a")$implode(), nulls_equal = TRUE),
        notin = pl$col("grp")$is_in(pl$lit("a")$implode(), nulls_equal = TRUE)$not()
      )

# translated dplyr functions: between, coalesce, near, if_else

    Code
      show_query(query)
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

# translated dplyr functions: case_when (with and without default)

    Code
      show_query(query)
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

# translated dplyr functions: case_match (with and without default)

    Code
      show_query(query)
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

# translated dplyr functions: recode_values, replace_values, replace_when

    Code
      show_query(query)
    Output
      dat$with_columns(
        rc = pl$col("grp")$replace_strict(old = "a", new = "AA", default = NA),
        rv = pl$col("grp")$replace(old = "b", new = "BB"),
        rw = pl$when(pl$col("int") > pl$lit(3))$
          then(pl$lit(0L))$
          otherwise(pl$col("int"))
      )

# translated dplyr functions: when_all and when_any

    Code
      show_query(query)
    Output
      dat$with_columns(
        wall = pl$all_horizontal(pl$col("lgl1"), pl$col("lgl2")),
        wany = pl$any_horizontal(pl$col("lgl1"), pl$col("lgl2"))
      )

# translated dplyr functions: window functions

    Code
      show_query(query)
    Output
      dat$with_columns(
        lg = pl$col("int")$shift(1),
        ld = pl$col("int")$shift(-2),
        rn = pl$int_range(start = 1, pl$len() + 1),
        dr = pl$col("int")$rank(method = "dense"),
        mr = pl$col("int")$rank(method = "min"),
        ci = pl$struct(pl$col("grp"))$rle_id() + 1
      )

# translated dplyr functions: reducers in summarize()

    Code
      show_query(query)
    Output
      dat$select(
        f = pl$col("grp")$first(),
        l = pl$col("grp")$last(),
        nt = pl$col("grp")$gather(1),
        cnt = pl$len(),
        nd = pl$struct(pl$col("grp"))$n_unique()
      )

# translated stats functions: median, sd, var

    Code
      show_query(query)
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

# translated stringr functions: detection

    Code
      show_query(query)
    Output
      dat$with_columns(
        det = pl$col("txt")$str$contains("o", literal = FALSE),
        len = pl$col("txt")$str$len_chars(),
        ct = pl$col("txt")$str$count_matches("o", literal = FALSE),
        st = pl$col("txt")$str$contains("^(H)"),
        en = pl$col("txt")$str$contains("(d)$")
      )

# translated stringr functions: replacement

    Code
      show_query(query)
    Output
      dat$with_columns(
        rp = pl$col("txt")$str$replace("o", "0", literal = FALSE),
        rpa = pl$col("txt")$str$replace_all("o", "0", literal = FALSE),
        rm = pl$col("txt")$str$replace("o", "")
      )

# translated stringr functions: case

    Code
      show_query(query)
    Output
      dat$with_columns(
        up = pl$col("txt")$str$to_uppercase(),
        lo = pl$col("txt")$str$to_lowercase(),
        ti = pl$col("txt")$str$to_titlecase()
      )

# translated stringr functions: padding and trimming

    Code
      show_query(query)
    Output
      dat$with_columns(
        pd = pl$col("txt")$str$pad_start(length = 10, fill_char = " "),
        tr = pl$col("txt")$str$strip_chars(),
        sq = pl$col("txt")$str$replace_all("\\s+", " ")$str$strip_chars()
      )

# translated stringr functions: extraction

    Code
      show_query(query)
    Output
      dat$with_columns(
        ex = pl$col("txt")$str$extract(pl$lit("[a-z]+"), group_index = 0),
        spi = pl$col("txt")$
          str$split(by = " ", inclusive = FALSE, literal = FALSE)$
          list$get(0, null_on_oob = TRUE),
        wd = pl$when(
          pl$lit(1L) > pl$col("txt")$str$split(" ")$list$len()$cast(pl$Int64)
        )$
          then(pl$lit(NA_character_))$
          otherwise(pl$col("txt")$str$split(" ")$list$slice(0, 1)$list$join(" "))
      )

# translated lubridate functions: date components

    Code
      show_query(query)
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

# translated lubridate functions: datetime handling

    Code
      show_query(query)
    Output
      dat$with_columns(
        dte = pl$col("time")$dt$date(),
        am_ = pl$col("time")$dt$hour() < 12,
        pm_ = pl$col("time")$dt$hour() >= 12,
        w = pl$col("time")$dt$convert_time_zone("Europe/Paris"),
        f = pl$col("time")$dt$replace_time_zone("Europe/Paris")
      )

# check query for fill, replace_na, drop_na

    Code
      show_query(query)
    Output
      test_pl$with_columns(pl$col("x")$fill_null(strategy = "forward"))

---

    Code
      show_query(query)
    Output
      test_pl$with_columns(
        pl$col("x")$fill_null(0),
        pl$col("y")$replace(NA, "z")
      )

---

    Code
      show_query(query)
    Output
      test_pl$drop_nulls()

# check query for bind_rows_polars, bind_cols_polars

    Code
      show_query(query)
    Output
      pl$concat(
        test_pl,
        test_pl,
        how = "diagonal_relaxed"
      )

---

    Code
      show_query(query)
    Output
      pl$concat(
        test_pl,
        other_pl,
        how = "horizontal_extend"
      )

---

    Code
      show_query(query)
    Output
      pl$concat(
        test_pl,
        test_pl,
        how = "diagonal_relaxed"
      )

# check query for complete()

    Code
      show_query(query)
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

# check query for uncount()

    Code
      show_query(query)
    Output
      test_pl$with_columns(pl$col("x")$repeat_by(pl$col("n")))$
        explode(
          pl$col("x"),
          empty_as_null = TRUE
        )$
        drop("n")

---

    Code
      show_query(query)
    Output
      test_pl$with_columns(pl$col("x")$repeat_by(pl$col("n")))$
        explode(
          pl$col("x"),
          empty_as_null = TRUE
        )$
        drop("n")$
        with_columns(pl$col("x")$cum_count()$over("x", "y")$alias("id"))

# check query for rowwise()

    Code
      show_query(query)
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

# check query for unnest_longer_polars()

    Code
      show_query(query)
    Output
      test_pl$explode(
        "values",
        empty_as_null = TRUE
      )$
        drop_nulls("values")

---

    Code
      show_query(query)
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

# check query for separate_longer_delim_polars() and separate_longer_position_polars()

    Code
      show_query(query)
    Output
      test_pl$with_columns(pl$col("x")$cast(pl$String)$str$split(","))$
        explode(
          "x",
          empty_as_null = TRUE
        )

---

    Code
      show_query(query)
    Output
      test_pl$with_columns(pl$col("x")$cast(pl$String)$str$extract_all(".{1,2}"))$
        filter(pl$all_horizontal(pl$col("x")$is_null() | pl$col("x")$list$len() > 0))$
        explode(
          "x",
          empty_as_null = TRUE
        )

# check query for make_unique_id()

    Code
      show_query(query)
    Output
      test_pl$with_columns(pl$struct(c("x", "y"))$hash()$alias("id"))

# check query for scan_*_polars() and read_*_polars()

    Code
      show_query(query)
    Output
      pl$scan_parquet(
        source = [TRUNCATED],
        n_rows = NULL,
        row_index_name = NULL,
        row_index_offset = 0L,
        parallel = "auto",
        hive_partitioning = NULL,
        hive_schema = NULL,
        try_parse_hive_dates = TRUE,
        glob = TRUE,
        rechunk = FALSE,
        low_memory = FALSE,
        storage_options = NULL,
        use_statistics = TRUE,
        cache = TRUE,
        include_file_paths = NULL
      )$
        filter(pl$col("cyl") > pl$lit(4))$
        select("mpg")

---

    Code
      show_query(query)
    Output
      pl$scan_ndjson(
        source = [TRUNCATED],
        infer_schema_length = 100,
        batch_size = NULL,
        n_rows = NULL,
        low_memory = FALSE,
        rechunk = FALSE,
        row_index_name = NULL,
        row_index_offset = 0,
        ignore_errors = FALSE
      )$
        collect(
          optimizations = pl$QueryOptFlags(
            predicate_pushdown = TRUE,
            projection_pushdown = TRUE,
            simplify_expression = TRUE,
            slice_pushdown = TRUE,
            comm_subplan_elim = TRUE,
            comm_subexpr_elim = TRUE,
            cluster_with_columns = TRUE
          ),
          engine = c("auto", "in-memory", "streaming")
        )$
        select("mpg")

---

    Code
      show_query(query)
    Output
      pl$scan_ipc(
        source = [TRUNCATED],
        n_rows = NULL,
        row_index_name = NULL,
        row_index_offset = 0L,
        rechunk = FALSE,
        cache = TRUE,
        include_file_paths = NULL
      )$
        select("mpg")

