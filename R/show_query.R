#' Show the polars code equivalent to the tidypolars pipeline
#'
#' @description
#' `show_query()` prints the pure `polars` code that `tidypolars` runs in the
#' background. This code can be copy-pasted and run with `polars` only (the
#' input data must be assigned to the name displayed in the first line of the
#' query).
#'
#' Recording the query is **disabled** by default, meaning that `show_query()` will
#' error with an informative message. It can be enabled with
#' `options(tidypolars_record_query = TRUE)` (see [tidypolars_options]).
#'
#' To keep the output readable and close to hand-written `polars` code, R
#' operators are used instead of their method equivalent (e.g. `a$add(b)` is
#' shown as `a + b`), and user-defined functions are displayed as a call
#' rather than expanded into the operations they perform internally.
#'
#' Long values coming from the calling environment are referred to by the name
#' of the object they come from, so that the printed code stays copy-pasteable.
#' Values that are too long to display and are not bound to a name, such as a
#' long inline vector, are shown as a placeholder like
#' `` `<numeric of length 200>` ``.
#'
#' @param x A Polars Data/LazyFrame that went through `tidypolars` functions.
#' @param ... Not used.
#'
#' @return The input, invisibly. This function is called for its side effect
#' of printing the polars query.
#' @export
#' @examplesIf requireNamespace("dplyr", quietly = TRUE) & requireNamespace("withr", quietly = TRUE)
#' withr::with_options(
#'   list(tidypolars_record_query = TRUE),
#'   mtcars |>
#'     as_polars_lf() |>
#'     filter(cyl == 4) |>
#'     mutate(
#'       mpg2 = mpg * 2,
#'       mpg2_max = max(mpg2),
#'      .by = am
#'     ) |>
#'     show_query()
#' )
show_query.polars_data_frame <- function(x, ...) {
  text <- tp_query_text(x)
  if (is.null(text)) {
    cli_abort(
      c(
        "No {.pkg polars} query was recorded for this object because the option {.code tidypolars_record_query} is {.code FALSE}.",
        "i" = "Run {.code options(tidypolars_record_query = TRUE)} and re-run your query to show the equivalent {.pkg polars} code.",
        "i" = "More info with {.code ?tidypolars_options}."
      )
    )
  }
  cat(highlight_query(format_polars_query(text)), "\n", sep = "")
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
  # Frame `$` calls originating from the polars namespace are polars' own
  # doing, not user-facing query steps, and must not be recorded: internal
  # plumbing (e.g. the eager `$unique()` calling `self$lazy()$unique()$
  # collect()`) and conversion/sink methods (`as_tibble()`, `to_r_vector()`,
  # `print()`, ...) both reach this method from the polars namespace. Recording
  # them would add spurious steps and alter the calls shown in polars error
  # messages. User-facing passthrough verbs polars implements as S3 methods
  # (`head()`/`tail()`) are handled by tidypolars' own methods further down, so
  # they reach this method from the tidypolars namespace instead. The check is
  # restricted to frames because expression methods like `$eq()` are
  # legitimately called from the polars namespace via group generics (e.g.
  # `Ops.polars_expr` for `==`).
  if (
    (is_polars_df(x) || is_polars_lf(x)) &&
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
  member <- eval_bare(call2("$", expr(polars::pl), sym(name)))
  if (tp_recorder$skip_next) {
    tp_recorder$skip_next <- FALSE
    return(member)
  }
  if (!query_recording_enabled()) {
    return(member)
  }
  wrap_polars_member(x, member, "pl", name)
}

# Wrap a member (`member`) accessed as `holder$name` so that using it keeps
# recording the query. Depending on what the member is, the wrapper either
# records the call and tags its result (methods), or tags the member itself
# (sub-namespaces and datatypes). `parent_text` is the recorded code of
# `holder`, onto which "$name" and the eventual call are appended.
#
# Examples (`holder$name` -> what the wrapper returns):
# - method: `pl$col` with parent_text "pl", name "col" -> a function that,
#   called as `...("x")`, returns the expression tagged `pl$col("x")`.
# - sub-namespace: `<expr>$str` on an expression tagged `pl$col("x")`, name
#   "str" -> the `str` namespace tagged `pl$col("x")$str`.
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
          on.exit({
            tp_recorder$skip_next <- FALSE
          })
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

# Re-tag the result of a user-defined function so that the recorded query
# shows the opaque call (e.g. `pl_standardize(pl$col("x"))`) instead of the
# polars operations performed inside the function body. `args` are the
# (already translated) arguments the function was called with.
record_udf_query <- function(out, fn_name, args) {
  if (!query_recording_enabled() || !inherits(out, "polars_object")) {
    return(out)
  }
  text <- tryCatch(
    {
      n <- length(args)
      nms <- names(args) %||% character(n)
      nms[is.na(nms)] <- ""
      dep <- vapply(args, deparse_query_arg, character(1))
      pieces <- ifelse(nms == "", dep, paste0(nms, " = ", dep))
      paste0(fn_name, "(", paste(pieces, collapse = ", "), ")")
    },
    error = function(e) NULL
  )
  if (is.null(text)) {
    return(out)
  }
  # `out` may be one of the (already tagged) inputs: cloning avoids corrupting
  # the input's own query.
  if (inherits(out, "tp_recorded") && is.environment(out)) {
    out <- clone_env_with_attrs(out)
  }
  tag_polars(out, text)
}

# Refer to a constant by the name of the caller-environment object it came
# from, but only when its value is too long to display faithfully: short
# values are clearer shown literally, and long ones would otherwise become an
# unusable placeholder like `` `<numeric of length 200>` ``.
record_named_literal <- function(out, name, value) {
  if (!query_recording_enabled() || !inherits(out, "tp_recorded")) {
    return(out)
  }
  # A leading "`<" marks a placeholder produced by deparse_query_arg() for
  # values that cannot be displayed as usable, copy-pasteable code.
  if (!startsWith(deparse_query_arg(value), "`<")) {
    return(out)
  }
  attr(out, "tp_query") <- paste0("pl$lit(", name, ")")
  out
}

# Capture the arguments of a call and return them as a single string, e.g.
# `"a", n = 2, pl$col("b")`.
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
    return(paste(pieces, collapse = ", "))
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
  paste(out, collapse = ", ")
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
    } else if (is.object(x) && !is_parseable(dep)) {
      # Objects whose deparse isn't valid R code, e.g. S7 objects created
      # outside of tidypolars deparse to "<object>".
      dep <- paste0("`<", class(x)[1], ">`")
    }
    dep
  }
}

# Whether `text` parses as valid R code.
is_parseable <- function(text) {
  tryCatch(
    {
      parse(text = text)
      TRUE
    },
    error = function(e) FALSE
  )
}

# ------------------------------------------------------------------------
# Use standard R operators instead of Polars methods (e.g. `$mul()`).
# ------------------------------------------------------------------------

# Method name (as recorded by polars' `Ops` dispatch) -> R operator.
tp_binary_ops <- c(
  add = "+",
  sub = "-",
  mul = "*",
  true_div = "/",
  floor_div = "%/%",
  mod = "%%",
  pow = "^",
  eq = "==",
  ne = "!=",
  gt = ">",
  ge = ">=",
  lt = "<",
  le = "<=",
  and = "&",
  or = "|"
)

# Used in utils-expr.R
known_ops <- c(unname(tp_binary_ops), "**", "!")

rewrite_query_operators <- function(text) {
  node <- tryCatch(
    parse(text = text, keep.source = FALSE)[[1]],
    error = function(e) NULL
  )
  if (is.null(node)) {
    return(text)
  }
  # Rewriting must never turn a working display into an error: any failure
  # degrades to the original (method-call) text.
  out <- tryCatch(
    collapse_deparse(deparse(rewrite_op_node(node), width.cutoff = 500L)),
    error = function(e) NULL
  )
  out %||% text
}

# `deparse()` wraps its output onto several lines when the code is longer than
# `width.cutoff` (capped at 500). The continuation lines carry alignment
# indentation, so pasting them with `collapse = ""` would embed that whitespace
# in the middle of the code (e.g. `month() ==     2`). Rebuild the single-line
# form instead: drop each continuation line's leading indentation and add a
# single separating space only when the break didn't already leave one. Breaks
# never fall inside a string literal, so stripping this whitespace is safe.
collapse_deparse <- function(lines) {
  out <- lines[1]
  for (line in lines[-1]) {
    cont <- sub("^ +", "", line)
    sep <- if (cont == "" || grepl(" $", out)) "" else " "
    out <- paste0(out, sep, cont)
  }
  out
}

rewrite_op_node <- function(node) {
  if (!is.call(node)) {
    return(node)
  }
  op <- match_binary_op(node)
  if (!is.null(op)) {
    # `lhs$method(rhs)`: the receiver is `node[[1]][[2]]`, the argument is
    # `node[[2]]`.
    lhs <- rewrite_op_node(node[[1]][[2]])
    rhs <- rewrite_op_node(node[[2]])
    return(call(op, lhs, rhs))
  }
  for (i in seq_along(node)) {
    node[[i]] <- rewrite_op_node(node[[i]])
  }
  node
}

# Return the R operator for a `lhs$method(rhs)` node whose method is a known
# binary operator called with a single unnamed argument, or NULL otherwise.
match_binary_op <- function(node) {
  if (length(node) != 2L) {
    return(NULL)
  }
  nms <- names(node)
  if (!is.null(nms) && nzchar(nms[[2]])) {
    return(NULL)
  }
  first_node <- node[[1]]
  if (
    !is.call(first_node) ||
      length(first_node) != 3L ||
      !identical(first_node[[1]], as.symbol("$")) ||
      !is.symbol(first_node[[3]])
  ) {
    return(NULL)
  }
  method <- as.character(first_node[[3]])
  if (!method %in% names(tp_binary_ops)) {
    return(NULL)
  }
  unname(tp_binary_ops[[method]])
}

# ------------------------------------------------------------------------
# Formatting:
# - one line per method called on the Data/LazyFrame (lines end with "$" so
#   that the printed block can be copy-pasted as is);
# - those calls get one argument per line when they don't fit on the line, or
#   when they have several compound arguments (named ones or nested
#   expressions); a call made only of plain unnamed values, like
#   `select("a", "b")`, stays inline as long as it fits;
# - inside arguments, the same rules apply recursively but only when the
#   line is too long, so that short values like `c(FALSE, TRUE)` stay
#   inline.
# ------------------------------------------------------------------------

tp_query_width <- 80L

format_polars_query <- function(text) {
  text <- rewrite_query_operators(text)
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

# Colorize the polars code produced.
highlight_query <- function(text) {
  if (num_ansi_colors() <= 1L) {
    return(text)
  }
  lines <- strsplit(text, "\n", fixed = TRUE)[[1]]
  out <- tryCatch(
    cli::code_highlight(lines, code_theme = "Solarized Light"),
    error = function(e) lines
  )
  paste(out, collapse = "\n")
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

# A "plain" argument is an unnamed literal (a string, number, logical, ...)
# with no nested call: it carries no structure that would be clearer split
# over its own line. Named arguments (top-level "=") and expressions
# (containing "(") are not plain.
is_plain_arg <- function(arg) {
  chars <- strsplit(arg, "", fixed = TRUE)[[1]]
  info <- scan_code(chars)
  !any(chars == "(" & !info$in_string) &&
    !any(chars == "=" & info$depth == 0L & !info$in_string)
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

  args <- trimws(split_at_positions(
    chars[(open + 1):(close - 1)],
    commas - open
  ))

  # `force_explode` puts each argument on its own line, but only compound
  # arguments (named ones, or nested expressions like `pl$col("a")`) benefit
  # from that. A call made solely of plain unnamed values, e.g.
  # `select("a", "b")`, stays inline as long as it fits on the line.
  too_long <- indent + nchar(part) > tp_query_width
  explode <- too_long ||
    (force_explode &&
      length(commas) > 0 &&
      !all(vapply(args, is_plain_arg, logical(1))))
  if (!explode) {
    return(part)
  }

  args <- vapply(args, format_query_value, character(1), indent = indent + 2L)
  pad_args <- strrep(" ", indent + 2L)
  pad_close <- strrep(" ", indent)

  # A call made solely of plain unnamed values (e.g. a long `c("a", "b", ...)`
  # vector) reads better with the values packed to fill each line rather than
  # one value per line. Compound arguments keep one per line so their structure
  # stays visible.
  if (all(vapply(args, is_plain_arg, logical(1)))) {
    body_lines <- fill_query_args(args, indent + 2L)
  } else {
    body_lines <- args
  }
  paste0(
    paste(chars[1:open], collapse = ""),
    "\n",
    paste0(pad_args, body_lines, collapse = ",\n"),
    "\n",
    pad_close,
    ")",
    if (close < length(chars)) {
      paste(chars[(close + 1):length(chars)], collapse = "")
    }
  )
}

# Pack plain arguments so that each line holds as many comma-separated values
# as fit within `tp_query_width`, instead of one value per line. Returns the
# lines without their leading indentation (`indent` is only used to measure the
# available width) and without trailing commas: those are added by the caller
# when the lines are joined.
fill_query_args <- function(args, indent) {
  lines <- character(0)
  current <- ""
  for (i in seq_along(args)) {
    piece <- args[[i]]
    trailing_comma <- if (i < length(args)) 1L else 0L
    if (current == "") {
      candidate <- piece
    } else {
      candidate <- paste0(current, ", ", piece)
    }
    if (
      current != "" &&
        indent + nchar(candidate) + trailing_comma > tp_query_width
    ) {
      lines <- c(lines, current)
      current <- piece
    } else {
      current <- candidate
    }
  }
  c(lines, current)
}
