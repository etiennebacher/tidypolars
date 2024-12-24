### [GENERATED AUTOMATICALLY] Update test-complete.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
	test <- polars::pl$LazyFrame(
		country = c("France", "France", "UK", "UK", "Spain"),
		year = c(2020, 2021, 2019, 2020, 2022),
		value = c(1, 2, 3, 4, 5)
	)

	expect_is_tidypolars(complete(test, country, year))

	expect_dim(
		complete(test, country, year),
		c(12, 3)
	)

	expect_equal_lazy(
		complete(test, country, year) |>
			pull(country),
		rep(c("France", "Spain", "UK"), each = 4)
	)

	expect_equal_lazy(
		complete(test, country, year) |>
			slice_head(n = 4) |>
			pull(value),
		c(NA, 1, 2, NA)
	)

	expect_equal_lazy(
		complete(test, country, year, fill = list(value = 99)) |>
			slice_head(n = 4) |>
			pull(value),
		c(99, 1, 2, 99)
	)

	expect_equal_lazy(
		complete(test, country),
		test
	)
})

test_that("works on grouped data", {
	df <- pl$LazyFrame(
		g = c("a", "b", "a"),
		a = c(1L, 1L, 2L),
		b = c("a", "a", "b"),
		c = c(4, 5, 6)
	)
	gdf <- group_by(df, g, maintain_order = TRUE)
	out <- complete(gdf, a, b)

	expect_equal_lazy(
		out,
		data.frame(
			g = c(rep("a", 4), "b"),
			a = c(1, 1, 2, 2, 1),
			b = c("a", "b", "a", "b", "a"),
			c = c(4, NA, NA, 6, 5)
		)
	)

	expect_equal_lazy(
		attr(out, "pl_grps"),
		"g"
	)

	expect_equal_lazy(
		attr(out, "maintain_grp_order"),
		TRUE
	)
})

test_that("argument 'explicit' works", {
	df <- pl$LazyFrame(
		g = c("a", "b", "a"),
		a = c(1L, 1L, 2L),
		b = c("a", NA, "b"),
		c = c(4, 5, NA)
	)

	expect_equal_lazy(
		df |>
			complete(g, a, fill = list(b = "foo", c = 1), explicit = FALSE),
		data.frame(
			g = rep(c("a", "b"), each = 2),
			a = rep(1:2, 2),
			b = c("a", "b", NA, "foo"),
			c = c(4, NA, 5, 1)
		)
	)

	expect_equal_lazy(
		df |>
			group_by(g, maintain_order = TRUE) |>
			complete(a, b, fill = list(c = 1), explicit = FALSE),
		data.frame(
			g = rep(c("a", "b"), c(4L, 1L)),
			a = c(1L, 1L, 2L, 2L, 1L),
			b = c("a", "b", "a", "b", NA),
			c = c(4, 1, 1, NA, 5)
		)
	)
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
