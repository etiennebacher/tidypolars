#' `tidypolars` global options
#'
#' There is currently one global option:
#'
#' * `tidypolars_unknown_args` controls what happens when some arguments passed
#'   in an expression are unknown, e.g the argument `prob` in `sample()`. The
#'   default (`"warn"`) only warns the user that some arguments are ignored by
#'   `tidypolars`. The only other accepted value is `"error"` to throw an
#'   error when this happens.
#'
#' @name tidypolars-options
#'
#' @examplesIf require("dplyr", quietly = TRUE)
#' options(tidypolars_unknown_args = "warn")
#' test <- polars::pl$DataFrame(x = c(2, 1, 5, 3, 1))
#'
#' # The default is to warn the user
#' mutate(test, x2 = sample(x, prob = 0.5))
#'
#' # But one can make this stricter and throw an error when this happens
#' options(tidypolars_unknown_args = "error")
#' try(mutate(test, x2 = sample(x, prob = 0.5))
#'
#' options(tidypolars_unknown_args = "warn")
NULL
