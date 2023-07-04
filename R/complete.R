#' @export

pl_complete <- function(data, ...) {

  check_polars_data(data)

  dots <- .select_nse_from_dots(data, ...)
  print(dots)

  dots2 <- dots
  temp <- data
  for (i in seq_along(dots)) {
    # TODO: wait for r-polars to have implemented how = "cross"
    temp <- temp$select(dots2[i])$unique()$join(
      temp$select(dots2[i+1])$unique(),
      how = 'cross'
    )
    dots2[i] <- NULL
  }

  data$join(temp, how='right', on = dots)
}
