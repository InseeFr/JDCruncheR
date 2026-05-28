#' @name JVS_matrix
#' @export
JVS_matrix <- function(x = list(), ...) {
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
