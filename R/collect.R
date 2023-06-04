#' @export

pl_collect <- function(data) {
  if (!inherits(data, "LazyFrame")) {
    stop("`collect()` can only be used on a LazyFrame.")
  }
  data$collect()
}
