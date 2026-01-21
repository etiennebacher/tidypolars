# Export data to IPC file(s)

Export data to IPC file(s)

## Usage

``` r
write_ipc_polars(
  .data,
  file,
  compression = "uncompressed",
  ...,
  compat_level = "newest",
  future
)
```

## Arguments

- .data:

  A Polars DataFrame.

- file:

  File path to which the result should be written.

- compression:

  `NULL` or a character of the compression method, `"uncompressed"` or
  "lz4" or "zstd". `NULL` is equivalent to `"uncompressed"`. Choose
  "zstd" for good compression performance. Choose "lz4" for fast
  compression/decompression.

- ...:

  Ignored.

- compat_level:

  Determines the compatibility level when exporting Polars' internal
  data structures. When specifying a new compatibility level, Polars
  exports its internal data structures that might not be interpretable
  by other Arrow implementations. The level can be specified as the name
  (e.g., `"newest"`) or as a scalar integer (currently, 0 or 1 is
  supported).

  - `"newest"` (default): Use the highest level, currently same as 1
    (Low compatibility).

  - `"oldest"`: Same as 0 (High compatibility).

- future:

  **\[deprecated\]** Deprecated, use `compat_level` instead.

## Value

The input DataFrame.

## Details

### Partitioned output

It is possible to export data to multiple files based on various
parameters, such as the values of some variables, or such that each file
has a maximum number of rows. See
[`partition_by()`](https://tidypolars.etiennebacher.com/reference/partitioned_output.md)
for more details.
