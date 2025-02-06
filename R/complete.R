#' Complete a data frame with missing combinations of data
#'
#' Turns implicit missing values into explicit missing values. This is useful
#' for completing missing combinations of data.
#'
#' @param data A Polars Data/LazyFrame
#' @param ... Any expression accepted by `dplyr::select()`: variable names,
#'  column numbers, select helpers, etc.
#' @param fill A named list that for each variable supplies a single value to
#' use instead of `NA` for missing combinations.
#' @param explicit Should both implicit (newly created) and explicit
#' (pre-existing) missing values be filled by `fill`? By default, this is
#' `TRUE`, but if set to `FALSE` this will limit the fill to only implicit
#' missing values.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' df <- polars::pl$DataFrame(
#'   group = c(1:2, 1, 2),
#'   item_id = c(1:2, 2, 3),
#'   item_name = c("a", "a", "b", "b"),
#'   value1 = c(1, NA, 3, 4),
#'   value2 = 4:7
#' )
#' df
#'
#' df |> complete(group, item_id, item_name)
#'
#' # Use `fill` to replace NAs with some value. By default, affects both new
#' # (implicit) and pre-existing (explicit) missing values.
#' df |>
#'   complete(
#'     group, item_id, item_name,
#'     fill = list(value1 = 0, value2 = 99)
#'   )
#'
#' # Limit the fill to only the newly created (i.e. previously implicit)
#' # missing values with `explicit = FALSE`
#' df |>
#'   complete(
#'     group, item_id, item_name,
#'     fill = list(value1 = 0, value2 = 99),
#'     explicit = FALSE
#'   )
#'
#' df |>
#'   group_by(group, maintain_order = TRUE) |>
#'   complete(item_id, item_name)
complete.RPolarsDataFrame <- function(
  data,
  ...,
  fill = list(),
  explicit = TRUE
) {
  dots <- enquos(...)
  names_dots <- names(dots)

  unnamed_dots <- dots[which(names_dots == "")]
  named_dots <- dots[which(names_dots != "")]

  data_eval_dots <- build_data_context(data)
  unnamed_dots <- lapply(unnamed_dots, function(x) {
    tidyselect::eval_select(
      x,
      data_eval_dots,
      error_call = caller_env()
    )
  }) |>
    unlist() |>
    names()

  named_dots <- lapply(names(named_dots), function(x) {
    out <- tibble(!!named_dots[[x]])
    names(out) <- x
    if (is_polars_df(data)) {
      as_polars_df(out)
    } else if (is_polars_lf(data)) {
      as_polars_lf(out)
    }
  }) |>
    set_names(names(named_dots))

  if (length(unnamed_dots) < 2 && length(named_dots) == 0) {
    return(data)
  }

  grps <- attributes(data)$pl_grps
  mo <- attributes(data)$maintain_grp_order
  is_grouped <- !is.null(grps)

  chain_is_empty <- FALSE
  if (length(unnamed_dots) == 0) {
    chain <- if (is_polars_df(data)) {
      pl$DataFrame()
    } else if (is_polars_lf(data)) {
      pl$LazyFrame()
    }
    chain_is_empty <- TRUE
  } else {
    if (isTRUE(is_grouped)) {
      chain <- data$group_by(grps, maintain_order = mo)$agg(
        pl$col(unnamed_dots)$unique()$sort()
      )
    } else {
      chain <- data$select(pl$col(unnamed_dots)$unique()$sort()$implode())
    }
  }

  for (i in seq_along(unnamed_dots)) {
    chain <- chain$explode(unnamed_dots[i])
  }

  for (i in seq_along(named_dots)) {
    if (chain_is_empty) {
      chain <- named_dots[[i]]
    } else {
      chain <- chain$join(named_dots[[i]], how = "cross", join_nulls = TRUE)
    }
  }

  all_dots <- c(unnamed_dots, names(named_dots))

  # To avoid filling explicit missings, i.e. missings that were already in the
  # original data, I split the expanded combinations between those that were
  # already in the data and those that weren't, and I only fill the latter.
  if (isFALSE(explicit)) {
    if (isTRUE(is_grouped)) {
      already_exist <- chain$join(
        data,
        on = c(grps, all_dots),
        how = "inner",
        join_nulls = TRUE
      )
      dont_already_exist <- chain$join(
        data,
        on = c(grps, all_dots),
        how = "anti",
        join_nulls = TRUE
      )
    } else {
      already_exist <- chain$join(
        data,
        on = all_dots,
        how = "inner",
        join_nulls = TRUE
      )
      dont_already_exist <- chain$join(
        data,
        on = all_dots,
        how = "anti",
        join_nulls = TRUE
      )
    }
    other_unnamed_dots <- setdiff(
      names(already_exist),
      names(dont_already_exist)
    )
    schema <- already_exist$schema
    for (i in other_unnamed_dots) {
      dont_already_exist <- dont_already_exist$with_columns(
        pl$lit(NA)$cast(schema[[i]])$alias(i)
      )
    }
    dont_already_exist <- replace_na(dont_already_exist, fill)
    out <- bind_rows_polars(already_exist, dont_already_exist)
    if (isTRUE(mo)) {
      if (isTRUE(is_grouped)) {
        out <- out$sort(c(grps, all_dots))
      } else {
        out <- out$sort(all_dots)
      }
    }
  } else {
    if (isTRUE(is_grouped)) {
      out <- chain$join(
        data,
        on = c(grps, all_dots),
        how = "full",
        join_nulls = TRUE,
        coalesce = TRUE
      )
    } else {
      out <- chain$join(
        data,
        on = all_dots,
        how = "full",
        join_nulls = TRUE,
        coalesce = TRUE
      )
    }

    if (length(fill) > 0) {
      out <- replace_na(out, fill)
    }
  }

  out <- if (is_grouped) {
    out |>
      relocate(all_of(grps), .before = 1) |>
      group_by(all_of(grps), maintain_order = mo)
  } else {
    out
  }

  add_tidypolars_class(out)
}

#' @rdname complete.RPolarsDataFrame
#' @export
complete.RPolarsLazyFrame <- complete.RPolarsDataFrame
