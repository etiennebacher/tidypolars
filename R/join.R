#' Mutating joins
#'
#' Mutating joins add columns from `y` to `x`, matching observations based on
#' the keys.
#'
#' @rdname mutating-joins
#'
#' @inheritParams rlang::check_dots_empty0
#' @param x,y Two Polars Data/LazyFrames
#' @param by Variables to join by. If `NULL` (default), `*_join()` will
#' perform a natural join, using all variables in common across `x` and `y`. A
#' message lists the variables so that you can check they're correct; suppress
#' the message by supplying `by` explicitly.
#'
#' `by` can take a character vector, like `c("x", "y")` if `x` and `y` are
#' in both datasets. To join on variables that don't have the same name, use
#' equalities in the character vector, like `c("x1" = "x2", "y")`. If you use
#' a character vector, the join can only be done using strict equality.
#'
#' `by` can also be a specification created by `dplyr::join_by()`. Contrary
#' to the input as character vector shown above, `join_by()` uses unquoted
#' column names, e.g `join_by(x1 == x2, y)`.
#'
#' Finally, `inner_join()` also supports inequality joins, e.g.
#' `join_by(x1 >= x2)`, and the helpers `between()`, `overlaps()`, and
#' `within()`. See the documentation of [`dplyr::join_by()`] for more
#' information. Other join types will likely support inequality joins in the
#' future.
#'
#' @param suffix If there are non-joined duplicate variables in `x` and `y`,
#' these suffixes will be added to the output to disambiguate them. Should be a
#' character vector of length 2.
#' @inheritParams slice_tail.RPolarsDataFrame
#' @param na_matches Should two `NA` values match?
#' * `"na"`, the default, treats two `NA` values as equal.
#' * `"never"` treats two `NA` values as different and will never match them
#'   together or to any other values.
#'
#' Note that when joining Polars Data/LazyFrames, `NaN` are always considered
#' equal, no matter the value of `na_matches`. This differs from the original
#' `dplyr` implementation.
#' @param relationship Handling of the expected relationship between the keys of
#' `x` and `y`. Must be one of the following:
#' * `NULL`, the default, is equivalent to `"many-to-many"`. It doesn't expect
#'   any relationship between `x` and `y`.
#' * `"one-to-one"` expects each row in `x` to match at most 1 row in `y` and
#'   each row in `y` to match at most 1 row in `x`.
#' * `"one-to-many"` expects each row in `y` to match at most 1 row in `x`.
#' * `"many-to-one"` expects each row in `x` matches at most 1 row in `y`.
#' @param copy,keep Not supported.
#'
#' @section Unknown arguments:
#'
#' Arguments that are supported by the original implementation in the tidyverse
#' but are not listed above will throw a warning by default if they are
#' specified. To change this behavior to error instead, use
#' `options(tidypolars_unknown_args = "error")`.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' test <- polars0::pl$DataFrame(
#'   x = c(1, 2, 3),
#'   y1 = c(1, 2, 3),
#'   z = c(1, 2, 3)
#' )
#'
#' test2 <- polars0::pl$DataFrame(
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
#' test2 <- polars0::pl$DataFrame(
#'   x = c(1, 2, 4),
#'   y1 = c(1, 2, 4),
#'   z = c(4, 5, 7)
#' )
#'
#' left_join(test, test2, by = "x", suffix = c("_left", "_right"))
#'
#' # the argument "relationship" ensures the join matches the expectation
#' country <- polars0::pl$DataFrame(
#'   iso = c("FRA", "DEU"),
#'   value = 1:2
#' )
#' country
#'
#' country_year <- polars0::pl$DataFrame(
#'   iso = rep(c("FRA", "DEU"), each = 2),
#'   year = rep(2019:2020, 2),
#'   value2 = 3:6
#' )
#' country_year
#'
#' # We expect that each row in "x" matches only one row in "y" but, it's not
#' # true as each row of "x" matches two rows of "y"
#' tryCatch(
#'   left_join(country, country_year, join_by(iso), relationship = "one-to-one"),
#'   error = function(e) e
#' )
#'
#' # A correct expectation would be "one-to-many":
#' left_join(country, country_year, join_by(iso), relationship = "one-to-many")
left_join.RPolarsDataFrame <- function(
  x,
  y,
  by = NULL,
  copy = FALSE,
  suffix = c(".x", ".y"),
  ...,
  keep = NULL,
  na_matches = "na",
  relationship = NULL
) {
  check_unsupported_arg(copy = copy, keep = keep)
  check_dots_empty()
  join_(
    x = x,
    y = y,
    by = by,
    how = "left",
    suffix = suffix,
    na_matches = na_matches,
    relationship = relationship
  )
}

#' @rdname mutating-joins
#' @export
right_join.RPolarsDataFrame <- function(
  x,
  y,
  by = NULL,
  copy = FALSE,
  suffix = c(".x", ".y"),
  ...,
  keep = NULL,
  na_matches = "na",
  relationship = NULL
) {
  check_unsupported_arg(copy = copy, keep = keep)
  check_dots_empty()
  join_(
    x = x,
    y = y,
    by = by,
    how = "right",
    suffix = suffix,
    na_matches = na_matches,
    relationship = relationship
  )
}

#' @rdname mutating-joins
#' @export
full_join.RPolarsDataFrame <- function(
  x,
  y,
  by = NULL,
  copy = FALSE,
  suffix = c(".x", ".y"),
  ...,
  keep = NULL,
  na_matches = "na",
  relationship = NULL
) {
  check_unsupported_arg(copy = copy, keep = keep)
  check_dots_empty()
  join_(
    x = x,
    y = y,
    by = by,
    how = "full",
    suffix = suffix,
    na_matches = na_matches,
    relationship = relationship
  )
}

#' @rdname mutating-joins
#' @export
inner_join.RPolarsDataFrame <- function(
  x,
  y,
  by = NULL,
  copy = FALSE,
  suffix = c(".x", ".y"),
  ...,
  keep = NULL,
  na_matches = "na",
  relationship = NULL
) {
  check_unsupported_arg(copy = copy, keep = keep)
  check_dots_empty()
  join_(
    x = x,
    y = y,
    by = by,
    how = "inner",
    suffix = suffix,
    na_matches = na_matches,
    relationship = relationship
  )
}

#' @rdname mutating-joins
#' @export
left_join.RPolarsLazyFrame <- left_join.RPolarsDataFrame

#' @rdname mutating-joins
#' @export
right_join.RPolarsLazyFrame <- right_join.RPolarsDataFrame

#' @rdname mutating-joins
#' @export
full_join.RPolarsLazyFrame <- full_join.RPolarsDataFrame

#' @rdname mutating-joins
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
#' @inheritSection left_join.RPolarsDataFrame Unknown arguments
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' test <- polars0::pl$DataFrame(
#'   x = c(1, 2, 3),
#'   y = c(1, 2, 3),
#'   z = c(1, 2, 3)
#' )
#'
#' test2 <- polars0::pl$DataFrame(
#'   x = c(1, 2, 4),
#'   y = c(1, 2, 4),
#'   z2 = c(1, 2, 4)
#' )
#'
#' test
#'
#' test2
#'
#' # only keep the rows of `test` that have matching keys in `test2`
#' semi_join(test, test2, by = c("x", "y"))
#'
#' # only keep the rows of `test` that don't have matching keys in `test2`
#' anti_join(test, test2, by = c("x", "y"))
semi_join.RPolarsDataFrame <- function(
  x,
  y,
  by = NULL,
  ...,
  na_matches = "na"
) {
  check_dots_empty_ignore(..., .unsupported = "copy")
  join_(
    x = x,
    y = y,
    by = by,
    how = "semi",
    suffix = NULL,
    na_matches = na_matches,
    relationship = NULL
  )
}

#' @rdname semi_join.RPolarsDataFrame
#' @export

anti_join.RPolarsDataFrame <- function(
  x,
  y,
  by = NULL,
  ...,
  na_matches = "na"
) {
  check_dots_empty_ignore(..., .unsupported = "copy")
  join_(
    x = x,
    y = y,
    by = by,
    how = "anti",
    suffix = NULL,
    na_matches = na_matches,
    relationship = NULL
  )
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
#' @inheritSection left_join.RPolarsDataFrame Unknown arguments
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' test <- polars0::pl$DataFrame(
#'   origin = c("ALG", "FRA", "GER"),
#'   year = c(2020, 2020, 2021)
#' )
#'
#' test2 <- polars0::pl$DataFrame(
#'   destination = c("USA", "JPN", "BRA"),
#'   language = c("english", "japanese", "portuguese")
#' )
#'
#' test
#'
#' test2
#'
#' cross_join(test, test2)
cross_join.RPolarsDataFrame <- function(x, y, ..., suffix = c(".x", ".y")) {
  check_dots_empty_ignore(..., .unsupported = "copy")
  join_(
    x = x,
    y = y,
    by = NULL,
    how = "cross",
    suffix = suffix,
    na_matches = NULL,
    relationship = NULL
  )
}

#' @rdname cross_join.RPolarsDataFrame
#' @export
cross_join.RPolarsLazyFrame <- cross_join.RPolarsDataFrame

join_ <- function(x, y, by = NULL, how, suffix, na_matches, relationship) {
  all_df_or_lf <- all(
    vapply(
      list(x, y),
      inherits,
      what = "RPolarsDataFrame",
      FUN.VALUE = logical(1L)
    )
  ) ||
    all(
      vapply(
        list(x, y),
        inherits,
        what = "RPolarsLazyFrame",
        FUN.VALUE = logical(1L)
      )
    )

  if (!all_df_or_lf) {
    cli_abort(
      "{.code x} and {.code y} must be either two DataFrames or two LazyFrames.",
      call = caller_env()
    )
  }

  if (!is.null(suffix) && length(suffix) != 2) {
    cli_abort(
      "{.code suffix} must be of length 2.",
      call = caller_env()
    )
  }

  if (!is.null(relationship)) {
    validate <- switch(
      relationship,
      "many-to-many" = "m:m",
      "one-to-one" = "1:1",
      "many-to-one" = "m:1",
      "one-to-many" = "1:m",
      cli_abort(
        "{.code relationship} must be one of \"one-to-one\", \"one-to-many\", \"many-to-one\", or \"many-to-many\", not {.val {relationship}}.",
        call = caller_env()
      )
    )
  } else {
    validate <- "m:m"
  }

  if (is.null(na_matches)) {
    join_nulls <- FALSE
  } else {
    join_nulls <- switch(
      na_matches,
      "na" = TRUE,
      "never" = FALSE,
      cli_abort(
        "{.code na_matches} must be one of \"na\" or \"never\", not {.val {na_matches}}.",
        call = caller_env()
      )
    )
  }

  if (is.null(by) && how != "cross") {
    by <- intersect(names(x), names(y))
    if (length(by) == 0) {
      cli_abort(
        c(
          "{.code by} must be supplied when {.code x} and {.code y} have no common variables.",
          "i" = "Use {.fn cross_join} to perform a cross-join."
        ),
        call = caller_env()
      )
    }
    rlang::inform(
      paste0("Joining by ", paste0("`", by, "`", collapse = ", "))
    )
  }

  if (is_inequality_join(by)) {
    out <- eval_inequality_join(x, y, how, by, suffix)
    return(out)
  }

  by <- unpack_join_by(by)

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
    setdiff(names(x), by),
    setdiff(names(y), by)
  )

  if (how == "right") {
    out <- y$join(
      other = x,
      left_on = left_on,
      right_on = right_on,
      how = "left",
      join_nulls = join_nulls,
      validate = validate
    )
  } else {
    out <- x$join(
      other = y,
      left_on = left_on,
      right_on = right_on,
      how = how,
      join_nulls = join_nulls,
      validate = validate,
      coalesce = TRUE
    )
  }

  out <- if (length(dupes) > 0) {
    mapping <- as.list(c(paste0(dupes, suffix[1]), paste0(dupes, suffix[2])))
    names(mapping) <- c(dupes, paste0(dupes, "_right"))
    out$rename(mapping)
  } else {
    out
  }
  add_tidypolars_class(out)
}

unpack_join_by <- function(by) {
  if (inherits(by, "dplyr_join_by")) {
    out <- by$y
    names(out) <- by$x
    out
  } else {
    by
  }
}

is_inequality_join <- function(by) {
  inherits(by, "dplyr_join_by") && !all(by$condition == "==")
}

eval_inequality_join <- function(x, y, how, by, suffix) {
  if (how != "inner") {
    cli_abort(
      "Inequality joins are only supported in {.fn inner_join} for now.",
      call = caller_env(2)
    )
  }
  by2 <- by

  common_cols <- intersect(names(x), names(y))

  by2$x <- lapply(by2$x, function(elem) {
    pl$col(as.character(elem))
  })

  by2$y <- lapply(by2$y, function(elem) {
    if (length(common_cols) > 0 && as.character(elem) %in% common_cols) {
      pl$col(paste0(as.character(elem), suffix[2]))
    } else {
      pl$col(as.character(elem))
    }
  })

  by3 <- lapply(seq_along(by$condition), function(i) {
    if (by$condition[i] == "==") {
      by2$x[[i]]$eq(by2$y[[i]])
    } else if (by$condition[i] == ">") {
      by2$x[[i]]$gt(by2$y[[i]])
    } else if (by$condition[i] == ">=") {
      by2$x[[i]]$gt_eq(by2$y[[i]])
    } else if (by$condition[i] == "<") {
      by2$x[[i]]$lt(by2$y[[i]])
    } else if (by$condition[i] == "<=") {
      by2$x[[i]]$lt_eq(by2$y[[i]])
    }
  })

  res <- x$join_where(y, by3, suffix = suffix[2])
  if (length(common_cols) > 0) {
    # Only keep common columns that were involved in inequality joins, otherwise
    # they just don't have a duplicate in the output
    common_cols <- Filter(
      function(x) paste0(x, suffix[2]) %in% names(res),
      common_cols
    )
    new_cols <- as.list(paste0(common_cols, suffix[1]))
    names(new_cols) <- common_cols
    res <- res$rename(new_cols)
  }
  res
}
