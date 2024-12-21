### [GENERATED AUTOMATICALLY] Update test-pull.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
	test <- polars::as_polars_lf(mtcars)

	expect_equal_lazy(
		pull(test, mpg),
		mtcars$mpg
	)

	expect_equal_lazy(
		pull(test, "mpg"),
		mtcars$mpg
	)

	expect_equal_lazy(
		pull(test, 1),
		mtcars$mpg
	)
})

test_that("error cases work", {
	test <- polars::as_polars_lf(mtcars)

	expect_snapshot_lazy(
		pull(test, dplyr::all_of(c("mpg", "drat"))),
		error = TRUE
	)
	expect_snapshot_lazy(
		pull(test, mpg, drat, hp),
		error = TRUE
	)
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
