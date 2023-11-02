# nocov start
# https://stackoverflow.com/questions/76475424/conditionally-provide-methods-for-generics-from-another-package/
.onLoad <- function(libname, pkgname) {

  if(requireNamespace("dplyr", quietly = TRUE)) {

    registerS3method("anti_join", "DataFrame", pl_anti_join, envir = asNamespace("dplyr"))
    registerS3method("anti_join", "LazyFrame", pl_anti_join, envir = asNamespace("dplyr"))

    registerS3method("cross_join", "DataFrame", pl_cross_join, envir = asNamespace("dplyr"))
    registerS3method("cross_join", "LazyFrame", pl_cross_join, envir = asNamespace("dplyr"))

    registerS3method("full_join", "DataFrame", pl_full_join, envir = asNamespace("dplyr"))
    registerS3method("full_join", "LazyFrame", pl_full_join, envir = asNamespace("dplyr"))

    registerS3method("inner_join", "DataFrame", pl_inner_join, envir = asNamespace("dplyr"))
    registerS3method("inner_join", "LazyFrame", pl_inner_join, envir = asNamespace("dplyr"))

    registerS3method("left_join", "DataFrame", pl_left_join, envir = asNamespace("dplyr"))
    registerS3method("left_join", "LazyFrame", pl_left_join, envir = asNamespace("dplyr"))

    registerS3method("right_join", "DataFrame", pl_right_join, envir = asNamespace("dplyr"))
    registerS3method("right_join", "LazyFrame", pl_right_join, envir = asNamespace("dplyr"))

    registerS3method("semi_join", "DataFrame", pl_semi_join, envir = asNamespace("dplyr"))
    registerS3method("semi_join", "LazyFrame", pl_semi_join, envir = asNamespace("dplyr"))

  }
  if(requireNamespace("tidyr", quietly = TRUE)) {

    registerS3method("unite", "DataFrame", pl_unite, envir = asNamespace("tidyr"))
    registerS3method("unite", "LazyFrame", pl_unite, envir = asNamespace("tidyr"))
  }
}
# nocov end
