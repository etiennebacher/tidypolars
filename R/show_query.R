#' Show the polars code equivalent to the tidypolars pipeline
#'
#' @description
#' `show_query()` prints the pure polars code that `tidypolars` runs in the
#' background. This code can be copy-pasted and run with `polars` only (the
#' input data must be assigned to the name displayed in the first line of the
#' query).
#'
#' Recording the query is enabled by default. It can be disabled with
#' `options(tidypolars_record_query = FALSE)`, in which case `show_query()`
#' errors (see [tidypolars_options]). Objects created while recording was
#' disabled cannot show their query.
#'
#' Some values cannot be displayed in a copy-pasteable way, for example long
#' vectors coming from the calling environment (those are truncated and shown
#' as a placeholder like `` `<numeric of length 200>` ``).
#'
#' @param x A Polars Data/LazyFrame that went through `tidypolars` functions.
#' @param ... Not used.
#'
#' @return The input, invisibly. This function is called for its side effect
#' of printing the polars query.
#' @export
#' @examplesIf require("dplyr", quietly = TRUE)
#' mtcars |>
#'   as_polars_lf() |>
#'   filter(cyl == 4) |>
#'   mutate(mpg2 = mpg * 2, .by = am) |>
#'   show_query()
show_query.polars_data_frame <- function(x, ...) {
  text <- tp_query_text(x)
  if (is.null(text)) {
    cli_abort(
      c(
        "No polars query was recorded for this object.",
        "i" = "The query is only recorded when the option {.code tidypolars_record_query} is {.code TRUE} (the default) while the {.pkg tidypolars} functions are applied.",
        "i" = "See {.code ?tidypolars_options}."
      )
    )
  }
  cat(format_polars_query(text), "\n", sep = "")
  invisible(x)
}

#' @rdname show_query.polars_data_frame
#' @export
show_query.polars_lazy_frame <- show_query.polars_data_frame

# ------------------------------------------------------------------------
# Query recording infrastructure.
#
# All polars objects (`pl` itself, Data/LazyFrames, expressions, and
# sub-namespaces like `<expr>$str`) are environments whose methods are
# accessed with `$`. We prepend the class "tp_recorded" to those objects,
# which allows `$.tp_recorded` to intercept every method call: it runs the
# real method and stores the R code of the call in the "tp_query" attribute
# of the output. Untagged objects and disabled recording go through the
# regular polars `$` untouched.
# ------------------------------------------------------------------------

query_recording_enabled <- function() {
  isTRUE(getOption("tidypolars_record_query", TRUE))
}

tp_query_text <- function(x) {
  attr(x, "tp_query", exact = TRUE)
}

# Polars objects are environments so cloning is required before tagging
# objects we don't own (e.g. the user's input frame), otherwise the tag would
# be added to the original object by reference. rlang::env_clone() drops
# attributes so they must be carried over manually.
clone_env_with_attrs <- function(x) {
  out <- env_clone(x)
  attributes(out) <- attributes(x)
  out
}

# S7 objects (e.g. `pl$QueryOptFlags()`) are also taggable: contrary to
# other polars objects they are not environments, so they have value
# semantics and modifying their attributes is always safe.
tag_polars <- function(x, text) {
  if (inherits(x, c("polars_object", "S7_object"))) {
    if (!inherits(x, "tp_recorded")) {
      class(x) <- c("tp_recorded", class(x))
    }
    attr(x, "tp_query") <- text
  }
  x
}

# Called at the entry of user-facing verbs: starts the recording on frames
# that don't have a query yet. `expr` (the expression the user passed as
# input data) provides the name displayed as the source of the query.
tag_frame <- function(x, expr = NULL) {
  if (
    !query_recording_enabled() ||
      !inherits(x, "polars_object") ||
      inherits(x, "tp_recorded")
  ) {
    return(x)
  }
  header <- if (is.null(expr)) NULL else safe_deparse(expr)
  if (is.null(header) || length(header) != 1 || nchar(header) > 80) {
    header <- "`<data>`"
  }
  tag_polars(clone_env_with_attrs(x), header)
}

# One-shot flag: when a recording wrapper re-evaluates the original call
# (see wrap_polars_member()), the `$` method must hand out the real polars
# member instead of wrapping it again.
tp_recorder <- new.env(parent = emptyenv())
tp_recorder$skip_next <- FALSE

#' @export
`$.tp_recorded` <- function(x, name) {
  if (tp_recorder$skip_next) {
    tp_recorder$skip_next <- FALSE
    return(NextMethod())
  }
  # Frame methods called by polars internally (e.g. the eager `$unique()`
  # calls `self$lazy()$unique()$collect()`) must not be recorded: only the
  # user-facing call is part of the query, and wrapping internal calls would
  # alter the calls displayed in polars error messages. This must not apply
  # to expressions: methods like `$eq()` are legitimately called from the
  # polars namespace via group generics (e.g. `Ops.polars_expr` for `==`).
  if (
    inherits(x, c("polars_data_frame", "polars_lazy_frame")) &&
      identical(topenv(parent.frame()), asNamespace("polars"))
  ) {
    return(NextMethod())
  }
  member <- NextMethod()
  if (!query_recording_enabled()) {
    return(member)
  }
  wrap_polars_member(x, member, tp_query_text(x) %||% "`<data>`", name)
}

# `pl` defined here shadows the one imported from polars everywhere in the
# package, so that expressions built internally (e.g. in funs-*.R) record
# their own code. When recording is disabled this only costs one extra
# environment lookup.
pl <- structure(new.env(parent = emptyenv()), class = "tidypolars_pl")

#' @export
`$.tidypolars_pl` <- function(x, name) {
  if (!exists(name, envir = polars::pl, inherits = FALSE)) {
    # Same error as `polars:::$.polars_object`
    abort(sprintf(
      "$ - syntax error: `%s` is not a member of this polars object",
      name
    ))
  }
  member <- polars::pl[[name]]
  if (tp_recorder$skip_next) {
    tp_recorder$skip_next <- FALSE
    return(member)
  }
  if (!query_recording_enabled()) {
    return(member)
  }
  wrap_polars_member(x, member, "pl", name)
}

wrap_polars_member <- function(holder, member, parent_text, name) {
  if (is.function(member)) {
    if (name == "clone") {
      # $clone() doesn't change the data: carry the query over without
      # recording the call.
      function(...) tag_polars(member(...), parent_text)
    } else {
      prefix <- paste0(parent_text, "$", name)
      function(...) {
        # polars builds its error messages from the call of the method's
        # execution frame (e.g. "Error in `.data$collect()`: Evaluation
        # failed in `$collect()`."). To keep those messages intact, the real
        # method is not called directly (the call would be displayed as
        # `member(...)`): we re-evaluate a call with the original shape,
        # where the receiver (already evaluated, so nothing runs twice) is
        # bound in a child environment of the caller and
        # `tp_recorder$skip_next` makes the `$` re-dispatch return the real
        # polars method this time.
        cl <- sys.call()
        original_call_shape <- is.call(cl) &&
          is.call(cl[[1]]) &&
          identical(cl[[1]][[1]], quote(`$`))
        out <- if (original_call_shape) {
          lhs <- cl[[1]][[2]]
          lhs_name <- if (is.symbol(lhs)) {
            as.character(lhs)
          } else {
            safe_deparse(lhs)
          }
          eval_env <- new.env(parent = parent.frame())
          assign(lhs_name, holder, envir = eval_env)
          cl[[1]][[2]] <- as.name(lhs_name)
          tp_recorder$skip_next <- TRUE
          on.exit(tp_recorder$skip_next <- FALSE)
          eval(cl, eval_env)
        } else {
          member(...)
        }
        if (inherits(out, c("polars_object", "S7_object"))) {
          if (inherits(out, "tp_recorded") && is.environment(out)) {
            # The method returned one of its (already tagged) inputs:
            # tagging it directly would corrupt the query of the input.
            out <- clone_env_with_attrs(out)
          }
          # Recording must never turn a working pipeline into an error: any
          # failure degrades to a placeholder.
          text <- tryCatch(
            paste0(prefix, "(", deparse_query_dots(...), ")"),
            error = function(e) paste0(prefix, "(`<...>`)")
          )
          out <- tag_polars(out, text)
        }
        out
      }
    }
  } else if (inherits(member, c("polars_object", "S7_object"))) {
    # Sub-namespaces such as `<expr>$str` or `<expr>$meta`, and datatypes
    # like `pl$Int64`.
    if (is.environment(member)) {
      member <- clone_env_with_attrs(member)
    }
    tag_polars(member, paste0(parent_text, "$", name))
  } else {
    member
  }
}

deparse_query_dots <- function(...) {
  # dots_list() is required to handle `!!!` splicing, which polars methods
  # support in their own dots collection. Polars methods also internally
  # forward dots that can contain missing arguments, hence
  # `.preserve_empty` and the extra care below to never force a missing
  # argument.
  args <- tryCatch(
    dots_list(..., .preserve_empty = TRUE, .ignore_empty = "none"),
    error = function(e) NULL
  )

  if (!is.null(args)) {
    n <- length(args)
    if (n == 0) {
      return("")
    }
    nms <- names(args) %||% character(n)
    nms[is.na(nms)] <- ""
    dep <- vapply(
      seq_len(n),
      \(i) {
        if (is_missing(args[[i]])) "" else deparse_query_arg(args[[i]])
      },
      character(1)
    )
    pieces <- ifelse(nms == "", dep, paste0(nms, " = ", dep))
    return(paste(drop_trailing_empty_args(pieces), collapse = ", "))
  }

  # dots_list() errored, e.g. because forcing a forwarded argument failed:
  # fall back to forcing each element individually.
  n <- ...length()
  if (n == 0) {
    return("")
  }
  nms <- ...names() %||% character(n)
  nms[is.na(nms)] <- ""
  out <- character(n)
  for (i in seq_len(n)) {
    dep <- tryCatch(
      {
        val <- ...elt(i)
        if (missing(val)) "" else deparse_query_arg(val)
      },
      error = function(e) ""
    )
    out[i] <- if (nms[i] == "") dep else paste0(nms[i], " = ", dep)
  }
  paste(drop_trailing_empty_args(out), collapse = ", ")
}

# A trailing comma in a call (accepted by polars methods collecting dots)
# would be recorded as a dangling empty argument.
drop_trailing_empty_args <- function(pieces) {
  while (length(pieces) > 0 && pieces[length(pieces)] == "") {
    pieces <- pieces[-length(pieces)]
  }
  pieces
}

deparse_query_arg <- function(x) {
  if (inherits(x, "tp_recorded")) {
    tp_query_text(x) %||% "`<polars object>`"
  } else if (inherits(x, "polars_object")) {
    # Object created with polars directly, outside of tidypolars: we cannot
    # recover its R code.
    "`<polars object>`"
  } else if (is.environment(x)) {
    "`<environment>`"
  } else if (is.list(x) && !is.object(x)) {
    inner <- vapply(x, deparse_query_arg, character(1))
    nms <- names(x) %||% character(length(x))
    nms[is.na(nms)] <- ""
    inner <- ifelse(nms == "", inner, paste0(nms, " = ", inner))
    paste0("list(", paste(inner, collapse = ", "), ")")
  } else if (is.atomic(x) && length(x) > 100) {
    paste0("`<", class(x)[1], " of length ", length(x), ">`")
  } else {
    attr(x, "tp_query") <- NULL
    dep <- deparse1(x)
    if (nchar(dep) > 300) {
      dep <- paste0("`<", class(x)[1], " value too long to display>`")
    } else if (
      is.object(x) &&
        !tryCatch(
          {
            parse(text = dep)
            TRUE
          },
          error = function(e) FALSE
        )
    ) {
      # Objects whose deparse isn't valid R code, e.g. S7 objects created
      # outside of tidypolars deparse to "<object>".
      dep <- paste0("`<", class(x)[1], ">`")
    }
    dep
  }
}

# ------------------------------------------------------------------------
# Formatting:
# - one line per method called on the Data/LazyFrame (lines end with "$" so
#   that the printed block can be copy-pasted as is);
# - those calls get one argument per line when they have several arguments,
#   or when they don't fit on the line;
# - inside arguments, the same rules apply recursively but only when the
#   line is too long, so that short values like `c(FALSE, TRUE)` stay
#   inline.
# ------------------------------------------------------------------------

tp_query_width <- 80L

format_polars_query <- function(text) {
  parts <- split_chain_merged(text)
  parts <- vapply(
    seq_along(parts),
    # the first part starts at column 0, the other ones are indented by 2
    \(i) {
      format_call_segment(
        parts[i],
        indent = if (i == 1) 0L else 2L,
        force_explode = TRUE
      )
    },
    character(1)
  )
  paste(parts, collapse = "$\n  ")
}

# Split a chain on top-level "$". Bare identifiers like the "pl" in
# "pl$scan_csv(...)" stay attached to the call that follows them.
split_chain_merged <- function(text) {
  parts <- split_query_chain(text)
  is_bare <- !grepl("(", parts, fixed = TRUE)
  i <- 1
  while (i < length(parts)) {
    if (is_bare[i]) {
      parts[i + 1] <- paste0(parts[i], "$", parts[i + 1])
      parts <- parts[-i]
      is_bare <- is_bare[-i]
    } else {
      i <- i + 1
    }
  }
  parts
}

# Format a value (e.g. an argument of a method call), which can itself be a
# chain of method calls. The first line is placed by the caller, so only
# continuation lines get the indent.
format_query_value <- function(text, indent) {
  if (indent + nchar(text) <= tp_query_width) {
    return(text)
  }
  parts <- split_chain_merged(text)
  if (length(parts) == 1) {
    return(format_call_segment(text, indent, force_explode = FALSE))
  }
  parts <- vapply(
    seq_along(parts),
    \(i) {
      format_call_segment(
        parts[i],
        indent = if (i == 1) indent else indent + 2L,
        force_explode = FALSE
      )
    },
    character(1)
  )
  paste(parts, collapse = paste0("$\n", strrep(" ", indent + 2L)))
}

# Scan R code characters: for each position, the parenthesis depth and
# whether it belongs to a string or a backquoted name.
scan_code <- function(chars) {
  n <- length(chars)
  depth <- integer(n)
  in_string <- logical(n)
  current_depth <- 0L
  string_delim <- ""
  escaped <- FALSE
  for (i in seq_len(n)) {
    char <- chars[i]
    if (string_delim != "") {
      in_string[i] <- TRUE
      if (escaped) {
        escaped <- FALSE
      } else if (char == "\\") {
        escaped <- TRUE
      } else if (char == string_delim) {
        string_delim <- ""
      }
    } else if (char %in% c("\"", "'", "`")) {
      string_delim <- char
      in_string[i] <- TRUE
    } else if (char %in% c("(", "[", "{")) {
      current_depth <- current_depth + 1L
    } else if (char %in% c(")", "]", "}")) {
      current_depth <- current_depth - 1L
    }
    depth[i] <- current_depth
  }
  list(depth = depth, in_string = in_string)
}

split_at_positions <- function(chars, breaks) {
  starts <- c(1L, breaks + 1L)
  ends <- c(breaks - 1L, length(chars))
  vapply(
    seq_along(starts),
    \(i) paste(chars[starts[i]:ends[i]], collapse = ""),
    character(1)
  )
}

# Split on "$" located at depth 0, i.e. not inside parentheses/brackets and
# not inside a string.
split_query_chain <- function(text) {
  chars <- strsplit(text, "", fixed = TRUE)[[1]]
  info <- scan_code(chars)
  breaks <- which(chars == "$" & info$depth == 0L & !info$in_string)
  if (length(breaks) == 0) {
    return(text)
  }
  split_at_positions(chars, breaks)
}

# Reformat "fn(arg1, arg2)" so that each argument is on its own line, if
# the call has several arguments (only with `force_explode = TRUE`) or if it
# doesn't fit on the line. Arguments are formatted recursively. Note that
# ")" is at depth 0 in scan_code() ("(" is at depth 1), which makes the
# closing parenthesis of `fn` easy to find.
format_call_segment <- function(part, indent, force_explode) {
  chars <- strsplit(part, "", fixed = TRUE)[[1]]
  info <- scan_code(chars)
  open <- which(chars == "(" & info$depth == 1L & !info$in_string)
  if (length(open) == 0) {
    return(part)
  }
  open <- open[1]
  close <- which(chars == ")" & info$depth == 0L & !info$in_string)
  close <- close[close > open][1]
  if (close == open + 1) {
    # no arguments
    return(part)
  }
  commas <- which(chars == "," & info$depth == 1L & !info$in_string)
  commas <- commas[commas > open & commas < close]

  too_long <- indent + nchar(part) > tp_query_width
  if (!too_long && !(force_explode && length(commas) > 0)) {
    return(part)
  }

  args <- trimws(split_at_positions(
    chars[(open + 1):(close - 1)],
    commas - open
  ))
  args <- vapply(args, format_query_value, character(1), indent = indent + 2L)
  pad_args <- strrep(" ", indent + 2L)
  pad_close <- strrep(" ", indent)
  paste0(
    paste(chars[1:open], collapse = ""),
    "\n",
    paste0(pad_args, args, collapse = ",\n"),
    "\n",
    pad_close,
    ")",
    if (close < length(chars)) {
      paste(chars[(close + 1):length(chars)], collapse = "")
    }
  )
}
