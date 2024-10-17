# tidypolars (development version)

## Breaking changes

* `arrange()` now errors with unknown variable names (like `dplyr::arrange()`).
  Previously, unknown variables were silently ignored. Using expressions (like
  `a + b`) is now accepted (#144).
  
* The parameter `inherit_optimization` is removed from all `sink_*()` functions.

## New features

* The power operators `^` and `**` now work.

* New function `sink_ndjson()` to write the results of a lazy query to a NDJSON
  file without collecting it in memory.

* `inner_join()` now accepts inequality joins in the `by` argument, including 
  the following helpers: `between()`, `overlaps()`, `within()` (#148).

## Bug fixes

* Using an external object in `case_when()`, `ifelse()` and `ifelse()` now works.

* `str_sub()` doesn't error anymore when `start` is positive and `end` is negative.

* `read_*_polars()` functions used to return a standard `data.frame` by mistake.
  They now return a Polars DataFrame.
  
* Using `[` for subsetting in expressions now works. Thanks @ginolhac for the 
  report (#141).
  
* `bind_cols_polars()` and `bind_rows_polars()` now error (as expected before) if
  elements are a mix of Polars DataFrames and LazyFrames.


# tidypolars 0.10.1

## Bug fixes

* Do not error when handling columns with datatype `Null`. Note that converting
  those columns to R with `as.data.frame()`, `as_tibble()`, or `collect()` is 
  still an issue as of `polars` 0.19.1.

# tidypolars 0.10.0

`tidypolars` requires `polars` >= 0.19.1.

## Breaking changes and deprecations

* `describe()` is deprecated as of tidypolars 0.10.0 and will be removed in a 
  future update. Use `summary()` with the same arguments instead (#127).

* `describe_plan()` and `describe_optimized_plan()` are deprecated as of 
  tidypolars 0.10.0 and will be removed in a future update. Use `explain()` with
  `optimized = TRUE/FALSE` instead (#128).
  
* In `sink_parquet()` and `sink_csv()`, all arguments except for `.data` and 
  `path` must be named (#136).
  
## New features

* Add support for more functions:

  - from package `base`: `substr()`.

* Better error message when a function can come from several packages but only
  one version is translated (#130).
  
* `row_number()` now works without argument (#131).

* New functions to import data as Polars DataFrames and LazyFrames (#136):

  * `read_<format>_polars()` to import data as a Polars DataFrame;
  * `scan_<format>_polars()` to import data as a Polars LazyFrame;
  * `<format>` can be "csv", "ipc", "json", "parquet".
  
  Those can replace functions from `polars`. For example, 
  `polars::pl$read_parquet(...)` can be replaced by 
  `read_parquet_polars(...)`.
  
* New functions to write Polars DataFrames to external files: 
  `write_<format>_polars()` where `<format>` can be "csv", "ipc", "json", 
  "ndjson", "parquet" (#136).
  
* New function `sink_ipc()` that is similar to `sink_parquet()` and `sink_csv()`
  but for IPC files (#136).
  
* `across()` now throws a better error message when the user passes an external
  list to `.fns`. This works with `dplyr` but cannot work with `tidypolars`
  (#135).
  
* Added support for argument `.add` in `group_by()`.
  
## Bug fixes

* `stringr::str_sub()` now works when both `start` and `end` are negative.

* Fixed a bug in `str_sub()` when `start` was greater than 1.

* `stringr::str_starts()` and `stringr::str_ends()` now work with a regex.

* `fill()` doesn't error anymore when `...` is empty. Instead, it returns the 
  input data.
  
* `unite()` now provides a proper error message when `col` is missing.

* `unite()` doesn't error anymore when `...` is empty. Instead, it uses all 
  variables in the dataset.
  
* `filter()`, `mutate()` and `summarize()` now work when using a column from 
  another data.frame, e.g. 
  ```r
  my_polars_df |> 
    filter(x %in% some_data_frame$y)
  ```
* `replace_na()` no longer converts the column to the datatype of the replacement,
  e.g. `data |> replace_na("a")` will error if the input data is numeric.
  
* `n_distinct()` now correctly applies the `na.rm` argument when several columns
  are passed as input (#137).

# tidypolars 0.9.0

`tidypolars` requires `polars` >= 0.18.0.

## New features

* Add support for several functions:

  - from package `base`: `%%` and `%/%`.
  
  - from package `dplyr`: `dense_rank()`, `row_number()`.

  - from package `lubridate`: `wday()`.

* Better handling of missing values to match `R` behavior. In the following
  functions, if there is at least one missing value and `na.rm = FALSE` (the 
  default), then the output will be `NA`: `max()`, `mean()`, `median()`, `min()`,
  `sd()`, `sum()`, `var()` (#120).
  
* New argument `cluster_with_columns` in `collect()`, `compute()`, and `fetch()`.

* Add a global option `tidypolars_unknown_args` to control what happens when 
  `tidypolars` doesn't know how to handle an argument in a function. The default
  is to warn and the only other accepted value is `"error"`.
  
## Bug fixes

* `count()` and `add_count()` no longer overwrite a variable named `n` if the 
  argument `name` is unspecified.


# tidypolars 0.8.0

`tidypolars` requires `polars` >= 0.17.0.

## Breaking changes

* As announced in `tidypolars` 0.7.0, the behavior of `collect()` has changed.
  It now returns a standard R `data.frame` and not a Polars `DataFrame` anymore.
  Replace `collect()` by `compute()` (with the same arguments) to keep the old
  behavior.
  
* In `bind_rows_polars()`, if `.id` is passed, the resulting column now is of 
  type character instead of integer.

## New features

* Add support for several functions:

  - from package `base`: `all()`, `any()`, `diff()`, `ISOdatetime()`, 
    `length()`, `rev()`, `unique()`.
  
  - from package `dplyr`: `consecutive_id()`, `min_rank()`, `na_if()`, 
    `n_distinct()`, `nth()`.
  
  - from package `lubridate`: `make_datetime()`.
  
  - from package `stringr`: `str_dup()`, `str_split()`, `str_split_i()`, 
    `str_trunc()`.
  
  - from package `tidyr`: `replace_na()` (the data.frame method was already
    translated but not the vector one that can be used in `mutate()` for example).
    
* It is now possible to use explicit namespaces (such as `dplyr::first()` instead
  of `first()`) in `mutate()`, `summarize()` and `filter()` (#114).
  
* In `bind_rows_polars()`, if all elements are named and `.id` is specified, the
  `.id` column will use the names of the elements (#116).
  
* It is now possible to rename variables in `select()` (#117).

* Add support for argument `na_matches` in all join functions (except 
  `cross_join()` that doesn't need it) (#109).

## Bug fixes

* Local variables in custom functions could not be used in tidypolars functions
  (reported in a blog post of Art Steinmetz). This is now fixed.
  
* `across()` now works when `.cols` contains only one variable and `.fns` contains
  only one function.
  
* In `across()`, the `.cols` argument now takes into account variables created
  in the same `mutate()` or `summarize()` call before `across()`. 
  
  ```r
  as_polars_df(mtcars) |> 
    head(n = 3) |> 
    mutate(
      foo = 1, 
      across(.cols = contains("oo"), \(x) x - 1)
    )
  
  shape: (3, 12)
  ┌──────┬─────┬───────┬───────┬───┬─────┬──────┬──────┬─────┐
  │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ am  ┆ gear ┆ carb ┆ foo │
  │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ ---  ┆ ---  ┆ --- │
  │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64  ┆ f64  ┆ f64 │
  ╞══════╪═════╪═══════╪═══════╪═══╪═════╪══════╪══════╪═════╡
  │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 4.0  ┆ 0.0 │
  │ 21.0 ┆ 6.0 ┆ 160.0 ┆ 110.0 ┆ … ┆ 1.0 ┆ 4.0  ┆ 4.0  ┆ 0.0 │
  │ 22.8 ┆ 4.0 ┆ 108.0 ┆ 93.0  ┆ … ┆ 1.0 ┆ 4.0  ┆ 1.0  ┆ 0.0 │
  └──────┴─────┴───────┴───────┴───┴─────┴──────┴──────┴─────┘
  ```
  
  Note that the `where()` function is not supported here. For example:
  
  ```r
  as_polars_df(mtcars) |> 
    mutate(
      foo = 1, 
      across(.cols = where(is.numeric), \(x) x - 1)
    )
  ```
  will *not* return 0 for the variable `foo`. A warning is emitted about this 
  behavior. 
  
* Better handling of negative values in `c()` when called in `mutate()` and
  `summarize()`.


# tidypolars 0.7.0

`tidypolars` requires `polars` >= 0.16.0.

## Breaking changes and deprecations

* `as_polars()` is now removed. It was deprecated in 0.6.0. Use `as_polars_df()`
  or `as_polars_lf()` instead.
  
* `to_r()` is now removed. It was deprecated in 0.6.0. Use `as.data.frame()`
  or `as_tibble()` instead.
  
* For consistency with `dplyr`, the behavior of `collect()` will change in 0.8.0
  as it will perform the lazy query **and** convert the result to a standard
  `data.frame`. For now, `collect()` only throws a warning about this future 
  change. It is recommended to use `compute()` to only perform the query and get
  a Polars DataFrame as output (#101).

## New features

* Several improvements and changes for `pivot_wider()` (#95):

  * `names_from` can now takes several variables;
  * add support for `id_cols` and `names_glue`;
  * default value of `names_sep` now is `_`, for consistency with `tidyr`;
  * fix documentation as `pivot_wider()` doesn't work on LazyFrame.
  
* Add support for `stringr::regex()`. Note that only the argument `ignore_case`
  is supported for now (#97).
  
* Add support for several `lubridate` functions: `dweeks()`, `ddays()`, 
  `dhours()`, `dminutes()`, `dseconds()`, `dmilliseconds()`, `make_date()` (#107).
  
* When a `polars` function called internally fails, the original error message
  is now displayed.
  
* Add support for `group_split()` (for `DataFrame` only).

* Add support for argument `relationship` in `left_join()`, `right_join()`, 
  `full_join()` and `inner_join()` (#106).


# tidypolars 0.6.0

`tidypolars` requires `polars` >= 0.15.0.

## Breaking changes and deprecations
  
* `as_polars()` is deprecated and will be removed in 0.7.0. Use `as_polars_lf()`
  or `as_polars_df()` instead.

* `as_polars()` doesn't have an argument `with_string_cache` anymore. When set
  to `TRUE`, this enabled the string cache globally, which could lead to 
  undesirable side effects.
  
* `to_r()` is deprecated and will be removed in 0.7.0. Use `as.data.frame()` or
  `as_tibble()` instead. This used to silently return a `LazyFrame` if the 
  input was `LazyFrame`. It now automatically collects the `LazyFrame` (#88).
  
* `pull()` nows automatically collects input `LazyFrame` (#89).
  
## New features

* Add support for argument `.keep` in `mutate()` (#80).

* Add support for `group_vars()` and `group_keys()` (#81).

* **Experimental** support of `rowwise()`. For now, this is limited to a few 
  functions: `mean()`, `median()`, `min()`, `max()`, `sum()`, `all()`, `any()`. 
  `rowwise()` and `group_by()` cannot be used at the same time (#40).
  
* All functions that return a polars `Data/LazyFrame` now add the class 
  `"tidypolars"` to the output (#86).

* Support `which.min()`, `which.max()`, `dplyr::n()`.

* Support `.data[[` and `.env[[` in addition to `.data$` and `.env$`. Better
  error messages when the objects specified in `.data` or `.env` don't exist.
  
## Bug fixes

* `pull()` now errors when `var` is of length > 1.


# tidypolars 0.5.0

`tidypolars` requires `polars` >= 0.12.0.

## Breaking changes

* `across()` now errors if the argument `.cols` is not provided (either named or
  unnamed). This behavior was deprecated in `dplyr` 1.1.0.
  
* It is no longer possible to use `!` in `arrange()` to sort by decreasing order,
  for compatibility with `dplyr::arrange()`. Use `-` or `desc()` instead.
  
## New features

* `summarize()` now works on ungrouped data and returns a 1-row output.

* It is now possible to use `desc(x1)` in `arrange()` to sort in decreasing 
  order of `x1` (this is equivalent to `-x1`).
  
* Add support for argument `names_prefix` in `pivot_longer()`.

* Add support for arguments `names_prefix` and `names_sep` in `pivot_wider()`.

* Add support for `tidyr::uncount()`.

* All `*_join()` functions now work when `by` is a specification created by 
  `dplyr::join_by()`. Notice that this is limited to equality joins for now.
  
* You can now use the "embrace" operator `{{ }}` to pass unquoted column names
  (among other things) as arguments of custom functions. See the ["Programming
  with dplyr" vignette](https://dplyr.tidyverse.org/dev/articles/programming.html)
  for some examples.
  
* `bind_cols_polars()` now works with two `LazyFrame`s, but not more.

* Add support for argument `.name_repair` in `bind_cols_polars()` (#74).

* Support for `.env$` and `.data$` pronouns in expressions of `filter()`, 
  `mutate()` and `summarize()`.
  
* Support named vector in the argument `pattern` of `str_replace_all()`, where
  names are patterns and values are replacements.
  
* Using `%in%` for factor variables doesn't require enabling the string cache
  anymore.

## Bug fixes

* `summarize()` no longer errors when `across(everything(), ...)` is used with
  `.by`.

* All `*_join()` functions no longer error when a named vector is provided in 
  the argument `by`.
  
* Expressions with values only are not named "literal" anymore.

## Misc

* Simplify the procedure to support new functions.


# tidypolars 0.4.0

`tidypolars` requires `polars` >= 0.11.0.

## Breaking changes

* It is no longer possible to pass a list in `rename()`. 

## New features

* The argument `with_string_cache` in `as_polars()` now enables the string cache
  globally if set to `TRUE` (#54).
  
* Better error message in `filter()` when comparing factors to strings while the
  string cache is disabled.
  
* Basic support for `strptime()`. It is possible to use `strptime(*, strict = FALSE)`
  to not error when the parsing of some characters fails.

* New argument `.by` in `filter()`, `mutate()`, and `summarize()`, and new 
  argument `by` in the `slice_*()` functions. This allows to do operations on
  groups without using `group_by()` and `ungroup()`. See the 
  [`dplyr` vignette](https://dplyr.tidyverse.org/reference/dplyr_by.html) for 
  more information (#59).
  
* `rename()` now accepts unquoted names both old and new names.

* Support fixed regexes in `str_detect()` (using `fixed()`) and in `grepl()` 
  (using `fixed = TRUE`).

## Bug fixes

* Improve robustness of sequential expressions in `mutate()` and `summarize()` 
  (i.e expressions that should be run one after the other because they depend on
  variables created in the same call) (#58).
  
* `relocate()` now works correctly when `.after = last_col()`.

* All functions that work on grouped data now correctly restore the groups 
  structure (#62).
  
## Misc

* Error messages coming from `mutate()`, `summarize()`, and `filter()` now give 
  the right function call. 

* Faster tidy selection (#61).


# tidypolars 0.3.0

`tidypolars` requires `polars` >= 0.10.0.

## Breaking changes

* All functions starting with `pl_` have been removed to the benefit of the S3
  methods. For example, `pl_distinct()` doesn't exist anymore so the only way to
  use it is to load `dplyr` and to use `distinct()` on a Polars DataFrame or
  LazyFrame. This is to avoid confusion about compatibility with `dplyr` and 
  `tidyr`. See #49 for a more detailed explanation.
  
* `pl_bind_rows()` and `pl_bind_cols()` are renamed `bind_rows_polars()` and
  `bind_cols_polars()` respectively. This is because `bind_rows()` and `bind_cols()`
  are not S3 methods (this might change in future versions of `dplyr`).

## New features

* New function `duplicated_rows()` that is the opposite of `distinct()` (#50).

* New argument `.id` in `bind_rows_polars()`.

* `bind_rows_polars()` can now bind Data/LazyFrames that don't have the same 
  schema. Columns will be upcast to common types if necessary. Unknown columns 
  will be filled with `NA`.
  
## Bug fixes

* `complete()` now works correctly on grouped data.

## Misc

* `relig_income` and `fish_encounters` are not reexported anymore since `tidyr` 
  is now imported.
  

# tidypolars 0.2.0

`tidypolars` requires `polars` >= 0.9.0.

## New features

* Rename `pl_fetch()` to `fetch()`.

* New functions supported: `describe()`, `sink_csv()`, `slice_sample()`.

* New argument `fill` in `pl_complete()`.
  
* Support `stringr::str_to_title()` and `tools::toTitleCase()`.

* Support `stringr::fixed()` to use literal strings.

* Support replacements with captured groups like `\\1` in `stringr::str_replace()`
  and `stringr::str_replace_all()`.

## Bug fixes

* `sink_parquet()` didn't use the user inputs (apart from the `path`).
  
## Misc

* Clearer error message when an expression contains `<pkg>::`. This is not 
  supported for now but could potentially be implemented later.

* `pl_colnames()` is no longer exported.


# tidypolars 0.1.0

## New features

* Support `as.numeric()`, `as.character()`, `as.logical()`, `grepl()`, and
  `paste()` in expressions in `pl_filter()`, `pl_mutate()` and `pl_summarize()`.
  
* Support `sink_parquet()` (#38).

* Support `fetch()` (#42).

* Support for additional `stringr` functions: `str_detect()`, `str_extract_all()`,
  `str_pad()`, `str_squish()`, `str_trim()`, `word()` (some arguments or corner 
  cases are not supported yet).

* Add all optimization parameters in `collect()`.

## Bug fixes

* Fix `pl_mutate()` and `pl_summarize()` when expressions use some variables 
  previously created or modified (#10, #37).
  
* Fix bug in `pl_filter()` when passing a vector in the RHS of `%in%`.
  
## Misc

* Improve the backend to translate R expressions into Polars expressions. This
  also led to a complete rewriting of the vignette "R and Polars expressions" 
  (#27).
  
* Error messages should now report the correct function call.

* Improve CI coverage (#35).



# tidypolars 0.0.1

* First Github release.
