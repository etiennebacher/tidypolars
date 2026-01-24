pl_replace_na_tidyr <- function(data, replace, ...) {
  check_empty_dots(...)
  data$fill_null(replace)
}
