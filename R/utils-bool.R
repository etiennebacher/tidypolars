parse_boolean_exprs <- function(expr) {
  for (i in seq_along(expr)) {
    tmp <- expr[i]
    OPERATION <- NULL

    # if there are boolean operators we need to split the string by them, do
    # the syntax conversion separately and add them back
    if (grepl("\\|", tmp)) {
      tmp <- strsplit(tmp, "\\|")[[1]] |>
        trimws()
      OPERATION <- "|"
    } else if (grepl("\\&", tmp)) {
      tmp <- strsplit(tmp, "\\&")[[1]] |>
        trimws()
      OPERATION <- "&"
    }

    # deal with %in%
    for (j in seq_along(tmp)) {
      if (grepl("%in%", tmp[j])) {
        tmp[j] <- replace_in_operator(tmp[j])
      }
    }

    expr[i] <- paste(tmp, collapse = OPERATION)
  }

  paste(expr, collapse = " & ")
}

replace_in_operator <- function(expr) {
  split <- strsplit(expr, "%in%")[[1]] |>
    trimws()
  left <- split[1]
  right <- split[2]
  new_right <- paste0("$is_in(pl$lit(", right, "))")
  paste0(left, new_right)
}
