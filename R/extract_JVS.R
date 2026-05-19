extract_JVS <- function(
        file,
        x,
        thresholds = getOption("jdc_thresholds"),
        ...
) {


    if (!missing(matrix_output_file)) {
        warning(
            "The `matrix_output_file` argument is deprecated",
            " and will be removed in the future. ",
            "Please use the `file` argument instead or ",
            "the `x` argument which may contain a diagnostic matrix ",
            "that has already been imported.",
            call. = FALSE
        )
        file <- matrix_output_file
    }

    if (missing(x) && missing(file)) {
        stop(
            "Please call extract_QR() on a csv file containing at least ",
            "one cruncher output matrix (demetra_m.csv for example) ",
            "with the argument `file` ",
            "or directly on a matrix with the argument `x`",
            call. = FALSE
        )
    } else if (missing(x)) {
        if (
            length(file) == 0L ||
            !file.exists(file) ||
            !endsWith(x = file, suffix = ".csv")
        ) {
            stop(
                "The chosen file desn't exist or isn't a csv file",
                call. = FALSE
            )
        }
        demetra_m <- read_demetra_m(file, ...)
    } else {
        demetra_m <- x
    }

    stat_Q <- extractStatQ(demetra_m, thresholds)
    stat_OOS <- extractOOS_test(demetra_m, thresholds)
    normality <- extractDistributionTests(demetra_m, thresholds)
    outliers <- extractOutliers(demetra_m, thresholds)
    test <- extractSeasTest(demetra_m, thresholds)
    frequency_series <- extractFrequency(demetra_m)
    arima_model <- extractARIMA(demetra_m)

    QR_modalities <- data.frame(
        series = series,
        normality[["modalities"]],
        test[["modalities"]],
        stat_OOS[["modalities"]],
        stat_Q[["modalities"]],
        outliers[["modalities"]]
    )


    return(NULL)
}
