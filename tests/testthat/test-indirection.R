test_that("basic behavior works", {
	test <- pl$DataFrame(x = c(1, 1, 1), y = 4:6, z = c("a", "a", "b"))

	add_one <- function(data, add_col) {
		data |>
			mutate(new_col = {{ add_col }} + 1)
	}

	add_two <- function(data, add_col) {
		data |>
			mutate("{{add_col}}_plus_2" := {{ add_col }} + 2)
	}

	var_summary <- function(data, var) {
		data |>
			summarise(min = min({{ var }}), max = max({{ var }}))
	}

	expect_equal(
		test |>
			add_one(x) |>
			pull(new_col),
		rep(2, 3)
	)

	expect_equal(
		test |>
			add_two(x) |>
			pull(x_plus_2),
		rep(3, 3)
	)

	pl_mtcars <- as_polars_df(mtcars)

	out <- pl_mtcars |>
		group_by(cyl) |>
		var_summary(mpg)

	expect_equal(
		out |> arrange(min) |> pull(min),
		c(10.4, 17.8, 21.4)
	)

	expect_equal(
		out |> arrange(max) |> pull(max),
		c(19.2, 21.4, 33.9)
	)
})
