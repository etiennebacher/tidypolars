test_that("basic behavior works", {
	pl_iris <- polars::as_polars_df(iris)
	pl_iris_g <- pl_iris |>
		group_by(Species, maintain_order = TRUE)

	expect_equal(
		summarize(pl_iris_g, x = mean(Sepal.Length)) |>
			pull(x),
		c(5.006, 5.936, 6.588)
	)

	expect_equal(
		summarize(pl_iris, x = mean(Sepal.Length), .by = Species) |>
			pull(x) |>
			sort(),
		summarize(pl_iris_g, x = mean(Sepal.Length)) |>
			pull(x) |>
			sort()
	)

	expect_equal(
		summarize(pl_iris_g, x = sum(Sepal.Length), y = mean(Sepal.Length)) |>
			pull(y),
		c(5.006, 5.936, 6.588)
	)

	expect_equal(
		summarize(pl_iris_g, x = 1) |>
			pull(x),
		rep(1, 3)
	)

	expect_equal(
		summarize(pl_iris, x = mean(Petal.Length)) |>
			pull(x),
		3.758
	)

	expect_colnames(
		summarize(pl_iris_g, Sepal.Length = NULL),
		names(iris)[2:5]
	)
})

test_that("correctly handles attributes", {
	pl_mtcars <- polars::as_polars_df(mtcars)
	pl_mtcars_g <- pl_mtcars |>
		group_by(cyl, am, maintain_order = TRUE)

	expect_equal(
		summarize(pl_mtcars_g, x = mean(mpg)) |>
			attr("pl_grps"),
		"cyl"
	)

	expect_equal(
		summarize(pl_mtcars_g, x = mean(mpg)) |>
			attr("maintain_grp_order"),
		TRUE
	)

	expect_equal(
		summarize(pl_mtcars, x = mean(mpg), .by = c(cyl, am)) |>
			attr("pl_grps"),
		NULL
	)

	expect_equal(
		summarize(pl_mtcars, x = mean(mpg), .by = c(cyl, am)) |>
			attr("maintain_grp_order"),
		NULL
	)

	expect_is_tidypolars(
		summarize(pl_mtcars, x = mean(mpg), .by = c(cyl, am))
	)
})

test_that("works with a local variable defined in a function", {
	pl_iris <- polars::as_polars_df(iris)
	pl_iris_g <- pl_iris |>
		group_by(Species, maintain_order = TRUE)

	foobar <- function(x) {
		local_var <- "a"
		x |> summarize(foo = local_var)
	}

	test <- polars::pl$DataFrame(chars = letters[1:3])

	expect_equal(
		foobar(test),
		data.frame(foo = "a")
	)
})

test_that("check .add argument of group_by works", {
	test <- polars::as_polars_df(mtcars)

	expect_equal(
		test |>
			group_by(cyl, am, maintain_order = TRUE) |>
			summarize(foo = sum(drat)),
		test |>
			group_by(cyl, maintain_order = TRUE) |>
			group_by(am, maintain_order = TRUE, .add = TRUE) |>
			summarize(foo = sum(drat))
	)
})

test_that("argument .groups works", {
	pl_mtcars <- as_polars_df(mtcars)

	# default is "drop_last"
	expect_equal(
		pl_mtcars |>
			group_by(am, cyl, vs) |>
			summarise(cyl_n = n()) |>
			group_vars(),
		c("am", "cyl")
	)

	# other values
	expect_equal(
		pl_mtcars |>
			group_by(am, cyl, vs) |>
			summarise(cyl_n = n(), .groups = "drop_last") |>
			group_vars(),
		c("am", "cyl")
	)
	expect_equal(
		pl_mtcars |>
			group_by(am, cyl, vs) |>
			summarise(cyl_n = n(), .groups = "keep") |>
			group_vars(),
		c("am", "cyl", "vs")
	)
	expect_equal(
		pl_mtcars |>
			group_by(am, cyl, vs) |>
			summarise(cyl_n = n(), .groups = "drop") |>
			group_vars(),
		character(0)
	)
	expect_snapshot(
		pl_mtcars |>
			group_by(am, cyl, vs) |>
			summarise(cyl_n = n(), .groups = "rowwise"),
		error = TRUE
	)
	expect_snapshot(
		pl_mtcars |>
			group_by(am, cyl, vs) |>
			summarise(cyl_n = n(), .groups = "foobar"),
		error = TRUE
	)

	# "drop_last" with one group originally
	expect_equal(
		pl_mtcars |>
			group_by(am) |>
			summarise(cyl_n = n(), .groups = "drop_last") |>
			group_vars(),
		character(0)
	)
})
