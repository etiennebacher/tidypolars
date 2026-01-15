# Show the optimized and non-optimized query plans

This function is available for `LazyFrame`s only.

By default,
[`explain()`](https://dplyr.tidyverse.org/reference/explain.html) shows
the query plan that is optimized and then run by Polars. Setting
`optimized = FALSE` shows the query plan as-is, without any optimization
done, but this is not the query performed. Note that the plans are read
from bottom to top.

## Usage

``` r
# S3 method for class 'polars_lazy_frame'
explain(x, optimized = TRUE, ...)
```

## Arguments

- x:

  A Polars LazyFrame.

- optimized:

  Logical. If `TRUE` (default), show the query optimized by Polars.
  Otherwise, show the initial query.

- ...:

  Ignored.

## Examples

``` r
query <- mtcars |>
  as_polars_lf() |>
  arrange(drat) |>
  filter(cyl == 3) |>
  select(mpg)

# unoptimized query plan:
no_opt <- explain(query, optimized = FALSE)
no_opt
#> [1] "SELECT [col(\"mpg\")]\n  FILTER [(col(\"cyl\")) == (3.0)]\n  FROM\n    SELECT [col(\"mpg\"), col(\"cyl\"), col(\"disp\"), col(\"hp\"), col(\"drat\"), col(\"wt\"), col(\"qsec\"), col(\"vs\"), col(\"am\"), col(\"gear\"), col(\"carb\")]\n      SORT BY [nulls_last: [true]] [col(\"__TIDYPOLARS_TEMP_SORT__1\")]\n         WITH_COLUMNS:\n         [col(\"drat\").alias(\"__TIDYPOLARS_TEMP_SORT__1\")] \n          DF [\"mpg\", \"cyl\", \"disp\", \"hp\", ...]; PROJECT */11 COLUMNS"

# better printing with cat():
cat(no_opt)
#> SELECT [col("mpg")]
#>   FILTER [(col("cyl")) == (3.0)]
#>   FROM
#>     SELECT [col("mpg"), col("cyl"), col("disp"), col("hp"), col("drat"), col("wt"), col("qsec"), col("vs"), col("am"), col("gear"), col("carb")]
#>       SORT BY [nulls_last: [true]] [col("__TIDYPOLARS_TEMP_SORT__1")]
#>          WITH_COLUMNS:
#>          [col("drat").alias("__TIDYPOLARS_TEMP_SORT__1")] 
#>           DF ["mpg", "cyl", "disp", "hp", ...]; PROJECT */11 COLUMNS

# optimized query run by polars
cat(explain(query))
#> simple π 1/1 ["mpg"]
#>   SORT BY [nulls_last: [true]] [col("__TIDYPOLARS_TEMP_SORT__1")]
#>      WITH_COLUMNS:
#>      [col("drat").alias("__TIDYPOLARS_TEMP_SORT__1")] 
#>       FILTER [(col("cyl")) == (3.0)]
#>       FROM
#>         DF ["mpg", "cyl", "disp", "hp", ...]; PROJECT["mpg", "cyl", "drat"] 3/11 COLUMNS
```
