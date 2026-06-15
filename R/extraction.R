create_NA_type <- function(
    type = c(
        "character",
        "integer",
        "double",
        "logical",
        "complex",
        "raw",
        "Date"
    ),
    len = 1L
) {
    type <- match.arg(type)
    output <- rep(
        x = switch(
            EXPR = type,
            character = NA_character_,
            integer = NA_integer_,
            double = NA_real_,
            logical = NA,
            complex = NA_complex_,
            raw = as.raw(0x00),
            Date = as.Date(NA_integer_)
        ),
        times = len
    )
    return(output)
}

find_variable <- function(
    demetra_m,
    pattern,
    type = c("double", "integer", "character", "logical"),
    p_value = FALSE,
    variable = "",
    exact = FALSE,
    verbose = TRUE
) {
    if (!exact) {
        pattern <- gsub(
            x = pattern,
            pattern = "$",
            replacement = "(\\.(\\d){1,})?$",
            fixed = TRUE
        )
    }

    cols <- id_cols <- grep(pattern = pattern, colnames(demetra_m))

    # Colonnes adjacentes
    for (idx in id_cols) {
        k <- 1L
        while (
            grepl(pattern = "^X\\.(\\d){1,}$", colnames(demetra_m)[idx + k])
        ) {
            cols <- c(cols, idx + k)
            k <- k + 1L
        }
    }

    # Type de la colonne
    type_cols <- unlist(lapply(
        X = demetra_m[, cols, drop = FALSE],
        FUN = function(x) {
            all(switch(
                type,
                double = is.double(x) || is.integer(x),
                integer = is.integer(x),
                character = is.character(x),
                logical = is.logical(x)
            ))
        }
    ))
    cols <- cols[type_cols]

    if (p_value && length(cols) > 0L) {
        y <- demetra_m[, cols, drop = FALSE]
        p_cols <- apply(
            X = is.na(y) | (y >= 0L & y <= 1L),
            FUN = all,
            MARGIN = 2L
        )
        cols <- cols[p_cols]
    }

    if (length(cols) == 0L) {
        # Aucune colonne
        return(list(
            values = create_NA_type(type = type, len = nrow(demetra_m)),
            missing = variable
        ))
    } else if (length(cols) == 1L) {
        # 1 seule colonnes
        return(list(
            values = demetra_m[, cols, drop = TRUE],
            missing = NULL
        ))
    }

    # Multiples colonnes

    # cond: les multiples colonnes sont elles égales ?
    cond <- all(apply(
        X = demetra_m[, cols, drop = FALSE],
        MARGIN = 2L,
        FUN = identical,
        demetra_m[, cols[1L], drop = TRUE]
    ))

    if (cond) {
        id <- 1L
    } else {
        if (verbose) {
            message(
                "Multiple column found for extraction of ",
                toString(variable),
                "\n",
                ifelse(p_value, "Last column selected", "First column selected")
            )
        }
        id <- ifelse(p_value, length(cols), 1L)
    }

    return(list(
        values = demetra_m[, cols[id], drop = TRUE],
        missing = NULL
    ))
}

extractStart <- function(demetra_m) {
    start_date <- find_variable(
        demetra_m,
        pattern = "(^span\\.start$)|(^start$)",
        type = "character",
        variable = "span.start"
    )
    return(start_date)
}

extractEnd <- function(demetra_m) {
    end_date <- find_variable(
        demetra_m,
        pattern = "(^span\\.end$)|(^end$)",
        type = "character",
        variable = "span.end"
    )
    return(end_date)
}

extractLog <- function(demetra_m) {
    log_transform <- find_variable(
        demetra_m,
        pattern = "^log$",
        type = "integer",
        variable = "log"
    )
    return(log_transform)
}

extractNobs <- function(demetra_m) {
    nobs <- find_variable(
        demetra_m,
        pattern = "(^span\\.n$)|(^n$)",
        type = "integer",
        variable = "span.n"
    )
    return(nobs)
}

extractNout <- function(demetra_m) {
    nout <- find_variable(
        demetra_m,
        pattern = "(^regression\\.nout$)|(^nout$)",
        type = "integer",
        variable = "regression.nout"
    )
    return(nout)
}

extractNtd <- function(demetra_m) {
    ntd <- find_variable(
        demetra_m,
        pattern = "(^regression\\.ntd$)|(^ntd$)",
        type = "integer",
        variable = "regression.ntd"
    )
    return(ntd)
}

extractM7 <- function(demetra_m) {
    m7 <- find_variable(
        demetra_m,
        pattern = "(^m\\.statistics\\.m7$)|(^m7$)",
        type = "double",
        variable = "m-statistics.m7"
    )
    return(m7)
}

extractMethod <- function(demetra_m) {
    m7 <- extractM7(demetra_m)
    method <- ifelse(is.na(m7$values), "Tramo-Seats", "X13")
    return(list(values = method, missing = m7$missing))
}

extractSeasonalFilter <- function(demetra_m) {
    seasonal_filters <- find_variable(
        demetra_m,
        pattern = "(^decomposition\\.seasonal\\.filters$)|(^seasonal\\.filters$)|(^decomposition\\.d9filter$)|(^decomposition\\.seasfilter$)|(^seasfilter$)",
        type = "character",
        variable = "decomposition.seasonal-filters"
    )
    return(seasonal_filters)
}

extractTrendFilter <- function(demetra_m) {
    trend_filters <- find_variable(
        demetra_m,
        pattern = "(^decomposition\\.trend\\.filter$)|(^trend\\.filter$)|(^decomposition\\.d12filter$)|(^decomposition\\.trendfilter$)|(^trendfilter$)",
        type = "integer",
        variable = "decomposition.trend-filter"
    )
    return(trend_filters)
}

extractQuality <- function(demetra_m) {
    quality <- find_variable(
        demetra_m,
        pattern = "(^quality\\.summary$)|(^summary$)|(^quality$)",
        type = "character",
        variable = "quality.summary"
    )
    return(quality)
}

extractLeapYear <- function(demetra_m) {
    lp <- find_variable(
        demetra_m,
        pattern = "(^regression\\.lp$)|(^lp$)",
        type = "character",
        variable = "regression.lp"
    )
    return(lp)
}

extractLeaster <- function(demetra_m) {
    leaster <- find_variable(
        demetra_m,
        pattern = "(^regression\\.leaster$)|(^leaster$)",
        type = "integer",
        variable = "regression.leaster"
    )
    return(leaster)
}

extractAutoCorr <- function(demetra_m) {
    auto_corr <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.seas\\.sa\\.ac1$)|(^seas\\.sa\\.ac1$)",
        type = "double",
        variable = "diagnostics.seas-sa-ac1"
    )
    return(auto_corr)
}

extractSeasCombined <- function(demetra_m) {
    presence_seasonality <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.seas\\.lin\\.combined$)|(^seas\\.lin\\.combined$)",
        type = "character",
        variable = "diagnostics.seas-lin-combined"
    )
    return(presence_seasonality)
}

extract3Outliers <- function(demetra_m) {

    outliers <- data.frame(
        out1 = character(nrow(demetra_m)),
        out2 = character(nrow(demetra_m)),
        out3 = character(nrow(demetra_m))
    )
    nout <- extractNout(demetra_m)
    if (is.null(nout$missing) && all(nout$values == 0)) {
        return(list(values = outliers))
    }

    pattern <- "(^regression\\.out$)|(^out$)" |>
        gsub(
            pattern = "$",
            replacement = "(\\.(\\d){1,}\\.)?$",
            fixed = TRUE
        )

    id_cols <- grep(pattern = pattern, colnames(demetra_m))

    if (length(id_cols) == 0L) {
        return(list(values = outliers, missing = c(nout$missing, "regression.out(*)")))
    }

    for (id_series in seq_len(nrow(demetra_m))) {
        outs <- demetra_m[id_series, id_cols]
        id_cols_out_series <- id_cols[!(is.na(outs) | outs == "")]
        outs <- as.character(demetra_m[id_series, id_cols_out_series])
        if (length(id_cols_out_series) > 1) {
            t_stat <- as.numeric(demetra_m[id_series, id_cols_out_series + 2])
            outs <- outs[order(abs(t_stat), decreasing = TRUE)[seq_len(min(
                3,
                length(id_cols_out_series)
            ))]]
        }
        outs <- c(outs, rep("", 3 - length(outs)))
        outliers[id_series, ] <- outs
    }

    return(list(values = outliers, missing = nout$missing))
}

extractTDFTest <- function(demetra_m) {
    td_f_test <- find_variable(
        demetra_m,
        pattern = "(^regression\\.td\\.ftest$)|(^td\\.ftest$)",
        type = "double",
        variable = "regression.td-ftest:3",
        p_value = TRUE
    )
    return(td_f_test)
}

extractIndependence <- function(
    demetra_m,
    thresholds = getOption("jdc_thresholds")
) {
    independency_pvalue <- find_variable(
        demetra_m,
        pattern = "(^residuals\\.lb$)|(^lb$)|(^independence$)",
        type = "double",
        variable = "residuals.lb:3",
        p_value = TRUE
    )

    modalities <- cut(
        x = as.numeric(independency_pvalue$values),
        breaks = c(-Inf, thresholds[["residuals_independency"]]),
        labels = names(thresholds[["residuals_independency"]]),
        right = FALSE,
        include.lowest = TRUE,
        ordered_result = TRUE
    )

    return(list(
        modalities = modalities,
        values = independency_pvalue$values,
        missing = independency_pvalue$missing
    ))
}

extractResidualsTDEffect <- function(
    demetra_m,
    thresholds = getOption("jdc_thresholds")
) {
    td_ftest <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.td\\.sa\\.last$)|(^td\\.sa\\.last$)",
        type = "double",
        variable = "diagnostics.td-sa-last:2",
        p_value = TRUE
    )

    modalities <- cut(
        x = as.numeric(td_ftest$values),
        breaks = c(-Inf, thresholds[["f_residual_td_on_sa"]]),
        labels = names(thresholds[["f_residual_td_on_sa"]]),
        right = FALSE,
        include.lowest = TRUE,
        ordered_result = TRUE
    )

    return(list(
        modalities = modalities,
        values = td_ftest$values,
        missing = td_ftest$missing
    ))
}

extractResidualsSeasEffect <- function(
    demetra_m,
    thresholds = getOption("jdc_thresholds")
) {
    residual_seasonality <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.seas\\.sa\\.f$)|(^seas\\.sa.f$)",
        type = "double",
        variable = "diagnostics.seas-sa-f:2",
        p_value = TRUE
    )

    modalities <- cut(
        x = as.numeric(residual_seasonality$values),
        breaks = c(-Inf, thresholds[["f_residual_s_on_sa"]]),
        labels = names(thresholds[["f_residual_s_on_sa"]]),
        right = FALSE,
        include.lowest = TRUE,
        ordered_result = TRUE
    )

    return(list(
        modalities = modalities,
        values = residual_seasonality$values,
        missing = residual_seasonality$missing
    ))
}

extractFrequency <- function(demetra_m) {
    start_date <- extractStart(demetra_m)
    end_date <- extractEnd(demetra_m)
    nobs <- extractNobs(demetra_m)

    if (!all(is.na(start_date$values)) && !all(is.na(end_date$values))) {
        start_date$values <- as.Date(start_date$values, format = "%Y-%m-%d")
        end_date$values <- as.Date(end_date$values, format = "%Y-%m-%d")

        start_date$values <- data.frame(
            y = as.numeric(format(start_date$values, "%Y")),
            m = as.numeric(format(start_date$values, "%m"))
        )
        end_date$values <- data.frame(
            y = as.numeric(format(end_date$values, "%Y")),
            m = as.numeric(format(end_date$values, "%m"))
        )
        freq <- c(12L, 6L, 4L, 3L, 2L)
        nobs_compute <- matrix(
            data = vapply(
                X = freq,
                FUN = function(x) {
                    x *
                        (end_date$values[, 1L] - start_date$values[, 1L]) +
                        (end_date$values[, 2L] - start_date$values[, 2L]) / (12L / x)
                },
                FUN.VALUE = double(nrow(demetra_m))
            ),
            nrow = nrow(demetra_m)
        )
        output <- vapply(
            X = seq_len(nrow(nobs_compute)),
            FUN = function(i) {
                if (is.na(nobs$values[i])) {
                    return(NA_integer_)
                }
                freq[which(
                    (nobs_compute[i, ] == nobs$values[i]) |
                        (nobs_compute[i, ] + 1L == nobs$values[i]) |
                        (nobs_compute[i, ] - 1L == nobs$values[i])
                )[[1L]]]
            },
            FUN.VALUE = integer(1L)
        )
    } else {
        output <- rep(NA_integer_, nrow(demetra_m))
    }
    return(list(
        values = output,
        missing = c(nobs$missing, end_date$missing, start_date$missing)
    ))
}

extractARIMA <- function(demetra_m) {
    arima_p <- find_variable(
        demetra_m,
        pattern = "(^arima\\.p$)|(^p$)",
        type = "integer",
        variable = "arima.p"
    )

    arima_d <- find_variable(
        demetra_m,
        pattern = "(^arima\\.d$)|(^d$)",
        type = "integer",
        variable = "arima.d"
    )

    arima_q <- find_variable(
        demetra_m,
        pattern = "(^arima\\.q$)|(^q$)",
        type = "integer",
        variable = "arima.q"
    )

    arima_bp <- find_variable(
        demetra_m,
        pattern = "(^arima\\.bp$)|(^bp$)",
        type = "integer",
        variable = "arima.bp"
    )

    arima_bd <- find_variable(
        demetra_m,
        pattern = "(^arima\\.bd$)|(^bd$)",
        type = "integer",
        variable = "arima.bd"
    )

    arima_bq <- find_variable(
        demetra_m,
        pattern = "(^arima\\.bq$)|(^bq$)",
        type = "integer",
        variable = "arima.bq"
    )

    arima_df <- data.frame(
        arima_p = arima_p$values,
        arima_d = arima_d$values,
        arima_q = arima_q$values,
        arima_bp = arima_bp$values,
        arima_bd = arima_bd$values,
        arima_bq = arima_bq$values
    )
    arima_df[["arima_model"]] <- paste0(
        "(",
        arima_df[["arima_p"]],
        ",",
        arima_df[["arima_d"]],
        ",",
        arima_df[["arima_q"]],
        ")",
        "(",
        arima_df[["arima_bp"]],
        ",",
        arima_df[["arima_bd"]],
        ",",
        arima_df[["arima_bq"]],
        ")"
    )
    return(list(
        values = arima_df[["arima_model"]],
        missing = c(
            arima_p$missing,
            arima_d$missing,
            arima_q$missing,
            arima_bp$missing,
            arima_bd$missing,
            arima_bq$missing
        )
    ))
}

extractStatQ <- function(demetra_m, thresholds = getOption("jdc_thresholds")) {
    q_stat <- find_variable(
        demetra_m,
        pattern = "(^m\\.statistics\\.q$)|(^q$)",
        type = "double",
        variable = "m-statistics.q"
    )

    q_m2 <- find_variable(
        demetra_m,
        pattern = "(^m\\.statistics\\.q\\.m2$)|(^q\\.m2$)",
        type = "double",
        variable = "m-statistics.q-m2"
    )

    stat_Q_modalities <- data.frame(
        q = cut(
            x = as.double(q_stat$values),
            breaks = c(-Inf, thresholds[["q"]]),
            labels = names(thresholds[["q"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        q_m2 = cut(
            x = as.double(q_m2$values),
            breaks = c(-Inf, thresholds[["q_m2"]]),
            labels = names(thresholds[["q_m2"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        stringsAsFactors = FALSE
    )
    stat_Q_values <- data.frame(
        q = as.double(q_stat$values),
        q_m2 = as.double(q_m2$values),
        stringsAsFactors = FALSE
    )

    return(list(
        modalities = stat_Q_modalities,
        values = stat_Q_values,
        missing = c(
            q_stat$missing,
            q_m2$missing
        )
    ))
}

extractOOS_test <- function(
    demetra_m,
    thresholds = getOption("jdc_thresholds")
) {
    mean_stat <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.fcast\\.outsample\\.mean$)|(^mean$)",
        type = "double",
        variable = c(
            "diagnostics.out-of-sample.mean:2",
            "diagnostics.fcast-outsample-mean:2"
        ),
        p_value = TRUE
    )

    mse_stat <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.fcast\\.outsample\\.variance$)|(^mse$)",
        type = "double",
        variable = c(
            "diagnostics.out-of-sample.mse:2",
            "diagnostics.fcast-outsample-variance:2"
        ),
        p_value = TRUE
    )

    stat_OOS_modalities <- data.frame(
        oos_mean = cut(
            x = as.double(mean_stat$values),
            breaks = c(-Inf, thresholds[["oos_mean"]]),
            labels = names(thresholds[["oos_mean"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        oos_mse = cut(
            x = as.double(mse_stat$values),
            breaks = c(-Inf, thresholds[["oos_mse"]]),
            labels = names(thresholds[["oos_mse"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        stringsAsFactors = FALSE
    )

    stat_OOS_values <- data.frame(
        oos_mean = as.double(mean_stat$values),
        oos_mse = as.double(mse_stat$values),
        stringsAsFactors = FALSE
    )

    return(list(
        modalities = stat_OOS_modalities,
        values = stat_OOS_values,
        missing = c(
            mean_stat$missing,
            mse_stat$missing
        )
    ))
}

extractDistributionTests <- function(
    demetra_m,
    thresholds = getOption("jdc_thresholds")
) {
    kurtosis_test <- find_variable(
        demetra_m,
        pattern = "(^residuals\\.kurtosis$)|(^kurtosis$)",
        type = "double",
        variable = "residuals.kurtosis:3",
        p_value = TRUE
    )

    skewness_test <- find_variable(
        demetra_m,
        pattern = "(^residuals\\.skewness$)|(^skewness$)",
        type = "double",
        variable = "residuals.skewness:3",
        p_value = TRUE
    )

    homoskedasticity_test <- find_variable(
        demetra_m,
        pattern = "(^residuals\\.lb2$)|(^lb2$)",
        type = "double",
        variable = "residuals.lb2:3",
        p_value = TRUE
    )

    independency_test <- extractIndependence(demetra_m, thresholds)

    normality_test <- find_variable(
        demetra_m,
        pattern = "(^residuals\\.doornikhansen$)|(^doornikhansen$)|(^dh$)|(^normality$)",
        type = "double",
        variable = c("residuals.dh:3", "residuals.doornikhansen:3"),
        p_value = TRUE
    )

    distribution_modalities <- data.frame(
        residuals_homoskedasticity = cut(
            x = homoskedasticity_test$values,
            breaks = c(-Inf, thresholds[["residuals_normality"]]),
            labels = names(thresholds[["residuals_normality"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        residuals_skewness = cut(
            x = skewness_test$values,
            breaks = c(-Inf, thresholds[["residuals_skewness"]]),
            labels = names(thresholds[["residuals_skewness"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        residuals_kurtosis = cut(
            x = kurtosis_test$values,
            breaks = c(-Inf, thresholds[["residuals_kurtosis"]]),
            labels = names(thresholds[["residuals_kurtosis"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        residuals_normality = cut(
            x = normality_test$values,
            breaks = c(-Inf, thresholds[["residuals_normality"]]),
            labels = names(thresholds[["residuals_normality"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        residuals_independency = independency_test$modalities
    )
    distribution_values <- data.frame(
        residuals_homoskedasticity = homoskedasticity_test$values,
        residuals_skewness = skewness_test$values,
        residuals_kurtosis = kurtosis_test$values,
        residuals_normality = normality_test$values,
        residuals_independency = independency_test$values
    )

    return(list(
        modalities = distribution_modalities,
        values = distribution_values,
        missing = c(
            homoskedasticity_test$missing,
            skewness_test$missing,
            kurtosis_test$missing,
            normality_test$missing,
            independency_test$missing
        )
    ))
}

extractOutliers <- function(
    demetra_m,
    thresholds = getOption("jdc_thresholds")
) {
    nobs <- extractNobs(demetra_m)
    nout <- extractNout(demetra_m)
    m7 <- extractM7(demetra_m)
    pct_outliers_value <- 100.0 * nout$values / nobs$values

    outliers_modalities <- data.frame(
        m7 = cut(
            x = m7$values,
            breaks = c(-Inf, thresholds[["m7"]]),
            labels = names(thresholds[["m7"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        pct_outliers = cut(
            x = pct_outliers_value,
            breaks = c(-Inf, thresholds[["pct_outliers"]]),
            labels = names(thresholds[["pct_outliers"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        )
    )
    outliers_values <- data.frame(
        m7 = m7$values,
        pct_outliers = pct_outliers_value
    )

    return(list(
        modalities = outliers_modalities,
        values = outliers_values,
        missing = c(
            nobs$missing,
            nout$missing,
            m7$missing
        )
    ))
}

extractSeasTest <- function(
    demetra_m,
    thresholds = getOption("jdc_thresholds")
) {
    qs_residual_s_on_sa <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.seas\\.sa\\.qs$)|(^seas\\.sa\\.qs$)",
        type = "double",
        variable = c("diagnostics.seas-sa-qs:2", "diagnostics.seas-sa-qs"),
        p_value = TRUE
    )

    qs_residual_sa_on_i <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.seas\\.i\\.qs$)|(^seas\\.i\\.qs$)",
        type = "double",
        variable = c("diagnostics.seas-i-qs:2", "diagnostics.seas-i-qs"),
        p_value = TRUE
    )

    f_residual_s_on_sa <- extractResidualsSeasEffect(demetra_m)

    f_residual_sa_on_i <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.seas\\.i\\.f$)|(^seas\\.i\\.f$)",
        type = "double",
        variable = c("diagnostics.seas-i-f:2", "diagnostics.seas-i-f"),
        p_value = TRUE
    )

    f_residual_td_on_sa <- extractResidualsTDEffect(demetra_m)

    f_residual_td_on_i <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.td\\.i\\.last$)|(^td\\.i\\.last$)",
        type = "double",
        variable = c("diagnostics.td-i-last:2", "diagnostics.td-i-last"),
        p_value = TRUE
    )

    test_values <- data.frame(
        qs_residual_s_on_sa = qs_residual_s_on_sa$values,
        f_residual_s_on_sa = f_residual_s_on_sa$values,
        qs_residual_sa_on_i = qs_residual_sa_on_i$values,
        f_residual_sa_on_i = f_residual_sa_on_i$values,
        f_residual_td_on_sa = f_residual_td_on_sa$values,
        f_residual_td_on_i = f_residual_td_on_i$values
    )

    test_modalities <- as.data.frame(lapply(
        X = colnames(test_values),
        FUN = function(series_name) {
            cut(
                x = as.numeric(test_values[, series_name]),
                breaks = c(-Inf, thresholds[[series_name]]),
                labels = names(thresholds[[series_name]]),
                right = FALSE,
                include.lowest = TRUE,
                ordered_result = TRUE
            )
        }
    ))
    colnames(test_modalities) <- colnames(test_values)

    return(list(
        modalities = test_modalities,
        values = test_values,
        missing = c(
            qs_residual_s_on_sa$missing,
            f_residual_s_on_sa$missing,
            qs_residual_sa_on_i$missing,
            f_residual_sa_on_i$missing,
            f_residual_td_on_sa$missing,
            f_residual_td_on_i$missing
        )
    ))
}

extractStandardDeviation <- function(i) {
    list_sd <- apply(
        X = i[, -1L, drop = FALSE],
        MARGIN = 2L,
        FUN = sd,
        na.rm = TRUE
    )
    return(list(
        values = list_sd
    ))
}

extractMaxAdj_oneseries <- function(y, sa) {
    valid <- y != 0 & !is.na(y) & !is.na(sa)

    if (!any(valid)) {
        return(Inf)
    }

    adj <- abs((y[valid] - sa[valid]) / y[valid])
    max_adj <- 100 * max(adj)

    return(max_adj)
}

extractMaxAdj_allseries <- function(y, sa) {
    if (ncol(y) != ncol(sa)) {
        stop("The files Y and SA do not have the same number of columns.")
    }

    if (nrow(y) != nrow(sa)) {
        stop("The files Y and SA do not have the same number of rows.")
    }

    list_max_adj <- mapply(
        FUN = extractMaxAdj_oneseries,
        y = y[, -1],
        sa = sa[, -1],
        SIMPLIFY = TRUE
    )

    return(list(
        values = list_max_adj
    ))
}

extractAdjustment <- function(demetra_m, s) {
    leaster <- extractLeaster(demetra_m)
    ntd <- extractNtd(demetra_m)
    ly <- extractLeapYear(demetra_m)
    ly$values[is.na(ly$values)] <- ""

    cond_sa <- apply(X = s[, -1], MARGIN = 2L, FUN = sd, na.rm = TRUE) != 0L
    cond_ca <- leaster$values > 0 | ntd$values > 0 | ly$values == "Leap year"

    adjustment <- paste0(
        ifelse(
            test = cond_sa,
            yes = "S",
            no = "NS"
        ),
        ifelse(
            test = is.na(cond_ca) | cond_ca,
            yes = "C",
            no = ""
        ),
        "A"
    )

    return(list(
        values = adjustment,
        missing = c(leaster$missing, ntd$missing, ly$missing)))
}
