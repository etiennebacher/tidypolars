#' @import polars
#' @export
NULL

# List of expressions of Polars

get_polars_expr <- function() {

  # rd_files <- list.files("C:\\Users\\etienne\\Desktop\\Divers\\r-polars\\man") |>
  #   tools::file_path_sans_ext()
  # rd_files <- rd_files[grepl("^Expr\\w+", rd_files, ignore.case = FALSE)]
  #
  # expr_category <- gsub("Expr", "", rd_files)
  # expr_category <- gsub("_.*", "", expr_category)
  # expr_category[expr_category == ""] <- "default"
  #
  # rd_files <- gsub("Expr(.*)_", "", rd_files)
  #
  # data.frame(
  #   category = expr_category,
  #   expr = rd_files
  # ) |>
  #   constructive::construct()

  data.frame(
    category = rep(
      c("default", "Bin", "Cat", "DT", "Meta", "Str", "Struct"),
      c(160L, 5L, 1L, 33L, 8L, 30L, 2L)
    ),
    expr = c(
      "abs", "add", "groups", "alias", "all", "and", "any", "append", "apply",
      "unique", "arccos", "arccosh", "arcsin", "arcsinh", "arctan", "arctanh",
      "max", "min", "sort", "unique", "arr", "fill", "bin", "k", "cast", "cat",
      "ceil", "class", "clip", "cos", "cosh", "count", "cumcount", "cummin",
      "cumprod", "cumsum", "eval", "diff", "div", "dot", "nans", "nulls", "dt",
      "entropy", "eq", "var", "exclude", "exp", "explode", "constant", "nan",
      "null", "filter", "first", "floor", "fill", "gt", "eq", "hash", "head",
      "inspect", "interpolate", "between", "duplicated", "finite", "first", "in",
      "infinite", "nan", "not", "nan", "null", "null", "unique", "name", "kurtosis",
      "last", "limit", "list", "df", "s", "log", "log10", "lt", "eq", "map",
      "alias", "max", "mean", "median", "meta", "min", "mode", "mul", "unique",
      "max", "min", "neq", "count", "or", "over", "change", "pow", "print",
      "product", "quantile", "rank", "rechunk", "reinterpret", "rep", "extend",
      "by", "reshape", "max", "mean", "median", "min", "quantile", "skew", "std",
      "sum", "var", "round", "rpow", "sample", "sorted", "sorted", "shift", "fill",
      "dtype", "shuffle", "sign", "sin", "sinh", "skew", "slice", "sort", "by",
      "sqrt", "std", "str", "struct", "sub", "sum", "tail", "take", "every", "tan",
      "tanh", "physical", "r", "struct", "k", "unique", "counts", "bound", "counts",
      "var", "otherwise", "xor", "contains", "decode", "encode", "with", "with",
      "ordering", "unit", "combine", "zone", "day", "days", "epoch", "hour",
      "hours", "year", "microsecond", "microseconds", "millisecond", "milliseconds",
      "minute", "minutes", "month", "nanosecond", "nanoseconds", "by", "day",
      "quarter", "zone", "round", "second", "seconds", "strftime", "timestamp",
      "truncate", "localize", "week", "weekday", "unit", "year", "eq", "outputs",
      "projection", "neq", "name", "pop", "names", "aliases", "concat", "contains",
      "match", "decode", "encode", "with", "explode", "extract", "all", "extract",
      "match", "lengths", "ljust", "lstrip", "chars", "int", "replace", "all",
      "rjust", "rstrip", "slice", "split", "exact", "splitn", "with", "strip",
      "strptime", "lowercase", "uppercase", "zfill", "field", "fields"
    )
  )
}

