#' Stack multiples Data/LazyFrames on top of each other
#'
#' @param ... Polars DataFrames or LazyFrames to combine. Each argument can
#'  either be a Data/LazyFrame, or a list of Data/LazyFrames. Columns are matched
#'  by name. All Data/LazyFrames must have the same number of columns with
#'  identical names.
#'
#' @export
#' @examples
#' p1 <- pl$DataFrame(
#'   x = sample(letters, 20),
#'   y = sample(1:100, 20)
#' )
#' p2 <- pl$DataFrame(
#'   x = sample(letters, 20),
#'   y = sample(1:100, 20)
#' )
#'
#' pl_bind_rows(p1, p2)
#'
#' # this is equivalent
#' pl_bind_rows(list(p1, p2))

pl_bind_rows <- function(...) {
  concat_(..., how = "vertical")
}

#' Append multiples Data/LazyFrames next to each other
#'
#' @param ... Polars DataFrames or LazyFrames to combine. Each argument can
#'  either be a Data/LazyFrame, or a list of Data/LazyFrames. Columns are matched
#'  by name. All Data/LazyFrames must have the same number of rows and there
#'  mustn't be duplicated column names.
#'
#' @export
#' @examples
#' p1 <- pl$DataFrame(
#'   x = sample(letters, 20),
#'   y = sample(1:100, 20)
#' )
#' p2 <- pl$DataFrame(
#'   z = sample(letters, 20),
#'   w = sample(1:100, 20)
#' )
#'
#' pl_bind_cols(p1, p2)
#' pl_bind_cols(list(p1, p2))

pl_bind_cols <- function(...) {
  concat_(..., how = "horizontal")
}



concat_ <- function(..., how) {
  dots <- get_dots(...)
  one_el <- length(dots) == 1L

  dots <- lapply(dots, \(x) eval(x, envir = parent.frame(4L)))
  dots_is_a_single_list <- one_el && is.list(dots)

  if (dots_is_a_single_list) dots <- unlist(dots)

  if (any(vapply(dots, \(y) !inherits(y, "DataFrame"), FUN.VALUE = logical(1L)))) {
    stop("Some elements in `...` are not a DataFrame.")
  }

  pl$concat(dots, how = how)
}
