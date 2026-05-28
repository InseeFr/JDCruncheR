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

    series <- gsub(
        "(^ *)|(* $)",
        "",
        gsub("(^.* \\* )|(\\[frozen\\])", "", demetra_m[, 1L])
    )

    method <- extractMethod(demetra_m)
    frequency_series <- extractFrequency(demetra_m)
    nobs <- extractNobs(demetra_m)
    start_date <- extractStart(demetra_m)
    end_date <- extractEnd(demetra_m)
    presence_seas_effect <- extractSeasCombined(demetra_m)
    presence_td_effect <- extractTDFTest(demetra_m = demetra_m)
    log_transform <- extractLog(demetra_m)
    arima_model <- extractARIMA(demetra_m)
    leap_year <- extractLeapYear(demetra_m)
    leaster <- extractLeaster(demetra_m)
    ntd <- extractNtd(demetra_m)
    nout <- extractNout(demetra_m)
    outliers <- extract3Outliers(demetra_m)
    res_sa_effect <- extractResidualsSeasEffect(demetra_m = demetra_m)
    res_td_effect <- extractResidualsTDEffect(demetra_m = demetra_m)
    stat_Q <- extractStatQ(demetra_m, thresholds)
    trend_filter <- extractTrendFilter(demetra_m)
    seas_filter <- extractSeasonalFilter(demetra_m)
    quality <- extractQuality(demetra_m)
    auto_corr <- extractAutoCorr(demetra_m)
    lb_test <- extractNormality(demetra_m)

    JVS_output <- data.frame(
        Series = series,
        Method = method$values,
        Period = frequency_series$values,
        Nobs = nobs$values,
        Start = start_date$values,
        End = end_date$values,
        Adjustment = NA,
        Presence_of_Seasonality_in_the_raw_series = ifelse(
            presence_seas_effect$values == "Present",
            "Yes",
            "No"
        ),
        Presence_of_TD_effects = ifelse(
            presence_td_effect$values > 0.05 | is.na(presence_td_effect$values),
            "No",
            "Yes"
        ),
        Log_Transformation = ifelse(log_transform$values == 1, "Yes", "No"),
        ARIMA_model = arima_model$values,
        LeapYear = leap_year$values,
        MovingHoliday = leaster$values,
        NbTD = ntd$values,
        Noutliers = nout$values,
        outliers$values,
        Residual_Seasonality = ifelse(res_sa_effect$values > 0.05, "No", "Yes"),
        Residual_TD_Effect = ifelse(res_td_effect$values > 0.05, "No", "Yes"),
        Q_Stat = stat_Q$values$q,
        Final_Henderson_Filter = trend_filter$values,
        Stage_2_Henderson_Filter = trend_filter$values,
        Seasonal_Filter = seas_filter$values,
        Quality = quality$values,
        Autocorrelation_of_order_1_of_the_SA_series = auto_corr$values,
        Ljung_Box_test = lb_test$values,
        Autocorrelation_negative_and_significant = ifelse(
            auto_corr$values < 0 & lb_test$values < 0.05,
            "Warning",
            ""
        ),
        Irregular_standard_deviation = NA,
        Max_Adj = NA
    )

    missing_items <- c(
        method$missing,
        frequency_series$missing,
        nobs$missing,
        start_date$missing,
        end_date$missing,
        presence_seas_effect$missing,
        presence_td_effect$missing,
        log_transform$missing,
        arima_model$missing,
        leap_year$missing,
        leaster$missing,
        ntd$missing,
        nout$missing,
        res_sa_effect$missing,
        res_td_effect$missing,
        stat_Q$missing,
        trend_filter$missing,
        seas_filter$missing,
        quality$missing,
        auto_corr$missing,
        lb_test$missing
    ) |>
        unique()

    colnames(JVS_output) <- c(
        "Series",
        "Method",
        "Period",
        "Nobs",
        "Start",
        "End",
        "Adjustment",
        "Presence of Seasonality in the Raw Series",
        "Presence of TD effects",
        "Log-Transformation",
        "ARIMA Model",
        "LeapYear",
        "MovingHoliday",
        "NbTD",
        "Noutliers",
        "Outlier1",
        "Outlier2",
        "Outlier3",
        "Residual Seasonality in SA Series (F-test)",
        "Residual TD Effect",
        "Q-Stat (for X13)",
        "Final Henderson Filter",
        "Stage 2 Henderson Filter",
        "Seasonal Filter",
        "Quality (for TS)",
        "Autocorrelation of order 1 of the SA series",
        "Ljung-Box Test (P-value)",
        "Autocorrelation negative and significant",
        "Irregular Standard-Deviation",
        "Max-Adj"
    )

    if (length(missing_items) > 0L) {
        warning(
            "Some items are missing. ",
            "Please re-compute the cruncher export with the options: ",
            toString(missing_items),
            "\n\n",
            "If you extract element with rjwsacruncher::cruncher_and_param(),",
            " don't forget to put `short_column_headers = FALSE`.",
            call. = FALSE
        )
    }

    JVS_output <- JVS_matrix(JVS_output)
    return(JVS_output)
}
