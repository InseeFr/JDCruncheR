#' @title Deprecated functions
#'
#' @description
#' Use [write()] instead of `export_xslx()`.
#'
#' @inheritParams write
#'
#' @returns \code{"QR_matrix"}, \code{"mQR_matrix"} or \code{"JVS_matrix"} object invisibly.
#'
#' @name deprecated-JDCruncheR
#' @export
export_xlsx <- function(x, ...) {
    .Deprecated("write")
    write(x, ...)
}
