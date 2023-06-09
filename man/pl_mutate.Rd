% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mutate.R
\name{pl_mutate}
\alias{pl_mutate}
\title{Create, modify, and delete columns}
\usage{
pl_mutate(.data, ...)
}
\arguments{
\item{.data}{A Polars Data/LazyFrame}

\item{...}{Name-value pairs. The name gives the name of the column in
the output. The value can be:
\itemize{
\item A vector the same length as the current group (or the whole data
frame if ungrouped).
\item NULL, to remove the column.
}}
}
\description{
This creates new columns that are functions of existing variables. It
can also modify (if the name is the same as an existing column) and
delete columns (by setting their value to NULL).
}
\details{
A lot of functions available in base R (cos, sin, multiplying, etc.) or
in other packages (dplyr::lag(), etc.) are implemented in an efficient
way in Polars. These functions will be automatically translated to Polars
syntax under the hood so that you can continue using the classic R syntax and
functions.

If a Polars built-in replacement doesn't exist (for example for custom
functions), the R function will be passed to \code{map()} in the Polars workflow.
Note that this is slower than using functions that can be translated to
Polars syntax.
}
\examples{
pl_iris <- polars::pl$DataFrame(iris)

# classic operation
pl_mutate(pl_iris, x = Sepal.Width + Sepal.Length)

# logical operation
pl_mutate(pl_iris, x = Sepal.Width > Sepal.Length & Petal.Width > Petal.Length)

# overwrite existing variable
pl_mutate(pl_iris, Sepal.Width = Sepal.Width*2)

# grouped computation
pl_iris |>
  pl_group_by(Species) |>
  pl_mutate(
    foo = mean(Sepal.Length)
  )
}
