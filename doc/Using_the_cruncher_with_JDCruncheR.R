## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, size = "small")
library("JDCruncheR")
library("kableExtra")
library("knitr")

## ----echo=FALSE---------------------------------------------------------------
refresh_policy <- structure(
    list(
        `Option in JDemetra+` = c(
            "Current adjustment (AO approach)",
            "Fixed model",
            "Estimate regression coefficients",
            "Estimate regression coefficients + Arima parameters",
            "Estimate regression coefficients + Last outliers",
            "Estimate regression coefficients + All outliers",
            "Estimate regression coefficients + Arima model",
            "Concurrent"
        ),
        `Cruncher options` = c(
            "current", "fixed", "fixedparameters", "parameters (default policy)", "lastoutliers", "outliers",
            "stochastic", "complete or concurrent"
        ),
        Description = c(
            "The ARIMA model, outliers and other regression variables are not re-identified, and the values of all associated coefficients are fixed. All new observations are classified as additive outliers and corresponding coefficients are estimated during the regression phase. The transformation type remains unchanged.",
            "The ARIMA model, outliers and other regression variables are not re-identified and the values of all coefficients are fixed. The transformation type remains unchanged.",
            "The ARIMA model, outliers and other regression variables are not re-identified. The coefficients of the ARIMA model are fixed but the regression variables coefficients are re-estimated. The transformation type remains unchanged.",
            "The ARIMA model, outliers and other regression variables are not re-identified. All coefficients of the RegARIMA model are re-estimated, for regression variables and ARIMA parameters. The transformation type remains unchanged.",
            "Outliers in the last year of the sample are re-identified. All coefficients of the RegARIMA model, regression variables and ARIMA parameters, are re-estimated. The transformation type remains unchanged.",
            "All outliers are re-identified. All coefficients of the RegARIMA model, regression variables and ARIMA parameters, are re-estimated. The transformation type remains unchanged.",
            "Re-identification of the ARIMA model, outliers and regression variables, except the calendar variables. The transformation type remains unchanged.",
            "Complete re-identification of the whole RegARIMA model, all regression variables and ARIMA model orders."
        )
    ),
    .Names = c("Option in JDemetra+", "Cruncher options", "Description"),
    class = "data.frame",
    row.names = c(NA, -8L)
)

if (opts_knit$get("rmarkdown.pandoc.to") == "latex") {
    kable(
        refresh_policy,
        caption = "The refresh/revision policies",
        booktabs = TRUE, format = "latex"
    ) %>%
        kable_styling(
            full_width = TRUE,
            latex_options = "hold_position"
        ) %>%
        group_rows("Current adjustment (AO approach)", 1, 1) %>%
        group_rows("Partial concurrent adjustment", 2, 7) %>%
        group_rows("Concurrent", 8, 8) %>%
        column_spec(1, width = "4cm") %>%
        column_spec(2, width = "2.5cm")
} else {
    refresh_policy[2:7, 1] <- paste("Partial concurrent adjustment ->", refresh_policy[2:7, 1])
    kable(
        refresh_policy,
        caption = "The refresh/revision policies",
        booktabs = TRUE
    )
}




## ---- eval = FALSE------------------------------------------------------------
#  library("JDCruncheR")
#   # To see the default parameters:
#  getOption("default_matrix_item")
#  # To customise the parameter selection (here, only the information criteria are exported):
#  options(default_matrix_item = c("likelihood.aic",
#                                  "likelihood.aicc",
#                                  "likelihood.bic",
#                                  "likelihood.bicc"))

## ---- eval = FALSE------------------------------------------------------------
#   # To see the default parameters:
#  getOption("default_tsmatrix_series")
#  # To customise the parameter selection (here, only the seasonaly adjusted series and its previsions are exported):
#  options(default_tsmatrix_series = c("sa", "sa_f"))

## ---- eval = FALSE------------------------------------------------------------
#  # A .param parameters file will be created in D:/, containing the "lastoutliers" refresh policy
#  # and default values for the other parameters
#  create_param_file(dir_file_param = "D:/",
#                    policy = "lastoutliers")
#
#  # To customise the "default_matrix_item" and "default_tsmatrix_series" options
#  # to only export the information criteria, the adjusted series and its forecast:
#  create_param_file(dir_file_param = "D:/",
#                    policy = "lastoutliers",
#                    matrix_item = c("likelihood.aic", "likelihood.aicc",
#                                    "likelihood.bic", "likelihood.bicc"),
#                    tsmatrix_series = c("sa", "sa_f"))

## ---- eval = FALSE------------------------------------------------------------
#  options(cruncher_bin_directory = "D:/jdemetra-cli-2.2.3/bin/")

## ---- eval = FALSE------------------------------------------------------------
#  # Code to update the "ipi" workspace stored in D:/seasonal_adjustment/, with the refresh policy "lastoutliers".
#  # All other create_param_file() parameters are default ones. In particular, the exported parameters are the default
#  # "default_matrix_item" and "default_tsmatrix_series", and the output folder is D:/seasonal_adjustment/Output/.
#  cruncher_and_param(workspace = "D:/seasonal_adjustment/ipi.xml",
#                     rename_multi_documents = FALSE,
#                     policy = "lastoutliers")
#
#  # Example of customisation of the parameter "output":
#  cruncher_and_param(workspace = "D:/seasonal_adjustment/ipi.xml",
#                     output = "D:/cruncher_results/",
#                     rename_multi_documents = FALSE,
#                     policy = "lastoutliers")
#
#  # Here, we explicitely have "rename_multi_documents = TRUE" (which is also the default value) to rename the ouput folders
#  # after the SAProcessings as displayed in the JDemetra+ interface.
#  # With parameter "delete_existing_file = TRUE", all pre-existing versions of such folders are deleted before the export.
#  cruncher_and_param(workspace = "D:/Campagne_CVS/ipi.xml",
#                     rename_multi_documents = TRUE,
#                     delete_existing_file = TRUE,
#                     policy = "lastoutliers")
#
#  # To see all the function parameters:
#  ?cruncher_and_param
