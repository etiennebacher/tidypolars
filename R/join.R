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
#'
#' `by` can take a character vector, like `c("x", "y")` if `x` and `y` are
#' in both datasets. To join on variables that don't have the same name, use
#' equalities in the character vector, like `c("x1" = "x2", "y")`. If you use
#' a character vector, the join can only be done using strict equality.
#'
#' Finally, `by` can be a specification created by `dplyr::join_by()`. Contrary
#' to the input as character vector shown above, `join_by()` uses unquoted column
#' names, e.g `join_by(x1 == x2, y)`. It also uses equality and inequality
#' operators `==`, `>` and similar. **For now, only equality operators are
#' supported**.
#'
#' @param suffix If there are non-joined duplicate variables in `x` and `y`,
#' these suffixes will be added to the output to disambiguate them. Should be a
#' character vector of length 2.
#' @inheritParams slice_tail.RPolarsDataFrame
#' @param copy,keep Not used.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' test <- polars::pl$DataFrame(
#'   x = c(1, 2, 3),
#'   y1 = c(1, 2, 3),
#'   z = c(1, 2, 3)
#' )
#'
#' test2 <- polars::pl$DataFrame(
#'   x = c(1, 2, 4),
#'   y2 = c(1, 2, 4),
#'   z2 = c(4, 5, 7)
#' )
#'
#' test
#'
#' test2
#'
#' # default is to use common columns, here "x" only
#' left_join(test, test2)
#'
#' # we can specify the columns on which to join with join_by()...
#' left_join(test, test2, by = join_by(x, y1 == y2))
#'
#' # ... or with a character vector
#' left_join(test, test2, by = c("x", "y1" = "y2"))
#'
#' # we can customize the suffix of common column names not used to join
#' test2 <- polars::pl$DataFrame(
#'   x = c(1, 2, 4),
#'   y1 = c(1, 2, 4),
#'   z = c(4, 5, 7)
#' )
#'
#' left_join(test, test2, by = "x", suffix = c("_left", "_right"))

left_join.RPolarsDataFrame <- function(x, y, by = NULL, copy = NULL,
                                suffix = c(".x", ".y"), ..., keep = NULL) {
  unused_args(copy, keep)
  join_(x = x, y = y, by = by, how = "left", suffix = suffix)
}

#' @rdname left_join.RPolarsDataFrame
#' @export
right_join.RPolarsDataFrame <- function(x, y, by = NULL, copy = NULL,
                                 suffix = c(".x", ".y"), ..., keep = NULL) {
  unused_args(copy, keep)
  join_(x = x, y = y, by = by, how = "right", suffix = suffix)
}

#' @rdname left_join.RPolarsDataFrame
#' @export
full_join.RPolarsDataFrame <- function(x, y, by = NULL, copy = NULL,
                                suffix = c(".x", ".y"), ..., keep = NULL) {
  unused_args(copy, keep)
  join_(x = x, y = y, by = by, how = "outer_coalesce", suffix = suffix)
}

#' @rdname left_join.RPolarsDataFrame
#' @export
inner_join.RPolarsDataFrame <- function(x, y, by = NULL, copy = NULL,
                                 suffix = c(".x", ".y"), ..., keep = NULL) {
  unused_args(copy, keep)
  join_(x = x, y = y, by = by, how = "inner", suffix = suffix)
}

#' @rdname left_join.RPolarsDataFrame
#' @export
left_join.RPolarsLazyFrame <- left_join.RPolarsDataFrame

#' @rdname left_join.RPolarsDataFrame
#' @export
right_join.RPolarsLazyFrame <- right_join.RPolarsDataFrame

#' @rdname left_join.RPolarsDataFrame
#' @export
full_join.RPolarsLazyFrame <- full_join.RPolarsDataFrame

#' @rdname left_join.RPolarsDataFrame
#' @export
inner_join.RPolarsLazyFrame <- inner_join.RPolarsDataFrame

#' Filtering joins
#'
#' Filtering joins filter rows from `x` based on the presence or absence of
#' matches in `y`:
#' * `semi_join()` return all rows from `x` with a match in `y`.
#' * `anti_join()` return all rows from `x` without a match in `y`.
#'
#' @param x,y Two Polars Data/LazyFrames
#' @inheritParams left_join.RPolarsDataFrame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
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

semi_join.RPolarsDataFrame <- function(x, y, by = NULL, ...) {
  join_(x = x, y = y, by = by, how = "semi", suffix = NULL)
}

#' @rdname semi_join.RPolarsDataFrame
#' @export

anti_join.RPolarsDataFrame <- function(x, y, by = NULL, ...) {
  join_(x = x, y = y, by = by, how = "anti", suffix = NULL)
}

#' @rdname semi_join.RPolarsDataFrame
#' @export
semi_join.RPolarsLazyFrame <- semi_join.RPolarsDataFrame

#' @rdname semi_join.RPolarsDataFrame
#' @export
anti_join.RPolarsLazyFrame <- anti_join.RPolarsDataFrame

#' Cross join
#'
#' Cross joins match each row in `x` to every row in `y`, resulting in a dataset
#' with `nrow(x) * nrow(y)` rows.
#'
#' @inheritParams left_join.RPolarsDataFrame
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
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

cross_join.RPolarsDataFrame <- function(x, y, suffix = c(".x", ".y"), ...) {
  join_(x = x, y = y, by = NULL, how = "cross", suffix = suffix)
}

#' @rdname cross_join.RPolarsDataFrame
#' @export
cross_join.RPolarsLazyFrame <- cross_join.RPolarsDataFrame


join_ <- function(x, y, by = NULL, how, suffix) {
  check_same_class(x, y, rlang::caller_env())

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

  if (inherits(by, "dplyr_join_by")) {
    by <- unpack_join_by(by)
  }

  if (!is.null(names(by))) {
    for (i in seq_along(by)) {
      if (names(by)[i] == "") {
        names(by)[i] <- by[i]
      }
    }
    left_on <- names(by)
    right_on <- unname(by)
  } else {
    left_on <- by
    right_on <- by
  }

  dupes <- intersect(
    setdiff(pl_colnames(x), by),
    setdiff(pl_colnames(y), by)
  )

  if (
    (inherits(x, "RPolarsDataFrame") && inherits(y, "RPolarsDataFrame")) ||
    (inherits(x, "RPolarsLazyFrame") && inherits(y, "RPolarsLazyFrame"))
  ) {
    if (how == "right") {
      out <- y$join(other = x, left_on = left_on, right_on = right_on, how = "left")
    } else {
      out <- x$join(other = y, left_on = left_on, right_on = right_on, how = how)
    }
  }

  out <- if (length(dupes) > 0) {
    mapping <- as.list(c(dupes, paste0(dupes, "_right")))
    names(mapping) <- c(paste0(dupes, suffix[1]), paste0(dupes, suffix[2]))
    out$rename(mapping)
  } else {
    out
  }
  add_tidypolars_class(out)
}


unpack_join_by <- function(by) {
  if (!all(by$condition == "==")) {
    rlang::abort(
      "`tidypolars` doesn't support inequality conditions in `join_by()` yet.",
      call = rlang::caller_env(2)
    )
  }
  out <- by$y
  names(out) <- by$x
  out
}
