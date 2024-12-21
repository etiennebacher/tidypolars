test_that("works with ungrouped data", {
	spl <- as_polars_df(iris) |>
		group_split(Species)

	expect_equal(length(spl), 3)
	expect_equal(lapply(spl, nrow), list(50, 50, 50))
})

test_that("works with when split variables and group variables are the same", {
	test <- as_polars_df(iris) |>
		group_by(Species)

	spl2 <- group_split(test)

	expect_equal(length(spl2), 3)
	expect_equal(lapply(spl2, nrow), list(50, 50, 50))
})

test_that("warn that split variables that are not group variables are ignored", {
	test <- as_polars_df(iris) |>
		group_by(Species)

	expect_warning(
		group_split(test, Sepal.Length),
		"is already grouped so variables"
	)
})
