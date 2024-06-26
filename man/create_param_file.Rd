% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/param_file.R
\encoding{UTF-8}
\name{create_param_file}
\alias{create_param_file}
\title{Creation of the .params file for the cruncher}
\usage{
create_param_file(
  dir_file_param = getwd(),
  bundle = 10000,
  csv_layout = "list",
  csv_separator = ";",
  ndecs = 6,
  policy = "parameters",
  output = NULL,
  matrix_item = getOption("default_matrix_item"),
  tsmatrix_series = getOption("default_tsmatrix_series"),
  paths_path = NULL
)
}
\arguments{
\item{dir_file_param}{path to the folder that will store the .param parameter file.}

\item{bundle}{maximum number of series in an output file. By default, \code{bundle = 10000}.}

\item{csv_layout}{layout of the output file. By default, \code{csv_layout = "list"}. Other options are: \code{csv_layout = "vtable"} or \code{csv_layout = "htable"}.}

\item{csv_separator}{column separator for the csv file. By default, \code{csv_separator = ";"}.}

\item{ndecs}{number of decimals in the output (6 by default).}

\item{policy}{refresh policy used. By default, \code{policy = "parameters"} (the model coefficients are re-estimated).
The other methods available are:

\code{"current"} or \code{"n"} (fixed model + all new data are classified as additive outliers)

\code{"fixed"} or \code{"f"} (fixed model: the model is stictly unchanged)

\code{"fixedparameters"} or \code{"fp"} (re-estimation of the regression coefficients)

\code{"parameters"} or \code{"p"} (above + re-estimation of the arima coefficients)

\code{"lastoutliers"} or \code{"l"} (above + re-identification of the outliers over the last year)

\code{"outliers"} or \code{"o"} (above + re-identification of the outliers over the whole series span)

\code{"stochastic"} or \code{"s"} (above + re-estimation of the arima model (orders))

\code{"complete"} or \code{"c"} (the model is completely re-estimated).}

\item{output}{folder where the results are stored. By default, (\code{output = NULL}) and a new "Output" folder is created in the workspace folder.}

\item{matrix_item}{string speciying the parameters to export (cf. JDemetra+ documentation).
To get the default parameters, compile \code{getOption("default_matrix_item")}. This option is initially set to JDemetra+'s default value.}

\item{tsmatrix_series}{string specifying the time series to export (cf. JDemetra+ documentation).
To get the default parameters, compile \code{getOption("default_tsmatrix_series")}. This option is initially set to JDemetra+'s default value.}

\item{paths_path}{paths to the input files (Excel, xml...).}
}
\value{
The parameters file address.
}
\description{
To operate, the cruncher needs a parameter file. It can be generated by the function \code{create_param_file}.
}
\seealso{
\link[=fr-create_param_file]{Traduction française}

Other Cruncher functions: 
\code{\link{cruncher}()},
\code{\link{cruncher_and_param}()},
\code{\link{update_workspace}()}
}
\concept{Cruncher functions}
