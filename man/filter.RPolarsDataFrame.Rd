% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filter.R
\name{filter.RPolarsDataFrame}
\alias{filter.RPolarsDataFrame}
\alias{filter.RPolarsLazyFrame}
\title{Keep rows that match a condition}
\usage{
\method{filter}{RPolarsDataFrame}(.data, ..., .by = NULL)

\method{filter}{RPolarsLazyFrame}(.data, ..., .by = NULL)
}
\arguments{
\item{.data}{A Polars Data/LazyFrame}

\item{...}{Expressions that return a logical value, and are defined in terms
of the variables in the data. If multiple expressions are included, they
will be combined with the & operator. Only rows for which all conditions
evaluate to \code{TRUE} are kept.}

\item{.by}{Optionally, a selection of columns to group by for just this
operation, functioning as an alternative to \code{group_by()}. The group order
is not maintained, use \code{group_by()} if you want more control over it.}
}
\description{
This function is used to subset a data frame, retaining all rows that satisfy
your conditions. To be retained, the row must produce a value of TRUE for all
conditions. Note that when a condition evaluates to NA the row will be
dropped, unlike base subsetting with \code{[}.
}
\examples{
\dontshow{if (require("dplyr", quietly = TRUE) && require("tidyr", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
pl_iris <- polars::as_polars_df(iris)

filter(pl_iris, Sepal.Length < 5, Species == "setosa")

filter(pl_iris, Sepal.Length < Sepal.Width + Petal.Length)

filter(pl_iris, Species == "setosa" | is.na(Species))

iris2 <- iris
iris2$Species <- as.character(iris2$Species)
iris2 |>
  as_polars_df() |>
  filter(Species \%in\% c("setosa", "virginica"))

# filter by group
pl_iris |>
  group_by(Species) |>
  filter(Sepal.Length == max(Sepal.Length)) |>
  ungroup()

# an alternative syntax for grouping is to use `.by`
pl_iris |>
  filter(Sepal.Length == max(Sepal.Length), .by = Species)
\dontshow{\}) # examplesIf}
}
