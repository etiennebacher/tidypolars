.onLoad <- function(...) {
  if (packageVersion("dplyr") > "1.1.4") {
    s3_register("dplyr::filter_out", "polars_data_frame")
    s3_register("dplyr::filter_out", "polars_lazy_frame")
  }
}
