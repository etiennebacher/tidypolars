lf <- list.files("tests/tinytest", pattern = "^test")
eager <- lf[grep("lazy", lf, invert = TRUE)]

# TODO: there should be no exceptions eventually
exceptions <- c("test_bind.R", "test_collect.R", "test_fill.R", "test_mutate.R",
                "test_pivot_longer.R", "test_pivot_wider.R", "test_separate.R",
                "test_summarize.R")

eager <- setdiff(eager, exceptions)

for (i in eager) {
  tmp <- readLines(paste0("tests/tinytest/", i))
  out <- gsub("pl\\$DataFrame", "pl\\$LazyFrame", tmp)
  out <- gsub("expect_equal", "expect_equal_lazy", out)
  out <- gsub("expect_error", "expect_error_lazy", out)
  out <- paste0("### [GENERATED AUTOMATICALLY] Update ", i, " instead.\n\n",
                "Sys.setenv('TIDYPOLARS_TEST' = TRUE)\n\n",
                paste(out, collapse = "\n"),
                "\n\nSys.setenv('TIDYPOLARS_TEST' = FALSE)")
  cat(out, file = paste0("tests/tinytest/", gsub("\\.R$", "_lazy\\.R", i)))
}


