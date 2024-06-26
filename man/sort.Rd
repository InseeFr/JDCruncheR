% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/QR_functions.R
\name{sort}
\alias{sort}
\alias{sort.QR_matrix}
\alias{sort.mQR_matrix}
\title{QR_matrix and mQR_matrix sorting}
\usage{
\method{sort}{QR_matrix}(x, decreasing = FALSE, sort_variables = "score", ...)

\method{sort}{mQR_matrix}(x, decreasing = FALSE, sort_variables = "score", ...)
}
\arguments{
\item{x}{a \code{QR_matrix} or \code{mQR_matrix} object}

\item{decreasing}{logical indicating whether the quality reports must be sorted in ascending or decreasing order.
By default, the sorting is done in ascending order.}

\item{sort_variables}{They must be present in the modalities table.}

\item{...}{other parameters of the function \code{\link[base]{order}} (unused for now)}
}
\value{
the input with sorted quality reports
}
\description{
To sort the quality reports on one or several variables
}
\examples{
\dontrun{
QR <- compute_score(extract_QR())
sort(QR, sort_variables = "score") # To sort by ascending values of the score
}
}
\seealso{
\link[=fr-sort.QR_matrix]{Traduction française}

Other QR_matrix functions: 
\code{\link{export_xlsx}()},
\code{\link{export_xlsx.QR_matrix}()},
\code{\link{export_xlsx.mQR_matrix}()},
\code{\link{extract_QR}()},
\code{\link{rbind.QR_matrix}()},
\code{\link{weighted_score}()}
}
\concept{QR_matrix functions}
