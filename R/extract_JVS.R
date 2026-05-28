extract_JVS <- function(
    dir = NULL,
    demetra_m = NULL,
    y = NULL,
    sa = NULL,
    s = NULL,
    i = NULL,
    thresholds = getOption("jdc_thresholds"),
    ...
) {

    # Lecture de demetra_m
    demetra_m <- check_obj(dir = dir, x = demetra_m, reading_fun = read_demetra_m, name = "demetra_m")

    # Lecture de y
    y <- check_obj(dir = dir, x = y, reading_fun = read_series, name = "y")

    # Lecture de sa
    sa <- check_obj(dir = dir, x = sa, reading_fun = read_series, name = "sa")

    # Lecture de s
    s <- check_obj(dir = dir, x = s, reading_fun = read_series, name = "s")

    # Lecture de i
    i <- check_obj(dir = dir, x = i, reading_fun = read_series, name = "i")

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
    adjustment <- extractAdjustment(demetra_m, s)
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
    standard_deviation <- extractStandardDeviation(i)
    max_adj <- extractMaxAdj_allseries(y, sa)

    JVS_output <- data.frame(
        Series = series,
        Method = method$values,
        Period = frequency_series$values,
        Nobs = nobs$values,
        Start = start_date$values,
        End = end_date$values,
        Adjustment = adjustment$values,
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
        Irregular_standard_deviation = standard_deviation$values,
        Max_Adj = max_adj$values
    )

    missing_items <- c(
        method$missing,
        frequency_series$missing,
        nobs$missing,
        start_date$missing,
        end_date$missing,
        adjustment$missing,
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
        "Quality",
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
            " don't forget to put `short_column_headers = FALSE` and `v3 = TRUE`.",
            call. = FALSE
        )
    }

    JVS_output <- JVS_matrix(JVS_output)
    return(JVS_output)
}
