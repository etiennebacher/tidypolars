# basic behavior works

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        sort(
          pl$col("cyl"),
          pl$col("disp"),
          descending = c(FALSE, TRUE),
          nulls_last = TRUE
        )$
        unique(
          "cyl",
          "am",
          keep = "first",
          maintain_order = TRUE
        )
      # A tibble: 6 x 11
          mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
      1  24.4     4  147.    62  3.69  3.19  20       1     0     4     2
      2  21.4     4  121    109  4.11  2.78  18.6     1     1     4     2
      3  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1
      4  21       6  160    110  3.9   2.62  16.5     0     1     4     4
      5  10.4     8  472    205  2.93  5.25  18.0     0     0     3     4
      6  15.8     8  351    264  4.22  3.17  14.5     0     1     5     4

# head()/tail() start recording when they are the first verb

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        head(n = 6L)
      # A tibble: 6 x 11
          mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
      1  21       6   160   110  3.9   2.62  16.5     0     1     4     4
      2  21       6   160   110  3.9   2.88  17.0     0     1     4     4
      3  22.8     4   108    93  3.85  2.32  18.6     1     1     4     1
      4  21.4     6   258   110  3.08  3.22  19.4     1     0     3     1
      5  18.7     8   360   175  3.15  3.44  17.0     0     0     3     2
      6  18.1     6   225   105  2.76  3.46  20.2     1     0     3     1

---

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        tail(n = 3)
      # A tibble: 3 x 11
          mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
      1  19.7     6   145   175  3.62  2.77  15.5     0     1     5     6
      2  15       8   301   335  3.54  3.57  14.6     0     1     5     8
      3  21.4     4   121   109  4.11  2.78  18.6     1     1     4     2

# show_query() works with group_by() and summarize()

    Code
      collect(current)
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
      # A tibble: 3 x 2
          cyl mean_mpg
        <dbl>    <dbl>
      1     6     19.7
      2     4     26.7
      3     8     15.1

# show_query() works with joins and shows the query of both inputs

    Code
      collect(current)
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
      # A tibble: 32 x 3
           cyl   mpg mean_mpg
         <dbl> <dbl>    <dbl>
       1     6  21       19.7
       2     6  21       19.7
       3     4  22.8     26.7
       4     6  21.4     19.7
       5     8  18.7     15.1
       6     6  18.1     19.7
       7     8  14.3     15.1
       8     4  24.4     26.7
       9     4  22.8     26.7
      10     6  19.2     19.7
      # i 22 more rows

# show_query() works with across()

    Code
      collect(current)
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
      # A tibble: 32 x 11
           mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
       1  20.1     6  160    110  3.9   2.62  16.5     0 0.406     4     4
       2  20.1     6  160    110  3.9   2.88  17.0     0 0.406     4     4
       3  20.1     4  108     93  3.85  2.32  18.6     1 0.406     4     1
       4  20.1     6  258    110  3.08  3.22  19.4     1 0.406     3     1
       5  20.1     8  360    175  3.15  3.44  17.0     0 0.406     3     2
       6  20.1     6  225    105  2.76  3.46  20.2     1 0.406     3     1
       7  20.1     8  360    245  3.21  3.57  15.8     0 0.406     3     4
       8  20.1     4  147.    62  3.69  3.19  20       1 0.406     4     2
       9  20.1     4  141.    95  3.92  3.15  22.9     1 0.406     4     2
      10  20.1     6  168.   123  3.92  3.44  18.3     1 0.406     4     4
      # i 22 more rows

# show_query() records magrittr pipe translations

    Code
      collect(current)
    Output
      as_polars_lf(tibble(x = 1:3))$
        with_columns(
          rounded = pl$col("x")$round(decimals = 2),
          in_range = pl$col("x")$
            is_between(
              lower_bound = pl$when(pl$col("x")$has_nulls())$
                then(NA)$
                otherwise(pl$col("x")$min()),
              upper_bound = pl$when(pl$col("x")$has_nulls())$
                then(NA)$
                otherwise(pl$col("x")$max()),
              closed = "both"
            )
        )
      # A tibble: 3 x 3
            x rounded in_range
        <int>   <int> <lgl>   
      1     1       1 TRUE    
      2     2       2 TRUE    
      3     3       3 TRUE    

# user-defined functions returning polars expressions are recorded

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        with_columns(mpg_std = pl_standardize(pl$col("mpg")))$
        select("mpg_std")
      # A tibble: 32 x 1
         mpg_std
           <dbl>
       1   0.151
       2   0.151
       3   0.450
       4   0.217
       5  -0.231
       6  -0.330
       7  -0.961
       8   0.715
       9   0.450
      10  -0.148
      # i 22 more rows

# long vectors are truncated in the query

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        with_columns(
          foo = pl$col("mpg")$is_in(pl$lit(large)$implode(), nulls_equal = TRUE)
        )
      # A tibble: 32 x 12
           mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb foo  
         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <lgl>
       1  21       6  160    110  3.9   2.62  16.5     0     1     4     4 FALSE
       2  21       6  160    110  3.9   2.88  17.0     0     1     4     4 FALSE
       3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1 FALSE
       4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1 FALSE
       5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2 FALSE
       6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1 FALSE
       7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4 FALSE
       8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2 FALSE
       9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2 FALSE
      10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4 FALSE
      # i 22 more rows

---

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        with_columns(
          foo = pl$col("mpg")$is_in(pl$lit(runif(200))$implode(), nulls_equal = TRUE)
        )
      # A tibble: 32 x 12
           mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb foo  
         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <lgl>
       1  21       6  160    110  3.9   2.62  16.5     0     1     4     4 FALSE
       2  21       6  160    110  3.9   2.88  17.0     0     1     4     4 FALSE
       3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1 FALSE
       4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1 FALSE
       5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2 FALSE
       6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1 FALSE
       7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4 FALSE
       8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2 FALSE
       9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2 FALSE
      10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4 FALSE
      # i 22 more rows

# count() doesn't record a `NULL` in sort() when input isn't grouped

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        group_by(am = pl$col("am"))$
        len()$
        rename(len = "n")$
        sort("am")
      # A tibble: 2 x 2
           am     n
        <dbl> <dbl>
      1     0    19
      2     1    13

---

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        group_by(am = pl$col("am"))$
        len()$
        rename(len = "n")$
        sort("am")
      # A tibble: 2 x 2
           am     n
        <dbl> <dbl>
      1     0    19
      2     1    13

# non-syntactic argument names are backquoted in the query

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        filter(pl$col("cyl") > pl$lit(4))$
        select(pl$len()$alias("n"))
      # A tibble: 1 x 1
            n
        <dbl>
      1    21

---

    Code
      collect(current)
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
      # A tibble: 1 x 3
           id   `4`   `5`
        <dbl> <dbl> <dbl>
      1     1    10    20

# the input data is not modified by the recording

    Code
      collect(current)
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object because it didn't go through tidypolars functions.
      i Recording only starts when a tidypolars function is applied to the data.

# the error mentions recording only when the option is FALSE

    Code
      collect(current)
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object because it didn't go through tidypolars functions.
      i Recording only starts when a tidypolars function is applied to the data.

---

    Code
      collect(current)
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object because the option `tidypolars_record_query` is `FALSE`.
      i Run `options(tidypolars_record_query = TRUE)` and re-run your query to show the equivalent polars code.
      i More info with `?tidypolars_options`.

# show_query() rejects extra arguments

    Code
      collect(current)
    Condition
      Error in `show_query()`:
      ! `...` must be empty.
      x Problematic argument:
      * foo = 1

---

    Code
      collect(current)
    Condition
      Error in `show_query()`:
      ! `...` must be empty.
      x Problematic argument:
      * ..1 = 2
      i Did you forget to name an argument?

# the query is wrapped at the console width

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        with_columns(
          mpg = pl$when(pl$col("mpg")$has_nulls())$then(NA)$otherwise(pl$col("mpg")$mean()),
          am = pl$when(pl$col("am")$has_nulls())$then(NA)$otherwise(pl$col("am")$mean())
        )$
        filter(pl$col("cyl") == pl$lit(4) & pl$col("am") == pl$lit(1))
      # A tibble: 0 x 11
      # i 11 variables: mpg <dbl>, cyl <dbl>, disp <dbl>, hp <dbl>, drat <dbl>,
      #   wt <dbl>, qsec <dbl>, vs <dbl>, am <dbl>, gear <dbl>, carb <dbl>

---

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
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
      # A tibble: 0 x 11
      # i 11 variables: mpg <dbl>, cyl <dbl>, disp <dbl>, hp <dbl>, drat <dbl>,
      #   wt <dbl>, qsec <dbl>, vs <dbl>, am <dbl>, gear <dbl>, carb <dbl>

# errors in the pipeline are not affected by the recording

    Code
      collect(current)
    Condition
      Error in `collect()`:
      ! conversion from `str` to `i32` failed in column 'char1' for 2 out of 2 values: ["a", "b"]

# option tidypolars_record_query = FALSE disables the recording

    Code
      collect(current)
    Condition
      Error in `show_query()`:
      ! No polars query was recorded for this object because the option `tidypolars_record_query` is `FALSE`.
      i Run `options(tidypolars_record_query = TRUE)` and re-run your query to show the equivalent polars code.
      i More info with `?tidypolars_options`.

# the input name falls back to a placeholder when it is too long

    Code
      collect(current)
    Output
      `<data>`$filter(pl$col("x") == pl$lit(1))
      # A tibble: 1 x 7
            x     y  zzzz  aaaa  bbbb  cccc  dddd
        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
      1     1     2     3     4     5     6     7

# data.frame arguments with non-syntactic names are rebuilt faithfully

    Code
      collect(current)
    Output
      as_polars_lf(dat)$
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
      # A tibble: 1 x 3
           id     a     b
        <dbl> <dbl> <dbl>
      1     1    10    20

# long vectors that deparse compactly are kept in the query

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        with_columns(
          foo = pl$col("mpg")$is_in(pl$lit(1:200)$implode(), nulls_equal = TRUE)
        )
      # A tibble: 32 x 12
           mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb foo  
         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <lgl>
       1  21       6  160    110  3.9   2.62  16.5     0     1     4     4 TRUE 
       2  21       6  160    110  3.9   2.88  17.0     0     1     4     4 TRUE 
       3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1 FALSE
       4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1 FALSE
       5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2 FALSE
       6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1 FALSE
       7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4 FALSE
       8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2 FALSE
       9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2 FALSE
      10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4 FALSE
      # i 22 more rows

# values too long to display fall back to the code producing them

    Code
      collect(current)
    Output
      as_polars_lf(data.frame(txt = "a"))$
        filter(pl$col("txt") == pl$lit(strrep("a", 400)))
      # A tibble: 0 x 1
      # i 1 variable: txt <chr>

# the source of a value is only used when it is short enough

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        with_columns(
          foo = pl$col("mpg")$
            is_in(pl$lit(`<numeric of length 200>`)$implode(), nulls_equal = TRUE)
        )
      # A tibble: 32 x 12
           mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb foo  
         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <lgl>
       1  21       6  160    110  3.9   2.62  16.5     0     1     4     4 FALSE
       2  21       6  160    110  3.9   2.88  17.0     0     1     4     4 FALSE
       3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1 FALSE
       4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1 FALSE
       5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2 FALSE
       6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1 FALSE
       7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4 FALSE
       8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2 FALSE
       9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2 FALSE
      10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4 FALSE
      # i 22 more rows

# arguments that don't fit on a line are wrapped too

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
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
      # A tibble: 32 x 12
           mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb      z
         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>
       1  21       6  160    110  3.9   2.62  16.5     0     1     4     4  0.151
       2  21       6  160    110  3.9   2.88  17.0     0     1     4     4  0.151
       3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1  0.450
       4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1  0.217
       5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2 -0.231
       6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1 -0.330
       7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4 -0.961
       8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2  0.715
       9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2  0.450
      10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4 -0.148
      # i 22 more rows

# a long value that is not a method call is left on its own line

    Code
      collect(current)
    Output
      as_polars_lf(data.frame(txt = "x"))$
        filter(
          pl$col("txt") ==
            pl$lit(
              "abababababababababababababababababababababababababababababababababababababababababababababababababababababababababababab"
            )
        )
      # A tibble: 0 x 1
      # i 1 variable: txt <chr>

# vignette 'Getting started': who pipeline

    Code
      collect(current)
    Output
      who_pl$filter(pl$col("year") > pl$lit(1990))$
        drop_nulls("newrel_f3544")$
        select(
          "iso3", "year", "newrel_f014", "newrel_f1524", "newrel_f2534",
          "newrel_f3544", "newrel_f4554", "newrel_f5564", "newrel_f65"
        )$
        sort(
          pl$col("iso3"),
          pl$col("year"),
          descending = c(FALSE, FALSE),
          nulls_last = TRUE
        )$
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
      # A tibble: 6 x 9
        ISO3   YEAR NEWREL_F014 NEWREL_F1524 NEWREL_F2534 NEWREL_F3544 NEWREL_F4554
        <chr> <dbl>       <dbl>        <dbl>        <dbl>        <dbl>        <dbl>
      1 AGO    2013         626         2644         2480         1671          991
      2 AIA    2013           0            0            0            0            0
      3 ALB    2013           5           28           34           13           18
      4 AND    2013           0            0            0            1            0
      5 ARE    2013           5            4            9            3            3
      6 ARG    2013         431          927          808          537          395
      # i 2 more variables: NEWREL_F5564 <dbl>, NEWREL_F65 <dbl>

# vignette 'R and Polars expressions': mean() trim argument is kept

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        with_columns(
          x = pl$when(pl$col("mpg")$has_nulls())$
            then(NA)$
            otherwise(pl$col("mpg")$median())
        )
      # A tibble: 32 x 12
           mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb     x
         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
       1  21       6  160    110  3.9   2.62  16.5     0     1     4     4  19.2
       2  21       6  160    110  3.9   2.88  17.0     0     1     4     4  19.2
       3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1  19.2
       4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1  19.2
       5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2  19.2
       6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1  19.2
       7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4  19.2
       8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2  19.2
       9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2  19.2
      10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4  19.2
      # i 22 more rows

# vignette 'R and Polars expressions': external object in filter

    Code
      collect(current)
    Output
      pl$LazyFrame(foo = c(2, 1, 2))$
        filter(pl$col("foo") >= pl$lit(1:3))
      # A tibble: 1 x 1
          foo
        <dbl>
      1     2

# show_query() example: grouped mutate with .by

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        filter(pl$col("cyl") == pl$lit(4))$
        with_columns(mpg2 = (pl$col("mpg") * pl$lit(2))$over("am"))
      # A tibble: 11 x 12
           mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb  mpg2
         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
       1  22.8     4 108      93  3.85  2.32  18.6     1     1     4     1  45.6
       2  24.4     4 147.     62  3.69  3.19  20       1     0     4     2  48.8
       3  22.8     4 141.     95  3.92  3.15  22.9     1     0     4     2  45.6
       4  32.4     4  78.7    66  4.08  2.2   19.5     1     1     4     1  64.8
       5  30.4     4  75.7    52  4.93  1.62  18.5     1     1     4     2  60.8
       6  33.9     4  71.1    65  4.22  1.84  19.9     1     1     4     1  67.8
       7  21.5     4 120.     97  3.7   2.46  20.0     1     0     3     1  43  
       8  27.3     4  79      66  4.08  1.94  18.9     1     1     4     1  54.6
       9  26       4 120.     91  4.43  2.14  16.7     0     1     5     2  52  
      10  30.4     4  95.1   113  3.77  1.51  16.9     1     1     5     2  60.8
      11  21.4     4 121     109  4.11  2.78  18.6     1     1     4     2  42.8

# mutate() example: logical operation and overwriting a column

    Code
      collect(current)
    Output
      as_polars_lf(iris)$
        with_columns(
          big = pl$col("Sepal.Width") > pl$col("Sepal.Length"),
          Sepal.Width = pl$col("Sepal.Width") * pl$lit(2)
        )
      # A tibble: 150 x 6
         Sepal.Length Sepal.Width Petal.Length Petal.Width Species big  
                <dbl>       <dbl>        <dbl>       <dbl> <fct>   <lgl>
       1          5.1         7            1.4         0.2 setosa  FALSE
       2          4.9         6            1.4         0.2 setosa  FALSE
       3          4.7         6.4          1.3         0.2 setosa  FALSE
       4          4.6         6.2          1.5         0.2 setosa  FALSE
       5          5           7.2          1.4         0.2 setosa  FALSE
       6          5.4         7.8          1.7         0.4 setosa  FALSE
       7          4.6         6.8          1.4         0.3 setosa  FALSE
       8          5           6.8          1.5         0.2 setosa  FALSE
       9          4.4         5.8          1.4         0.2 setosa  FALSE
      10          4.9         6.2          1.5         0.1 setosa  FALSE
      # i 140 more rows

# mutate() example: across() with a list of functions and .names

    Code
      collect(current)
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
      # A tibble: 150 x 9
         Sepal.Length Sepal.Width Petal.Length Petal.Width Species
                <dbl>       <dbl>        <dbl>       <dbl> <fct>  
       1          5.1         3.5          1.4         0.2 setosa 
       2          4.9         3            1.4         0.2 setosa 
       3          4.7         3.2          1.3         0.2 setosa 
       4          4.6         3.1          1.5         0.2 setosa 
       5          5           3.6          1.4         0.2 setosa 
       6          5.4         3.9          1.7         0.4 setosa 
       7          4.6         3.4          1.4         0.3 setosa 
       8          5           3.4          1.5         0.2 setosa 
       9          4.4         2.9          1.4         0.2 setosa 
      10          4.9         3.1          1.5         0.1 setosa 
      # i 140 more rows
      # i 4 more variables: mean_of_Sepal.Length <dbl>, sd_of_Sepal.Length <dbl>,
      #   mean_of_Sepal.Width <dbl>, sd_of_Sepal.Width <dbl>

# filter() example: grouped filter with .by

    Code
      collect(current)
    Output
      as_polars_lf(dplyr::starwars)$
        select("name", "mass", "gender")$
        filter((pl$col("mass") > pl$col("mass")$mean())$over("gender"))
      # A tibble: 15 x 3
         name                    mass gender   
         <chr>                  <dbl> <chr>    
       1 Darth Vader            136   masculine
       2 Owen Lars              120   masculine
       3 Beru Whitesun Lars      75   feminine 
       4 Chewbacca              112   masculine
       5 Jabba Desilijic Tiure 1358   masculine
       6 Jek Tono Porkins       110   <NA>     
       7 IG-88                  140   masculine
       8 Bossk                  113   masculine
       9 Ayla Secura             55   feminine 
      10 Gregar Typho            85   <NA>     
      11 Luminara Unduli         56.2 feminine 
      12 Zam Wesell              55   feminine 
      13 Shaak Ti                57   feminine 
      14 Grievous               159   masculine
      15 Tarfful                136   masculine

# pivot_longer() example: relig_income

    Code
      collect(current)
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
        )
      # A tibble: 180 x 3
         religion                income count
         <chr>                   <chr>  <dbl>
       1 Agnostic                <$10k     27
       2 Atheist                 <$10k     12
       3 Buddhist                <$10k     27
       4 Catholic                <$10k    418
       5 Don’t know/refused      <$10k     15
       6 Evangelical Prot        <$10k    575
       7 Hindu                   <$10k      1
       8 Historically Black Prot <$10k    228
       9 Jehovah's Witness       <$10k     20
      10 Jewish                  <$10k     19
      # i 170 more rows

# separate() example: split on a dot

    Code
      collect(current)
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
      # A tibble: 4 x 2
        foo   foo2 
        <chr> <chr>
      1 <NA>  <NA> 
      2 x     y    
      3 x     z    
      4 y     z    

# unite() example: combine columns with a separator

    Code
      collect(current)
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
      # A tibble: 3 x 1
        date      
        <chr>     
      1 2009-10-11
      2 2010-11-22
      3 2011-12-28

# relocate() example: move columns with .after

    Code
      collect(current)
    Output
      as_polars_lf(mtcars)$
        select(
          "mpg", "cyl", "disp", "drat", "wt", "qsec", "am", "gear", "hp", "vs", "carb"
        )
      # A tibble: 32 x 11
           mpg   cyl  disp  drat    wt  qsec    am  gear    hp    vs  carb
         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
       1  21       6  160   3.9   2.62  16.5     1     4   110     0     4
       2  21       6  160   3.9   2.88  17.0     1     4   110     0     4
       3  22.8     4  108   3.85  2.32  18.6     1     4    93     1     1
       4  21.4     6  258   3.08  3.22  19.4     0     3   110     1     1
       5  18.7     8  360   3.15  3.44  17.0     0     3   175     0     2
       6  18.1     6  225   2.76  3.46  20.2     0     3   105     1     1
       7  14.3     8  360   3.21  3.57  15.8     0     3   245     0     4
       8  24.4     4  147.  3.69  3.19  20       0     4    62     1     2
       9  22.8     4  141.  3.92  3.15  22.9     0     4    95     1     2
      10  19.2     6  168.  3.92  3.44  18.3     0     4   123     1     4
      # i 22 more rows

# slice example: slice_head() and slice_tail()

    Code
      collect(current)
    Output
      as_polars_lf(iris)$
        head(3)
      # A tibble: 3 x 5
        Sepal.Length Sepal.Width Petal.Length Petal.Width Species
               <dbl>       <dbl>        <dbl>       <dbl> <fct>  
      1          5.1         3.5          1.4         0.2 setosa 
      2          4.9         3            1.4         0.2 setosa 
      3          4.7         3.2          1.3         0.2 setosa 

---

    Code
      collect(current)
    Output
      as_polars_lf(iris)$
        tail(3)
      # A tibble: 3 x 5
        Sepal.Length Sepal.Width Petal.Length Petal.Width Species  
               <dbl>       <dbl>        <dbl>       <dbl> <fct>    
      1          6.5         3            5.2         2   virginica
      2          6.2         3.4          5.4         2.3 virginica
      3          5.9         3            5.1         1.8 virginica

# translated base functions: maths and rounding

    Code
      collect(current)
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
      # A tibble: 5 x 17
          num   int grp   txt   lgl1  lgl2  date       time                    a     b
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <dbl> <dbl>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00   1.5  1.41
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00   2.3  1.73
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00   4    1   
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00  NA    2.24
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00   6.7  2   
      # i 7 more variables: c <dbl>, d <dbl>, e <dbl>, f <dbl>, g <dbl>, h <dbl>,
      #   i <dbl>

# translated base functions: trigonometry

    Code
      collect(current)
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
      # A tibble: 5 x 17
          num   int grp   txt       lgl1  lgl2  date       time                      a
        <dbl> <int> <chr> <chr>     <lgl> <lgl> <date>     <dttm>                <dbl>
      1   1.5     2 a     Hello Wo~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00  0.0707
      2  -2.3     3 a     foo bar   FALSE TRUE  2021-06-30 2021-06-30 14:00:00 -0.666 
      3   4       1 b     BAZ       TRUE  FALSE 2019-12-01 2019-12-01 23:59:00 -0.654 
      4  NA       5 b     <NA>      NA    FALSE 2022-03-10 2022-03-10 00:00:00 NA     
      5   6.7     4 a     a1b2      FALSE TRUE  2020-07-04 2020-07-04 12:15:00  0.914 
      # i 8 more variables: b <dbl>, c <dbl>, d <dbl>, e <dbl>, f <dbl>, g <dbl>,
      #   h <dbl>, i <dbl>

# translated base functions: cumulative and diff

    Code
      collect(current)
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
      # A tibble: 5 x 13
          num   int grp   txt   lgl1  lgl2  date       time                   cs  cmin
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <int> <int>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00     2     2
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00     5     2
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00     6     1
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00    11     1
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00    15     1
      # i 3 more variables: cmax <int>, rv <int>, df <int>

# translated base functions: anyDuplicated and duplicated

    Code
      collect(current)
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
      # A tibble: 5 x 10
          num   int grp   txt         lgl1  lgl2  date       time                dup  
        <dbl> <int> <chr> <chr>       <lgl> <lgl> <date>     <dttm>              <lgl>
      1   1.5     2 a     Hello World TRUE  TRUE  2020-01-15 2020-01-15 08:30:00 FALSE
      2  -2.3     3 a     foo bar     FALSE TRUE  2021-06-30 2021-06-30 14:00:00 FALSE
      3   4       1 b     BAZ         TRUE  FALSE 2019-12-01 2019-12-01 23:59:00 FALSE
      4  NA       5 b     <NA>        NA    FALSE 2022-03-10 2022-03-10 00:00:00 TRUE 
      5   6.7     4 a     a1b2        FALSE TRUE  2020-07-04 2020-07-04 12:15:00 FALSE
      # i 1 more variable: any_dup <dbl>

# translated base functions: aggregations in summarize()

    Code
      collect(current)
    Output
      dat$select(
        al = (pl$col("int") > pl$lit(0))$all(ignore_nulls = FALSE),
        an = (pl$col("int") > pl$lit(4))$any(ignore_nulls = FALSE),
        na = pl$col("num")$has_nulls(),
        wmn = (pl$col("num")$arg_min() + 1)$first(),
        wmx = (pl$col("num")$arg_max() + 1)$first()
      )
      # A tibble: 1 x 5
        al    an    na      wmn   wmx
        <lgl> <lgl> <lgl> <dbl> <dbl>
      1 TRUE  TRUE  TRUE      2     5

# translated base functions: string manipulation

    Code
      collect(current)
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
      # A tibble: 5 x 13
          num   int grp   txt   lgl1  lgl2  date       time                    n up   
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <dbl> <chr>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00    11 HELL~
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00     7 FOO ~
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00     3 BAZ  
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00    NA <NA> 
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00     4 A1B2 
      # i 3 more variables: lo <chr>, p0 <chr>, p <chr>

# translated base functions: type conversions

    Code
      collect(current)
    Output
      dat$with_columns(
        ch = pl$col("int")$cast(pl$String, strict = FALSE),
        nu = (pl$col("grp") == pl$lit("a"))$cast(pl$Float64, strict = FALSE),
        lg = (pl$col("int") - pl$lit(1))$cast(pl$Boolean, strict = FALSE)
      )
      # A tibble: 5 x 11
          num   int grp   txt   lgl1  lgl2  date       time                ch       nu
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <chr> <dbl>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00 2         1
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00 3         1
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00 1         0
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00 5         0
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00 4         1
      # i 1 more variable: lg <lgl>

# translated base functions: is.* checks

    Code
      collect(current)
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
      # A tibble: 5 x 12
          num   int grp   txt   lgl1  lgl2  date       time                na    fin  
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <lgl> <lgl>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00 FALSE TRUE 
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00 FALSE TRUE 
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00 FALSE TRUE 
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00 TRUE  FALSE
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00 FALSE TRUE 
      # i 2 more variables: inf <lgl>, nan <lgl>

# translated base functions: %in% and %notin%

    Code
      collect(current)
    Output
      dat$with_columns(
        ins = pl$col("grp")$is_in(pl$lit("a")$implode(), nulls_equal = TRUE),
        notin = pl$col("grp")$is_in(pl$lit("a")$implode(), nulls_equal = TRUE)$not()
      )
      # A tibble: 5 x 10
          num   int grp   txt   lgl1  lgl2  date       time                ins   notin
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <lgl> <lgl>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00 TRUE  FALSE
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00 TRUE  FALSE
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00 FALSE TRUE 
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00 FALSE TRUE 
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00 TRUE  FALSE

# translated dplyr functions: between, coalesce, near, if_else

    Code
      collect(current)
    Output
      dat$with_columns(
        bt = pl$col("int")$
          is_between(lower_bound = 2, upper_bound = 4, closed = "both"),
        co = pl$coalesce(pl$col("num"), pl$lit(0)),
        nr = (pl$col("num") - pl$lit(4))$abs() < 1.49011611938477e-08,
        ie = pl$when((pl$col("num") > pl$lit(0))$is_null())$
          then(pl$lit(NA))$
          when(pl$col("num") > pl$lit(0))$
          then(pl$lit("pos"))$
          otherwise(pl$lit("neg")),
        ie_missing = pl$when((pl$col("num") > pl$lit(0))$is_null())$
          then(pl$lit("unknown"))$
          when(pl$col("num") > pl$lit(0))$
          then(pl$lit("pos"))$
          otherwise(pl$lit("neg"))
      )
      # A tibble: 5 x 13
          num   int grp   txt   lgl1  lgl2  date       time                bt       co
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <lgl> <dbl>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00 TRUE    1.5
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00 TRUE   -2.3
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00 FALSE   4  
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00 FALSE   0  
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00 TRUE    6.7
      # i 3 more variables: nr <lgl>, ie <chr>, ie_missing <chr>

# translated dplyr functions: case_when (with and without default)

    Code
      collect(current)
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
      # A tibble: 5 x 10
          num   int grp   txt         lgl1  lgl2  date       time               
        <dbl> <int> <chr> <chr>       <lgl> <lgl> <date>     <dttm>             
      1   1.5     2 a     Hello World TRUE  TRUE  2020-01-15 2020-01-15 08:30:00
      2  -2.3     3 a     foo bar     FALSE TRUE  2021-06-30 2021-06-30 14:00:00
      3   4       1 b     BAZ         TRUE  FALSE 2019-12-01 2019-12-01 23:59:00
      4  NA       5 b     <NA>        NA    FALSE 2022-03-10 2022-03-10 00:00:00
      5   6.7     4 a     a1b2        FALSE TRUE  2020-07-04 2020-07-04 12:15:00
      # i 2 more variables: with_default <chr>, no_default <chr>

# translated dplyr functions: case_match (with and without default)

    Code
      collect(current)
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
      # A tibble: 5 x 10
          num   int grp   txt         lgl1  lgl2  date       time               
        <dbl> <int> <chr> <chr>       <lgl> <lgl> <date>     <dttm>             
      1   1.5     2 a     Hello World TRUE  TRUE  2020-01-15 2020-01-15 08:30:00
      2  -2.3     3 a     foo bar     FALSE TRUE  2021-06-30 2021-06-30 14:00:00
      3   4       1 b     BAZ         TRUE  FALSE 2019-12-01 2019-12-01 23:59:00
      4  NA       5 b     <NA>        NA    FALSE 2022-03-10 2022-03-10 00:00:00
      5   6.7     4 a     a1b2        FALSE TRUE  2020-07-04 2020-07-04 12:15:00
      # i 2 more variables: with_default <chr>, no_default <chr>

# translated dplyr functions: recode_values, replace_values, replace_when

    Code
      collect(current)
    Output
      dat$with_columns(
        rc = pl$col("grp")$replace_strict(old = "a", new = "AA", default = NA),
        rv = pl$col("grp")$replace(old = "b", new = "BB"),
        rw = pl$when(pl$col("int") > pl$lit(3))$
          then(pl$lit(0L))$
          otherwise(pl$col("int"))
      )
      # A tibble: 5 x 11
          num   int grp   txt   lgl1  lgl2  date       time                rc    rv   
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <chr> <chr>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00 AA    a    
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00 AA    a    
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00 <NA>  BB   
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00 <NA>  BB   
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00 AA    a    
      # i 1 more variable: rw <int>

# translated dplyr functions: when_all and when_any

    Code
      collect(current)
    Output
      dat$with_columns(
        wall = pl$all_horizontal(pl$col("lgl1"), pl$col("lgl2")),
        wany = pl$any_horizontal(pl$col("lgl1"), pl$col("lgl2"))
      )
      # A tibble: 5 x 10
          num   int grp   txt   lgl1  lgl2  date       time                wall  wany 
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <lgl> <lgl>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00 TRUE  TRUE 
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00 FALSE TRUE 
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00 FALSE TRUE 
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00 FALSE NA   
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00 FALSE TRUE 

# translated dplyr functions: window functions

    Code
      collect(current)
    Output
      dat$with_columns(
        lg = pl$col("int")$shift(1),
        ld = pl$col("int")$shift(-2),
        rn = pl$int_range(start = 1, pl$len() + 1),
        dr = pl$col("int")$rank(method = "dense"),
        mr = pl$col("int")$rank(method = "min"),
        ci = pl$struct(pl$col("grp"))$rle_id() + 1
      )
      # A tibble: 5 x 14
          num   int grp   txt   lgl1  lgl2  date       time                   lg    ld
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <int> <int>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00    NA     1
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00     2     5
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00     3     4
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00     1    NA
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00     5    NA
      # i 4 more variables: rn <dbl>, dr <dbl>, mr <dbl>, ci <dbl>

# translated dplyr functions: reducers in summarize()

    Code
      collect(current)
    Output
      dat$select(
        f = pl$col("grp")$first(),
        l = pl$col("grp")$last(),
        nt = pl$col("grp")$gather(1),
        cnt = pl$len(),
        nd = pl$struct(pl$col("grp"))$n_unique()
      )
      # A tibble: 1 x 5
        f     l     nt      cnt    nd
        <chr> <chr> <chr> <dbl> <dbl>
      1 a     a     a         5     2

# translated stats functions: median, sd, var

    Code
      collect(current)
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
      # A tibble: 1 x 3
           md     s     v
        <dbl> <dbl> <dbl>
      1  2.75  1.58   2.5

# translated stringr functions: detection

    Code
      collect(current)
    Output
      dat$with_columns(
        det = pl$col("txt")$str$contains("o", literal = FALSE),
        len = pl$col("txt")$str$len_chars(),
        ct = pl$col("txt")$str$count_matches("o", literal = FALSE),
        st = pl$col("txt")$str$contains("^(H)"),
        en = pl$col("txt")$str$contains("(d)$")
      )
      # A tibble: 5 x 13
          num   int grp   txt   lgl1  lgl2  date       time                det     len
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <lgl> <dbl>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00 TRUE     11
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00 TRUE      7
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00 FALSE     3
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00 NA       NA
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00 FALSE     4
      # i 3 more variables: ct <dbl>, st <lgl>, en <lgl>

# translated stringr functions: replacement

    Code
      collect(current)
    Output
      dat$with_columns(
        rp = pl$col("txt")$str$replace("o", "0", literal = FALSE),
        rpa = pl$col("txt")$str$replace_all("o", "0", literal = FALSE),
        rm = pl$col("txt")$str$replace("o", "")
      )
      # A tibble: 5 x 11
          num   int grp   txt   lgl1  lgl2  date       time                rp    rpa  
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <chr> <chr>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00 Hell~ Hell~
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00 f0o ~ f00 ~
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00 BAZ   BAZ  
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00 <NA>  <NA> 
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00 a1b2  a1b2 
      # i 1 more variable: rm <chr>

# translated stringr functions: case

    Code
      collect(current)
    Output
      dat$with_columns(
        up = pl$col("txt")$str$to_uppercase(),
        lo = pl$col("txt")$str$to_lowercase(),
        ti = pl$col("txt")$str$to_titlecase()
      )
      # A tibble: 5 x 11
          num   int grp   txt   lgl1  lgl2  date       time                up    lo   
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <chr> <chr>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00 HELL~ hell~
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00 FOO ~ foo ~
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00 BAZ   baz  
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00 <NA>  <NA> 
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00 A1B2  a1b2 
      # i 1 more variable: ti <chr>

# translated stringr functions: padding and trimming

    Code
      collect(current)
    Output
      dat$with_columns(
        pd = pl$col("txt")$str$pad_start(length = 10, fill_char = " "),
        tr = pl$col("txt")$str$strip_chars(),
        sq = pl$col("txt")$str$replace_all("\\s+", " ")$str$strip_chars()
      )
      # A tibble: 5 x 11
          num   int grp   txt   lgl1  lgl2  date       time                pd    tr   
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <chr> <chr>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00 "Hel~ Hell~
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00 "   ~ foo ~
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00 "   ~ BAZ  
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00  <NA> <NA> 
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00 "   ~ a1b2 
      # i 1 more variable: sq <chr>

# translated stringr functions: extraction

    Code
      collect(current)
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
      # A tibble: 5 x 11
          num   int grp   txt   lgl1  lgl2  date       time                ex    spi  
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <chr> <chr>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00 ello  Hello
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00 foo   foo  
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00 <NA>  BAZ  
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00 <NA>  <NA> 
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00 a     a1b2 
      # i 1 more variable: wd <chr>

# translated lubridate functions: date components

    Code
      collect(current)
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
      # A tibble: 5 x 18
          num   int grp   txt   lgl1  lgl2  date       time                   yr    mo
        <dbl> <int> <chr> <chr> <lgl> <lgl> <date>     <dttm>              <int> <int>
      1   1.5     2 a     Hell~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00  2020     1
      2  -2.3     3 a     foo ~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00  2021     6
      3   4       1 b     BAZ   TRUE  FALSE 2019-12-01 2019-12-01 23:59:00  2019    12
      4  NA       5 b     <NA>  NA    FALSE 2022-03-10 2022-03-10 00:00:00  2022     3
      5   6.7     4 a     a1b2  FALSE TRUE  2020-07-04 2020-07-04 12:15:00  2020     7
      # i 8 more variables: dy <int>, md <int>, wd <int>, yd <int>, q <int>,
      #   ly <lgl>, dim <int>, nd <date>

# translated lubridate functions: datetime handling

    Code
      collect(current)
    Output
      dat$with_columns(
        dte = pl$col("time")$dt$date(),
        am_ = pl$col("time")$dt$hour() < 12,
        pm_ = pl$col("time")$dt$hour() >= 12,
        w = pl$col("time")$dt$convert_time_zone("Europe/Paris"),
        f = pl$col("time")$dt$replace_time_zone("Europe/Paris")
      )
      # A tibble: 5 x 13
          num   int grp   txt    lgl1  lgl2  date       time                dte       
        <dbl> <int> <chr> <chr>  <lgl> <lgl> <date>     <dttm>              <date>    
      1   1.5     2 a     Hello~ TRUE  TRUE  2020-01-15 2020-01-15 08:30:00 2020-01-15
      2  -2.3     3 a     foo b~ FALSE TRUE  2021-06-30 2021-06-30 14:00:00 2021-06-30
      3   4       1 b     BAZ    TRUE  FALSE 2019-12-01 2019-12-01 23:59:00 2019-12-01
      4  NA       5 b     <NA>   NA    FALSE 2022-03-10 2022-03-10 00:00:00 2022-03-10
      5   6.7     4 a     a1b2   FALSE TRUE  2020-07-04 2020-07-04 12:15:00 2020-07-04
      # i 4 more variables: am_ <lgl>, pm_ <lgl>, w <dttm>, f <dttm>

# check query for fill, replace_na, drop_na

    Code
      collect(current)
    Output
      test_pl$with_columns(pl$col("x")$fill_null(strategy = "forward"))
      # A tibble: 3 x 2
            x y    
        <dbl> <chr>
      1     1 a    
      2     1 <NA> 
      3     3 c    

---

    Code
      collect(current)
    Output
      test_pl$with_columns(
        pl$col("x")$fill_null(0),
        pl$col("y")$replace(NA, "z")
      )
      # A tibble: 3 x 2
            x y    
        <dbl> <chr>
      1     1 a    
      2     0 z    
      3     3 c    

---

    Code
      collect(current)
    Output
      test_pl$drop_nulls()
      # A tibble: 2 x 2
            x y    
        <dbl> <chr>
      1     1 a    
      2     3 c    

# check query for bind_rows_polars, bind_cols_polars

    Code
      collect(current)
    Output
      pl$concat(
        test_pl,
        test_pl,
        how = "diagonal_relaxed"
      )
      # A tibble: 4 x 1
            x
        <dbl>
      1     1
      2     2
      3     1
      4     2

---

    Code
      collect(current)
    Output
      pl$concat(
        test_pl,
        other_pl,
        how = "horizontal_extend"
      )
      # A tibble: 2 x 2
            x y    
        <dbl> <chr>
      1     1 a    
      2     2 b    

---

    Code
      collect(current)
    Output
      pl$concat(
        test_pl,
        test_pl,
        how = "diagonal_relaxed"
      )
      # A tibble: 4 x 1
            x
        <dbl>
      1     1
      2     2
      3     1
      4     2

# check query for complete()

    Code
      collect(current)
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
      # A tibble: 6 x 3
        country  year value
        <chr>   <dbl> <dbl>
      1 France   2019    99
      2 France   2020     1
      3 France   2021     2
      4 UK       2019     3
      5 UK       2020    99
      6 UK       2021    99

# check query for uncount()

    Code
      collect(current)
    Output
      test_pl$with_columns(pl$col("x")$repeat_by(pl$col("n")))$
        explode(
          pl$col("x"),
          empty_as_null = TRUE
        )$
        drop("n")
      # A tibble: 3 x 2
        x         y
        <chr> <int>
      1 a       100
      2 b       101
      3 b       101

---

    Code
      collect(current)
    Output
      test_pl$with_columns(pl$col("x")$repeat_by(pl$col("n")))$
        explode(
          pl$col("x"),
          empty_as_null = TRUE
        )$
        drop("n")$
        with_columns(pl$col("x")$cum_count()$over("x", "y")$alias("id"))
      # A tibble: 3 x 3
        x         y    id
        <chr> <int> <dbl>
      1 a       100     1
      2 b       101     1
      3 b       101     2

# check query for rowwise()

    Code
      collect(current)
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
      # A tibble: 2 x 5
            x     y     z total   avg
        <dbl> <dbl> <dbl> <dbl> <dbl>
      1     2     2     5     9   3  
      2     2     3    NA    NA   2.5

# check query for unnest_longer_polars()

    Code
      collect(current)
    Output
      test_pl$explode(
        "values",
        empty_as_null = TRUE
      )$
        drop_nulls("values")
      # A tibble: 6 x 2
           id values
        <int>  <dbl>
      1     1      1
      2     1      2
      3     2      3
      4     2      4
      5     2      5
      6     3      6

---

    Code
      collect(current)
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
      # A tibble: 6 x 3
           id   idx   val
        <int> <dbl> <dbl>
      1     1     1     1
      2     1     2     2
      3     2     1     3
      4     2     2     4
      5     2     3     5
      6     3     1     6

# check query for separate_longer_delim_polars() and separate_longer_position_polars()

    Code
      collect(current)
    Output
      test_pl$with_columns(pl$col("x")$cast(pl$String)$str$split(","))$
        explode(
          "x",
          empty_as_null = TRUE
        )
      # A tibble: 6 x 2
           id x    
        <int> <chr>
      1     1 a    
      2     1 b    
      3     1 c    
      4     2 d    
      5     2 e    
      6     3 f    

---

    Code
      collect(current)
    Output
      test_pl$with_columns(pl$col("x")$cast(pl$String)$str$extract_all(".{1,2}"))$
        filter(pl$all_horizontal(pl$col("x")$is_null() | pl$col("x")$list$len() > 0))$
        explode(
          "x",
          empty_as_null = TRUE
        )
      # A tibble: 6 x 2
           id x    
        <int> <chr>
      1     1 a,   
      2     1 b,   
      3     1 c    
      4     2 d,   
      5     2 e    
      6     3 f    

# check query for make_unique_id()

    Code
      collect(current)
    Output
      test_pl$with_columns(pl$struct(c("x", "y"))$hash()$alias("id"))
      # A tibble: 2 x 3
        x         y      id
        <chr> <dbl>   <dbl>
      1 a         1 9.40e18
      2 b         2 6.70e18

