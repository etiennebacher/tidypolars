% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_scan.R
\name{from_parquet}
\alias{from_parquet}
\alias{read_parquet_polars}
\alias{scan_parquet_polars}
\title{Import data from Parquet file(s)}
\usage{
read_parquet_polars(
  source,
  ...,
  n_rows = NULL,
  row_index_name = NULL,
  row_index_offset = 0L,
  parallel = "auto",
  hive_partitioning = NULL,
  hive_schema = NULL,
  try_parse_hive_dates = TRUE,
  glob = TRUE,
  rechunk = TRUE,
  low_memory = FALSE,
  storage_options = NULL,
  use_statistics = TRUE,
  cache = TRUE,
  include_file_paths = NULL
)

scan_parquet_polars(
  source,
  ...,
  n_rows = NULL,
  row_index_name = NULL,
  row_index_offset = 0L,
  parallel = "auto",
  hive_partitioning = NULL,
  hive_schema = NULL,
  try_parse_hive_dates = TRUE,
  glob = TRUE,
  rechunk = FALSE,
  low_memory = FALSE,
  storage_options = NULL,
  use_statistics = TRUE,
  cache = TRUE,
  include_file_paths = NULL
)
}
\arguments{
\item{source}{Path to a file. You can use globbing with \code{*} to scan/read multiple
files in the same directory (see examples).}

\item{...}{Ignored.}

\item{n_rows}{Maximum number of rows to read.}

\item{row_index_name}{If not \code{NULL}, this will insert a row index column with
the given name into the DataFrame.}

\item{row_index_offset}{Offset to start the row index column (only used if
the name is set).}

\item{parallel}{This determines the direction of parallelism. \code{"auto"} will
try to determine the optimal direction. Can be \code{"auto"}, \code{"columns"},
\code{"row_groups"}, \code{"prefiltered"}, or \code{"none"}. See 'Details'.}

\item{hive_partitioning}{Infer statistics and schema from Hive partitioned URL
and use them to prune reads. If \code{NULL} (default), it is automatically
enabled when a single directory is passed, and otherwise disabled.}

\item{hive_schema}{A list containing the column names and data types of the
columns by which the data is partitioned, e.g.
\code{list(a = pl$String, b = pl$Float32)}. If \code{NULL} (default), the schema of
the Hive partitions is inferred.}

\item{try_parse_hive_dates}{Whether to try parsing hive values as date/datetime
types.}

\item{glob}{Expand path given via globbing rules.}

\item{rechunk}{In case of reading multiple files via a glob pattern, rechunk
the final DataFrame into contiguous memory chunks.}

\item{low_memory}{Reduce memory usage (will yield a lower performance).}

\item{storage_options}{Experimental. List of options necessary to scan
parquet files from different cloud storage providers (GCP, AWS, Azure,
HuggingFace). See the 'Details' section.}

\item{use_statistics}{Use statistics in the parquet file to determine if pages
can be skipped from reading.}

\item{cache}{Cache the result after reading.}

\item{include_file_paths}{Include the path of the source file(s) as a column
with this name.}
}
\description{
\code{read_parquet_polars()} imports the data as a Polars DataFrame.

\code{scan_parquet_polars()} imports the data as a Polars LazyFrame.
}
\details{
\subsection{On parallel strategies}{

The prefiltered strategy first evaluates the pushed-down predicates in
parallel and determines a mask of which rows to read. Then, it parallelizes
over both the columns and the row groups while filtering out rows that do not
need to be read. This can provide significant speedups for large files (i.e.
many row-groups) with a predicate that filters clustered rows or filters
heavily. In other cases, prefiltered may slow down the scan compared other
strategies.

The prefiltered settings falls back to auto if no predicate is given.
}

\subsection{Connecting to cloud providers}{

Polars supports scanning parquet files from different cloud providers.
The cloud providers currently supported are AWS, GCP, and Azure.
The supported keys to pass to the \code{storage_options} argument can be found
here:
\itemize{
\item \href{https://docs.rs/object_store/latest/object_store/aws/enum.AmazonS3ConfigKey.html}{aws}
\item \href{https://docs.rs/object_store/latest/object_store/gcp/enum.GoogleConfigKey.html}{gcp}
\item \href{https://docs.rs/object_store/latest/object_store/azure/enum.AzureConfigKey.html}{azure}
}

Currently it is impossible to scan public parquet files from GCP without
a valid service account. Be sure to always include a service account in the
\code{storage_options} argument.
}

\subsection{Scanning from HuggingFace}{

It is possible to scan data stored on HuggingFace using a path starting with
\verb{hf://}. The \verb{hf://} path format is defined as
\verb{hf://BUCKET/REPOSITORY@REVISION/PATH}, where:
\itemize{
\item BUCKET is one of datasets or spaces
\item REPOSITORY is the location of the repository. this is usually in the
format of username/repo_name. A branch can also be optionally specified by
appending \verb{@branch}.
\item REVISION is the name of the branch (or commit) to use. This is optional
and defaults to main if not given.
\item PATH is a file or directory path, or a glob pattern from the repository
root.
}

A Hugging Face API key can be passed to access private locations using
either of the following methods:
\itemize{
\item Passing a token in storage_options to the scan function, e.g.
\verb{scan_parquet(..., storage_options = list(token = <your HF token>))}
\item Setting the HF_TOKEN environment variable, e.g.
\verb{Sys.setenv(HF_TOKEN = <your HF token>)}.
}
}
}
