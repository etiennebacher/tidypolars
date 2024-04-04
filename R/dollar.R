`$.tidypolars` <- function(x, name) {
  whitelist <- c("shape", "schema", "height", "width")
  if (name %in% whitelist) {
    NextMethod("$")
  }

  class_2 <- class(x)[2]
  my_new_env <- modify_env(
    data = x,
    env_clone(ns_env("polars")[[class_2]]),
    fun_name = name
  )
  my_new_env[[name]]
}

#' @export
show_query.tidypolars <- function(x) {
  cat("Pure polars expression:\n\n")
  attrs <- attributes(x)$polars_expression
  out <- lapply(seq_along(attrs), function(x) {
    e <- attrs[[x]]
    e <- gsub("^[^\\$]+\\$", "$", e)
    gsub("^\\$", "$\\\n  ", e)
  }) |>
    unlist() |>
    paste(collapse = "")
  out <- paste0("<data>", out)
  cat(out)
}
