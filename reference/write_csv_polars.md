# Export data to CSV file(s)

Export data to CSV file(s)

## Usage

``` r
write_csv_polars(
  .data,
  file,
  ...,
  include_bom = FALSE,
  include_header = TRUE,
  separator = ",",
  line_terminator = "\n",
  quote_char = "\"",
  batch_size = 1024,
  datetime_format = NULL,
  date_format = NULL,
  time_format = NULL,
  float_precision = NULL,
  null_value = "",
  quote_style = "necessary",
  quote,
  null_values
)
```

## Arguments

- .data:

  A Polars DataFrame.

- file:

  File path to which the result should be written.

- ...:

  Ignored.

- include_bom:

  Whether to include UTF-8 BOM (byte order mark) in the CSV output.

- include_header:

  Whether to include header in the CSV output.

- separator:

  Separate CSV fields with this symbol.

- line_terminator:

  String used to end each row.

- quote_char:

  Byte to use as quoting character.

- batch_size:

  Number of rows that will be processed per thread.

- datetime_format:

  A format string, with the specifiers defined by the chrono Rust crate.
  If no format specified, the default fractional-second precision is
  inferred from the maximum timeunit found in the frame’s Datetime cols
  (if any).

- date_format:

  A format string, with the specifiers defined by the chrono Rust crate.

- time_format:

  A format string, with the specifiers defined by the chrono Rust crate.

- float_precision:

  Number of decimal places to write, applied to both Float32 and Float64
  datatypes.

- null_value:

  A string representing null values (defaulting to the empty string).

- quote_style:

  Determines the quoting strategy used.

  - `"necessary"` (default): This puts quotes around fields only when
    necessary. They are necessary when fields contain a quote, delimiter
    or record terminator. Quotes are also necessary when writing an
    empty record (which is indistinguishable from a record with one
    empty field). This is the default.

  - `"always"`: This puts quotes around every field.

  - `"non_numeric"`: This puts quotes around all fields that are
    non-numeric. Namely, when writing a field that does not parse as a
    valid float or integer, then quotes will be used even if they
    aren\`t strictly necessary.

  - `"never"`: This never puts quotes around fields, even if that
    results in invalid CSV data (e.g. by not quoting strings containing
    the separator).

- quote:

  **\[deprecated\]** Deprecated, use `quote_char` instead.

- null_values:

  **\[deprecated\]** Deprecated, use `null_value` instead.

## Value

The input DataFrame.

## Examples

``` r
dest <- tempfile(fileext = ".csv")
mtcars |>
  as_polars_df() |>
  write_csv_polars(dest)

read.csv(dest)
#>     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> 1  21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
#> 2  21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#> 3  22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> 4  21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
#> 5  18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
#> 6  18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
#> 7  14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
#> 8  24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> 9  22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> 10 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
#> 11 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
#> 12 16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
#> 13 17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
#> 14 15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
#> 15 10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
#> 16 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
#> 17 14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
#> 18 32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
#> 19 30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> 20 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
#> 21 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
#> 22 15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
#> 23 15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
#> 24 13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
#> 25 19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
#> 26 27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> 27 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
#> 28 30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
#> 29 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
#> 30 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
#> 31 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
#> 32 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
```
