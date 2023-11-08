library(dplyr)

if (.Platform$OS.type == "unix") {
  rd_files <- list.files("/home/etienne/Bureau/Git/not_my_packages/r-polars/man")
} else {
  rd_files <- list.files("C:\\Users\\etienne\\Desktop\\Divers\\r-polars\\man")
}

rd_files <- rd_files |>
  tools::file_path_sans_ext()

rd_files <- rd_files[grepl("^Expr\\w+", rd_files, ignore.case = FALSE)]

expr_category <- gsub("Expr", "", rd_files)
expr_category <- gsub("_.*", "", expr_category)
expr_category[expr_category == ""] <- "default"

# drop everything before first underscore
rd_files <- gsub("^[^_]*_", "", rd_files)

r_polars_funs <- data.frame(
  category = expr_category,
  polars_funs = rd_files,
  r_funs = rd_files
) |>
  mutate(
    r_funs = case_match(
      r_funs,
      "std" ~ "sd",
      "arccos" ~ "acos",
      "arccosh" ~ "acosh",
      "arcsin" ~ "asin",
      "arcsinh" ~ "asinh",
      "arctan" ~ "atan",
      "arctanh" ~ "atanh",
      "ceil" ~ "ceiling",
      "shift" ~ "lag",
      "is_between" ~ "between",
      "count_matches" ~ "str_count",
      "replace" ~ "str_replace",
      "replace_all" ~ "str_replace_all",
      "len_chars" ~ "nchar",
      "weekday" ~ "wday",
      "ordinal_day" ~ "yday",
      "is_nan" ~ "is.nan",
      "is_null" ~ "is.na",
      "is_finite" ~ "is.finite",
      "is_infinite" ~ "is.infinite",
      .default = r_funs
    ),
    r_funs = case_when(
      category == "Str" & r_funs == "slice" ~ "str_sub",
      category == "Str" & r_funs == "extract" ~ "str_extract",
      .default = r_funs
    ),
    polars_funs = case_when(
      category == "DT" ~ paste0("dt_", polars_funs),
      category == "Str" ~ paste0("str_", polars_funs),
      .default = polars_funs
    )
  ) |>
  distinct() |>
  bind_rows(
    tribble(
      ~polars_funs, ~r_funs,
      "ifelse", "ifelse",
      "ifelse", "if_else",
      "case_when", "case_when",
      "case_match", "case_match",
      "coalesce", "coalesce",
      "str_extract", "str_extract",
      "str_extract_all", "str_extract_all",
      "str_to_upper", "toupper",
      "str_to_upper", "str_to_upper",
      "str_to_lower", "tolower",
      "str_to_lower", "str_to_lower",
      "str_to_title", "toTitleCase",
      "str_to_title", "str_to_title",
      "str_detect", "str_detect",
      "str_ends", "str_ends",
      "str_pad", "str_pad",
      "str_starts", "str_starts",
      "str_length", "str_length",
      "str_remove", "str_remove",
      "str_remove_all", "str_remove_all",
      "str_squish", "str_squish",
      "str_trim", "str_trim",
      "grepl", "grepl",
      "paste0", "paste0",
      "paste", "paste",
      "trimws", "trimws",
      "ymd_hms", "ymd_hms",
      "ymd_hm", "ymd_hm",
      "dt_day", "mday",
      "dt_ordinal_day", "yday",
      "as.numeric", "as.numeric",
      "as.logical", "as.logical",
      "as.character", "as.character",
      "word", "word"
    )
  ) |>
  arrange(category, polars_funs, .locale = "en")

usethis::use_data(r_polars_funs, overwrite = TRUE, internal = TRUE)