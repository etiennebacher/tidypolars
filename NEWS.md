# tidypolars (development)

**New features**

* The argument `with_string_cache` in `as_polars()` now enables the string cache
  globally if set to `TRUE` (#54).
  
**Misc**

* Error messages coming from `mutate()`, `summarize()`, and `filter()` now give 
  the right function call. 

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
