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

read_series <- function(file, sep = ";", dec = ","){
    series_df <- read.csv(
        file = file,
        sep = sep,
        dec = dec,
        stringsAsFactors = FALSE,
        na.strings = c("NA", "?"),
        fileEncoding = "latin1",
        quote = ""
    )

    test_date <- as.Date(series_df[,1], format = "%Y-%m-%d")

    if (all(is.na(test_date))) {
        warning("Incorrect table format: use csv_layout = 'vtable'")
    } else {
        series_df[,1] <- test_date
        series_df <- series_df[order(series_df[,1]), ]
        colnames(series_df)[1] <- "date"
    }

    return(series_df)
}
