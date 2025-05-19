# error if no common variables and and `by` no provided

    Code
      left_join(test, neopolars::as_polars_df(iris))
    Condition
      Error in `left_join()`:
      ! `by` must be supplied when `x` and `y` have no common variables.
      i Use `cross_join()` to perform a cross-join.

# argument suffix works

    Code
      left_join(test, test2, by = c("x", "y"), suffix = c(".hi"))
    Condition
      Error in `left_join()`:
      ! `suffix` must be of length 2.

# suffix + join_by works

    Code
      left_join(test, test2, by = join_by(x, y), suffix = c(".hi"))
    Condition
      Error in `left_join()`:
      ! `suffix` must be of length 2.

# argument relationship works

    Code
      left_join(test, test2, by = join_by(x, y), relationship = "foo")
    Condition
      Error in `left_join()`:
      ! `relationship` must be one of "one-to-one", "one-to-many", "many-to-one", or "many-to-many", not "foo".

---

    Code
      do.call(i, list(country, country_year, join_by(iso), relationship = "one-to-one"))
    Condition
      Error in `x$join()`:
      ! Evaluation failed in `$join()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill 1:1 validation

---

    Code
      do.call(i, list(country, country_year, join_by(iso), relationship = "many-to-one"))
    Condition
      Error in `x$join()`:
      ! Evaluation failed in `$join()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill m:1 validation

---

    Code
      do.call(i, list(country, country_year, join_by(iso), relationship = "one-to-one"))
    Condition
      Error in `x$join()`:
      ! Evaluation failed in `$join()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill 1:1 validation

---

    Code
      do.call(i, list(country, country_year, join_by(iso), relationship = "many-to-one"))
    Condition
      Error in `x$join()`:
      ! Evaluation failed in `$join()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill m:1 validation

---

    Code
      do.call(i, list(country, country_year, join_by(iso), relationship = "one-to-one"))
    Condition
      Error in `x$join()`:
      ! Evaluation failed in `$join()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill 1:1 validation

---

    Code
      do.call(i, list(country, country_year, join_by(iso), relationship = "many-to-one"))
    Condition
      Error in `x$join()`:
      ! Evaluation failed in `$join()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill m:1 validation

---

    Code
      right_join(country, country_year, join_by(iso), relationship = "one-to-one")
    Condition
      Error in `y$join()`:
      ! Evaluation failed in `$join()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill 1:1 validation

---

    Code
      right_join(country, country_year, join_by(iso), relationship = "one-to-many")
    Condition
      Error in `y$join()`:
      ! Evaluation failed in `$join()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! join keys did not fulfill 1:m validation

# argument na_matches works

    Code
      left_join(pdf1, pdf2, na_matches = "foo")
    Condition
      Error in `left_join()`:
      ! `relationship` must be one of "na" or "never", not "foo".

# error if two inputs don't have the same class

    Code
      left_join(test, iris)
    Condition
      Error in `left_join()`:
      ! `x` and `y` must be either two DataFrames or two LazyFrames.

# unsupported args throw warning

    Code
      left_join(test, test2, by = "country", keep = TRUE)
    Condition
      Error in `left_join()`:
      ! Argument `keep` is not supported by tidypolars.
      i Use `options(tidypolars_unknown_args = "warn")` to warn when this happens instead of throwing an error.

# dots must be empty

    Code
      left_join(test, test2, by = "country", foo = TRUE)
    Condition
      Error in `left_join()`:
      ! `...` must be empty.
      x Problematic argument:
      * foo = TRUE

---

    Code
      left_join(test, test2, by = "country", copy = TRUE, foo = TRUE)
    Condition
      Warning in `left_join()`:
      Argument `copy` is not supported by tidypolars.
      Error in `left_join()`:
      ! `...` must be empty.
      x Problematic argument:
      * foo = TRUE

