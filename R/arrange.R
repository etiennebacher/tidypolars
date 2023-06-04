#' @export

pl_arrange <- function(data, ...) {

  check_polars_data(data)

  dots <- get_dots(...)
  out_length <- length(dots)
  direction <- rep(FALSE, out_length)

  vars <- lapply(seq_along(dots), \(x) {
      out <- as.character(dots[[x]])
      if (length(out) == 2 && out[1] %in% c("-", "!")) {
        out <- as.character(dots[[x]][2])
        direction[x] <<- TRUE
      }
      out
    }) |>
    unlist()

  expr <- paste0("c('", paste(vars, collapse = "', '"), "')") |>
    str2lang()

  data$sort(eval(expr), descending = eval(direction))
}
