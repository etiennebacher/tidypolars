# `$.tidypolars` <- function(x, name) {
#   # browser()
#   # foo <- as_quosure(frame_call(), env = caller_env())
#   # foo2 <- enexpr(foo)
#   # print(foo2)
#   foo <- frame_call()
#   print(foo)
#   browser()
#   foo[[2]] |> eval_bare(env = caller_env()) |> print()
#   # browser()
#   # out <- eval_bare(foo, env = caller_env())
#   # print(out)
#   # attr(out, "polars_expressions") <- append(attr(out, "polars_expressions"), foo)
#   nm <- if (inherits(x, "RPolarsDataFrame")) {
#     "RPolarsDataFrame"
#   } else if (inherits(x, "RPolarsLazyFrame")) {
#     "RPolarsLazyFrame"
#   }
#   out <- NextMethod("$", nm)
#   print(out)
#   attr(out, "polars_expressions") <- append(attr(out, "polars_expressions"), foo)
#   return(out)
# }

#' @export
show_query.tidypolars <- function(x) {
  cat("Pure polars expression:\n\n")
  attributes(x)$polars_expression
}
