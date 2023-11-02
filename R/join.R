#' Mutating joins
#'
#' Mutating joins add columns from `y` to `x`, matching observations based on
#' the keys.
#'
#' @param x,y Two Polars Data/LazyFrames
#' @param by Variables to join by. If `NULL`, the default, `*_join()` will
#' perform a natural join, using all variables in common across `x` and `y`. A
#' message lists the variables so that you can check they're correct; suppress
#' the message by supplying `by` explicitly.
#' @param suffix If there are non-joined duplicate variables in `x` and `y`,
#' these suffixes will be added to the output to disambiguate them. Should be a
#' character vector of length 2.
#'
#' @rdname mutating-joins
#'
#' @export
#' @examples
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
#' left_join(test, test2)
#'
#' inner_join(test, test2)
#'
#' full_join(test, test2)
#'
#' # Show how the arg 'suffix' works:
#' test2 <- polars::pl$DataFrame(
#'   x = c(1, 2, 4),
#'   y = c(1, 2, 4),
#'   z = c(4, 5, 7)
#' )
#'
#' left_join(test, test2, by = c("x", "y"), suffix = c("_left", "_right"))

left_join.DataFrame <- function(x, y, by = NULL, suffix = c(".x", ".y")) {
  join_(x = x, y = y, by = by, how = "left", suffix = suffix)
}

#' @rdname mutating-joins
#' @export
right_join.DataFrame <- function(x, y, by = NULL, suffix = c(".x", ".y")) {
  join_(x = x, y = y, by = by, how = "right", suffix = suffix)
}

#' @rdname mutating-joins
#' @export
full_join.DataFrame <- function(x, y, by = NULL, suffix = c(".x", ".y")) {
  join_(x = x, y = y, by = by, how = "outer", suffix = suffix)
}

#' @rdname mutating-joins
#' @export
inner_join.DataFrame <- function(x, y, by = NULL, suffix = c(".x", ".y")) {
  join_(x = x, y = y, by = by, how = "inner", suffix = suffix)
}

#' @export
left_join.LazyFrame <- left_join.DataFrame

#' @export
right_join.LazyFrame <- right_join.DataFrame

#' @export
full_join.LazyFrame <- full_join.DataFrame

#' @export
inner_join.LazyFrame <- inner_join.DataFrame

#' Filtering joins
#'
#' Filtering joins filter rows from `x` based on the presence or absence of
#' matches in `y`:
#' * `semi_join()` return all rows from `x` with a match in `y`.
#' * `anti_join()` return all rows from `x` without a match in `y`.
#'
#' @param x,y Two Polars Data/LazyFrames
#' @inheritParams left_join
#'
#' @rdname filtering-joins
#'
#' @export
#' @examples
#' test <- polars::pl$DataFrame(
#'   x = c(1, 2, 3),
#'   y = c(1, 2, 3),
#'   z = c(1, 2, 3)
#' )
#
#' test2 <- polars::pl$DataFrame(
#'   x = c(1, 2, 4),
#'   y = c(1, 2, 4),
#'   z2 = c(1, 2, 4)
#' )
#
#' test
#
#' test2
#
#' # only keep the rows of `test` that have matching keys in `test2`
#' semi_join(test, test2, by = c("x", "y"))
#
#' # only keep the rows of `test` that don't have matching keys in `test2`
#' anti_join(test, test2, by = c("x", "y"))

semi_join.DataFrame <- function(x, y, by = NULL) {
  join_(x = x, y = y, by = by, how = "semi", suffix = NULL)
}

#' @rdname filtering-joins
#' @export

anti_join.DataFrame <- function(x, y, by = NULL) {
  join_(x = x, y = y, by = by, how = "anti", suffix = NULL)
}

#' @export
semi_join.LazyFrame <- semi_join.DataFrame

#' @export
anti_join.LazyFrame <- anti_join.DataFrame

#' Cross join
#'
#' Cross joins match each row in `x` to every row in `y`, resulting in a dataset
#' with `nrow(x) * nrow(y)` rows.
#'
#' @inheritParams left_join
#'
#' @export
#' @examples
#' test <- polars::pl$DataFrame(
#'   origin = c("ALG", "FRA", "GER"),
#'   year = c(2020, 2020, 2021)
#' )
#'
#' test2 <- polars::pl$DataFrame(
#'   destination = c("USA", "JPN", "BRA"),
#'   language = c("english", "japanese", "portuguese")
#' )
#'
#' test
#'
#' test2
#'
#' cross_join(test, test2)

cross_join.DataFrame <- function(x, y, suffix = c(".x", ".y")) {
  join_(x = x, y = y, by = NULL, how = "cross", suffix = suffix)
}

#' @export
cross_join.LazyFrame <- cross_join.DataFrame


join_ <- function(x, y, by = NULL, how, suffix) {

  check_polars_data(x)
  check_polars_data(y)
  check_same_class(x, y)

  if (!is.null(suffix) && length(suffix) != 2) {
    rlang::abort(
      "`suffix` must be of length 2.",
      call = caller_env()
    )
  }

  if (is.null(by) && how != "cross") {
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
