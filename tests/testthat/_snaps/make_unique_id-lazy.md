# make_unique_id() is deprecated

    Code
      collect(current)
    Condition
      Warning:
      `make_unique_id()` was deprecated in tidypolars 0.16.0.
      i This has no guarantee of giving the same results across Polars versions.
      i It has no replacement in `tidypolars`.
    Output
      # A tibble: 32 x 12
           mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb    hash
         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>   <dbl>
       1  21       6  160    110  3.9   2.62  16.5     0     1     4     4 1.00e19
       2  21       6  160    110  3.9   2.88  17.0     0     1     4     4 2.50e18
       3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1 1.32e19
       4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1 9.79e18
       5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2 1.64e19
       6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1 7.27e18
       7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4 3.57e18
       8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2 5.72e17
       9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2 1.14e19
      10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4 5.21e18
      # i 22 more rows

