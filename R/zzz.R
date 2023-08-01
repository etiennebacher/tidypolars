# nocov start
# https://stackoverflow.com/questions/76475424/conditionally-provide-methods-for-generics-from-another-package/
.onLoad <- function(libname, pkgname) {

  if(requireNamespace("dplyr", quietly = TRUE)) {

    registerS3method("add_count", "DataFrame", pl_add_count, envir = asNamespace("dplyr"))
    registerS3method("add_count", "GroupBy", pl_add_count, envir = asNamespace("dplyr"))
    registerS3method("add_count", "LazyFrame", pl_add_count, envir = asNamespace("dplyr"))
    registerS3method("add_count", "LazyGroupBy", pl_add_count, envir = asNamespace("dplyr"))

    registerS3method("anti_join", "DataFrame", pl_anti_join, envir = asNamespace("dplyr"))
    registerS3method("anti_join", "LazyFrame", pl_anti_join, envir = asNamespace("dplyr"))

    registerS3method("arrange", "DataFrame", pl_arrange, envir = asNamespace("dplyr"))
    registerS3method("arrange", "GroupBy", pl_arrange, envir = asNamespace("dplyr"))
    registerS3method("arrange", "LazyFrame", pl_arrange, envir = asNamespace("dplyr"))
    registerS3method("arrange", "LazyGroupBy", pl_arrange, envir = asNamespace("dplyr"))

    registerS3method("bind_cols", "DataFrame", pl_bind_cols, envir = asNamespace("dplyr"))
    registerS3method("bind_cols", "LazyFrame", pl_bind_cols, envir = asNamespace("dplyr"))

    registerS3method("bind_rows", "DataFrame", pl_bind_rows, envir = asNamespace("dplyr"))
    registerS3method("bind_rows", "LazyFrame", pl_bind_rows, envir = asNamespace("dplyr"))

    registerS3method("collect", "LazyFrame", pl_collect, envir = asNamespace("dplyr"))
    registerS3method("collect", "LazyGroupBy", pl_collect, envir = asNamespace("dplyr"))

    registerS3method("count", "DataFrame", pl_count, envir = asNamespace("dplyr"))
    registerS3method("count", "GroupBy", pl_count, envir = asNamespace("dplyr"))
    registerS3method("count", "LazyFrame", pl_count, envir = asNamespace("dplyr"))
    registerS3method("count", "LazyGroupBy", pl_count, envir = asNamespace("dplyr"))

    registerS3method("cross_join", "DataFrame", pl_cross_join, envir = asNamespace("dplyr"))
    registerS3method("cross_join", "LazyFrame", pl_cross_join, envir = asNamespace("dplyr"))

    registerS3method("distinct", "DataFrame", pl_distinct, envir = asNamespace("dplyr"))
    registerS3method("distinct", "LazyFrame", pl_distinct, envir = asNamespace("dplyr"))

    registerS3method("filter", "DataFrame", pl_filter, envir = asNamespace("dplyr"))
    registerS3method("filter", "GroupBy", pl_filter, envir = asNamespace("dplyr"))
    registerS3method("filter", "LazyFrame", pl_filter, envir = asNamespace("dplyr"))
    registerS3method("filter", "LazyGroupBy", pl_filter, envir = asNamespace("dplyr"))

    registerS3method("full_join", "DataFrame", pl_full_join, envir = asNamespace("dplyr"))
    registerS3method("full_join", "LazyFrame", pl_full_join, envir = asNamespace("dplyr"))

    registerS3method("group_by", "DataFrame", pl_group_by, envir = asNamespace("dplyr"))
    registerS3method("group_by", "LazyFrame", pl_group_by, envir = asNamespace("dplyr"))

    registerS3method("inner_join", "DataFrame", pl_inner_join, envir = asNamespace("dplyr"))
    registerS3method("inner_join", "LazyFrame", pl_inner_join, envir = asNamespace("dplyr"))

    registerS3method("left_join", "DataFrame", pl_left_join, envir = asNamespace("dplyr"))
    registerS3method("left_join", "LazyFrame", pl_left_join, envir = asNamespace("dplyr"))

    registerS3method("mutate", "DataFrame", pl_mutate, envir = asNamespace("dplyr"))
    registerS3method("mutate", "GroupBy", pl_mutate, envir = asNamespace("dplyr"))
    registerS3method("mutate", "LazyFrame", pl_mutate, envir = asNamespace("dplyr"))
    registerS3method("mutate", "LazyGroupBy", pl_mutate, envir = asNamespace("dplyr"))

    registerS3method("pull", "DataFrame", pl_pull, envir = asNamespace("dplyr"))
    registerS3method("pull", "LazyFrame", pl_pull, envir = asNamespace("dplyr"))

    registerS3method("relocate", "DataFrame", pl_relocate, envir = asNamespace("dplyr"))
    registerS3method("relocate", "LazyFrame", pl_relocate, envir = asNamespace("dplyr"))

    registerS3method("rename", "DataFrame", pl_rename, envir = asNamespace("dplyr"))
    registerS3method("rename", "LazyFrame", pl_rename, envir = asNamespace("dplyr"))

    registerS3method("rename_with", "DataFrame", pl_rename_with, envir = asNamespace("dplyr"))
    registerS3method("rename_with", "LazyFrame", pl_rename_with, envir = asNamespace("dplyr"))

    registerS3method("right_join", "DataFrame", pl_right_join, envir = asNamespace("dplyr"))
    registerS3method("right_join", "LazyFrame", pl_right_join, envir = asNamespace("dplyr"))

    registerS3method("select", "DataFrame", pl_select, envir = asNamespace("dplyr"))
    registerS3method("select", "LazyFrame", pl_select, envir = asNamespace("dplyr"))

    registerS3method("semi_join", "DataFrame", pl_semi_join, envir = asNamespace("dplyr"))
    registerS3method("semi_join", "LazyFrame", pl_semi_join, envir = asNamespace("dplyr"))

    registerS3method("slice_head", "DataFrame", pl_slice_head, envir = asNamespace("dplyr"))
    registerS3method("slice_head", "GroupBy", pl_slice_head, envir = asNamespace("dplyr"))
    registerS3method("slice_head", "LazyFrame", pl_slice_head, envir = asNamespace("dplyr"))
    registerS3method("slice_head", "LazyGroupBy", pl_slice_head, envir = asNamespace("dplyr"))

    registerS3method("slice_tail", "DataFrame", pl_slice_tail, envir = asNamespace("dplyr"))
    registerS3method("slice_tail", "GroupBy", pl_slice_tail, envir = asNamespace("dplyr"))
    registerS3method("slice_tail", "LazyFrame", pl_slice_tail, envir = asNamespace("dplyr"))
    registerS3method("slice_tail", "LazyGroupBy", pl_slice_tail, envir = asNamespace("dplyr"))

    registerS3method("summarize", "GroupBy", pl_summarize, envir = asNamespace("dplyr"))
    registerS3method("summarise", "GroupBy", pl_summarise, envir = asNamespace("dplyr"))
    registerS3method("summarize", "LazyGroupBy", pl_summarize, envir = asNamespace("dplyr"))
    registerS3method("summarise", "LazyGroupBy", pl_summarise, envir = asNamespace("dplyr"))

    registerS3method("ungroup", "GroupBy", pl_ungroup, envir = asNamespace("dplyr"))
    registerS3method("ungroup", "LazyGroupBy", pl_ungroup, envir = asNamespace("dplyr"))

  }
  if(requireNamespace("tidyr", quietly = TRUE)) {

    registerS3method("complete", "DataFrame", pl_complete, envir = asNamespace("tidyr"))
    registerS3method("complete", "LazyFrame", pl_complete, envir = asNamespace("tidyr"))

    registerS3method("drop_na", "DataFrame", pl_drop_na, envir = asNamespace("tidyr"))
    registerS3method("drop_na", "LazyFrame", pl_drop_na, envir = asNamespace("tidyr"))

    registerS3method("fill", "DataFrame", pl_fill, envir = asNamespace("tidyr"))
    registerS3method("fill", "GroupBy", pl_fill, envir = asNamespace("tidyr"))
    registerS3method("fill", "LazyFrame", pl_fill, envir = asNamespace("tidyr"))
    registerS3method("fill", "LazyGroupBy", pl_fill, envir = asNamespace("tidyr"))

    registerS3method("pivot_longer", "DataFrame", pl_pivot_longer, envir = asNamespace("tidyr"))
    registerS3method("pivot_longer", "LazyFrame", pl_pivot_longer, envir = asNamespace("tidyr"))

    registerS3method("pivot_wider", "DataFrame", pl_pivot_wider, envir = asNamespace("tidyr"))
    registerS3method("pivot_wider", "LazyFrame", pl_pivot_wider, envir = asNamespace("tidyr"))

    registerS3method("replace_na", "DataFrame", pl_replace_na, envir = asNamespace("tidyr"))
    registerS3method("replace_na", "LazyFrame", pl_replace_na, envir = asNamespace("tidyr"))

    registerS3method("separate", "DataFrame", pl_separate, envir = asNamespace("tidyr"))
    registerS3method("separate", "LazyFrame", pl_separate, envir = asNamespace("tidyr"))

    registerS3method("unite", "DataFrame", pl_unite, envir = asNamespace("tidyr"))
    registerS3method("unite", "LazyFrame", pl_unite, envir = asNamespace("tidyr"))
  }
}
# nocov end
