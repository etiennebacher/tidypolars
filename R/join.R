#' @export
pl_left_join <- function(x, y, by = NULL) {
  join_(x = x, y = y, by = by, how = "left")
}

#' @export
pl_right_join <- function(x, y, by = NULL) {
  join_(x = x, y = y, by = by, how = "right")
}

#' @export
pl_full_join <- function(x, y, by = NULL) {
  join_(x = x, y = y, by = by, how = "outer")
}

#' @export
pl_inner_join <- function(x, y, by = NULL) {
  join_(x = x, y = y, by = by, how = "inner")
}

#' @export
pl_semi_join <- function(x, y, by = NULL) {
  join_(x = x, y = y, by = by, how = "semi")
}

#' @export
pl_anti_join <- function(x, y, by = NULL) {
  join_(x = x, y = y, by = by, how = "anti")
}

join_ <- function(x, y, by = NULL, how) {

  check_polars_data(x)
  check_polars_data(y)
  check_same_class(x, y)

  if (is.null(by)) {
    by <- intersect(pl_colnames(x), pl_colnames(y))
  }

  if (inherits(x, "DataFrame") && inherits(y, "DataFrame")) {
    # polars doesn't have right join and I think reassigning y to x and
    # x to y would consume some memory
    if (how == "right") {
      y$join(other = x, on = by, how = "left")
    } else {
      x$join(other = y, on = by, how = how)
    }
  }

}
