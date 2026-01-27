### [GENERATED AUTOMATICALLY] Update test-join_inequality.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

test_that("basic inequality join works", {
  companies <- tibble(
    id = c("A", "B", "B"),
    since = c(1973, 2009, 2022),
    name = c("Patagonia", "RStudio", "Posit")
  )

  transactions <- tibble(
    company = c("A", "A", "B", "B"),
    year = c(2019, 2020, 2021, 2023),
    revenue = c(50, 4, 10, 12)
  )

  companies_pl <- as_polars_lf(companies)
  transactions_pl <- as_polars_lf(transactions)

  by <- join_by(company == id, year >= since)
  expect_equal_lazy(
    inner_join(transactions_pl, companies_pl, by),
    inner_join(transactions, companies, by)
  )
})

test_that("inequality joins only work in inner joins for now", {
  a <- pl$LazyFrame(x = 1)
  b <- pl$LazyFrame(y = 1)
  expect_snapshot_lazy(
    left_join(a, b, join_by(x > y)),
    error = TRUE
  )
  expect_snapshot_lazy(
    left_join(a, b, join_by(within(x, y, z))),
    error = TRUE
  )
})

# Can't use patrick here because join_by() requires the use of !!, which is not
# accepted by patrick
test_that("'between' helper works", {
  segments <- tibble(
    segment_id = 1:4,
    chromosome = c("chr1", "chr2", "chr2", "chr1"),
    start = c(140, 210, 380, 230),
    end = c(150, 240, 415, 280)
  )
  reference <- tibble(
    reference_id = 1:4,
    chromosome = c("chr1", "chr1", "chr2", "chr2"),
    start = c(100, 200, 300, 415),
    end = c(150, 250, 399, 450)
  )

  segments_pl <- as_polars_lf(segments)
  reference_pl <- as_polars_lf(reference)

  for (bnds in c("[]", "[)", "(]", "()")) {
    by <- join_by(
      chromosome,
      between(start, start, end, bounds = !!bnds)
    )

    expect_equal_lazy(
      inner_join(segments_pl, reference_pl, by) |>
        arrange(segment_id),
      inner_join(segments, reference, by)
    )

    by2 <- join_by(
      chromosome,
      between(x$start, y$start, y$end, bounds = !!bnds)
    )

    expect_equal_lazy(
      inner_join(segments_pl, reference_pl, by2) |>
        arrange(segment_id),
      inner_join(segments, reference, by2)
    )
  }
})

test_that("'within' helper works", {
  segments <- tibble(
    segment_id = 1:4,
    chromosome = c("chr1", "chr2", "chr2", "chr1"),
    start = c(140, 210, 380, 230),
    end = c(150, 240, 415, 280)
  )
  reference <- tibble(
    reference_id = 1:4,
    chromosome = c("chr1", "chr1", "chr2", "chr2"),
    start = c(100, 200, 300, 415),
    end = c(150, 250, 399, 450)
  )

  segments_pl <- as_polars_lf(segments)
  reference_pl <- as_polars_lf(reference)

  by <- join_by(
    chromosome,
    within(start, end, start, end)
  )

  expect_equal_lazy(
    inner_join(segments_pl, reference_pl, by) |>
      arrange(segment_id),
    inner_join(segments, reference, by)
  )

  by2 <- join_by(
    chromosome,
    within(x$start, x$end, y$start, y$end)
  )

  expect_equal_lazy(
    inner_join(segments_pl, reference_pl, by2) |>
      arrange(segment_id),
    inner_join(segments, reference, by2)
  )
})

test_that("'overlaps' helper works", {
  segments <- tibble(
    segment_id = 1:4,
    chromosome = c("chr1", "chr2", "chr2", "chr1"),
    start = c(140, 210, 380, 230),
    end = c(150, 240, 415, 280)
  )
  reference <- tibble(
    reference_id = 1:4,
    chromosome = c("chr1", "chr1", "chr2", "chr2"),
    start = c(100, 200, 300, 415),
    end = c(150, 250, 399, 450)
  )

  segments_pl <- as_polars_lf(segments)
  reference_pl <- as_polars_lf(reference)

  for (bnds in c("[]", "[)", "(]", "()")) {
    by <- join_by(
      chromosome,
      overlaps(start, end, start, end, bounds = !!bnds)
    )

    expect_equal_lazy(
      inner_join(segments_pl, reference_pl, by) |>
        arrange(segment_id),
      inner_join(segments, reference, by)
    )

    by2 <- join_by(
      chromosome,
      overlaps(x$start, x$end, y$start, y$end, bounds = !!bnds)
    )

    expect_equal_lazy(
      inner_join(segments_pl, reference_pl, by2) |>
        arrange(segment_id),
      inner_join(segments, reference, by2)
    )
  }
})

test_that("all common columns are used in join conditions", {
  # https://stackoverflow.com/questions/79782259/tidypolars-strange-error-with-inequality-join
  x <- tibble(
    id = c(1, 1, 2, 2),
    t = as.POSIXct("2023-05-02 12:00") %m+% months(0:3)
  )
  x_pl <- as_polars_lf(x)

  y <- tibble(
    id = c(1, 1, 2, 2),
    start = as.POSIXct("2023-05-01 12:00") %m+% months(0:3),
    end = as.POSIXct("2023-05-03 12:00") %m+% months(0:3),
  )
  y_pl <- as_polars_lf(y)

  expect_equal_lazy(
    x_pl |> inner_join(y_pl, by = join_by(id, between(t, start, end))),
    x |> inner_join(y, by = join_by(id, between(t, start, end)))
  )
})

Sys.setenv('TIDYPOLARS_TEST' = FALSE)
