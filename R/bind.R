#' Stack multiple Data/LazyFrames on top of each other
#'
#' @param ... Polars DataFrames or LazyFrames to combine. Each argument can
#'  either be a Data/LazyFrame, or a list of Data/LazyFrames. Columns are matched
#'  by name, and any missing columns will be filled with `NA`.
#' @param .id The name of an optional identifier column. Provide a string to
#' create an output column that identifies each input.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' library(polars)
#' p1 <- pl$DataFrame(
#'   x = c("a", "b"),
#'   y = 1:2
#' )
#' p2 <- pl$DataFrame(
#'   y = 3:4,
#'   z = c("c", "d")
#' )$with_columns(pl$col("y")$cast(pl$Int16))
#'
#' bind_rows_polars(p1, p2)
#'
#' # this is equivalent
#' bind_rows_polars(list(p1, p2))
#'
#' # create an id colum
#' bind_rows_polars(p1, p2, .id = "id")

bind_rows_polars <- function(..., .id = NULL) {
  concat_(..., how = "diagonal_relaxed", .id = .id)
}

#' Append multiple Data/LazyFrames next to each other
#'
#' @param ... Polars DataFrames or LazyFrames to combine. Each argument can
#'  either be a Data/LazyFrame, or a list of Data/LazyFrames. Columns are matched
#'  by name. All Data/LazyFrames must have the same number of rows and there
#'  mustn't be duplicated column names.
#'
#' @export
#' @examplesIf require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)
#' p1 <- polars::pl$DataFrame(
#'   x = sample(letters, 20),
#'   y = sample(1:100, 20)
#' )
#' p2 <- polars::pl$DataFrame(
#'   z = sample(letters, 20),
#'   w = sample(1:100, 20)
#' )
#'
#' bind_cols_polars(p1, p2)
#' bind_cols_polars(list(p1, p2))

# bind_* functions are not generics: https://github.com/tidyverse/dplyr/issues/6905

bind_cols_polars <- function(
    ...,
    .name_repair = c("unique", "universal", "check_unique", "minimal")
  ) {
  concat_(..., how = "horizontal", .name_repair = .name_repair)
}

concat_ <- function(..., how, .id = NULL, .name_repair = NULL) {
  dots <- rlang::list2(...)
  if (length(dots) == 1 && rlang::is_bare_list(dots[[1]])) {
    dots <- dots[[1]]
  }

  any_not_polars <- any(vapply(dots, \(y) {
    !inherits(y, "DataFrame") && !inherits(y, "LazyFrame")
  }, FUN.VALUE = logical(1L)))

  if (any_not_polars) {
    rlang::abort(
      "All elements in `...` must be either DataFrames or LazyFrames.",
      call = caller_env()
    )
  }

  all_df_or_lf <- all(vapply(dots, \(y) {
    inherits(y, "DataFrame") || inherits(y, "LazyFrame")
  }, FUN.VALUE = logical(1L)))

  if (!all_df_or_lf) {
    rlang::abort(
      "All elements in `...` must be of the same class (either DataFrame or LazyFrame).",
      call = caller_env()
    )
  }

  if (!is.null(.id)) {
    dots <- lapply(seq_along(dots), \(x) {
      dots[[x]]$
        with_columns(
          pl$lit(x)$alias(.id)
        )$
        select(pl$col(.id), pl$col("*")$exclude(.id))
    })
  }

  switch(
    how,
    "horizontal" = {
      # TODO: provide a "name_repair" option
      all_names <- unlist(lapply(dots, names), use.names = FALSE)
      if (anyDuplicated(all_names) > 0) {
        dupes <- get_dupes(all_names)
        switch(
          .name_repair,
          "check_unique" = {
              msg <- make_dupes_msg(dupes)
              rlang::abort(
                c(
                  "Names must be unique.",
                  "x" = "These names are duplicated (`variable` (locations)):",
                  " " = msg
                ),
                call = caller_env()
              )
          },
          "minimal" = {
            rlang::abort(
              c(
                "Argument `.name_repair = \"minimal\"` doesn't work on Polars Data/LazyFrames.",
                "i" = "Either provide unique names or use `.name_repair = \"universal\"`."
              ),
              call = caller_env()
            )
          },
          "universal" = {
            dupes <- names(dupes)
            vctrs::vec_as_names(dupes, repair = "universal")
            browser()
          }
        )
      }

      if (inherits(dots[[1]], "DataFrame")) {
        return(pl$concat(dots, how = how))
      } else {
        if (length(dots) > 2) {
          rlang::abort(
            "`bind_cols_polars()` doesn't work with more than two LazyFrames.",
            call = caller_env()
          )
        }
        dots[[1]]$with_context(dots[[2]])$select(pl$all())
      }
    },
    # default
    pl$concat(dots, how = how)
  )
}
