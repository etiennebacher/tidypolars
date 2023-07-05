# https://stackoverflow.com/questions/76475424/conditionally-provide-methods-for-generics-from-another-package/
.onLoad <- function(libname, pkgname) {
  if(requireNamespace("dplyr", quietly = TRUE)) {
    registerS3method("arrange", "DataFrame", pl_arrange, envir = asNamespace("dplyr"))
    registerS3method("bind_cols", "DataFrame", pl_bind_cols, envir = asNamespace("dplyr"))
    registerS3method("bind_rows", "DataFrame", pl_bind_rows, envir = asNamespace("dplyr"))
    registerS3method("collect", "DataFrame", pl_collect, envir = asNamespace("dplyr"))
    registerS3method("count", "DataFrame", pl_count, envir = asNamespace("dplyr"))
    registerS3method("count", "GroupBy", pl_count, envir = asNamespace("dplyr"))
    registerS3method("add_count", "DataFrame", pl_add_count, envir = asNamespace("dplyr"))
    registerS3method("add_count", "GroupBy", pl_add_count, envir = asNamespace("dplyr"))
    registerS3method("distinct", "DataFrame", pl_distinct, envir = asNamespace("dplyr"))
    registerS3method("filter", "DataFrame", pl_filter, envir = asNamespace("dplyr"))
    registerS3method("group_by", "DataFrame", pl_group_by, envir = asNamespace("dplyr"))
    registerS3method("mutate", "DataFrame", pl_mutate, envir = asNamespace("dplyr"))
    registerS3method("pull", "DataFrame", pl_pull, envir = asNamespace("dplyr"))
    registerS3method("rename", "DataFrame", pl_rename, envir = asNamespace("dplyr"))
    registerS3method("rename_with", "DataFrame", pl_rename_with, envir = asNamespace("dplyr"))
    registerS3method("select", "DataFrame", pl_select, envir = asNamespace("dplyr"))
    registerS3method("slice_head", "DataFrame", pl_slice_head, envir = asNamespace("dplyr"))
    registerS3method("slice_tail", "DataFrame", pl_slice_tail, envir = asNamespace("dplyr"))
    registerS3method("summarize", "GroupBy", pl_summarize, envir = asNamespace("dplyr"))
    registerS3method("summarise", "GroupBy", pl_summarise, envir = asNamespace("dplyr"))
    registerS3method("ungroup", "GroupBy", pl_ungroup, envir = asNamespace("dplyr"))
  }
  if(requireNamespace("tidyr", quietly = TRUE)) {
    registerS3method("complete", "DataFrame", pl_complete, envir = asNamespace("tidyr"))
    registerS3method("drop_na", "DataFrame", pl_drop_na, envir = asNamespace("tidyr"))
    registerS3method("fill", "DataFrame", pl_fill, envir = asNamespace("tidyr"))
    registerS3method("pivot_longer", "DataFrame", pl_pivot_longer, envir = asNamespace("tidyr"))
    registerS3method("pivot_wider", "DataFrame", pl_pivot_wider, envir = asNamespace("tidyr"))
    registerS3method("replace_na", "DataFrame", pl_replace_na, envir = asNamespace("tidyr"))
    registerS3method("separate", "DataFrame", pl_separate, envir = asNamespace("tidyr"))
    registerS3method("unite", "DataFrame", pl_unite, envir = asNamespace("tidyr"))
  }
}
