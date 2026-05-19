extract_JVS <- function(
        file,
        x,
        thresholds = getOption("jdc_thresholds"),
        ...
) {

    if (missing(x) && missing(file)) {
        stop(
            "Please call extract_JVS() on a csv file containing at least ",
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

    JVS_output <- data.frame(
        series = series,
        extractStatQ(demetra_m, thresholds)
    ) |> JVS_matrix()

    return(JVS_output)
}
