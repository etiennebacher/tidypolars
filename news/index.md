# Changelog

## tidypolars (development version)

### Breaking changes and deprecations

- The following functions (deprecated since 0.10.0, August 2024) are now
  removed
  ([\#303](https://github.com/etiennebacher/tidypolars/issues/303)):

  - `describe()`, use [`summary()`](https://rdrr.io/r/base/summary.html)
    instead.
  - `describe_plan()` and `describe_optimized_plan()`, use
    `explain(optimized = TRUE/FALSE)` instead.

- [`make_unique_id()`](https://tidypolars.etiennebacher.com/reference/make_unique_id.md)
  is deprecated and will be removed in a future version. This is because
  the underlying Polars function isn’t guaranteed to give the same
  results across different versions. This function doesn’t have a
  replacement in `tidypolars`
  ([\#304](https://github.com/etiennebacher/tidypolars/issues/304)).

### New features

- Added support for
  [`dplyr::near()`](https://dplyr.tidyverse.org/reference/near.html)
  ([\#311](https://github.com/etiennebacher/tidypolars/issues/311)).

- [`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html)
  now works with Polars LazyFrames
  ([\#318](https://github.com/etiennebacher/tidypolars/issues/318)).

- Added support for several functions implemented in `dplyr` 1.2.0:

  - [`filter_out()`](https://dplyr.tidyverse.org/reference/filter.html)
    ([\#280](https://github.com/etiennebacher/tidypolars/issues/280))
  - [`recode_values()`](https://dplyr.tidyverse.org/reference/recode-and-replace-values.html)
    ([\#308](https://github.com/etiennebacher/tidypolars/issues/308))
  - [`replace_values()`](https://dplyr.tidyverse.org/reference/recode-and-replace-values.html)
    ([\#308](https://github.com/etiennebacher/tidypolars/issues/308))
  - [`replace_when()`](https://dplyr.tidyverse.org/reference/case-and-replace-when.html)
    ([\#307](https://github.com/etiennebacher/tidypolars/issues/307))
  - [`when_any()`](https://dplyr.tidyverse.org/reference/when-any-all.html)
    ([\#306](https://github.com/etiennebacher/tidypolars/issues/306))
  - [`when_all()`](https://dplyr.tidyverse.org/reference/when-any-all.html)
    ([\#306](https://github.com/etiennebacher/tidypolars/issues/306))

### Other changes

- Several changes to make `tidypolars` more aligned with the `tidyverse`
  output in general
  ([\#316](https://github.com/etiennebacher/tidypolars/issues/316)):

  - in [`count()`](https://dplyr.tidyverse.org/reference/count.html), if
    `sort = TRUE` and there are some ties, then other variables are
    sorted in increasing order.
  - [`coalesce()`](https://dplyr.tidyverse.org/reference/coalesce.html)
    no longer has a `default` argument. This was an implementation
    mistake since
    [`dplyr::coalesce()`](https://dplyr.tidyverse.org/reference/coalesce.html)
    never had this argument.
  - [`ungroup()`](https://dplyr.tidyverse.org/reference/group_by.html)
    used to remove the group-specific attributes in the original grouped
    data, even if the result of the operation was not assigned. This is
    fixed.
  - [`replace_na()`](https://tidyr.tidyverse.org/reference/replace_na.html)
    on a Polars DataFrame or LazyFrame now errors if `replacement` is
    not a list.
  - `slice_*()` functions on grouped data return columns in the same
    order as in the input.
  - [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
    with only `NULL` expressions now returns one row per unique group
    instead of the entire data.
  - [`unite()`](https://tidyr.tidyverse.org/reference/unite.html) now
    returns columns in the correct order, and doesn’t duplicate the
    `sep` in the output if some values are `NA`.

#### Bug fixes

- [`bind_rows_polars()`](https://tidypolars.etiennebacher.com/reference/bind_rows_polars.md)
  now uses input names in `.id` if not all inputs are named, for example
  `bind_rows_polars(x1 = x1, x2, .id = "id")`
  ([\#317](https://github.com/etiennebacher/tidypolars/issues/317)).

## tidypolars 0.16.0

`tidypolars` requires `polars` \>= 1.8.0.

### New features

- New function
  [`unnest_longer_polars()`](https://tidypolars.etiennebacher.com/reference/unnest_longer_polars.md)
  to unnest list-columns into rows, equivalent to
  [`tidyr::unnest_longer()`](https://tidyr.tidyverse.org/reference/unnest_longer.html).
  It supports the parameters `values_to`, `indices_to`, `keep_empty`, as
  well as the `{col}` templates for column naming.
  ([\#212](https://github.com/etiennebacher/tidypolars/issues/212),
  [\#281](https://github.com/etiennebacher/tidypolars/issues/281),
  [@Yousa-Mirage](https://github.com/Yousa-Mirage))

- New functions
  [`separate_longer_delim_polars()`](https://tidypolars.etiennebacher.com/reference/separate_longer.md)
  and
  [`separate_longer_position_polars()`](https://tidypolars.etiennebacher.com/reference/separate_longer.md)
  to split string columns into rows by delimiter or fixed width,
  equivalent to
  [`tidyr::separate_longer_delim()`](https://tidyr.tidyverse.org/reference/separate_longer_delim.html)
  and
  [`tidyr::separate_longer_position()`](https://tidyr.tidyverse.org/reference/separate_longer_delim.html).
  ([\#57](https://github.com/etiennebacher/tidypolars/issues/57),
  [\#285](https://github.com/etiennebacher/tidypolars/issues/285),
  [@Yousa-Mirage](https://github.com/Yousa-Mirage))

- New argument `.by` in
  [`fill()`](https://tidyr.tidyverse.org/reference/fill.html) (this was
  introduced in `tidyr` 1.3.2).
  ([\#283](https://github.com/etiennebacher/tidypolars/issues/283))

- `wday()` now supports arbitrary `week_start` values (1~7), allowing
  for custom week start days.
  ([\#292](https://github.com/etiennebacher/tidypolars/issues/292),
  [@Yousa-Mirage](https://github.com/Yousa-Mirage))

- Add support for argument `type` in `nchar`
  ([\#288](https://github.com/etiennebacher/tidypolars/issues/288)).

- It is now possible to use translated functions without loading the
  package they come from. For example, the following code can run
  without loading `stringr` in the session:

  ``` r
  data |>
    mutate(y = .tp$str_extract_stringr(x, "\\d+"))
  ```

  This can be useful to benefit from `polars` speed while using the
  interface of `tidyverse` functions, without adding additional
  `tidyverse` dependencies. This may be useful to avoid installing extra
  dependencies, but it is not the recommended usage because it makes it
  harder to convert `tidypolars` code to run with other
  `tidyverse`-based backends. More information with
  [`?.tp`](https://tidypolars.etiennebacher.com/reference/dot-tp.md)
  ([\#293](https://github.com/etiennebacher/tidypolars/issues/293)).

- New argument `mkdir` in
  [`write_parquet_polars()`](https://tidypolars.etiennebacher.com/reference/write_parquet_polars.md)
  (this already existed in
  [`sink_parquet()`](https://tidypolars.etiennebacher.com/reference/sink_parquet.md)).
  ([\#298](https://github.com/etiennebacher/tidypolars/issues/298))

- New (experimental) function
  [`partition_by()`](https://tidypolars.etiennebacher.com/reference/partitioned_output.md)
  to write partitioned output in `sink_*()` and `write_*_polars()`. The
  following functions are deprecated and will be removed in a future
  release
  ([\#299](https://github.com/etiennebacher/tidypolars/issues/299)):

  - [`partition_by_key()`](https://tidypolars.etiennebacher.com/reference/partitioned_output.md)
    can be replaced with `partition_by(key =)`
  - [`partition_by_max_size()`](https://tidypolars.etiennebacher.com/reference/partitioned_output.md)
    can be replaced with `partition_by(max_rows_per_file =)`

### Changes

- [`collect()`](https://dplyr.tidyverse.org/reference/compute.html) now
  returns a `tibble` instead of a `data.frame`, for consistency with
  other
  [`collect()`](https://dplyr.tidyverse.org/reference/compute.html)
  methods
  ([\#273](https://github.com/etiennebacher/tidypolars/issues/273)).

### Bug fixes

- [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) now
  works with literal values, such as `arrange(x, 1:2)`
  ([\#296](https://github.com/etiennebacher/tidypolars/issues/296)).

### Documentation

- Removed the “FAQ” vignette, which was outdated and wasn’t particularly
  helpful.

## tidypolars 0.15.1

`tidypolars` requires `polars` \>= 1.6.0.

## tidypolars 0.15.0

### Breaking changes

- For consistency with `dplyr`,
  [`distinct()`](https://dplyr.tidyverse.org/reference/distinct.html)
  now only keeps the selected columns. To keep all columns, use
  `.keep_all = TRUE`
  ([\#227](https://github.com/etiennebacher/tidypolars/issues/227),
  [@ppanko](https://github.com/ppanko)).

### New features

- New argument `mkdir` in all `sink_*()` functions to recursively create
  the folder(s) specified in the path(s) to files
  ([\#236](https://github.com/etiennebacher/tidypolars/issues/236)).

- New functions
  [`partition_by_key()`](https://tidypolars.etiennebacher.com/reference/partitioned_output.md)
  and
  [`partition_by_max_size()`](https://tidypolars.etiennebacher.com/reference/partitioned_output.md)
  that can be used in the `path` argument of `sink_*()` functions. Those
  enable writing a LazyFrame to several files as partitioned output. See
  more details in `?sink_parquet()`
  ([\#237](https://github.com/etiennebacher/tidypolars/issues/237)).

- [`bind_cols_polars()`](https://tidypolars.etiennebacher.com/reference/bind_cols_polars.md)
  now works with more than two LazyFrames
  ([\#244](https://github.com/etiennebacher/tidypolars/issues/244)).

- Add support for [`gsub()`](https://rdrr.io/r/base/grep.html)
  ([\#250](https://github.com/etiennebacher/tidypolars/issues/250)).

- Add partial support for
  [`stringr::str_equal()`](https://stringr.tidyverse.org/reference/str_equal.html)
  ([\#228](https://github.com/etiennebacher/tidypolars/issues/228)).

- Add support for `lubridate` functions `rollbackward()`, `rollback()`,
  and `rollforward()`
  ([\#252](https://github.com/etiennebacher/tidypolars/issues/252)).

- Support
  [`stringr::fixed()`](https://stringr.tidyverse.org/reference/modifiers.html)
  in more `stringr` functions
  ([\#250](https://github.com/etiennebacher/tidypolars/issues/250)).

- Add support for argument `ignore.case` in
  [`grepl()`](https://rdrr.io/r/base/grep.html)
  ([\#251](https://github.com/etiennebacher/tidypolars/issues/251)).

- Add support for argument `.keep_all` in
  [`distinct()`](https://dplyr.tidyverse.org/reference/distinct.html)
  ([\#227](https://github.com/etiennebacher/tidypolars/issues/227),
  [@ppanko](https://github.com/ppanko)).

### Bug fixes

- Better error message in
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
  for unsupported argument `.drop`
  ([\#230](https://github.com/etiennebacher/tidypolars/issues/230)).

- Better error message in
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
  when passing named expressions in `...`. `dplyr` supports those but it
  is more and more recommended to use the `.by` / `by` argument in
  individual functions rather than using
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
  and [`ungroup()`](https://dplyr.tidyverse.org/reference/group_by.html)
  ([\#238](https://github.com/etiennebacher/tidypolars/issues/238)).

- Better error message in
  [`count()`](https://dplyr.tidyverse.org/reference/count.html) when
  passing named expressions in `...`
  ([\#239](https://github.com/etiennebacher/tidypolars/issues/239)).

- Fix bug in `join_where()` when all common column names between two
  DataFrames are used in the join conditions
  ([\#254](https://github.com/etiennebacher/tidypolars/issues/254)).

- Using `%in%` with `NA` now retains the `NA` in the data. Using
  `%in% NA` will error
  ([\#256](https://github.com/etiennebacher/tidypolars/issues/256)).

- Remove occasional deprecation message coming from Polars when using
  `%in%`
  ([\#259](https://github.com/etiennebacher/tidypolars/issues/259),
  [@ppanko](https://github.com/ppanko)).

- Better handling of functions prefixed with `<pkg>::`
  ([\#261](https://github.com/etiennebacher/tidypolars/issues/261)).

- Fix wrong behavior of [`paste()`](https://rdrr.io/r/base/paste.html)
  and [`paste0()`](https://rdrr.io/r/base/paste.html) with `collapse`
  ([\#263](https://github.com/etiennebacher/tidypolars/issues/263)).

### Documentation

- New vignette “How to benchmark tidypolars”
  ([\#232](https://github.com/etiennebacher/tidypolars/issues/232)).

- Better documentation for all `read_*()` and `scan_*()` functions
  ([\#241](https://github.com/etiennebacher/tidypolars/issues/241)).

## tidypolars 0.14.1

- `tidypolars` requires `polars` \>= 1.1.0
  ([\#222](https://github.com/etiennebacher/tidypolars/issues/222)).

### Bug fixes

- Fix a corner case when
  [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) was
  used in a custom function with missing arguments
  ([\#220](https://github.com/etiennebacher/tidypolars/issues/220)).

- In [`grepl()`](https://rdrr.io/r/base/grep.html), the argument `fixed`
  is now used correctly (thanks
  [@gernophil](https://github.com/gernophil) for the report,
  [\#223](https://github.com/etiennebacher/tidypolars/issues/223)).

- [`if_else()`](https://dplyr.tidyverse.org/reference/if_else.html) and
  [`ifelse()`](https://rdrr.io/r/base/ifelse.html) now work when using
  named arguments
  ([\#224](https://github.com/etiennebacher/tidypolars/issues/224)).

## tidypolars 0.14.0

- `tidypolars` requires `polars` \>= 1.0.0. This release of `polars`
  contains many breaking changes. Those should be invisible to
  `tidypolars` users, with the exception of deprecation messages (see
  below). However, if your code contains user-defined functions that use
  `polars` syntax, you may need to revise those
  ([\#194](https://github.com/etiennebacher/tidypolars/issues/194)).

### Deprecations and breaking changes

- The following arguments are deprecated and will be removed in a future
  version. The recommended replacement is indicated on the right of the
  arrow
  ([\#194](https://github.com/etiennebacher/tidypolars/issues/194)):

  - in [`compute()`](https://dplyr.tidyverse.org/reference/compute.html)
    and
    [`collect()`](https://dplyr.tidyverse.org/reference/compute.html):
    `streaming` -\> `engine`;
  - in
    [`read_csv_polars()`](https://tidypolars.etiennebacher.com/reference/from_csv.md)
    and
    [`scan_csv_polars()`](https://tidypolars.etiennebacher.com/reference/from_csv.md):
    - `dtypes` -\> `schema_overrides`
    - `reuse_downloaded` -\> no replacement
  - in `read_ndjson_polars` and
    [`scan_ndjson_polars()`](https://tidypolars.etiennebacher.com/reference/from_ndjson.md):
    - `reuse_downloaded` -\> no replacement
  - in `read_ipc_polars` and
    [`scan_ipc_polars()`](https://tidypolars.etiennebacher.com/reference/from_ipc.md):
    - `memory_map` -\> no replacement
  - in
    [`write_csv_polars()`](https://tidypolars.etiennebacher.com/reference/write_csv_polars.md)
    and
    [`sink_csv()`](https://tidypolars.etiennebacher.com/reference/sink_csv.md):
    - `null_values` -\> `null_value`
    - `quote` -\> `quote_char`
  - in
    [`write_ndjson_polars()`](https://tidypolars.etiennebacher.com/reference/write_ndjson_polars.md):
    - `pretty` -\> no replacement
    - `row_oriented` -\> no replacement
  - in
    [`write_ipc_polars()`](https://tidypolars.etiennebacher.com/reference/write_ipc_polars.md):
    - `future` -\> `compat_level`

- [`fetch()`](https://tidypolars.etiennebacher.com/reference/fetch.md)
  is deprecated, use [`head()`](https://rdrr.io/r/utils/head.html)
  before
  [`collect()`](https://dplyr.tidyverse.org/reference/compute.html)
  instead
  ([\#194](https://github.com/etiennebacher/tidypolars/issues/194)).

- [`group_keys()`](https://dplyr.tidyverse.org/reference/group_data.html)
  now returns a `tibble` and not a `data.frame` anymore
  ([\#194](https://github.com/etiennebacher/tidypolars/issues/194)).

- [`lubridate::make_date()`](https://lubridate.tidyverse.org/reference/make_datetime.html),
  [`lubridate::make_datetime()`](https://lubridate.tidyverse.org/reference/make_datetime.html),
  and [`ISOdatetime()`](https://rdrr.io/r/base/ISOdatetime.html) now
  error if some components go over their expected range,
  e.g. `month = 20` or `hour = 25`. Before, those functions were
  returning `NA` in this situation
  ([\#194](https://github.com/etiennebacher/tidypolars/issues/194)).

- [`summary()`](https://rdrr.io/r/base/summary.html) returns an
  additional row for the 50% percentile
  ([\#194](https://github.com/etiennebacher/tidypolars/issues/194)).

### New features

- Added support for various `lubridate` functions:

  - `force_tz()` and `with_tz()`
    ([@atsyplenkov](https://github.com/atsyplenkov),
    [\#170](https://github.com/etiennebacher/tidypolars/issues/170));
  - [`date()`](https://rdrr.io/r/base/date.html)
    ([@atsyplenkov](https://github.com/atsyplenkov),
    [\#181](https://github.com/etiennebacher/tidypolars/issues/181));
  - `today()` and `now()`
    ([\#183](https://github.com/etiennebacher/tidypolars/issues/183));
  - `weeks()`, `days()`, `hours()`, `minutes()`, `seconds()`,
    `milliseconds()`, `microseconds()`, `nanoseconds()`
    ([\#184](https://github.com/etiennebacher/tidypolars/issues/184)).

- `tidypolars` can now use expressions that contain non-translated
  functions if those expressions do not use columns from the data.

  Example:

  ``` r
  dat <- pl$DataFrame(foo = c(2, 1, 2))
  a <- c("d", "e", "f")
  dat |>
    filter(foo >= agrep("a", a))
  ```

  [`agrep()`](https://rdrr.io/r/base/agrep.html) is not a translated
  function so this used to error:

      Error in `filter()`:
      ! `tidypolars` doesn't know how to translate this function: `agrep()`.

  However, we see that `agrep("a", a)` doesn’t use any column but
  instead an object in the environment so it can be evaluated without
  caring whether `tidypolars` knows this function or not:

      shape: (1, 1)
      ┌─────┐
      │ foo │
      │ --- │
      │ f64 │
      ╞═════╡
      │ 2.0 │
      └─────┘

  Note that this is evaluated before running `polars` in the background
  so this expression can’t benefit from `polars` parallel evaluation for
  instance. Thanks [@mgacc0](https://github.com/mgacc0) for the
  suggestion.

- Add support for [`as.Date()`](https://rdrr.io/r/base/as.Date.html) for
  character columns
  ([\#190](https://github.com/etiennebacher/tidypolars/issues/190)).

- Error messages due to untranslated functions now suggest opening an
  issue to ask for their translation
  ([\#197](https://github.com/etiennebacher/tidypolars/issues/197)).

- Add support for `%>%` in expressions
  ([\#200](https://github.com/etiennebacher/tidypolars/issues/200)).

- Add support for
  [`dplyr::tally()`](https://dplyr.tidyverse.org/reference/count.html)
  ([\#203](https://github.com/etiennebacher/tidypolars/issues/203)).

- [`count()`](https://dplyr.tidyverse.org/reference/count.html) and
  [`add_count()`](https://dplyr.tidyverse.org/reference/count.html) now
  warn or error when argument `wt` is used since it is not supported.
  The behavior depends on the global option `tidypolars_unknown_args`
  ([\#204](https://github.com/etiennebacher/tidypolars/issues/204)).

- `tidypolars` has experimental support for fallback to R when a
  function is not internally translated to polars syntax. The default
  behavior is still to error, but the user can now set
  `options(tidypolars_fallback_to_r = TRUE)` to handle those unknown
  functions. See
  [`?tidypolars_options`](https://tidypolars.etiennebacher.com/reference/tidypolars_options.md)
  for details on the drawbacks of this approach
  ([\#205](https://github.com/etiennebacher/tidypolars/issues/205)).

- Large performance improvement when using selection helpers (such as
  [`contains()`](https://tidyselect.r-lib.org/reference/starts_with.html))
  on data with many columns
  ([\#211](https://github.com/etiennebacher/tidypolars/issues/211)).

- `tidypolars` now exports rules to be used with `flir` for detecting
  deprecated functions `describe_plan()` and
  `describe_optimized_plan()`. Those can be used in your project by
  following [this
  article](https://flir.etiennebacher.com/articles/sharing_rules#for-users).
  Note that this requires `flir` 0.5.0.9000 or higher
  ([\#214](https://github.com/etiennebacher/tidypolars/issues/214)).

### Bug fixes

- Fix behavior of
  [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) and
  [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
  when they don’t contain any expression
  ([\#191](https://github.com/etiennebacher/tidypolars/issues/191)).

- Fix error in
  [`count()`](https://dplyr.tidyverse.org/reference/count.html) when it
  includes grouping variables
  ([\#193](https://github.com/etiennebacher/tidypolars/issues/193)).

- Passing `.` in an anonymous function in
  [`across()`](https://dplyr.tidyverse.org/reference/across.html) now
  works
  ([\#216](https://github.com/etiennebacher/tidypolars/issues/216)).

## tidypolars 0.13.0

### New features

- Added support for
  [`stringr::str_replace_na()`](https://stringr.tidyverse.org/reference/str_replace_na.html)
  ([\#153](https://github.com/etiennebacher/tidypolars/issues/153)).

- Better checks for unknown and unsupported arguments in
  [`compute()`](https://dplyr.tidyverse.org/reference/compute.html),
  [`collect()`](https://dplyr.tidyverse.org/reference/compute.html),
  `*_join()`, `pivot_*()`, `sink_*()`,
  [`slice_sample()`](https://dplyr.tidyverse.org/reference/slice.html)
  and
  [`uncount()`](https://tidyr.tidyverse.org/reference/uncount.html)([\#158](https://github.com/etiennebacher/tidypolars/issues/158),
  thanks [@fkohrt](https://github.com/fkohrt) for the report). Now, when
  those functions receive:

  - an argument that exists in the `tidyverse` implementation but not
    supported by `tidypolars`, they warn the user. This default
    behaviour can be changed to error instead with
    `options(tidypolars_unknown_args = "error")`.
  - an argument that doesn’t exist at all, they error.

- Add support for argument `explicit` in
  [`tidyr::complete()`](https://tidyr.tidyverse.org/reference/complete.html).

- Add option to keep track of filenames in
  [`scan_csv_polars()`](https://tidypolars.etiennebacher.com/reference/from_csv.md)
  ([\#171](https://github.com/etiennebacher/tidypolars/issues/171),
  [@ginolhac](https://github.com/ginolhac)).

- Add partial support for [`seq()`](https://rdrr.io/r/base/seq.html)
  (argument `length.out` is not supported) and
  [`seq_len()`](https://rdrr.io/r/base/seq.html).

- [`complete()`](https://tidyr.tidyverse.org/reference/complete.html)
  now accepts named elements, e.g. `complete(df, group, value = 1:4)`
  ([\#176](https://github.com/etiennebacher/tidypolars/issues/176)).

- Add support for several `lubridate` functions:

  - `am()`, `pm()`, `leap_year()`, `days_in_month()`
    ([\#178](https://github.com/etiennebacher/tidypolars/issues/178));

### Bug fixes

- Fix edge cases in the `tidypolars` implementation of
  [`stringr::str_sub()`](https://stringr.tidyverse.org/reference/str_sub.html)
  and [`substr()`](https://rdrr.io/r/base/substr.html) compared to their
  original implementation
  ([\#159](https://github.com/etiennebacher/tidypolars/issues/159)).

- [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) now
  places `NA` values last, like `dplyr`.

## tidypolars 0.12.0

`tidypolars` requires `polars` \>= 0.21.0.

### Breaking changes

- [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
  now drops the last group of the output by default (for consistency
  with `dplyr`). Previously it kept the same groups as in the input data
  ([\#149](https://github.com/etiennebacher/tidypolars/issues/149)).

### New features

- Add support for argument `.groups` in
  [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html).
  Value `"rowwise"` is not supported for now
  ([\#149](https://github.com/etiennebacher/tidypolars/issues/149)).

- Added support for
  [`dplyr::lead()`](https://dplyr.tidyverse.org/reference/lead-lag.html).
  In
  [`dplyr::lead()`](https://dplyr.tidyverse.org/reference/lead-lag.html)
  and
  [`dplyr::lag()`](https://dplyr.tidyverse.org/reference/lead-lag.html),
  the arguments `default` and `order_by` are now supported
  ([\#151](https://github.com/etiennebacher/tidypolars/issues/151)).

## tidypolars 0.11.0

`tidypolars` requires `polars` \>= 0.20.0.

### Breaking changes

- [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) now
  errors with unknown variable names (like
  [`dplyr::arrange()`](https://dplyr.tidyverse.org/reference/arrange.html)).
  Previously, unknown variables were silently ignored. Using expressions
  (like `a + b`) is now accepted
  ([\#144](https://github.com/etiennebacher/tidypolars/issues/144)).

- The parameter `inherit_optimization` is removed from all `sink_*()`
  functions.

### New features

- The power operators `^` and `**` now work.

- New function
  [`sink_ndjson()`](https://tidypolars.etiennebacher.com/reference/sink_ndjson.md)
  to write the results of a lazy query to a NDJSON file without
  collecting it in memory.

- [`inner_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html)
  now accepts inequality joins in the `by` argument, including the
  following helpers:
  [`between()`](https://dplyr.tidyverse.org/reference/between.html),
  `overlaps()`, [`within()`](https://rdrr.io/r/base/with.html)
  ([\#148](https://github.com/etiennebacher/tidypolars/issues/148)).

### Bug fixes

- Using an external object in
  [`case_when()`](https://dplyr.tidyverse.org/reference/case-and-replace-when.html),
  [`ifelse()`](https://rdrr.io/r/base/ifelse.html) and
  [`ifelse()`](https://rdrr.io/r/base/ifelse.html) now works.

- [`str_sub()`](https://stringr.tidyverse.org/reference/str_sub.html)
  doesn’t error anymore when `start` is positive and `end` is negative.

- `read_*_polars()` functions used to return a standard `data.frame` by
  mistake. They now return a Polars DataFrame.

- Using `[` for subsetting in expressions now works. Thanks
  [@ginolhac](https://github.com/ginolhac) for the report
  ([\#141](https://github.com/etiennebacher/tidypolars/issues/141)).

- [`bind_cols_polars()`](https://tidypolars.etiennebacher.com/reference/bind_cols_polars.md)
  and
  [`bind_rows_polars()`](https://tidypolars.etiennebacher.com/reference/bind_rows_polars.md)
  now error (as expected before) if elements are a mix of Polars
  DataFrames and LazyFrames.

## tidypolars 0.10.1

### Bug fixes

- Do not error when handling columns with datatype `Null`. Note that
  converting those columns to R with
  [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html),
  [`as_tibble()`](https://tibble.tidyverse.org/reference/as_tibble.html),
  or [`collect()`](https://dplyr.tidyverse.org/reference/compute.html)
  is still an issue as of `polars` 0.19.1.

## tidypolars 0.10.0

`tidypolars` requires `polars` \>= 0.19.1.

### Breaking changes and deprecations

- `describe()` is deprecated as of tidypolars 0.10.0 and will be removed
  in a future update. Use
  [`summary()`](https://rdrr.io/r/base/summary.html) with the same
  arguments instead
  ([\#127](https://github.com/etiennebacher/tidypolars/issues/127)).

- `describe_plan()` and `describe_optimized_plan()` are deprecated as of
  tidypolars 0.10.0 and will be removed in a future update. Use
  [`explain()`](https://dplyr.tidyverse.org/reference/explain.html) with
  `optimized = TRUE/FALSE` instead
  ([\#128](https://github.com/etiennebacher/tidypolars/issues/128)).

- In
  [`sink_parquet()`](https://tidypolars.etiennebacher.com/reference/sink_parquet.md)
  and
  [`sink_csv()`](https://tidypolars.etiennebacher.com/reference/sink_csv.md),
  all arguments except for `.data` and `path` must be named
  ([\#136](https://github.com/etiennebacher/tidypolars/issues/136)).

### New features

- Add support for more functions:

  - from package `base`:
    [`substr()`](https://rdrr.io/r/base/substr.html).

- Better error message when a function can come from several packages
  but only one version is translated
  ([\#130](https://github.com/etiennebacher/tidypolars/issues/130)).

- [`row_number()`](https://dplyr.tidyverse.org/reference/row_number.html)
  now works without argument
  ([\#131](https://github.com/etiennebacher/tidypolars/issues/131)).

- New functions to import data as Polars DataFrames and LazyFrames
  ([\#136](https://github.com/etiennebacher/tidypolars/issues/136)):

  - `read_<format>_polars()` to import data as a Polars DataFrame;
  - `scan_<format>_polars()` to import data as a Polars LazyFrame;
  - `<format>` can be “csv”, “ipc”, “json”, “parquet”.

  Those can replace functions from `polars`. For example,
  `polars::pl$read_parquet(...)` can be replaced by
  `read_parquet_polars(...)`.

- New functions to write Polars DataFrames to external files:
  `write_<format>_polars()` where `<format>` can be “csv”, “ipc”,
  “json”, “ndjson”, “parquet”
  ([\#136](https://github.com/etiennebacher/tidypolars/issues/136)).

- New function
  [`sink_ipc()`](https://tidypolars.etiennebacher.com/reference/sink_ipc.md)
  that is similar to
  [`sink_parquet()`](https://tidypolars.etiennebacher.com/reference/sink_parquet.md)
  and
  [`sink_csv()`](https://tidypolars.etiennebacher.com/reference/sink_csv.md)
  but for IPC files
  ([\#136](https://github.com/etiennebacher/tidypolars/issues/136)).

- [`across()`](https://dplyr.tidyverse.org/reference/across.html) now
  throws a better error message when the user passes an external list to
  `.fns`. This works with `dplyr` but cannot work with `tidypolars`
  ([\#135](https://github.com/etiennebacher/tidypolars/issues/135)).

- Added support for argument `.add` in
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html).

### Bug fixes

- [`stringr::str_sub()`](https://stringr.tidyverse.org/reference/str_sub.html)
  now works when both `start` and `end` are negative.

- Fixed a bug in
  [`str_sub()`](https://stringr.tidyverse.org/reference/str_sub.html)
  when `start` was greater than 1.

- [`stringr::str_starts()`](https://stringr.tidyverse.org/reference/str_starts.html)
  and
  [`stringr::str_ends()`](https://stringr.tidyverse.org/reference/str_starts.html)
  now work with a regex.

- [`fill()`](https://tidyr.tidyverse.org/reference/fill.html) doesn’t
  error anymore when `...` is empty. Instead, it returns the input data.

- [`unite()`](https://tidyr.tidyverse.org/reference/unite.html) now
  provides a proper error message when `col` is missing.

- [`unite()`](https://tidyr.tidyverse.org/reference/unite.html) doesn’t
  error anymore when `...` is empty. Instead, it uses all variables in
  the dataset.

- [`filter()`](https://dplyr.tidyverse.org/reference/filter.html),
  [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) and
  [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
  now work when using a column from another data.frame, e.g.

  ``` r
  my_polars_df |>
    filter(x %in% some_data_frame$y)
  ```

- [`replace_na()`](https://tidyr.tidyverse.org/reference/replace_na.html)
  no longer converts the column to the datatype of the replacement,
  e.g. `data |> replace_na("a")` will error if the input data is
  numeric.

- [`n_distinct()`](https://dplyr.tidyverse.org/reference/n_distinct.html)
  now correctly applies the `na.rm` argument when several columns are
  passed as input
  ([\#137](https://github.com/etiennebacher/tidypolars/issues/137)).

## tidypolars 0.9.0

`tidypolars` requires `polars` \>= 0.18.0.

### New features

- Add support for several functions:

  - from package `base`: `%%` and `%/%`.

  - from package `dplyr`:
    [`dense_rank()`](https://dplyr.tidyverse.org/reference/row_number.html),
    [`row_number()`](https://dplyr.tidyverse.org/reference/row_number.html).

  - from package `lubridate`: `wday()`.

- Better handling of missing values to match `R` behavior. In the
  following functions, if there is at least one missing value and
  `na.rm = FALSE` (the default), then the output will be `NA`:
  [`max()`](https://rdrr.io/r/base/Extremes.html),
  [`mean()`](https://rdrr.io/r/base/mean.html),
  [`median()`](https://rdrr.io/r/stats/median.html),
  [`min()`](https://rdrr.io/r/base/Extremes.html),
  [`sd()`](https://rdrr.io/r/stats/sd.html),
  [`sum()`](https://rdrr.io/r/base/sum.html),
  [`var()`](https://rdrr.io/r/stats/cor.html)
  ([\#120](https://github.com/etiennebacher/tidypolars/issues/120)).

- New argument `cluster_with_columns` in
  [`collect()`](https://dplyr.tidyverse.org/reference/compute.html),
  [`compute()`](https://dplyr.tidyverse.org/reference/compute.html), and
  [`fetch()`](https://tidypolars.etiennebacher.com/reference/fetch.md).

- Add a global option `tidypolars_unknown_args` to control what happens
  when `tidypolars` doesn’t know how to handle an argument in a
  function. The default is to warn and the only other accepted value is
  `"error"`.

### Bug fixes

- [`count()`](https://dplyr.tidyverse.org/reference/count.html) and
  [`add_count()`](https://dplyr.tidyverse.org/reference/count.html) no
  longer overwrite a variable named `n` if the argument `name` is
  unspecified.

## tidypolars 0.8.0

`tidypolars` requires `polars` \>= 0.17.0.

### Breaking changes

- As announced in `tidypolars` 0.7.0, the behavior of
  [`collect()`](https://dplyr.tidyverse.org/reference/compute.html) has
  changed. It now returns a standard R `data.frame` and not a Polars
  `DataFrame` anymore. Replace
  [`collect()`](https://dplyr.tidyverse.org/reference/compute.html) by
  [`compute()`](https://dplyr.tidyverse.org/reference/compute.html)
  (with the same arguments) to keep the old behavior.

- In
  [`bind_rows_polars()`](https://tidypolars.etiennebacher.com/reference/bind_rows_polars.md),
  if `.id` is passed, the resulting column now is of type character
  instead of integer.

### New features

- Add support for several functions:

  - from package `base`: [`all()`](https://rdrr.io/r/base/all.html),
    [`any()`](https://rdrr.io/r/base/any.html),
    [`diff()`](https://rdrr.io/r/base/diff.html),
    [`ISOdatetime()`](https://rdrr.io/r/base/ISOdatetime.html),
    [`length()`](https://rdrr.io/r/base/length.html),
    [`rev()`](https://rdrr.io/r/base/rev.html),
    [`unique()`](https://rdrr.io/r/base/unique.html).

  - from package `dplyr`:
    [`consecutive_id()`](https://dplyr.tidyverse.org/reference/consecutive_id.html),
    [`min_rank()`](https://dplyr.tidyverse.org/reference/row_number.html),
    [`na_if()`](https://dplyr.tidyverse.org/reference/na_if.html),
    [`n_distinct()`](https://dplyr.tidyverse.org/reference/n_distinct.html),
    [`nth()`](https://dplyr.tidyverse.org/reference/nth.html).

  - from package `lubridate`: `make_datetime()`.

  - from package `stringr`:
    [`str_dup()`](https://stringr.tidyverse.org/reference/str_dup.html),
    [`str_split()`](https://stringr.tidyverse.org/reference/str_split.html),
    [`str_split_i()`](https://stringr.tidyverse.org/reference/str_split.html),
    [`str_trunc()`](https://stringr.tidyverse.org/reference/str_trunc.html).

  - from package `tidyr`:
    [`replace_na()`](https://tidyr.tidyverse.org/reference/replace_na.html)
    (the data.frame method was already translated but not the vector one
    that can be used in
    [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) for
    example).

- It is now possible to use explicit namespaces (such as
  [`dplyr::first()`](https://dplyr.tidyverse.org/reference/nth.html)
  instead of
  [`first()`](https://dplyr.tidyverse.org/reference/nth.html)) in
  [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html),
  [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
  and [`filter()`](https://dplyr.tidyverse.org/reference/filter.html)
  ([\#114](https://github.com/etiennebacher/tidypolars/issues/114)).

- In
  [`bind_rows_polars()`](https://tidypolars.etiennebacher.com/reference/bind_rows_polars.md),
  if all elements are named and `.id` is specified, the `.id` column
  will use the names of the elements
  ([\#116](https://github.com/etiennebacher/tidypolars/issues/116)).

- It is now possible to rename variables in
  [`select()`](https://dplyr.tidyverse.org/reference/select.html)
  ([\#117](https://github.com/etiennebacher/tidypolars/issues/117)).

- Add support for argument `na_matches` in all join functions (except
  [`cross_join()`](https://dplyr.tidyverse.org/reference/cross_join.html)
  that doesn’t need it)
  ([\#109](https://github.com/etiennebacher/tidypolars/issues/109)).

### Bug fixes

- Local variables in custom functions could not be used in tidypolars
  functions (reported in a blog post of Art Steinmetz). This is now
  fixed.

- [`across()`](https://dplyr.tidyverse.org/reference/across.html) now
  works when `.cols` contains only one variable and `.fns` contains only
  one function.

- In [`across()`](https://dplyr.tidyverse.org/reference/across.html),
  the `.cols` argument now takes into account variables created in the
  same [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html)
  or
  [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
  call before
  [`across()`](https://dplyr.tidyverse.org/reference/across.html).

  ``` r
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

  Note that the
  [`where()`](https://tidyselect.r-lib.org/reference/where.html)
  function is not supported here. For example:

  ``` r
  as_polars_df(mtcars) |>
    mutate(
      foo = 1,
      across(.cols = where(is.numeric), \(x) x - 1)
    )
  ```

  will *not* return 0 for the variable `foo`. A warning is emitted about
  this behavior.

- Better handling of negative values in
  [`c()`](https://rdrr.io/r/base/c.html) when called in
  [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) and
  [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html).

## tidypolars 0.7.0

`tidypolars` requires `polars` \>= 0.16.0.

### Breaking changes and deprecations

- `as_polars()` is now removed. It was deprecated in 0.6.0. Use
  [`as_polars_df()`](https://pola-rs.github.io/r-polars/man/as_polars_df.html)
  or
  [`as_polars_lf()`](https://pola-rs.github.io/r-polars/man/as_polars_lf.html)
  instead.

- `to_r()` is now removed. It was deprecated in 0.6.0. Use
  [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html) or
  [`as_tibble()`](https://tibble.tidyverse.org/reference/as_tibble.html)
  instead.

- For consistency with `dplyr`, the behavior of
  [`collect()`](https://dplyr.tidyverse.org/reference/compute.html) will
  change in 0.8.0 as it will perform the lazy query **and** convert the
  result to a standard `data.frame`. For now,
  [`collect()`](https://dplyr.tidyverse.org/reference/compute.html) only
  throws a warning about this future change. It is recommended to use
  [`compute()`](https://dplyr.tidyverse.org/reference/compute.html) to
  only perform the query and get a Polars DataFrame as output
  ([\#101](https://github.com/etiennebacher/tidypolars/issues/101)).

### New features

- Several improvements and changes for
  [`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html)
  ([\#95](https://github.com/etiennebacher/tidypolars/issues/95)):

  - `names_from` can now takes several variables;
  - add support for `id_cols` and `names_glue`;
  - default value of `names_sep` now is `_`, for consistency with
    `tidyr`;
  - fix documentation as
    [`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html)
    doesn’t work on LazyFrame.

- Add support for
  [`stringr::regex()`](https://stringr.tidyverse.org/reference/modifiers.html).
  Note that only the argument `ignore_case` is supported for now
  ([\#97](https://github.com/etiennebacher/tidypolars/issues/97)).

- Add support for several `lubridate` functions: `dweeks()`, `ddays()`,
  `dhours()`, `dminutes()`, `dseconds()`, `dmilliseconds()`,
  `make_date()`
  ([\#107](https://github.com/etiennebacher/tidypolars/issues/107)).

- When a `polars` function called internally fails, the original error
  message is now displayed.

- Add support for
  [`group_split()`](https://dplyr.tidyverse.org/reference/group_split.html)
  (for `DataFrame` only).

- Add support for argument `relationship` in
  [`left_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html),
  [`right_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html),
  [`full_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html)
  and
  [`inner_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html)
  ([\#106](https://github.com/etiennebacher/tidypolars/issues/106)).

## tidypolars 0.6.0

`tidypolars` requires `polars` \>= 0.15.0.

### Breaking changes and deprecations

- `as_polars()` is deprecated and will be removed in 0.7.0. Use
  [`as_polars_lf()`](https://pola-rs.github.io/r-polars/man/as_polars_lf.html)
  or
  [`as_polars_df()`](https://pola-rs.github.io/r-polars/man/as_polars_df.html)
  instead.

- `as_polars()` doesn’t have an argument `with_string_cache` anymore.
  When set to `TRUE`, this enabled the string cache globally, which
  could lead to undesirable side effects.

- `to_r()` is deprecated and will be removed in 0.7.0. Use
  [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html) or
  [`as_tibble()`](https://tibble.tidyverse.org/reference/as_tibble.html)
  instead. This used to silently return a `LazyFrame` if the input was
  `LazyFrame`. It now automatically collects the `LazyFrame`
  ([\#88](https://github.com/etiennebacher/tidypolars/issues/88)).

- [`pull()`](https://dplyr.tidyverse.org/reference/pull.html) nows
  automatically collects input `LazyFrame`
  ([\#89](https://github.com/etiennebacher/tidypolars/issues/89)).

### New features

- Add support for argument `.keep` in
  [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html)
  ([\#80](https://github.com/etiennebacher/tidypolars/issues/80)).

- Add support for
  [`group_vars()`](https://dplyr.tidyverse.org/reference/group_data.html)
  and
  [`group_keys()`](https://dplyr.tidyverse.org/reference/group_data.html)
  ([\#81](https://github.com/etiennebacher/tidypolars/issues/81)).

- **Experimental** support of
  [`rowwise()`](https://dplyr.tidyverse.org/reference/rowwise.html). For
  now, this is limited to a few functions:
  [`mean()`](https://rdrr.io/r/base/mean.html),
  [`median()`](https://rdrr.io/r/stats/median.html),
  [`min()`](https://rdrr.io/r/base/Extremes.html),
  [`max()`](https://rdrr.io/r/base/Extremes.html),
  [`sum()`](https://rdrr.io/r/base/sum.html),
  [`all()`](https://rdrr.io/r/base/all.html),
  [`any()`](https://rdrr.io/r/base/any.html).
  [`rowwise()`](https://dplyr.tidyverse.org/reference/rowwise.html) and
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
  cannot be used at the same time
  ([\#40](https://github.com/etiennebacher/tidypolars/issues/40)).

- All functions that return a polars `Data/LazyFrame` now add the class
  `"tidypolars"` to the output
  ([\#86](https://github.com/etiennebacher/tidypolars/issues/86)).

- Support [`which.min()`](https://rdrr.io/r/base/which.min.html),
  [`which.max()`](https://rdrr.io/r/base/which.min.html),
  [`dplyr::n()`](https://dplyr.tidyverse.org/reference/context.html).

- Support `.data[[` and `.env[[` in addition to `.data$` and `.env$`.
  Better error messages when the objects specified in `.data` or `.env`
  don’t exist.

### Bug fixes

- [`pull()`](https://dplyr.tidyverse.org/reference/pull.html) now errors
  when `var` is of length \> 1.

## tidypolars 0.5.0

`tidypolars` requires `polars` \>= 0.12.0.

### Breaking changes

- [`across()`](https://dplyr.tidyverse.org/reference/across.html) now
  errors if the argument `.cols` is not provided (either named or
  unnamed). This behavior was deprecated in `dplyr` 1.1.0.

- It is no longer possible to use `!` in
  [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) to
  sort by decreasing order, for compatibility with
  [`dplyr::arrange()`](https://dplyr.tidyverse.org/reference/arrange.html).
  Use `-` or [`desc()`](https://dplyr.tidyverse.org/reference/desc.html)
  instead.

### New features

- [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
  now works on ungrouped data and returns a 1-row output.

- It is now possible to use `desc(x1)` in
  [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) to
  sort in decreasing order of `x1` (this is equivalent to `-x1`).

- Add support for argument `names_prefix` in
  [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html).

- Add support for arguments `names_prefix` and `names_sep` in
  [`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html).

- Add support for
  [`tidyr::uncount()`](https://tidyr.tidyverse.org/reference/uncount.html).

- All `*_join()` functions now work when `by` is a specification created
  by
  [`dplyr::join_by()`](https://dplyr.tidyverse.org/reference/join_by.html).
  Notice that this is limited to equality joins for now.

- You can now use the “embrace” operator `{{ }}` to pass unquoted column
  names (among other things) as arguments of custom functions. See the
  [“Programming with dplyr”
  vignette](https://dplyr.tidyverse.org/dev/articles/programming.html)
  for some examples.

- [`bind_cols_polars()`](https://tidypolars.etiennebacher.com/reference/bind_cols_polars.md)
  now works with two `LazyFrame`s, but not more.

- Add support for argument `.name_repair` in
  [`bind_cols_polars()`](https://tidypolars.etiennebacher.com/reference/bind_cols_polars.md)
  ([\#74](https://github.com/etiennebacher/tidypolars/issues/74)).

- Support for `.env$` and `.data$` pronouns in expressions of
  [`filter()`](https://dplyr.tidyverse.org/reference/filter.html),
  [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) and
  [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html).

- Support named vector in the argument `pattern` of
  [`str_replace_all()`](https://stringr.tidyverse.org/reference/str_replace.html),
  where names are patterns and values are replacements.

- Using `%in%` for factor variables doesn’t require enabling the string
  cache anymore.

### Bug fixes

- [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
  no longer errors when `across(everything(), ...)` is used with `.by`.

- All `*_join()` functions no longer error when a named vector is
  provided in the argument `by`.

- Expressions with values only are not named “literal” anymore.

### Misc

- Simplify the procedure to support new functions.

## tidypolars 0.4.0

`tidypolars` requires `polars` \>= 0.11.0.

### Breaking changes

- It is no longer possible to pass a list in
  [`rename()`](https://dplyr.tidyverse.org/reference/rename.html).

### New features

- The argument `with_string_cache` in `as_polars()` now enables the
  string cache globally if set to `TRUE`
  ([\#54](https://github.com/etiennebacher/tidypolars/issues/54)).

- Better error message in
  [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) when
  comparing factors to strings while the string cache is disabled.

- Basic support for
  [`strptime()`](https://rdrr.io/r/base/strptime.html). It is possible
  to use `strptime(*, strict = FALSE)` to not error when the parsing of
  some characters fails.

- New argument `.by` in
  [`filter()`](https://dplyr.tidyverse.org/reference/filter.html),
  [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html), and
  [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html),
  and new argument `by` in the `slice_*()` functions. This allows to do
  operations on groups without using
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
  and
  [`ungroup()`](https://dplyr.tidyverse.org/reference/group_by.html).
  See the [`dplyr`
  vignette](https://dplyr.tidyverse.org/reference/dplyr_by.html) for
  more information
  ([\#59](https://github.com/etiennebacher/tidypolars/issues/59)).

- [`rename()`](https://dplyr.tidyverse.org/reference/rename.html) now
  accepts unquoted names both old and new names.

- Support fixed regexes in
  [`str_detect()`](https://stringr.tidyverse.org/reference/str_detect.html)
  (using
  [`fixed()`](https://stringr.tidyverse.org/reference/modifiers.html))
  and in [`grepl()`](https://rdrr.io/r/base/grep.html) (using
  `fixed = TRUE`).

### Bug fixes

- Improve robustness of sequential expressions in
  [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) and
  [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
  (i.e expressions that should be run one after the other because they
  depend on variables created in the same call)
  ([\#58](https://github.com/etiennebacher/tidypolars/issues/58)).

- [`relocate()`](https://dplyr.tidyverse.org/reference/relocate.html)
  now works correctly when `.after = last_col()`.

- All functions that work on grouped data now correctly restore the
  groups structure
  ([\#62](https://github.com/etiennebacher/tidypolars/issues/62)).

### Misc

- Error messages coming from
  [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html),
  [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html),
  and [`filter()`](https://dplyr.tidyverse.org/reference/filter.html)
  now give the right function call.

- Faster tidy selection
  ([\#61](https://github.com/etiennebacher/tidypolars/issues/61)).

## tidypolars 0.3.0

`tidypolars` requires `polars` \>= 0.10.0.

### Breaking changes

- All functions starting with `pl_` have been removed to the benefit of
  the S3 methods. For example, `pl_distinct()` doesn’t exist anymore so
  the only way to use it is to load `dplyr` and to use
  [`distinct()`](https://dplyr.tidyverse.org/reference/distinct.html) on
  a Polars DataFrame or LazyFrame. This is to avoid confusion about
  compatibility with `dplyr` and `tidyr`. See
  [\#49](https://github.com/etiennebacher/tidypolars/issues/49) for a
  more detailed explanation.

- `pl_bind_rows()` and `pl_bind_cols()` are renamed
  [`bind_rows_polars()`](https://tidypolars.etiennebacher.com/reference/bind_rows_polars.md)
  and
  [`bind_cols_polars()`](https://tidypolars.etiennebacher.com/reference/bind_cols_polars.md)
  respectively. This is because
  [`bind_rows()`](https://dplyr.tidyverse.org/reference/bind_rows.html)
  and
  [`bind_cols()`](https://dplyr.tidyverse.org/reference/bind_cols.html)
  are not S3 methods (this might change in future versions of `dplyr`).

### New features

- New function
  [`duplicated_rows()`](https://tidypolars.etiennebacher.com/reference/distinct.polars_data_frame.md)
  that is the opposite of
  [`distinct()`](https://dplyr.tidyverse.org/reference/distinct.html)
  ([\#50](https://github.com/etiennebacher/tidypolars/issues/50)).

- New argument `.id` in
  [`bind_rows_polars()`](https://tidypolars.etiennebacher.com/reference/bind_rows_polars.md).

- [`bind_rows_polars()`](https://tidypolars.etiennebacher.com/reference/bind_rows_polars.md)
  can now bind Data/LazyFrames that don’t have the same schema. Columns
  will be upcast to common types if necessary. Unknown columns will be
  filled with `NA`.

### Bug fixes

- [`complete()`](https://tidyr.tidyverse.org/reference/complete.html)
  now works correctly on grouped data.

### Misc

- `relig_income` and `fish_encounters` are not reexported anymore since
  `tidyr` is now imported.

## tidypolars 0.2.0

`tidypolars` requires `polars` \>= 0.9.0.

### New features

- Rename `pl_fetch()` to
  [`fetch()`](https://tidypolars.etiennebacher.com/reference/fetch.md).

- New functions supported: `describe()`,
  [`sink_csv()`](https://tidypolars.etiennebacher.com/reference/sink_csv.md),
  [`slice_sample()`](https://dplyr.tidyverse.org/reference/slice.html).

- New argument `fill` in `pl_complete()`.

- Support
  [`stringr::str_to_title()`](https://stringr.tidyverse.org/reference/case.html)
  and
  [`tools::toTitleCase()`](https://rdrr.io/r/tools/toTitleCase.html).

- Support
  [`stringr::fixed()`](https://stringr.tidyverse.org/reference/modifiers.html)
  to use literal strings.

- Support replacements with captured groups like `\\1` in
  [`stringr::str_replace()`](https://stringr.tidyverse.org/reference/str_replace.html)
  and
  [`stringr::str_replace_all()`](https://stringr.tidyverse.org/reference/str_replace.html).

### Bug fixes

- [`sink_parquet()`](https://tidypolars.etiennebacher.com/reference/sink_parquet.md)
  didn’t use the user inputs (apart from the `path`).

### Misc

- Clearer error message when an expression contains `<pkg>::`. This is
  not supported for now but could potentially be implemented later.

- `pl_colnames()` is no longer exported.

## tidypolars 0.1.0

### New features

- Support [`as.numeric()`](https://rdrr.io/r/base/numeric.html),
  [`as.character()`](https://rdrr.io/r/base/character.html),
  [`as.logical()`](https://rdrr.io/r/base/logical.html),
  [`grepl()`](https://rdrr.io/r/base/grep.html), and
  [`paste()`](https://rdrr.io/r/base/paste.html) in expressions in
  `pl_filter()`, `pl_mutate()` and `pl_summarize()`.

- Support
  [`sink_parquet()`](https://tidypolars.etiennebacher.com/reference/sink_parquet.md)
  ([\#38](https://github.com/etiennebacher/tidypolars/issues/38)).

- Support
  [`fetch()`](https://tidypolars.etiennebacher.com/reference/fetch.md)
  ([\#42](https://github.com/etiennebacher/tidypolars/issues/42)).

- Support for additional `stringr` functions:
  [`str_detect()`](https://stringr.tidyverse.org/reference/str_detect.html),
  [`str_extract_all()`](https://stringr.tidyverse.org/reference/str_extract.html),
  [`str_pad()`](https://stringr.tidyverse.org/reference/str_pad.html),
  [`str_squish()`](https://stringr.tidyverse.org/reference/str_trim.html),
  [`str_trim()`](https://stringr.tidyverse.org/reference/str_trim.html),
  [`word()`](https://stringr.tidyverse.org/reference/word.html) (some
  arguments or corner cases are not supported yet).

- Add all optimization parameters in
  [`collect()`](https://dplyr.tidyverse.org/reference/compute.html).

### Bug fixes

- Fix `pl_mutate()` and `pl_summarize()` when expressions use some
  variables previously created or modified
  ([\#10](https://github.com/etiennebacher/tidypolars/issues/10),
  [\#37](https://github.com/etiennebacher/tidypolars/issues/37)).

- Fix bug in `pl_filter()` when passing a vector in the RHS of `%in%`.

### Misc

- Improve the backend to translate R expressions into Polars
  expressions. This also led to a complete rewriting of the vignette “R
  and Polars expressions”
  ([\#27](https://github.com/etiennebacher/tidypolars/issues/27)).

- Error messages should now report the correct function call.

- Improve CI coverage
  ([\#35](https://github.com/etiennebacher/tidypolars/issues/35)).

## tidypolars 0.0.1

- First Github release.
