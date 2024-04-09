# source("helpers.R")
# using("tidypolars")
#
# expect_snapshot_print(
#   label = "simple_query",
#   {
#     x <- iris |>
#       as_polars_df() |>
#       filter(Sepal.Length > 5) |>
#       show_query(show = FALSE)
#     cat(x)
#   }
# )
#
