
if ( requireNamespace("tinytest", quietly=TRUE) ){
  library(dplyr, warn.conflicts = FALSE)
  library(tidyr, warn.conflicts = FALSE)
  tinytest::test_package("tidypolars", testdir = "tinytest")
}

