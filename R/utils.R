get_dots <- function(...) {
  eval(substitute(alist(...)))
}

# Code adapted from {datawizard}
# License GPL-3

.select_nse_from_dots <- function(.data, ...) {
  columns <- pl_colnames(.data)

  # avoid conflicts
  conflicting_packages <- .conflicting_packages("poorman")
  on.exit(.attach_packages(conflicting_packages))

  dots <- get_dots(...)

  selected <- lapply(dots, \(x) .eval_expr(x, .data = .data )) |>
    unlist() |>
    unique()

  selected <- selected[!is.na(selected)]

  columns[selected]
}

.select_nse_from_var <- function(.data, var) {
  columns <- pl_colnames(.data)

  # avoid conflicts
  conflicting_packages <- .conflicting_packages("poorman")
  on.exit(.attach_packages(conflicting_packages))

  dots <- str2lang(var)

  selected <- .eval_expr(dots, .data) |>
    unique()

  columns[selected]
}


# This is where we dispatch the expression to several helper functions.
# This function is called multiple times for expressions that are composed
# of several symbols/language.
#
# Ex:
# * "cyl" -> will go to .select_char() and will return directly
# * cyl:gear -> function (`:`) so find which function it is, then get the
#   position for each variable, then evaluate the function with the positions

.eval_expr <- function(x, .data) {
  if (is.null(x)) {
    return(NULL)
  }

  type <- typeof(x)

  out <- switch(
    type,
    "integer" = x,
    "double" = as.integer(x),
    "character" = .select_char(.data, x),
    "symbol" = .select_symbol(.data, x),
    "language" = .eval_call(.data, x),
    stop(
      paste0(
        "Expressions of type <",
        typeof(x),
        "> cannot be evaluated for use when subsetting."
      )
    )
  )

  out
}


# Possibilities:
# - quoted variable name
# - quoted variable name with ignore case
# - character that should be regex-ed on variable names
# - special word "all" to return all vars

.select_char <- function(.data, x, verbose = TRUE) {
  # use colnames because names() doesn't work for matrices
  columns <- pl_colnames(.data)
  if (length(x) == 1L && x == "all") {
    seq_len(length(columns))
  } else {
    matches <- match(x, columns)
    if (isTRUE(verbose) && anyNA(matches)) {
      warning(
        paste0("Following variable(s) were not found: ",
               toString(x[is.na(matches)]))
      )
    }
    matches[!is.na(matches)]
  }
}

# 3 types of symbols:
# - unquoted variables
# - objects that need to be evaluated, e.g data_find(iris, i) where i is a
#   function arg or is defined before. This can also be a vector of names or
#   positions.
# - functions (without parenthesis)

# The first case is easy to deal with.
# For the 2nd one, we try to get the value of the object at each environment
# (starting from the lower one) until the global environment. If we get its
# value but it errors because the function doesn't exist then it means that
# it is a select helper that we grab from the error message.

.select_symbol <- function(.data, x) {
  try_eval <- try(eval(x), silent = TRUE)
  x_dep <- deparse(x)
  is_select_helper <- FALSE
  out <- NULL

  if (x_dep %in% pl_colnames(.data)) {
    matches <- match(x_dep, pl_colnames(.data))
    out <- matches[!is.na(matches)]
  } else {
    new_expr <- tryCatch(
      dynGet(x, inherits = FALSE, minframe = 0L),
      error = function(e) {
        # if starts_with() et al. don't exist
        fn <- deparse(e$call)

        # if starts_with() et al. come from tidyselect but need to be used in
        # a select environment, then the error doesn't have the same structure.
        if (is.null(fn) &&
            grepl("must be used within a", e$message, fixed = TRUE)) {
          trace <- lapply(e$trace$call, function(x) {
            tmp <- deparse(x)
            if (grepl(paste0("^", .regex_select_helper()), tmp)) {
              tmp
            }
          })
          fn <- Filter(Negate(is.null), trace)[1]
        }
        # if we actually obtain the select helper call, return it, else return
        # what we already had
        if (length(fn) > 0L && grepl(.regex_select_helper(), fn)) {
          is_select_helper <<- TRUE
          return(fn)
        } else {
          NULL
        }
      }
    )

    # when "x" is a function arg which is itself a function call to evaluate,
    # dynGet can return "x" infinitely so we try to evaluate this arg
    # see #414
    if (!is.null(new_expr) && deparse(new_expr) == "x") {
      new_expr <-
        .dynEval(
          x,
          inherits = FALSE,
          minframe = 0L,
          remove_n_top_env = 4
        )
    }

    if (is_select_helper) {
      new_expr <- str2lang(unlist(new_expr, use.names = FALSE))
      out <- .eval_expr(
        new_expr,
        .data = .data
      )
    } else if (length(new_expr) == 1L && is.function(new_expr)) {
      out <- which(vapply(.data, new_expr, FUN.VALUE = logical(1L)))
    } else {
      out <- unlist(
        lapply(
          new_expr,
          .eval_expr,
          .data = .data
        ),
        use.names = FALSE
      )
    }
  }

  # sometimes an object that needs to be evaluated has the same name as a
  # function (e.g `colnames`). Vector of names have the priority on functions
  # so function evaluation is delayed at the max.
  if (is.null(out) && is.function(try_eval)) {
    cols <- names(.data)
    out <- which(vapply(.data, x, FUN.VALUE = logical(1L)))
  }

  out
}

# Dispatch expressions to various select helpers according to the function call

.eval_call <- function(.data, x) {
  type <- deparse(x[[1]])

  switch(
    type,
    `:` = .select_seq(x, .data),
    `-` = .select_minus(x, .data),
    `!` = .select_bang(x, .data),
    `c` = .select_c(x, .data),
    `(` = .select_bracket(x, .data),
    "last_col" = .select_last(x, .data),
    "everything" = .select_all(x, .data),
    "num_range" = .select_num_range(x, .data),
    "starts_with" = ,
    "ends_with" = ,
    "matches" = ,
    "contains" = ,
    "regex" = .select_helper(x, .data),
    "all_of" = ,
    "any_of" = .select_vector(x, .data),
    "where" = .select_where(x, .data),
    .select_context(x, .data)
  )
}

# e.g 1:3, or gear:cyl
.select_seq <- function(expr, .data) {
  x <- .eval_expr(
    expr[[2]],
    .data = .data
  )
  y <- .eval_expr(
    expr[[3]],
    .data = .data
  )
  x:y
}

# e.g -cyl
.select_minus <- function(expr, .data) {
  x <- .eval_expr(
    expr[[2]],
    .data
  )
  if (length(x) == 0L) {
    seq_along(.data)
  } else {
    x * -1L
  }
}

# e.g !cyl
.select_bang <- function(expr, .data) {
  x <- .eval_expr(
    expr[[2]],
    .data
  )
  if (length(x) == 0L) {
    seq_along(.data)
  } else {
    x * -1L
  }
}

# e.g c("gear", "cyl")
.select_c <- function(expr, .data) {
  lst_expr <- as.list(expr)
  lst_expr[[1]] <- NULL
  unlist(
    lapply(
      lst_expr,
      .eval_expr,
      .data
    ),
    use.names = FALSE
  )
}

# e.g -(gear:cyl)
.select_bracket <- function(expr, .data) {
  .eval_expr(
    expr[[2]],
    .data
  )
}

# e.g last_col()
.select_last <- function(expr, .data) {
  lst_expr <- as.list(expr)
  if (length(lst_expr) == 1) { # last_col()
    ncol(.data)
  } else { # last_col(offset = 1)
    if ("offset" %in% names(lst_expr)) {
      offset <- lst_expr$offset
    } else {
      offset <- lst_expr[[2]]
    }
    ncol(.data) - offset
  }
}

# e.g everything()
.select_all <- function(expr, .data) {
  seq_len(length(pl_colnames(.data)))
}

# e.g num_range("x", 2:5)
.select_num_range <- function(expr, .data) {
  lst_expr <- as.list(expr)
  if ("prefix" %in% names(lst_expr)) {
    prefix <- lst_expr$prefix
  } else {
    prefix <- lst_expr[[2]]
  }
  if ("range" %in% names(lst_expr)) {
    range <- eval(lst_expr$range)
  } else {
    range <- eval(lst_expr[[3]])
  }
  if ("suffix" %in% names(lst_expr)) {
    suffix <- lst_expr$suffix
  } else {
    suffix <- ""
  }
  if ("width" %in% names(lst_expr)) {
    width <- lst_expr$width
  } else {
    width <- 1
  }

  if (width != 1) {
    range <- as.character(range)
    nchar_range <- nchar(range)
    n_rep <- width - nchar_range
    # TODO: there has to be a better way than this loop
    for (i in seq_along(n_rep)) {
      range[i] <- paste0(rep("0", n_rep[i]), range[i])
    }
  }

  vars <- paste0(prefix, range)
  vars <- paste0(vars, suffix)

  .select_char(.data, vars, verbose = FALSE)
}

# e.g all_of(x) or any_of(x)
.select_vector <- function(expr, .data) {
  lst_expr <- as.list(expr)
  vars <- dynGet(lst_expr[[2]], inherits = FALSE, minframe = 0L)
  if (lst_expr[[1]] == "all_of" && !all(vars %in% pl_colnames(.data))) {
    stop(
      paste0("In `all_of()`: some elements of `", safe_deparse(lst_expr[[2]]),
             "`` do not correspond to any column names.")
    )
  }
  .select_char(.data, vars, verbose = FALSE)
}

# e.g where(is.numeric)
.select_where <- function(expr, .data) {
  lst_expr <- as.list(expr)
  fn <- safe_deparse(lst_expr[[2]])

  if (!startsWith(fn, "is.")) {
    stop("`where()` can only take `is.*` functions (like `is.numeric`).")
  }

  vars <- switch(
    fn,
    "is.character" = is_polars_character(.data$schema),
    "is.numeric" = is_polars_numeric(.data$schema),
    "is.factor" = is_polars_factor(.data$schema),
    "is.logical" = is_polars_logical(.data$schema),
    "is.Date" = is_polars_date(.data$schema)
  )

  which(vars)
}

# e.g starts_with("Sep")
.select_helper <- function(expr, .data) {
  lst_expr <- as.list(expr)

  # need this if condition to distinguish between starts_with("Sep") (that we
  # can use directly) and starts_with(i) (where we need to get i)
  if (length(lst_expr) == 2L && typeof(lst_expr[[2]]) == "symbol") {
    collapsed_patterns <-
      dynGet(lst_expr[[2]], inherits = FALSE, minframe = 0L)
  } else {
    lst_expr[[2]] <- eval(lst_expr[[2]])
    collapsed_patterns <-
      paste(unlist(lst_expr[2:length(lst_expr)]), collapse = "|")
  }

  helper <- deparse(lst_expr[[1]])

  rgx <- switch(
    helper,
    "starts_with" = paste0("^(", collapsed_patterns, ")"),
    "ends_with" = paste0("(", collapsed_patterns, ")$"),
    "contains" = paste0("(", collapsed_patterns, ")"),
    "matches" = ,
    "regex" = collapsed_patterns,
    stop("There is no select helper called '", helper, "'.")
  )
  grep(rgx, pl_colnames(.data))
}

# e.g is.numeric()
.select_context <- function(expr, .data) {
  x_dep <- deparse(expr)
  if (endsWith(x_dep, "()")) {
    new_expr <- gsub("\\(\\)$", "", x_dep)
    new_expr <- str2lang(new_expr)
    .eval_expr(
      new_expr,
      .data = .data
    )
  } else {
    out <- .dynEval(expr, inherits = FALSE, minframe = 0L)
    .eval_expr(
      out,
      .data = .data
    )
  }
}

# -------------------------------------

.regex_select_helper <- function() {
  "(starts\\_with|ends\\_with|col\\_ends\\_with|contains|regex)"
}

.conflicting_packages <- function(packages = NULL) {
  if (is.null(packages)) {
    packages <- "poorman"
  }

  namespace <-
    vapply(packages, isNamespaceLoaded, FUN.VALUE = logical(1L))
  attached <- paste0("package:", packages) %in% search()
  attached <- stats::setNames(attached, packages)

  for (i in packages) {
    unloadNamespace(i)
  }

  list(package = packages,
       namespace = namespace,
       attached = attached)
}

.attach_packages <- function(packages = NULL) {
  if (!is.null(packages)) {
    pkg <- packages$package
    for (i in seq_along(pkg)) {
      if (isTRUE(packages$namespace[i])) {
        loadNamespace(pkg[i])
      }
      if (isTRUE(packages$attached[i])) {
        suppressPackageStartupMessages(suppressWarnings(require(
          pkg[i], quietly = TRUE, character.only = TRUE
        )))
      }
    }
  }
}

# Similar to dynGet() but instead of getting an object from the environment,
# we try to evaluate an expression. It stops as soon as the evaluation doesn't
# error. Returns NULL if can never be evaluated.
#
# Custom arg "remove_n_top_env" to remove the first environments which are
# ".select_nse_from_dots()" and the other custom functions
.dynEval <- function(x,
                     ifnotfound = stop(gettextf("%s not found", sQuote(x)), domain = NA),
                     minframe = 1L,
                     inherits = FALSE,
                     remove_n_top_env = 0) {
  n <- sys.nframe() - remove_n_top_env
  x <- deparse(x)
  while (n > minframe) {
    n <- n - 1L
    env <- sys.frame(n)
    r <- try(eval(str2lang(x), envir = env), silent = TRUE)
    if (!inherits(r, "try-error") && !is.null(r)) {
      return(r)
    }
  }
  ifnotfound
}


safe_deparse <- function (x, ...) {
  if (is.null(x)) {
    return(NULL)
  }
  paste0(sapply(deparse(x, width.cutoff = 500), trimws, simplify = TRUE),
         collapse = " ")
}

is_polars_numeric <- function(schema) {
  vapply(schema, \(x) {
    x == polars::pl$Float32 | x == polars::pl$Float64 |
      x == polars::pl$UInt8 | x == polars::pl$UInt16 | x == polars::pl$UInt32 | x == polars::pl$UInt64 |
      x == polars::pl$Int8  |x == polars::pl$Int16 | x == polars::pl$Int32 | x == polars::pl$Int64
  }, FUN.VALUE = logical(1L))
}

is_polars_factor <- function(schema) {
  vapply(schema, \(x) {
    x == polars::pl$Categorical
  }, FUN.VALUE = logical(1L))
}

is_polars_character <- function(schema) {
  vapply(schema, \(x) {
    x == polars::pl$Utf8
  }, FUN.VALUE = logical(1L))
}

is_polars_logical <- function(schema) {
  vapply(schema, \(x) {
    x == polars::pl$Boolean
  }, FUN.VALUE = logical(1L))
}

is_polars_date <- function(schema) {
  vapply(schema, \(x) {
    x == polars::pl$Date | x == polars::pl$Time
  }, FUN.VALUE = logical(1L))
}
