#' @export

to_r <- function(data) {
  if (inherits(data, "DataFrame")) {
    data$to_data_frame()
  } else {
    data$to_r()
  }
}
