# tidypolars (development version)

**Breaking changes**

* `across()` now errors if the argument `.cols` is not provided (either named or
  unnamed). This behavior was deprecated in `dplyr` 1.1.0.
  
* It is no longer possible to use `!` in `arrange()` to sort by decreasing order,
  for compatibility with `dplyr::arrange()`. Use `-` or `desc()` instead.
  
**New features**

* `summarize()` now works on ungrouped data and returns a 1-row output.

* It is now possible to use `desc(x1)` in `arrange()` to sort in decreasing 
  order of `x1` (this is equivalent to `-x1`).
  
* Add support for argument `names_prefix` in `pivot_longer()` and `pivot_wider()`.

* Add support for argument `names_sep` in `pivot_wider()`.

**Bug fixes**

* `summarize()` no longer errors when `across(everything(), ...)` is used with
  `.by`.

**Misc**

* Simplify the procedure to support new functions.


# tidypolars 0.4.0

`tidypolars` requires `polars` >= 0.11.0.

**Breaking changes**

* It is no longer possible to pass a list in `rename()`. 

**New features**

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

**Bug fixes**

* Improve robustness of sequential expressions in `mutate()` and `summarize()` 
  (i.e expressions that should be run one after the other because they depend on
  variables created in the same call) (#58).
  
* `relocate()` now works correctly when `.after = last_col()`.

* All functions that work on grouped data now correctly restore the groups 
  structure (#62).
  
**Misc**

* Error messages coming from `mutate()`, `summarize()`, and `filter()` now give 
  the right function call. 

* Faster tidy selection (#61).

# tidypolars (0.3.0)

`tidypolars` requires `polars` >= 0.10.0.

**Breaking changes**

* All functions starting with `pl_` have been removed to the benefit of the S3
  methods. For example, `pl_distinct()` doesn't exist anymore so the only way to
  use it is to load `dplyr` and to use `distinct()` on a Polars DataFrame or
  LazyFrame. This is to avoid confusion about compatibility with `dplyr` and 
  `tidyr`. See #49 for a more detailed explanation.
  
* `pl_bind_rows()` and `pl_bind_cols()` are renamed `bind_rows_polars()` and
  `bind_cols_polars()` respectively. This is because `bind_rows()` and `bind_cols()`
  are not S3 methods (this might change in future versions of `dplyr`).

**New features**

* New function `duplicated_rows()` that is the opposite of `distinct()` (#50).

* New argument `.id` in `bind_rows_polars()`.

* `bind_rows_polars()` can now bind Data/LazyFrames that don't have the same 
  schema. Columns will be upcast to common types if necessary. Unknown columns 
  will be filled with `NA`.
  
**Bug fixes**

* `complete()` now works correctly on grouped data.

**Misc**

* `relig_income` and `fish_encounters` are not reexported anymore since `tidyr` 
  is now imported.
  

# tidypolars 0.2.0

`tidypolars` requires `polars` >= 0.9.0.

**New features**

* Rename `pl_fetch()` to `fetch()`.

* New functions supported: `describe()`, `sink_csv()`, `slice_sample()`.

* New argument `fill` in `pl_complete()`.
  
* Support `stringr::str_to_title()` and `tools::toTitleCase()`.

* Support `stringr::fixed()` to use literal strings.

* Support replacements with captured groups like `\\1` in `stringr::str_replace()`
  and `stringr::str_replace_all()`.

**Bug fixes**

* `sink_parquet()` didn't use the user inputs (apart from the `path`).
  
**Misc**

* Clearer error message when an expression contains `<pkg>::`. This is not 
  supported for now but could potentially be implemented later.

* `pl_colnames()` is no longer exported.


# tidypolars 0.1.0

**New features**

* Support `as.numeric()`, `as.character()`, `as.logical()`, `grepl()`, and
  `paste()` in expressions in `pl_filter()`, `pl_mutate()` and `pl_summarize()`.
  
* Support `sink_parquet()` (#38).

* Support `fetch()` (#42).

* Support for additional `stringr` functions: `str_detect()`, `str_extract_all()`,
  `str_pad()`, `str_squish()`, `str_trim()`, `word()` (some arguments or corner 
  cases are not supported yet).

* Add all optimization parameters in `collect()`.

**Bug fixes**

* Fix `pl_mutate()` and `pl_summarize()` when expressions use some variables 
  previously created or modified (#10, #37).
  
* Fix bug in `pl_filter()` when passing a vector in the RHS of `%in%`.
  
**Misc**

* Improve the backend to translate R expressions into Polars expressions. This
  also led to a complete rewriting of the vignette "R and Polars expressions" 
  (#27).
  
* Error messages should now report the correct function call.

* Improve CI coverage (#35).



# tidypolars 0.0.1

* First Github release.
