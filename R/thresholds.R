#' Set values for thresholds
#'
#' @param test_name String. The name of the test to update.
#' @param thresholds Named vector of numerics. The upper values of
#' each break of a threshold.
#'
#' @details
#' If \code{test_name} is missing, the argument \code{thresholds} is not used
#' and all thresholds will be updated to their default values.
#'
#' If \code{test_name} is not missing, but if the argument \code{thresholds} is
#' missing then only the thresholds of the test \code{test_name} will be updated
#' to its default values.
#'
#' Finally, if \code{test_name} and \code{thresholds} are not missing, then only
#' the thresholds of the test \code{test_name} are updated with the value
#' \code{thresholds}.
#'
#' @export
#' @examples
#'
#' # Set "m7"
#' set_thresholds(
#'     test_name = "m7",
#'     thresholds = c(Good = 0.8, Bad = 1.4, Severe = Inf)
#' )
#'
#' # Set "oos_mean" to default
#' set_thresholds(test_name = "oos_mean")
#'
#' # Set all thresholds to default
#' set_thresholds()
#'
set_thresholds <- function(test_name,
                           thresholds) {
    default_thresholds <- get_thresholds(default = TRUE)
    if (missing(test_name)) {
        all_thresholds <- default_thresholds
    } else {
        all_thresholds <- get_thresholds(default = FALSE)
        if (missing(thresholds)) {
            all_thresholds[[test_name]] <- default_thresholds[[test_name]]
        } else {
            all_thresholds[[test_name]] <- thresholds
        }
    }
    options(jdc_thresholds = all_thresholds)
    return(invisible(all_thresholds))
}

#' Get all (default) thresholds
#'
#' @param test_name String. The name of the test to get.
#' @param default Boolean. (default is TRUE)
#' If TRUE, the default threshold will be returned.
#' If FALSE the current used thresholds.
#'
#' @details
#' If \code{test_name} is missing, all threshold will be returned.
#'
#' @export
#' @examples
#'
#' # Get all default thresholds
#' get_thresholds(default = TRUE)
#'
#' # Get all current thresholds
#' get_thresholds(default = FALSE)
#'
#' # Get all current thresholds
#' get_thresholds(test_name = "oos_mean", default = FALSE)
#'
get_thresholds <- function(test_name, default = TRUE) {

    default_thresholds <- list(
        qs_residual_sa_on_sa = c(Severe = 0.001, Bad = 0.01, Uncertain = 0.05, Good = Inf),
        qs_residual_sa_on_i = c(Severe = 0.001, Bad = 0.01, Uncertain = 0.05, Good = Inf),

        f_residual_sa_on_sa = c(Severe = 0.001, Bad = 0.01, Uncertain = 0.05, Good = Inf),
        f_residual_sa_on_i = c(Severe = 0.001, Bad = 0.01, Uncertain = 0.05, Good = Inf),

        f_residual_td_on_sa = c(Severe = 0.001, Bad = 0.01, Uncertain = 0.05, Good = Inf),
        f_residual_td_on_i = c(Severe = 0.001, Bad = 0.01, Uncertain = 0.05, Good = Inf),

        residuals_independency = c(Bad = 0.01, Uncertain = 0.1, Good = Inf),
        residuals_homoskedasticity = c(Bad = 0.01, Uncertain = 0.1, Good = Inf),

        residuals_skewness = c(Bad = 0.01, Uncertain = 0.1, Good = Inf),
        residuals_kurtosis = c(Bad = 0.01, Uncertain = 0.1, Good = Inf),
        residuals_normality = c(Bad = 0.01, Uncertain = 0.1, Good = Inf),

        oos_mean = c(Bad = 0.01, Uncertain = 0.1, Good = Inf),
        oos_mse = c(Bad = 0.01, Uncertain = 0.1, Good = Inf),

        m7 = c(Good = 1, Bad = 2, Severe = Inf),
        q = c(Good = 1, Bad = Inf),
        q_m2 = c(Good = 1, Bad = Inf),
        pct_outliers = c(Good = 3, Uncertain = 5, Bad = Inf)
    )

    if (default) {
        thresholds <- default_thresholds
    } else {
        thresholds <- getOption("jdc_thresholds")
    }

    if (missing(test_name)) {
        return(thresholds)
    } else {
        return(thresholds[[test_name]])
    }
}
