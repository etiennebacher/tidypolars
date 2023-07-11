#' @export

to_r <- function(.data) {

  # for testing only
  if (inherits(.data, "LazyFrame") && Sys.getenv("TIDYPOLARS_TEST") == "TRUE") {
    return(.data$collect()$to_data_frame())
  }

  if (inherits(.data, "DataFrame")) {
    .data$to_data_frame()
  } else {
    .data$to_r()
  }
}
