#' Get tidypolars function translation without loading their original package
#'
#' @description
#' Use `tp$function_name()` to get access to the functions that are translated
#' by `tidypolars` without loading the package these functions originally come
#' from.
#'
#' This may be useful in cases where you want to benefit from the interface of
#' these functions but don't want to add some `tidyverse` dependencies to your
#' project (e.g. `stringr` because it might be slow to build the package in some
#' cases).
#'
#' Note that the name of the package that originally provided the function must
#' be appended to the function name. For instance, if you want to use
#' `stringr::str_extract()` without loading `stringr`, you can do so with
#' `tp$str_extract_stringr()`. This is because multiple packages may have a
#' function named `str_extract()`, so we need to inform `tidypolars` of which
#' translation we want exactly.
#'
#' **Note:** using `tp` will make it harder to convert `tidypolars` code to run
#' with other `tidyverse`-based backends because `tp` will be unknown to those
#' backends. If you expect to switch between `tidypolars`, the original `tidyverse`,
#' and `tidyverse`-based backends, you should avoid using `tp`and load the original
#' packages in the session instead.
#'
#' This is similar to the `dd` object in `duckplyr` and to the `.sql` object in
#' `dbplyr`.
#'
#' @export
#' @format NULL
#' @examplesIf require("dplyr", quietly = TRUE)
#' # List of all functions stored in this object
#' sort(names(tp))
#'
#' dat <- polars::pl$DataFrame(x = c("abc12", "def3"))
#' dat |>
#'   mutate(y = tp$str_extract_stringr(x, "\\d+"))
tp <- new.env(parent = emptyenv())

fn_names <- ls(rlang::current_env(), pattern = "^pl_")
new_names <- sub("^pl_", "", fn_names)

lapply(seq_along(fn_names), function(i) {
  fn <- get(fn_names[i], envir = rlang::current_env())
  assign(new_names[i], fn, envir = tp)
})
