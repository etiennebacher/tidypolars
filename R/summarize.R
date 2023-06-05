#' @export

pl_summarize <- function(data, ...) {
  if (!inherits(data, "GroupBy")) {
    stop("`pl_summarize()` only works on grouped data.")
  }
  check_polars_data(data)

  dots <- get_dots(...)
  out_exprs <- rearrange_exprs(data, dots)
  return(out_exprs)
  out <- lapply(out_exprs, str2lang)
  data$agg(lapply(out, eval))
}
