# Package index

## Import data

Functions to import data as Polars DataFrames (`read_` functions) and
LazyFrames (`scan_` functions).

- [`read_csv_polars()`](https://tidypolars.etiennebacher.com/reference/from_csv.md)
  [`scan_csv_polars()`](https://tidypolars.etiennebacher.com/reference/from_csv.md)
  : Import data from CSV file(s)
- [`read_ipc_polars()`](https://tidypolars.etiennebacher.com/reference/from_ipc.md)
  [`scan_ipc_polars()`](https://tidypolars.etiennebacher.com/reference/from_ipc.md)
  : Import data from IPC file(s)
- [`read_ndjson_polars()`](https://tidypolars.etiennebacher.com/reference/from_ndjson.md)
  [`scan_ndjson_polars()`](https://tidypolars.etiennebacher.com/reference/from_ndjson.md)
  : Import data from NDJSON file(s)
- [`read_parquet_polars()`](https://tidypolars.etiennebacher.com/reference/from_parquet.md)
  [`scan_parquet_polars()`](https://tidypolars.etiennebacher.com/reference/from_parquet.md)
  : Import data from Parquet file(s)

## Export data

Functions to export Polars DataFrames (`write_` functions) and
LazyFrames (`sink_` functions).

- [`sink_csv()`](https://tidypolars.etiennebacher.com/reference/sink_csv.md)
  : Stream output to a CSV file
- [`sink_ipc()`](https://tidypolars.etiennebacher.com/reference/sink_ipc.md)
  : Stream output to an IPC file
- [`sink_ndjson()`](https://tidypolars.etiennebacher.com/reference/sink_ndjson.md)
  : Stream output to a NDJSON file
- [`sink_parquet()`](https://tidypolars.etiennebacher.com/reference/sink_parquet.md)
  : Stream output to a parquet file
- [`write_csv_polars()`](https://tidypolars.etiennebacher.com/reference/write_csv_polars.md)
  : Export data to CSV file(s)
- [`write_ipc_polars()`](https://tidypolars.etiennebacher.com/reference/write_ipc_polars.md)
  : Export data to IPC file(s)
- [`write_json_polars()`](https://tidypolars.etiennebacher.com/reference/write_json_polars.md)
  : Export data to JSON file(s)
- [`write_ndjson_polars()`](https://tidypolars.etiennebacher.com/reference/write_ndjson_polars.md)
  : Export data to NDJSON file(s)
- [`write_parquet_polars()`](https://tidypolars.etiennebacher.com/reference/write_parquet_polars.md)
  : Export data to Parquet file(s)

## Functions from `dplyr`

- [`count(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/count.polars_data_frame.md)
  [`tally(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/count.polars_data_frame.md)
  [`count(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/count.polars_data_frame.md)
  [`tally(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/count.polars_data_frame.md)
  [`add_count(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/count.polars_data_frame.md)
  [`add_count(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/count.polars_data_frame.md)
  : Count the observations in each group
- [`semi_join(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/semi_join.polars_data_frame.md)
  [`anti_join(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/semi_join.polars_data_frame.md)
  [`semi_join(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/semi_join.polars_data_frame.md)
  [`anti_join(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/semi_join.polars_data_frame.md)
  : Filtering joins
- [`arrange(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/arrange.polars_data_frame.md)
  : Order rows using column values
- [`bind_cols_polars()`](https://tidypolars.etiennebacher.com/reference/bind_cols_polars.md)
  : Append multiple Data/LazyFrames next to each other
- [`bind_rows_polars()`](https://tidypolars.etiennebacher.com/reference/bind_rows_polars.md)
  : Stack multiple Data/LazyFrames on top of each other
- [`compute(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/compute.polars_lazy_frame.md)
  [`collect(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/compute.polars_lazy_frame.md)
  : Run computations on a LazyFrame
- [`cross_join(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/cross_join.polars_data_frame.md)
  [`cross_join(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/cross_join.polars_data_frame.md)
  : Cross join
- [`distinct(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/distinct.polars_data_frame.md)
  [`distinct(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/distinct.polars_data_frame.md)
  [`duplicated_rows()`](https://tidypolars.etiennebacher.com/reference/distinct.polars_data_frame.md)
  : Remove or keep only duplicated rows in a Data/LazyFrame
- [`explain(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/explain.polars_lazy_frame.md)
  : Show the optimized and non-optimized query plans
- [`filter(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/filter.polars_data_frame.md)
  [`filter(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/filter.polars_data_frame.md)
  [`filter_out(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/filter.polars_data_frame.md)
  [`filter_out(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/filter.polars_data_frame.md)
  : Keep or drop rows that match a condition
- [`left_join(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/mutating-joins.md)
  [`right_join(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/mutating-joins.md)
  [`full_join(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/mutating-joins.md)
  [`inner_join(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/mutating-joins.md)
  [`left_join(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/mutating-joins.md)
  [`right_join(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/mutating-joins.md)
  [`full_join(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/mutating-joins.md)
  [`inner_join(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/mutating-joins.md)
  : Mutating joins
- [`group_by(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/group_by.polars_data_frame.md)
  [`ungroup(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/group_by.polars_data_frame.md)
  [`group_by(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/group_by.polars_data_frame.md)
  [`ungroup(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/group_by.polars_data_frame.md)
  : Group by one or more variables
- [`group_split(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/group_split.polars_data_frame.md)
  : Grouping metadata
- [`group_vars(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/group_vars.polars_data_frame.md)
  [`group_vars(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/group_vars.polars_data_frame.md)
  [`group_keys(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/group_vars.polars_data_frame.md)
  [`group_keys(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/group_vars.polars_data_frame.md)
  : Grouping metadata
- [`mutate(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/mutate.polars_data_frame.md)
  [`mutate(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/mutate.polars_data_frame.md)
  : Create, modify, and delete columns
- [`pull(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/pull.polars_data_frame.md)
  [`pull(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/pull.polars_data_frame.md)
  : Extract a variable of a Data/LazyFrame
- [`relocate(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/relocate.polars_data_frame.md)
  [`relocate(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/relocate.polars_data_frame.md)
  : Change column order
- [`rename(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/rename.polars_data_frame.md)
  [`rename(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/rename.polars_data_frame.md)
  [`rename_with(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/rename.polars_data_frame.md)
  [`rename_with(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/rename.polars_data_frame.md)
  : Rename columns
- [`rowwise(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/rowwise.polars_data_frame.md)
  [`rowwise(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/rowwise.polars_data_frame.md)
  : Group input by rows
- [`select(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/select.polars_data_frame.md)
  [`select(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/select.polars_data_frame.md)
  : Select columns from a Data/LazyFrame
- [`separate(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/separate.polars_data_frame.md)
  [`separate(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/separate.polars_data_frame.md)
  : Separate a character column into multiple columns based on a
  substring
- [`slice_tail(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/slice_tail.polars_data_frame.md)
  [`slice_tail(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/slice_tail.polars_data_frame.md)
  [`slice_head(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/slice_tail.polars_data_frame.md)
  [`slice_head(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/slice_tail.polars_data_frame.md)
  [`slice_sample(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/slice_tail.polars_data_frame.md)
  : Subset rows of a Data/LazyFrame
- [`summarize(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/summarize.polars_data_frame.md)
  [`summarise(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/summarize.polars_data_frame.md)
  [`summarize(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/summarize.polars_data_frame.md)
  [`summarise(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/summarize.polars_data_frame.md)
  : Summarize each group down to one row

## Functions from `tidyr`

- [`complete(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/complete.polars_data_frame.md)
  [`complete(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/complete.polars_data_frame.md)
  : Complete a data frame with missing combinations of data
- [`drop_na(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/drop_na.polars_data_frame.md)
  [`drop_na(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/drop_na.polars_data_frame.md)
  : Drop missing values
- [`fill(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/fill.polars_data_frame.md)
  : Fill in missing values with previous or next value
- [`pivot_longer(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/pivot_longer.polars_data_frame.md)
  [`pivot_longer(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/pivot_longer.polars_data_frame.md)
  : Pivot a Data/LazyFrame from wide to long
- [`pivot_wider(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/pivot_wider.polars_data_frame.md)
  [`pivot_wider(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/pivot_wider.polars_data_frame.md)
  : Pivot a Data/LazyFrame from long to wide
- [`replace_na(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/replace_na.polars_data_frame.md)
  [`replace_na(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/replace_na.polars_data_frame.md)
  : Replace NAs with specified values
- [`separate(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/separate.polars_data_frame.md)
  [`separate(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/separate.polars_data_frame.md)
  : Separate a character column into multiple columns based on a
  substring
- [`separate_longer_delim_polars()`](https://tidypolars.etiennebacher.com/reference/separate_longer.md)
  [`separate_longer_position_polars()`](https://tidypolars.etiennebacher.com/reference/separate_longer.md)
  : Split a string column into rows
- [`uncount(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/uncount.polars_data_frame.md)
  [`uncount(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/uncount.polars_data_frame.md)
  : Uncount a Data/LazyFrame
- [`unite(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/unite.polars_data_frame.md)
  [`unite(`*`<polars_lazy_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/unite.polars_data_frame.md)
  : Unite multiple columns into one by pasting strings together
- [`unnest_longer_polars()`](https://tidypolars.etiennebacher.com/reference/unnest_longer_polars.md)
  : Unnest a list-column into rows

## Other methods

Other functions or S3 methods.

- [`summary(`*`<polars_data_frame>`*`)`](https://tidypolars.etiennebacher.com/reference/summary.polars_data_frame.md)
  : Summary statistics for a Polars DataFrame

- [`tidypolars_options`](https://tidypolars.etiennebacher.com/reference/tidypolars_options.md)
  :

  `tidypolars` global options

## Other Polars functions

Other Polars-specific functions (most are deprecated).

- [`fetch()`](https://tidypolars.etiennebacher.com/reference/fetch.md)
  **\[deprecated\]** :

  Fetch `n` rows of a LazyFrame

- [`make_unique_id()`](https://tidypolars.etiennebacher.com/reference/make_unique_id.md)
  **\[deprecated\]** : Create a column with unique id per row values

- [`partition_by()`](https://tidypolars.etiennebacher.com/reference/partitioned_output.md)
  [`partition_by_key()`](https://tidypolars.etiennebacher.com/reference/partitioned_output.md)
  [`partition_by_max_size()`](https://tidypolars.etiennebacher.com/reference/partitioned_output.md)
  **\[experimental\]** : Helper functions to export data as a
  partitioned output

## Advanced

Functions for very specific usage.

- [`.tp`](https://tidypolars.etiennebacher.com/reference/dot-tp.md) :
  Get tidypolars function translation without loading their original
  package
