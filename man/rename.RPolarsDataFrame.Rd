% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rename.R
\name{rename.RPolarsDataFrame}
\alias{rename.RPolarsDataFrame}
\alias{rename.RPolarsLazyFrame}
\alias{rename_with.RPolarsDataFrame}
\alias{rename_with.RPolarsLazyFrame}
\title{Rename columns}
\usage{
\method{rename}{RPolarsDataFrame}(.data, ...)

\method{rename}{RPolarsLazyFrame}(.data, ...)

\method{rename_with}{RPolarsDataFrame}(.data, .fn, .cols = tidyselect::everything(), ...)

\method{rename_with}{RPolarsLazyFrame}(.data, .fn, .cols = tidyselect::everything(), ...)
}
\arguments{
\item{.data}{A Polars Data/LazyFrame}

\item{...}{For \code{rename()}, use \code{new_name = old_name} to rename selected
variables. It is also possible to use quotation marks, e.g
\code{"new_name" = "old_name"}.

For \code{rename_with}, additional arguments passed to \code{fn}.}

\item{.fn}{Function to apply on column names}

\item{.cols}{Columns on which to apply \code{fn}. Can be anything accepted by
\code{dplyr::select()}.}
}
\description{
Rename columns
}
\examples{
\dontshow{if (require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
pl_test <- polars::as_polars_df(mtcars)

rename(pl_test, miles_per_gallon = mpg, horsepower = "hp")

rename(pl_test, `Miles per gallon` = "mpg", `Horse power` = "hp")

rename_with(pl_test, toupper, .cols = contains("p"))

pl_test_2 <- polars::as_polars_df(iris)

rename_with(pl_test_2, function(x) tolower(gsub(".", "_", x, fixed = TRUE)))

rename_with(pl_test_2, \(x) tolower(gsub(".", "_", x, fixed = TRUE)))
\dontshow{\}) # examplesIf}
}
