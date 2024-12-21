### [GENERATED AUTOMATICALLY] Update test-fill.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic behavior works", {
	pl_test <- polars::pl$LazyFrame(
		grp = rep(c("A", "B"), each = 3),
		x = c(NA, 1, NA, NA, 2, NA),
		y = c(3, NA, 4, NA, 3, 1)
	)

	expect_is_tidypolars(fill(pl_test, everything(), .direction = "down"))

	expect_equal_lazy(
		fill(pl_test, everything(), .direction = "down") |>
			pull(x),
		c(NA, 1, 1, 1, 2, 2)
	)

	expect_equal_lazy(
		fill(pl_test, everything(), .direction = "down"),
		fill(pl_test, x, y)
	)

	expect_equal_lazy(
		fill(pl_test, everything(), .direction = "updown") |>
			pull(x),
		c(1, 1, 2, 2, 2, 2)
	)

	expect_equal_lazy(
		fill(pl_test, everything(), .direction = "downup") |>
			pull(x),
		c(1, 1, 1, 1, 2, 2)
	)
})

test_that("when nothing to fill, input = output", {
	pl_test <- polars::pl$LazyFrame(
		grp = rep(c("A", "B"), each = 3),
		x = c(NA, 1, NA, NA, 2, NA),
		y = c(3, NA, 4, NA, 3, 1)
	)

	expect_equal_lazy(
		pl_test |> fill(.direction = "updown"),
		pl_test
	)
})

test_that("works with grouped data", {
	pl_grouped <- polars::pl$LazyFrame(
		grp = rep(c("A", "B"), each = 3),
		x = c(NA, 1, NA, NA, 2, NA),
		y = c(3, NA, 4, NA, 3, 1)
	) |>
		group_by(grp, maintain_order = TRUE)

	expect_equal_lazy(
		fill(pl_grouped, everything(), .direction = "down") |>
			pull(x),
		c(NA, 1, 1, NA, 2, 2)
	)

	expect_equal_lazy(
		fill(pl_grouped, everything(), .direction = "downup") |>
			pull(y),
		c(3, 3, 4, 3, 3, 1)
	)

	expect_equal_lazy(
		fill(pl_grouped, everything(), .direction = "updown") |>
			pull(y),
		c(3, 4, 4, 3, 3, 1)
	)

	expect_equal_lazy(
		fill(pl_grouped, everything(), .direction = "down") |>
			attr("pl_grps"),
		"grp"
	)

	expect_equal_lazy(
		fill(pl_grouped, everything(), .direction = "down") |>
			attr("maintain_grp_order"),
		TRUE
	)
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
