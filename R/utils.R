utils::globalVariables(c("name", "value"))

get_dots <- function(...) {
  eval(substitute(alist(...)))
}

safe_deparse <- function(x, ...) {
  if (is.null(x)) {
    return(NULL)
  }
  paste(
    vapply(deparse(x, width.cutoff = 500), trimws, FUN.VALUE = character(1)),
    collapse = " "
  )
}

# sort of equivalent of purrr::compact()
# takes a list, returns a list
compact <- function(x) {
  Filter(\(y) length(y) != 0, x)
}

# takes a list, returns a list with only length-0 elements
empty_elems <- function(x) {
  Filter(\(y) length(y) == 0, x)
}

# take a string, replace \\1 by $1, \\2 by $2, etc.
# this is to match Polars syntax for regexes
parse_replacement <- function(x) {
  gsub("\\\\(\\d+)", "$\\1", x)
}

get_grps <- function(.data, .by, env) {
  grps <- attributes(.data)$pl_grps
  inline_grps <- tidyselect_named_arg(.data, .by)
  if (length(inline_grps) > 0) {
    if (!is.null(grps)) {
      cli_abort(
        "Can't supply {.code .by} when {.code .data} is a grouped DataFrame or LazyFrame.",
        call = env
      )
    } else {
      grps <- inline_grps
    }
  }
  grps
}

`%||%` <- function(x, y) {
  if (is_null(x)) y else x
}

# takes a character vector, returns a named list where the name is the duplicated
# value and the values are its positions
get_dupes <- function(x) {
  y <- table(x)
  dup <- names(y[y > 1])
  out <- lapply(dup, function(z) which(x == z))
  names(out) <- dup
  out
}

make_dupes_msg <- function(x) {
  msgs <- vector("list", length = length(x))
  for (i in seq_along(x)) {
    msgs[[i]] <- paste0("`", names(x)[i], "` (", toString(x[[i]]), ")")
  }
  if (length(msgs) > 3) {
    final_msg <- paste0(toString(msgs[1:3]), ", ...")
  } else {
    final_msg <- toString(msgs)
  }
  final_msg
}

# Extract an argument value from a quosure, first by its name if it's named,
# then by its expected position
select_by_name_or_position <- function(expr, name, position, default, env) {
  # first position is the operator in expr, so I add 1 to get the real position
  position <- position + 1
  if (name %in% names(expr)) {
    expr[[name]]
  } else if (length(expr) >= position) {
    expr[[position]]
  } else {
    default
  }
}

# Check that dots are not used, but throw a custom error when some args are
# supported by tidyverse but not tidypolars.
check_dots_empty_ignore <- function(..., .unsupported = NULL) {
  dots <- enquos(...)
  rlang_action <- getOption("tidypolars_unknown_args", "warn")
  unsupported_dots <- names(dots[.unsupported])
  unsupported_dots <- unsupported_dots[!is.na(unsupported_dots)]

  if (length(unsupported_dots) > 0) {
    msg <- "{qty(unsupported_dots)} Argument{?s} {.code {unsupported_dots}} {?is/are} not supported by {.pkg tidypolars}."

    if (rlang_action == "warn") {
      cli_warn(msg, call = caller_env())
    } else if (rlang_action == "error") {
      cli_abort(
        c(
          msg,
          "i" = "Use {.code options(tidypolars_unknown_args = \"warn\")} to warn when this happens instead of throwing an error."
        ),
        call = caller_env()
      )
    }

    for (i in .unsupported) {
      dots[[i]] <- NULL
    }
  }

  if (length(dots) > 0) {
    cli_abort("{.code ...} must be empty.", call = caller_env())
  }
}

# mostly to make R CMD check happy about S3 consistency
check_unsupported_arg <- function(...) {
  dots <- list2(...)
  if ("copy" %in% names(dots) && isFALSE(dots[["copy"]])) {
    dots[["copy"]] <- NULL
  }
  unsupported_args <- names(Filter(Negate(is.null), dots))
  rlang_action <- getOption("tidypolars_unknown_args", "warn")

  if (length(unsupported_args) == 0) {
    return(invisible())
  }

  msg <- "{qty(unsupported_args)} Argument{?s} {.code {unsupported_args}} {?is/are} not supported by {.pkg tidypolars}."

  if (rlang_action == "warn") {
    cli_warn(msg, call = caller_env())
  } else if (rlang_action == "error") {
    cli_abort(
      c(
        msg,
        "i" = "Use {.code options(tidypolars_unknown_args = \"warn\")} to warn when this happens instead of throwing an error."
      ),
      call = caller_env()
    )
  }
}

check_integerish <- function(x, name, allow_na = TRUE) {
  x <- polars_expr_to_r(x)
  if (is.na(x) && allow_na) {
    return(invisible())
  }
  if (!rlang::is_integerish(x)) {
    cli_abort("{.code {name}} must be integerish.")
  }
}

is_list_of_polars_expr <- function(x, n = NULL) {
  is_list_of_polars_expr_impl <- function(x) {
    for (i in seq_along(x)) {
      if (!is_polars_expr(x[[i]])) {
        return(FALSE)
      }
    }
    TRUE
  }
  is_list(x, n = n) && is_list_of_polars_expr_impl(x)
}
