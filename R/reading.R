check_obj <- function(
    dir = NULL,
    x = NULL,
    reading_fun = NULL,
    name = "",
    ...
) {
    if (!is.null(x)) {
        return(x)
    }
    if (is.null(x) & is.null(dir)) {
        stop(
            "Please call the function on a directory",
            " (using the `dir` argument)",
            " containing at least one `",
            name,
            "` file,",
            " or directly on a R object using the `",
            name,
            "` argument.",
            call. = FALSE
        )
    }

    list_files <- dir[
        !dir.exists(dir) & file.exists(dir) & endsWith(x = dir, suffix = ".csv")
    ]
    dir <- dir[dir.exists(dir)]
    if (length(dir) == 0L & length(list_files) == 0L) {
        stop(
            "The chosen dir doesn't exist.",
            call. = FALSE
        )
    }

    list_files <- c(
        list_files,
        list.files(
            path = dir,
            pattern = paste0(name, "\\.csv$"),
            all.files = TRUE,
            full.names = TRUE,
            recursive = TRUE
        )
    ) |>
        normalizePath()

    if (length(list_files) > 1L) {
        message(
            "Several files with same pattern has been found:\n",
            paste(list_files, collapse = "\n"),
            "\n\nThe first one (",
            list_files[1L],
            ") will be used."
        )
    } else if (length(list_files) == 0L) {
        stop(
            "No files with ",
            name,
            ".csv form have been found in the directory :",
            paste(dir, collapse = "\n")
        )
    }

    x <- reading_fun(file = list_files[1L], ...)
    if (nrow(x) == 0L || ncol(x) == 0L) {
        stop(
            "The chosen csv file (",
            list_files[1L],
            ") is empty.",
            call. = FALSE
        )
    }

    return(x)
}

read_demetra_m <- function(file, sep = ";", dec = ",") {
    demetra_m <- read.csv(
        file = file,
        sep = sep,
        dec = dec,
        stringsAsFactors = FALSE,
        na.strings = c("NA", "?"),
        fileEncoding = "latin1",
        quote = ""
    )
    return(demetra_m)
}

read_series <- function(file, sep = ";", dec = ",") {
    series_df <- read.csv(
        file = file,
        sep = sep,
        dec = dec,
        stringsAsFactors = FALSE,
        na.strings = c("NA", "?"),
        fileEncoding = "latin1",
        quote = ""
    )

    test_date <- as.Date(series_df[, 1], format = "%Y-%m-%d")

    if (all(is.na(test_date))) {
        warning("Incorrect table format: use csv_layout = 'vtable'")
    } else {
        series_df[, 1] <- test_date
        series_df <- series_df[order(series_df[, 1]), ]
        colnames(series_df)[1] <- "date"
    }

    return(series_df)
}
