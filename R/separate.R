#' @export
pl_separate <- function(data, col, into, sep = "[^[:alnum:]]+", remove = TRUE) {

  check_polars_data(data)
  col <- deparse(substitute(col))

  into_len <- length(into) - 1
  # to avoid collision with an existing col
  temp_id <- paste(sample(letters), collapse = "")

  data <- data$
    with_columns(
      pl$col(col)$cast(pl$Utf8)$
        str$split_exact(eval(sep), into_len)$
        alias(eval(temp_id))$
        struct$
        rename_fields(eval(into))
    )$unnest(temp_id)

  if (isTRUE(remove)) {
    data <- data$drop(col)
  }

  data
}

#' @export
separate.DataFrame <- pl_separate
