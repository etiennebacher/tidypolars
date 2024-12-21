### [GENERATED AUTOMATICALLY] Update test-n.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
	test <- pl$LazyFrame(
		x1 = c("a", "a", "b", "a", "c"),
		x2 = c(2, 1, 5, 3, 1),
		x3 = 1:5
	)

	expect_equal_lazy(
		test |>
			summarize(n_obs = n()) |>
			pull(n_obs),
		5
	)
})

test_that("works with grouped data", {
	test <- pl$LazyFrame(
		x1 = c("a", "a", "b", "a", "c"),
		x2 = c(2, 1, 5, 3, 1),
		x3 = 1:5
	)
	expect_equal_lazy(
		test |>
			summarize(n_obs = n(), .by = x1) |>
			pull(n_obs) |>
			sort(decreasing = TRUE),
		c(3, 1, 1)
	)

	expect_equal_lazy(
		test |>
			group_by(x1) |>
			summarize(n_obs = n()) |>
			pull(n_obs) |>
			sort(decreasing = TRUE),
		c(3, 1, 1)
	)
})

test_that("works in computation", {
	test <- pl$LazyFrame(
		x1 = c("a", "a", "b", "a", "c"),
		x2 = c(2, 1, 5, 3, 1),
		x3 = 1:5
	)
	expect_equal_lazy(
		test |>
			group_by(x1) |>
			summarize(foo = mean(x3) / n()) |>
			pull(foo) |>
			sort(decreasing = TRUE),
		c(5, 3, 0.7777),
		tolerance = 0.001
	)
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
