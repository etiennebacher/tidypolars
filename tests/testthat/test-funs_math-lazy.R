### [GENERATED AUTOMATICALLY] Update test-funs_math.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("mathematical functions work", {
	test_df <- data.frame(
		x1 = c("a", "a", "b", "a", "c"),
		x2 = c(2, 1, 5, 3, 1),
		value = sample(11:15),
		value_trigo = seq(0, 0.4, 0.1),
		value_mix = -2:2,
		value_with_NA = c(-2, -1, NA, 1, 2)
	)
	test <- as_polars_lf(test_df)

	for (i in c(
		"abs",
		"acos",
		"acosh",
		"asin",
		"asinh",
		"atan",
		"atanh",
		"ceiling",
		"cos",
		"cosh",
		"cummin",
		"cumprod",
		"cumsum",
		"exp",
		"first",
		"floor",
		"last",
		"log",
		"log10",
		"rank",
		"sign",
		"sin",
		"sinh",
		"sort",
		"sqrt",
		"tan",
		"tanh"
	)) {
		if (
			i %in%
				c(
					"acos",
					"asin",
					"atan",
					"atanh",
					"ceiling",
					"cos",
					"floor",
					"sin",
					"tan"
				)
		) {
			variable <- "value_trigo"
		} else if (i %in% c("abs", "mean")) {
			variable <- "value_mix"
		} else {
			variable <- "value"
		}

		pol <- paste0("mutate(test, foo =", i, "(", variable, "))") |>
			str2lang() |>
			eval() |>
			pull(foo)

		res <- paste0("mutate(test_df, foo =", i, "(", variable, "))") |>
			str2lang() |>
			eval() |>
			pull(foo)

		expect_equal_lazy(pol, res, info = i)
	}
})

test_that("warns if unknown args", {
	test_df <- data.frame(
		x1 = c("a", "a", "b", "a", "c"),
		x2 = c(2, 1, 5, 3, 1),
		value = sample(11:15),
		value_trigo = seq(0, 0.4, 0.1),
		value_mix = -2:2,
		value_with_NA = c(-2, -1, NA, 1, 2)
	)
	test <- as_polars_lf(test_df)
	foo <- test |>
		mutate(x = sample(x2)) |>
		pull(x)

	expect_true(all(foo %in% c(1, 2, 3, 5)))

	expect_warning(
		test |> mutate(x = sample(x2, prob = 0.5)),
		"doesn't know how to use some arguments"
	)
})

test_that("diff() works", {
	test_df <- data.frame(
		x1 = c("a", "a", "b", "a", "c"),
		x2 = c(2, 1, 5, 3, 1),
		value = sample(11:15),
		value_trigo = seq(0, 0.4, 0.1),
		value_mix = -2:2,
		value_with_NA = c(-2, -1, NA, 1, 2)
	)
	test <- as_polars_lf(test_df)
	expect_equal_lazy(
		test |>
			summarize(foo = diff(value)) |>
			pull(foo),
		test_df |>
			summarize(foo = diff(value)) |>
			pull(foo) |>
			suppressWarnings()
	)

	expect_equal_lazy(
		test |>
			summarize(foo = diff(value, lag = 2)) |>
			pull(foo),
		test_df |>
			summarize(foo = diff(value, lag = 2)) |>
			pull(foo) |>
			suppressWarnings()
	)

	expect_error_lazy(
		test |> summarize(foo = diff(value, differences = 2)),
		"doesn't support"
	)
})

test_that("%% and %/% work", {
	test_df <- data.frame(
		x1 = c("a", "a", "b", "a", "c"),
		x2 = c(2, 1, 5, 3, 1),
		value = sample(11:15),
		value_trigo = seq(0, 0.4, 0.1),
		value_mix = -2:2,
		value_with_NA = c(-2, -1, NA, 1, 2)
	)
	test <- as_polars_lf(test_df)

	expect_equal_lazy(
		test |>
			mutate(foo = value %% 10) |>
			pull(foo),
		test_df |>
			mutate(foo = value %% 10) |>
			pull(foo)
	)

	expect_equal_lazy(
		test |>
			mutate(foo = value %/% 10) |>
			pull(foo),
		test_df |>
			mutate(foo = value %/% 10) |>
			pull(foo)
	)
})

test_that("ensure na.rm works fine", {
	test_df <- data.frame(
		x1 = c("a", "a", "b", "a", "c"),
		x2 = c(2, 1, 5, 3, 1),
		value = sample(11:15),
		value_trigo = seq(0, 0.4, 0.1),
		value_mix = -2:2,
		value_with_NA = c(-2, -1, NA, 1, 2)
	)
	test <- as_polars_lf(test_df)

	for (i in c("max", "mean", "median", "min", "sd", "sum", "var")) {
		for (remove_na in c(TRUE, FALSE)) {
			pol <- paste0(
				"mutate(test, foo =",
				i,
				"(value_with_NA, na.rm = ",
				remove_na,
				"))"
			) |>
				str2lang() |>
				eval() |>
				pull(foo)

			res <- paste0(
				"mutate(test_df, foo =",
				i,
				"(value_with_NA, na.rm = ",
				remove_na,
				"))"
			) |>
				str2lang() |>
				eval() |>
				pull(foo)

			expect_equal_lazy(pol, res, info = i)
		}
	}
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
