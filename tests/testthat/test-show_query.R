### This is disabled by default but I don't want to enable it in each test of
### show_query().
withr::local_options(tidypolars_record_query = TRUE)

get_query <- function(x) {
  attr(x, "tp_query", exact = TRUE)
}

replay_query <- function(x) {
  pl <- polars::pl
  eval(parse(text = get_query(x)), envir = caller_env())
}

# A small frame with numeric, integer, string, logical, date and datetime
# columns, used by the "translated functions" tests further down.
tp_test_frame <- function() {
  polars::pl$DataFrame(
    num = c(1.5, -2.3, 4, NA, 6.7),
    int = c(2L, 3L, 1L, 5L, 4L),
    grp = c("a", "a", "b", "b", "a"),
    txt = c("Hello World", "foo bar", "BAZ", NA, "a1b2"),
    lgl1 = c(TRUE, FALSE, TRUE, NA, FALSE),
    lgl2 = c(TRUE, TRUE, FALSE, FALSE, TRUE),
    date = as.Date(c(
      "2020-01-15",
      "2021-06-30",
      "2019-12-01",
      "2022-03-10",
      "2020-07-04"
    )),
    time = as.POSIXct(
      c(
        "2020-01-15 08:30:00",
        "2021-06-30 14:00:00",
        "2019-12-01 23:59:00",
        "2022-03-10 00:00:00",
        "2020-07-04 12:15:00"
      ),
      tz = "UTC"
    )
  )
}

test_that("basic behavior works", {
  query <- mtcars |>
    as_polars_df() |>
    arrange(cyl, desc(disp)) |>
    distinct(cyl, am, .keep_all = TRUE)

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("head()/tail() start recording when they are the first verb", {
  query_head <- mtcars |>
    as_polars_df() |>
    head()
  query_tail <- mtcars |>
    as_polars_df() |>
    tail(3)

  expect_snapshot(show_query(query_head))
  expect_snapshot(show_query(query_tail))

  expect_equal(replay_query(query_head), query_head)
  expect_equal(replay_query(query_tail), query_tail)
})

test_that("show_query() works with group_by() and summarize()", {
  query <- mtcars |>
    as_polars_df() |>
    group_by(cyl, maintain_order = TRUE) |>
    summarize(mean_mpg = mean(mpg)) |>
    ungroup()

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("show_query() works with joins and shows the query of both inputs", {
  lhs <- as_polars_df(mtcars) |> select(cyl, mpg)
  rhs <- as_polars_df(mtcars) |> summarize(mean_mpg = mean(mpg), .by = cyl)
  query <- left_join(lhs, rhs, by = "cyl")

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("show_query() works with across()", {
  query <- mtcars |>
    as_polars_df() |>
    mutate(across(contains("m"), mean))

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("user-defined functions returning polars expressions are recorded", {
  pl_standardize <- function(x) {
    (x - x$mean()) / x$std()
  }
  query <- mtcars |>
    as_polars_df() |>
    mutate(mpg_std = pl_standardize(mpg)) |>
    select(mpg_std)

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("compute() records the $collect() call", {
  skip_if(Sys.getenv('TIDYPOLARS_TEST') %in% c("", "FALSE"))
  query <- mtcars |>
    as_polars_df() |>
    filter(cyl == 4) |>
    compute()

  expect_match(get_query(query), "$collect(", fixed = TRUE)

  expect_equal(replay_query(query), query)
})

test_that("long vectors are truncated in the query", {
  large <- runif(200)
  query <- mtcars |>
    as_polars_df() |>
    mutate(foo = mpg %in% large)

  expect_snapshot(show_query(query))

  # Same, but written inline
  query <- mtcars |>
    as_polars_df() |>
    mutate(foo = mpg %in% runif(200))

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("`NULL` arguments are kept in the query", {
  skip_if(Sys.getenv('TIDYPOLARS_TEST') == "TRUE")
  dest <- tempfile(fileext = ".csv")
  on.exit(unlink(dest))
  write.csv(mtcars, dest, row.names = FALSE)

  query <- read_csv_polars(dest) |>
    filter(cyl > 4)

  expect_snapshot(show_query(query), transform = function(x) {
    gsub("source = .*csv\",", "source = [TRUNCATED],", x)
  })
  expect_equal(replay_query(query), query)
})

test_that("count() doesn't record a `NULL` in sort() when input isn't grouped", {
  query <- mtcars |>
    as_polars_df() |>
    count(am)

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("non-syntactic argument names are backquoted in the query", {
  query <- mtcars |>
    as_polars_df() |>
    filter(cyl > 4) |>
    tally()

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)

  test_pl <- as_polars_df(data.frame(
    id = c(1, 1),
    k = c(4, 5),
    v = c(10, 20)
  ))
  query <- pivot_wider(test_pl, names_from = k, values_from = v)

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("count() doesn't record a `NULL` in sort() when input isn't grouped", {
  query <- mtcars |>
    as_polars_df() |>
    count(am)

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("the input data is not modified by the recording", {
  test_pl <- as_polars_df(mtcars)
  invisible(mutate(test_pl, foo = 1))

  expect_false(inherits(test_pl, "tp_recorded"))
  expect_null(get_query(test_pl))
  expect_snapshot(show_query(test_pl), error = TRUE)
})

test_that("the error mentions recording only when the option is FALSE", {
  test_pl <- as_polars_df(mtcars)

  # Recording is on (see the top of this file) but the frame never went
  # through tidypolars, so the message must not blame the option.
  expect_snapshot(show_query(test_pl), error = TRUE)

  withr::with_options(
    list(tidypolars_record_query = FALSE),
    expect_snapshot(show_query(test_pl), error = TRUE)
  )
})

test_that("show_query() rejects extra arguments", {
  query <- mtcars |>
    as_polars_df() |>
    filter(cyl == 4)

  expect_snapshot(show_query(query, foo = 1), error = TRUE)
  expect_snapshot(show_query(query, 2), error = TRUE)
})

test_that("the query is wrapped at the console width", {
  query <- mtcars |>
    as_polars_df() |>
    mutate(across(contains("m"), mean)) |>
    filter(cyl == 4 & am == 1)

  # A wide console keeps the method chains of each argument inline, a narrow
  # one explodes them.
  expect_snapshot(withr::with_options(list(width = 120), show_query(query)))
  expect_snapshot(withr::with_options(list(width = 40), show_query(query)))

  expect_equal(replay_query(query), query)
})

test_that("errors in the pipeline are not affected by the recording", {
  test_pl <- as_polars_df(data.frame(char1 = c("a", "b")))
  expect_snapshot(
    mutate(test_pl, char1 = as.integer(char1)),
    error = TRUE
  )
})

test_that("option tidypolars_record_query = FALSE disables the recording", {
  withr::local_options(tidypolars_record_query = FALSE)

  query <- mtcars |>
    as_polars_df() |>
    filter(cyl == 4)

  expect_null(get_query(query))
  expect_snapshot(show_query(query), error = TRUE)
})

# Test code from vignettes and examples

test_that("vignette 'Getting started': who pipeline", {
  who_pl <- as_polars_df(tidyr::who)

  query <- who_pl |>
    filter(year > 1990) |>
    drop_na(newrel_f3544) |>
    select(iso3, year, matches("^newrel(.*)_f")) |>
    arrange(iso3, year) |>
    rename_with(.fn = toupper) |>
    head()

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("vignette 'R and Polars expressions': unsupported argument is dropped", {
  query <- suppressWarnings(
    mtcars |>
      as_polars_df() |>
      mutate(x = mean(mpg, trim = 2))
  )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("vignette 'R and Polars expressions': external object in filter", {
  dat <- pl$DataFrame(foo = c(2, 1, 2))
  a <- c("d", "e", "f")

  query <- dat |>
    filter(foo >= agrep("a", a))

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("show_query() example: grouped mutate with .by", {
  query <- mtcars |>
    as_polars_df() |>
    filter(cyl == 4) |>
    mutate(mpg2 = mpg * 2, .by = am)

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("mutate() example: logical operation and overwriting a column", {
  query <- iris |>
    as_polars_df() |>
    mutate(big = Sepal.Width > Sepal.Length, Sepal.Width = Sepal.Width * 2)

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("mutate() example: across() with a list of functions and .names", {
  query <- iris |>
    as_polars_df() |>
    mutate(
      across(
        .cols = contains("Sepal"),
        .fns = list(mean = mean, sd = ~ sd(.x)),
        .names = "{.fn}_of_{.col}"
      )
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("filter() example: grouped filter with .by", {
  query <- dplyr::starwars |>
    as_polars_df() |>
    select(name, mass, gender) |>
    filter(mass > mean(mass, na.rm = TRUE), .by = gender)

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("pivot_longer() example: relig_income", {
  query <- tidyr::relig_income |>
    as_polars_df() |>
    pivot_longer(!religion, names_to = "income", values_to = "count")

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("separate() example: split on a dot", {
  query <- polars::pl$DataFrame(x = c(NA, "x.y", "x.z", "y.z")) |>
    separate(x, into = c("foo", "foo2"), sep = "\\.")

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("unite() example: combine columns with a separator", {
  query <- polars::pl$DataFrame(
    year = 2009:2011,
    month = 10:12,
    day = c(11L, 22L, 28L)
  ) |>
    unite(col = "date", year, month, day, sep = "-")

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("relocate() example: move columns with .after", {
  query <- mtcars |>
    as_polars_df() |>
    relocate(hp, vs, .after = "gear")

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("slice example: slice_head() and slice_tail()", {
  query_head <- iris |>
    as_polars_df() |>
    slice_head(n = 3)
  query_tail <- iris |>
    as_polars_df() |>
    slice_tail(n = 3)

  expect_snapshot(show_query(query_head))
  expect_snapshot(show_query(query_tail))

  expect_equal(replay_query(query_head), query_head)
  expect_equal(replay_query(query_tail), query_tail)
})

# Translated functions (see the "List of supported functions" vignette). Each
# test records a query using a family of translated functions and checks that
# the recorded polars code reproduces the original result.

test_that("translated base functions: maths and rounding", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      a = abs(num),
      b = sqrt(int),
      c = exp(num),
      d = log(int),
      e = log10(int),
      f = round(num, 1),
      g = ceiling(num),
      h = floor(num),
      i = trunc(num)
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated base functions: trigonometry", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      a = cos(num),
      b = sin(num),
      c = tan(num),
      d = acos(num / 10),
      e = asin(num / 10),
      f = atan(num),
      g = cosh(num),
      h = sinh(num),
      i = tanh(num)
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated base functions: cumulative and diff", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      cs = cumsum(int),
      cmin = cummin(int),
      cmax = cummax(int),
      rv = rev(int),
      df = int - dplyr::lag(int)
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated base functions: aggregations in summarize()", {
  dat <- tp_test_frame()
  query <- dat |>
    summarize(
      al = all(int > 0),
      an = any(int > 4),
      na = anyNA(num),
      wmn = which.min(num),
      wmx = which.max(num)
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated base functions: string manipulation", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      n = nchar(txt),
      up = toupper(txt),
      lo = tolower(txt),
      p0 = paste0(grp, "_", int),
      p = paste(grp, int, sep = "-")
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated base functions: type conversions", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      ch = as.character(int),
      nu = as.numeric(grp == "a"),
      lg = as.logical(int - 1)
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated base functions: is.* checks", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      na = is.na(num),
      fin = is.finite(num),
      inf = is.infinite(num),
      nan = is.nan(num)
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated base functions: %in% and %notin%", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(ins = grp %in% c("a"), notin = grp %notin% c("a"))

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated dplyr functions: between, coalesce, near, if_else", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      bt = between(int, 2, 4),
      co = coalesce(num, 0),
      nr = near(num, 4),
      ie = if_else(num > 0, "pos", "neg")
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated dplyr functions: case_when (with and without default)", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      with_default = case_when(int > 3 ~ "hi", .default = "lo"),
      no_default = case_when(int > 3 ~ "hi", int > 1 ~ "mid")
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated dplyr functions: case_match (with and without default)", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      with_default = case_match(grp, "a" ~ "A", .default = "Z"),
      no_default = case_match(grp, "a" ~ "A", "b" ~ "B")
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated dplyr functions: recode_values, replace_values, replace_when", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      rc = recode_values(grp, "a" ~ "AA"),
      rv = replace_values(grp, "b" ~ "BB"),
      rw = replace_when(int, int > 3 ~ 0L)
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated dplyr functions: when_all and when_any", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(wall = when_all(lgl1, lgl2), wany = when_any(lgl1, lgl2))

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated dplyr functions: window functions", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      lg = dplyr::lag(int),
      ld = lead(int, 2),
      rn = row_number(),
      dr = dense_rank(int),
      mr = min_rank(int),
      ci = consecutive_id(grp)
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated dplyr functions: reducers in summarize()", {
  dat <- tp_test_frame()
  query <- dat |>
    summarize(
      f = first(grp),
      l = last(grp),
      nt = nth(grp, 2),
      cnt = n(),
      nd = n_distinct(grp)
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated stats functions: median, sd, var", {
  dat <- tp_test_frame()
  query <- dat |>
    summarize(md = median(num, na.rm = TRUE), s = sd(int), v = var(int))

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated stringr functions: detection", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      det = str_detect(txt, "o"),
      len = str_length(txt),
      ct = str_count(txt, "o"),
      st = str_starts(txt, "H"),
      en = str_ends(txt, "d")
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated stringr functions: replacement", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      rp = str_replace(txt, "o", "0"),
      rpa = str_replace_all(txt, "o", "0"),
      rm = str_remove(txt, "o")
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated stringr functions: case", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      up = str_to_upper(txt),
      lo = str_to_lower(txt),
      ti = str_to_title(txt)
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated stringr functions: padding and trimming", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(pd = str_pad(txt, 10), tr = str_trim(txt), sq = str_squish(txt))

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated stringr functions: extraction", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      ex = str_extract(txt, "[a-z]+"),
      spi = str_split_i(txt, " ", 1),
      wd = word(txt, 1)
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated lubridate functions: date components", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      yr = year(date),
      mo = month(date),
      dy = day(date),
      md = mday(date),
      wd = wday(date),
      yd = yday(date),
      q = quarter(date),
      ly = leap_year(date),
      dim = days_in_month(date),
      nd = make_date(2020, int, 1)
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("translated lubridate functions: datetime handling", {
  dat <- tp_test_frame()
  query <- dat |>
    mutate(
      dte = date(time),
      am_ = am(time),
      pm_ = pm(time),
      w = with_tz(time, "Europe/Paris"),
      f = force_tz(time, "Europe/Paris")
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("check query for fill, replace_na, drop_na", {
  test_pl <- as_polars_df(data.frame(x = c(1, NA, 3), y = c("a", NA, "c")))

  query <- fill(test_pl, x)
  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)

  query <- replace_na(test_pl, list(x = 0, y = "z"))
  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)

  query <- drop_na(test_pl)
  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("check query for bind_rows_polars, bind_cols_polars", {
  test_pl <- as_polars_df(data.frame(x = c(1, 2)))
  other_pl <- as_polars_df(data.frame(y = c("a", "b")))

  query <- bind_rows_polars(test_pl, test_pl)
  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)

  query <- bind_cols_polars(test_pl, other_pl)
  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)

  query <- bind_rows_polars(list(test_pl, test_pl))
  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("check query for complete()", {
  test_pl <- as_polars_df(data.frame(
    country = c("France", "France", "UK"),
    year = c(2020, 2021, 2019),
    value = c(1, 2, 3)
  ))

  query <- complete(test_pl, country, year, fill = list(value = 99))
  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("check query for uncount()", {
  # The frame must contain a column named "x" because `uncount()` hardcodes
  # `pl$col("x")`. The snapshot below will change when this is fixed.
  test_pl <- as_polars_df(data.frame(
    x = c("a", "b"),
    y = 100:101,
    n = c(1, 2)
  ))

  query <- uncount(test_pl, n)
  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)

  query <- uncount(test_pl, n, .id = "id")
  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("check query for rowwise()", {
  test_pl <- as_polars_df(data.frame(
    x = c(2, 2),
    y = c(2, 3),
    z = c(5, NA)
  ))

  query <- test_pl |>
    rowwise() |>
    mutate(
      total = sum(c(x, y, z)),
      avg = mean(c(x, y, z), na.rm = TRUE)
    )

  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("check query for unnest_longer_polars()", {
  test_pl <- as_polars_df(tibble(
    id = 1:3,
    values = list(c(1, 2), c(3, 4, 5), 6)
  ))

  query <- unnest_longer_polars(test_pl, values)
  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)

  # `indices_to` creates a temporary column whose name contains a random
  # number, hence the transformation below.
  query <- unnest_longer_polars(
    test_pl,
    values,
    values_to = "val",
    indices_to = "idx"
  )
  expect_snapshot(
    show_query(query),
    transform = function(x) {
      gsub("__tidypolars_row_id_\\d+__", "__tidypolars_row_id__", x)
    }
  )
  expect_equal(replay_query(query), query)
})

test_that("check query for separate_longer_delim_polars() and separate_longer_position_polars()", {
  test_pl <- as_polars_df(data.frame(
    id = 1:3,
    x = c("a,b,c", "d,e", "f")
  ))

  query <- separate_longer_delim_polars(test_pl, x, delim = ",")
  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)

  query <- separate_longer_position_polars(test_pl, x, width = 2)
  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("check query for make_unique_id()", {
  withr::local_options(lifecycle_verbosity = "quiet")
  test_pl <- as_polars_df(data.frame(x = c("a", "b"), y = c(1, 2)))

  query <- make_unique_id(test_pl, x, y, new_col = "id")
  expect_snapshot(show_query(query))
  expect_equal(replay_query(query), query)
})

test_that("check query for scan_*_polars() and read_*_polars()", {
  skip_if(Sys.getenv('TIDYPOLARS_TEST') == "TRUE")
  dest_dir <- withr::local_tempdir()
  test_pl <- as_polars_df(mtcars)

  # The source is a temporary path, hence the transformation below.
  redact_source <- function(x) {
    gsub('source = ".*"', "source = [TRUNCATED]", x)
  }

  dest <- file.path(dest_dir, "data.parquet")
  write_parquet_polars(test_pl, dest)
  query <- scan_parquet_polars(dest) |>
    filter(cyl > 4) |>
    select(mpg)
  expect_snapshot(show_query(query), transform = redact_source)
  expect_equal(as_tibble(replay_query(query)), as_tibble(query))

  dest <- file.path(dest_dir, "data.ndjson")
  write_ndjson_polars(test_pl, dest)
  query <- read_ndjson_polars(dest) |>
    select(mpg)
  expect_snapshot(show_query(query), transform = redact_source)
  expect_equal(replay_query(query), query)

  dest <- file.path(dest_dir, "data.arrow")
  write_ipc_polars(test_pl, dest)
  query <- scan_ipc_polars(dest) |>
    select(mpg)
  expect_snapshot(show_query(query), transform = redact_source)
  expect_equal(as_tibble(replay_query(query)), as_tibble(query))
})
