% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rowwise.R
\name{rowwise.RPolarsDataFrame}
\alias{rowwise.RPolarsDataFrame}
\alias{rowwise.RPolarsLazyFrame}
\title{Group input by rows}
\usage{
\method{rowwise}{RPolarsDataFrame}(data, ...)

\method{rowwise}{RPolarsLazyFrame}(data, ...)
}
\arguments{
\item{data}{A Polars Data/LazyFrame}

\item{...}{Any expression accepted by \code{dplyr::select()}: variable names,
column numbers, select helpers, etc.}
}
\value{
A Polars Data/LazyFrame.
}
\description{
[EXPERIMENTAL]

\code{rowwise()} allows you to compute on a Data/LazyFrame a row-at-a-time. This
is most useful when a vectorised function doesn't exist. \code{rowwise()} produces
another type of grouped data, and therefore can be removed with \code{ungroup()}.
}
\examples{
\dontshow{if (require("dplyr", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
df <- polars::pl$DataFrame(x = c(1, 3, 4), y = c(2, 1, 5), z = c(2, 3, 1))

# Compute the mean of x, y, z in each row
df |>
 rowwise() |>
 mutate(m = mean(c(x, y, z)))

# Compute the min and max of x and y in each row
df |>
 rowwise() |>
 mutate(min = min(c(x, y)), max = max(c(x, y)))
\dontshow{\}) # examplesIf}
}
