
if ( requireNamespace("tinytest", quietly=TRUE) ){
  source("tests/tinytest/setup.R")
  tinytest::test_package("tidypolars", testdir = "tinytest")
}

