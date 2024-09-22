library(lubridate)
library(quickcheck)
library(stringr)

lf <- list.files(test_path(), pattern = "^test")
eager <- lf[grep("lazy", lf, invert = TRUE)]

exceptions <- c("test-benchmark.R", "test-compute.R", "test-collect.R",
                "test-describe.R", "test-fetch.R",
                "test-group-split.R",
                "test-pivot-wider.R", "test-sink-csv.R",
                "test-sink.R", "test-summary.R", "test-utils.R",
                "test-write.R")

eager <- setdiff(eager, exceptions)

for (i in eager) {
  tmp <- readLines(test_path(i))
  out <- gsub("pl\\$DataFrame", "pl\\$LazyFrame", tmp)
  out <- gsub("expect_equal", "expect_equal_lazy", out)
  out <- gsub("expect_error", "expect_error_lazy", out)
  out <- paste0("### [GENERATED AUTOMATICALLY] Update ", i, " instead.\n\n",
                "Sys.setenv('TIDYPOLARS_TEST' = TRUE)\n\n",
                paste(out, collapse = "\n"),
                "\n\nSys.setenv('TIDYPOLARS_TEST' = FALSE)")
  cat(out, file = test_path(gsub("\\.R$", "-lazy\\.R", i)))
}

