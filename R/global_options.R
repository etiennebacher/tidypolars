#' `tidypolars` global options
#'
#' @description
#' `tidypolars` has the following global options:
#'
#' * `tidypolars_unknown_args` controls what happens when some arguments passed
#'   in an expression are unknown, e.g the argument `prob` in `sample()`. The
#'   default (`"warn"`) only warns the user that some arguments are ignored by
#'   `tidypolars`. The only other accepted value is `"error"` to throw an
#'   error when this happens.
#'
#' * `tidypolars_fallback_to_r` controls what happens when an unknown function
#'   (that isn't translated to use polars syntax) is passed in an expression.
#'   The default is `FALSE`, meaning that unknown functions will trigger an
#'   error. Setting this option to `TRUE` will convert the data to R, apply the
#'   unknown function, and convert the output back to polars.
#'   **Using the fallback to R has several drawbacks:**
#'   - it loses some of polars built-in parallelism and other optimizations;
#'   - the session may crash or experience a severe slowdown when the data is
#'     converted to R (especially if the input is a LazyFrame).
#'
#' The package `polars` also contains several global options that may be useful,
#' such as changing the default behavior when converting Int64 values to R:
#' <https://pola-rs.github.io/r-polars/man/polars_options.html>.
#'
#' @name tidypolars_options
#'
#' @examplesIf require("dplyr", quietly = TRUE)
#' ##### Unknown arguments
#'
#' options(tidypolars_unknown_args = "warn")
#' test <- polars0::pl$DataFrame(x = c(2, 1, 5, 3, 1))
#'
#' # The default is to warn the user
#' mutate(test, x2 = sample(x, prob = 0.5))
#'
#' # But one can make this stricter and throw an error when this happens
#' options(tidypolars_unknown_args = "error")
#' try(mutate(test, x2 = sample(x, prob = 0.5)))
#'
#' options(tidypolars_unknown_args = "warn")
#'
#' ##### Fallback to R
#'
#' test <- polars0::pl$DataFrame(x = c(2, 1, 5, 3, 1))
#'
#' # The default is to error because mad() isn't translated internally
#' try(mutate(test, x2 = mad(x)))
#'
#' # But one can allow fallback to R to apply this function and then convert
#' # the output back to polars (see drawbacks in the "description" section
#' # above)
#' options(tidypolars_fallback_to_r = TRUE)
#' mutate(test, x2 = mad(x))
#'
#' options(tidypolars_fallback_to_r = FALSE)
NULL
