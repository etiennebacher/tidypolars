#' Order rows using column values
#'
#' @param .data A Polars Data/LazyFrame
#' @param ... Quoted or unquoted variable names. Select helpers cannot be used.
#'
#' @export
#' @examples
#' pl_test <- polars::pl$DataFrame(
#'   x1 = c("a", "a", "b", "a", "c"),
#'   x2 = c(2, 1, 5, 3, 1),
#'   value = sample(1:5)
#' )
#'
#' pl_arrange(pl_test, x1)
#' pl_arrange(pl_test, -"x1")
#' pl_arrange(pl_test, x1, -x2)


pl_arrange <- function(.data, ...) {

  check_polars_data(.data)

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

  not_exist <- which(!vars %in% pl_colnames(.data))
  if (length(not_exist) > 0) {
    vars <- vars[-not_exist]
    direction <- direction[-not_exist]
  }

  if (length(vars) == 0) return(.data)

  .data$sort(eval(vars), descending = eval(direction))
}
