### In this file, we define S3 methods that should be applied to columns with
### special classes that can't be translated as-is to polars.

#' @export
as_polars_series.ivs_iv = function(x, ...) {
  pl$DataFrame(unclass(x))$select(
    pl$date_range(
      pl$col("start"),
      pl$col("end"),
      interval = "1d",
      explode = FALSE
    )$alias("ivs_iv")
  )$to_series()
}
