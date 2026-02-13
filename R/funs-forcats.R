pl_fct_rev_forcats <- function(f, .data) {
  check_option_factor_to_enum_is_true()
  cats <- get_cats(f, .data)
  f$cast(pl$Enum(rev(cats)))
}

pl_fct_collapse_forcats <- function(.f, ..., other_level = NULL) {
  check_option_factor_to_enum_is_true()
  dots <- clean_dots(...)
  .f <- .f$cast(pl$String)

  # Would be cleaner with $replace() but some list values can contain multiple
  # elements
  out <- NULL
  for (i in seq_along(dots)) {
    clean <- polars_expr_to_r(dots[[i]])
    if (is.null(out)) {
      out <- pl$when(.f$is_in(list(clean)))$then(pl$lit(names(dots)[i]))
    } else {
      out <- out$when(.f$is_in(list(clean)))$then(pl$lit(names(dots)[i]))
    }
  }
  if (!is.null(other_level)) {
    out <- out$otherwise(pl$lit(other_level))
    new_cats <- c(names(dots), other_level)
  } else {
    out <- out$otherwise(.f)
    new_cats <- names(dots)
  }
  out$cast(pl$Enum(new_cats))
}


# Utils ------------------------------

get_cats <- function(f, .data) {
  as.list(.data$select(f$cat$get_categories()), as_series = FALSE)[[1]]
}

check_option_factor_to_enum_is_true <- function() {
  val <- isTRUE(getOption("polars.factor_as_enum"))
  if (!val) {
    cli_abort(
      c(
        "x" = "The global option {.code polars.factor_as_enum} is not {.code TRUE}.",
        "i" = "Using {.pkg forcats} functions in {.pkg tidypolars} without this argument can lead to wrong results.",
        "i" = "Enable this option with {.code options(polars.factor_as_enum = TRUE)}."
      )
    )
  }
}
