# `$.tidypolars` <- function(x, name, ...) {
#   print(list2(...))
#   browser()
#   x <- as_quosure(frame_call(), env = caller_env())
#   y <- enexpr(x)
#   x
# }

#' @export
show_query.tidypolars <- function(x) {
  cat("Pure polars expression:\n\n")
  attributes(x)$polars_expression
}
