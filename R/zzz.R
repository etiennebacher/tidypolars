.onLoad <- function(...) {
  if (packageVersion("dplyr") >= "1.2.0") {
    s3_register("dplyr::filter_out", "polars_data_frame")
    s3_register("dplyr::filter_out", "polars_lazy_frame")
  }
}
