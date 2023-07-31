#' Join DataFrames or LazyFrames
#'
#' @param x,y Two Polars Data/LazyFrames
#' @param by Variables to join by. If `NULL`, the default, *_join() will perform
#' a natural join, using all variables in common across x and y. A message lists
#' the variables so that you can check they're correct; suppress the message by
#' supplying by explicitly.
#' @param suffix If there are non-joined duplicate variables in `x` and `y`,
#' these suffixes will be added to the output to disambiguate them. Should be a
#' character vector of length 2.
#'
#' @rdname classic-joins
#'
#' @export
#' @examples
#'
#' test <- polars::pl$DataFrame(
#'   x = c(1, 2, 3),
#'   y = c(1, 2, 3),
#'   z = c(1, 2, 3)
#' )
#'
#' test2 <- polars::pl$DataFrame(
#'   x = c(1, 2, 4),
#'   y = c(1, 2, 4),
#'   z2 = c(4, 5, 7)
#' )
#'
#' test
#'
#' test2
#'
#' pl_left_join(test, test2)
#'
#' pl_inner_join(test, test2)
#'
#' pl_full_join(test, test2)
#'
#' # Show how the arg 'suffix' works:
#' test2 <- polars::pl$DataFrame(
#'   x = c(1, 2, 4),
#'   y = c(1, 2, 4),
#'   z = c(4, 5, 7)
#' )
#'
#' pl_left_join(test, test2, by = c("x", "y"), suffix = c("_left", "_right"))

pl_left_join <- function(x, y, by = NULL, suffix = c(".x", ".y")) {
  join_(x = x, y = y, by = by, how = "left", suffix = suffix)
}

#' @rdname classic-joins
#' @export
pl_right_join <- function(x, y, by = NULL, suffix = c(".x", ".y")) {
  join_(x = x, y = y, by = by, how = "right", suffix = suffix)
}

#' @rdname classic-joins
#' @export
pl_full_join <- function(x, y, by = NULL, suffix = c(".x", ".y")) {
  join_(x = x, y = y, by = by, how = "outer", suffix = suffix)
}

#' @rdname classic-joins
#' @export
pl_inner_join <- function(x, y, by = NULL, suffix = c(".x", ".y")) {
  join_(x = x, y = y, by = by, how = "inner", suffix = suffix)
}




#' @export
pl_semi_join <- function(x, y, by = NULL) {
  join_(x = x, y = y, by = by, how = "semi")
}

#' @export
pl_anti_join <- function(x, y, by = NULL) {
  join_(x = x, y = y, by = by, how = "anti")
}

join_ <- function(x, y, by = NULL, how, suffix) {

  check_polars_data(x)
  check_polars_data(y)
  check_same_class(x, y)

  if (length(suffix) != 2) {
    rlang::abort("`suffix` must be of length 2.")
  }

  if (is.null(by)) {
    by <- intersect(pl_colnames(x), pl_colnames(y))
    rlang::inform(
      paste0("Joining by ", paste("`", by, "`", collapse = ", ", sep = ""))
    )
  }

  dupes <- intersect(
    setdiff(pl_colnames(x), by),
    setdiff(pl_colnames(y), by)
  )

  if (
    (inherits(x, "DataFrame") && inherits(y, "DataFrame")) ||
    (inherits(x, "LazyFrame") && inherits(y, "LazyFrame"))
  ) {
    # polars doesn't have right join and I think reassigning y to x and
    # x to y would consume some memory
    if (how == "right") {
      out <- y$join(other = x, on = by, how = "left")
    } else {
      out <- x$join(other = y, on = by, how = how)
    }
  }

  if (length(dupes) > 0) {
    mapping <- as.list(c(dupes, paste0(dupes, "_right")))
    names(mapping) <- c(paste0(dupes, suffix[1]), paste0(dupes, suffix[2]))
    out$rename(mapping)
  } else {
    out
  }
}
