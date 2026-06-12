#' @title JVS matrix object
#'
#' @description
#' \code{JVS_matrix()} are creating a quality report based on the Eurostat JVS
#' Plug-In.
#'
#' @param x a \code{data.frame} containing the output variables' values
#' (test p-values, test statistics, etc.) and modalities (Yes/No).
#'
#' @details A\code{\link{QR_matrix}} object is a data.frame with 30 items:
#'
#' * Series
#' * Method
#' * Period
#' * Nobs
#' * Start
#' * End
#' * Adjustment
#' * Presence of Seasonality in the Raw Series
#' * Presence of TD effects
#' * Log-Transformation
#' * ARIMA Model
#' * LeapYear
#' * MovingHoliday
#' * NbTD
#' * Noutliers
#' * Outlier1
#' * Outlier2
#' * Outlier3
#' * Residual Seasonality in SA Series (F-test)
#' * Residual TD Effect
#' * Q-Stat (for X13)
#' * Final Henderson Filter
#' * Stage 2 Henderson Filter
#' * Seasonal Filter
#' * Quality
#' * Autocorrelation of order 1 of the SA series
#' * Ljung-Box Test (P-value)
#' * Autocorrelation negative and significant
#' * Irregular Standard-Deviation
#' * Max-Adj
#'
#' @returns
#' \code{JVS_matrix()} creates and returns a \code{\link{JVS_matrix}} object.
#'
#' @encoding UTF-8
#' @name JVS_matrix
#' @export
JVS_matrix <- function(x = list()) {
    UseMethod("JVS_matrix", x)
}

#' @rdname JVS_matrix
#' @exportS3Method JVS_matrix data.frame
#' @method JVS_matrix data.frame
#' @export
JVS_matrix.data.frame <- function(x) {
    class(x) <- c("JVS_matrix", "data.frame")
    return(x)
}

#' @rdname JVS_matrix
#' @exportS3Method JVS_matrix JVS_matrix
#' @method JVS_matrix JVS_matrix
#' @export
JVS_matrix.JVS_matrix <- function(x) {
    return(x)
}

#' @rdname JVS_matrix
#' @exportS3Method JVS_matrix default
#' @method JVS_matrix default
#' @export
JVS_matrix.default <- function(x) {
    stop("A JVS_matrix or data.frame object is required!", call. = FALSE)
}
