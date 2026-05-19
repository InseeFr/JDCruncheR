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
        exact = FALSE
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

    #Type de la colonne
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
        return(create_NA_type(type = type, len = nrow(demetra_m)))
    } else if (length(cols) == 1L) {
        # 1 seule colonnes
        return(demetra_m[, cols, drop = TRUE])
    }

    # Multiples colonnes

    # cond: les multiples colonnes sont elles égales ?
    cond <- all(apply(
        X = demetra_m[, cols, drop = FALSE],
        MARGIN = 2L,
        FUN = `==`,
        demetra_m[, cols[1L], drop = TRUE]
    ))

    if (cond) {
        id <- 1L
    } else {
        message(
            "Multiple column found for extraction of ",
            variable,
            "\n",
            ifelse(p_value, "Last column selected", "First column selected")
        )
        id <- ifelse(p_value, length(cols), 1L)
    }

    return(demetra_m[, cols[id], drop = TRUE])
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

extractStart <- function(demetra_m) {
    missing_var <- NULL

    start_date <- find_variable(
        demetra_m,
        pattern = "(^span\\.start$)|(^start$)",
        type = "character",
        variable = "start"
    )
    if (all(is.na(start_date))) missing_var <- "span.start"

    return(list(values = start_date, missing = missing_var))
}

extractEnd <- function(demetra_m) {
    missing_var <- NULL

    end_date <- find_variable(
        demetra_m,
        pattern = "(^span\\.end$)|(^end$)",
        type = "character",
        variable = "end"
    )
    if (all(is.na(end_date))) missing_var <- "span.end"

    return(list(values = end_date, missing = missing_var))
}

extractNobs <- function(demetra_m) {
    missing_var <- NULL

    nobs <- find_variable(
        demetra_m,
        pattern = "(^span\\.n$)|(^n$)",
        type = "integer",
        variable = "n"
    )
    if (all(is.na(nobs))) missing_var <- c(missing_var, "span.n")

    return(list(values = nobs, missing = missing_var))
}

extractNout <- function(demetra_m) {
    missing_var <- NULL

    nout <- find_variable(
        demetra_m,
        pattern = "(^regression\\.nout$)|(^nout$)",
        type = "integer",
        variable = "nout"
    )
    if (all(is.na(nout))) missing_var <- c(missing_var, "regression.nout")

    return(list(values = nout, missing = missing_var))
}

extractM7 <- function(demetra_m) {
    missing_var <- NULL

    m7 <- find_variable(
        demetra_m,
        pattern = "(^m\\.statistics\\.m7$)|(^m7$)",
        type = "double",
        variable = "m7"
    )
    if (all(is.na(m7))) missing_var <- c(missing_var, "m-statistics.m7")

    return(list(values = m7, missing = missing_var))
}

extractTD_ftest <- function(demetra_m) {
    missing_var <- NULL

    td_ftest <- find_variable(
        demetra_m,
        pattern = "(^regression\\.td\\.ftest$)|(^td\\.ftest$)",
        type = "double",
        variable = "td-ftest"
    )
    if (all(is.na(td_ftest))) missing_var <- c(missing_var, "regression.td-ftest")

    return(list(values = td_ftest, missing = missing_var))
}

extractFrequency <- function(demetra_m) {
    missing_var <- NULL

    start_date <- extractStart(demetra_m)
    missing_var <- c(missing_var, start_date$missing)
    start_date <- start_date$values

    end_date <- extractEnd(demetra_m)
    missing_var <- c(missing_var, end_date$missing)
    end_date <- end_date$values

    nobs <- extractNobs(demetra_m)
    missing_var <- c(missing_var, nobs$missing)
    nobs <- nobs$values

    if (!all(is.na(start_date)) && !all(is.na(end_date))) {
        start_date <- as.Date(start_date, format = "%Y-%m-%d")
        end_date <- as.Date(end_date, format = "%Y-%m-%d")

        start_date <- data.frame(
            y = as.numeric(format(start_date, "%Y")),
            m = as.numeric(format(start_date, "%m"))
        )
        end_date <- data.frame(
            y = as.numeric(format(end_date, "%Y")),
            m = as.numeric(format(end_date, "%m"))
        )
        freq <- c(12L, 6L, 4L, 3L, 2L)
        nobs_compute <- matrix(
            data = vapply(
                X = freq,
                FUN = function(x) {
                    x *
                        (end_date[, 1L] - start_date[, 1L]) +
                        (end_date[, 2L] - start_date[, 2L]) / (12L / x)
                },
                FUN.VALUE = double(nrow(demetra_m))
            ),
            nrow = nrow(demetra_m)
        )
        output <- vapply(
            X = seq_len(nrow(nobs_compute)),
            FUN = function(i) {
                if (is.na(nobs[i])) return(NA_integer_)
                freq[which(
                    (nobs_compute[i, ] == nobs[i]) |
                        (nobs_compute[i, ] + 1L == nobs[i]) |
                        (nobs_compute[i, ] - 1L == nobs[i])
                )[[1L]]]
            },
            FUN.VALUE = integer(1L)
        )
    } else {
        output <- rep(NA_integer_, nrow(demetra_m))
    }
    return(list(values = output, missing = missing_var))
}

extractARIMA <- function(demetra_m) {
    missing_var <- NULL

    arima_p <- find_variable(
        demetra_m,
        pattern = "(^arima\\.p$)|(^p$)",
        type = "integer",
        variable = "arima.p"
    )
    if (all(is.na(arima_p))) missing_var <- c(missing_var, "arima.p")

    arima_d <- find_variable(
        demetra_m,
        pattern = "(^arima\\.d$)|(^d$)",
        type = "integer",
        variable = "arima.d"
    )
    if (all(is.na(arima_d))) missing_var <- c(missing_var, "arima.d")

    arima_q <- find_variable(
        demetra_m,
        pattern = "(^arima\\.q$)|(^q$)",
        type = "integer",
        variable = "arima.q"
    )
    if (all(is.na(arima_q))) missing_var <- c(missing_var, "arima.q")

    arima_bp <- find_variable(
        demetra_m,
        pattern = "(^arima\\.bp$)|(^bp$)",
        type = "integer",
        variable = "arima.bp"
    )
    if (all(is.na(arima_bp))) missing_var <- c(missing_var, "arima.bp")

    arima_bd <- find_variable(
        demetra_m,
        pattern = "(^arima\\.bd$)|(^bd$)",
        type = "integer",
        variable = "arima.bd"
    )
    if (all(is.na(arima_bd))) missing_var <- c(missing_var, "arima.bd")

    arima_bq <- find_variable(
        demetra_m,
        pattern = "(^arima\\.bq$)|(^bq$)",
        type = "integer",
        variable = "arima.bq"
    )
    if (all(is.na(arima_bq))) missing_var <- c(missing_var, "arima.bq")

    arima_df <- data.frame(
        arima_p = arima_p,
        arima_d = arima_d,
        arima_q = arima_q,
        arima_bp = arima_bp,
        arima_bd = arima_bd,
        arima_bq = arima_bq
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
    return(list(values = arima_df[["arima_model"]], missing = missing_var))
}

extractStatQ <- function(demetra_m, thresholds = getOption("jdc_thresholds")) {
    missing_var <- NULL

    q_value <- find_variable(
        demetra_m,
        pattern = "(^m\\.statistics\\.q$)|(^q$)",
        type = "double",
        variable = "q statistic"
    )
    if (all(is.na(q_value))) missing_var <- c(missing_var, "m-statistics.q")

    q_m2_value <- find_variable(
        demetra_m,
        pattern = "(^m\\.statistics\\.q\\.m2$)|(^q\\.m2$)",
        type = "double",
        variable = "q-m2 statistic"
    )
    if (all(is.na(q_m2_value))) {
        missing_var <- c(missing_var, "m-statistics.q-m2")
    }

    stat_Q_modalities <- data.frame(
        q = cut(
            x = as.double(q_value),
            breaks = c(-Inf, thresholds[["q"]]),
            labels = names(thresholds[["q"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        q_m2 = cut(
            x = as.double(q_m2_value),
            breaks = c(-Inf, thresholds[["q_m2"]]),
            labels = names(thresholds[["q_m2"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        stringsAsFactors = FALSE
    )
    stat_Q_values <- data.frame(
        q = as.double(q_value),
        q_m2 = as.double(q_m2_value),
        stringsAsFactors = FALSE
    )

    return(list(
        modalities = stat_Q_modalities,
        values = stat_Q_values,
        missing = missing_var
    ))
}

extractOOS_test <- function(
        demetra_m,
        thresholds = getOption("jdc_thresholds")
) {
    missing_var <- NULL

    mean_value <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.fcast\\.outsample\\.mean$)|(^mean$)",
        type = "double",
        variable = "mean",
        p_value = TRUE
    )
    if (all(is.na(mean_value))) {
        missing_var <- c(
            missing_var,
            "diagnostics.out-of-sample.mean:2",
            "diagnostics.fcast-outsample-mean:2"
        )
    }

    mse_value <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.fcast\\.outsample\\.variance$)|(^mse$)",
        type = "double",
        variable = "mse",
        p_value = TRUE
    )
    if (all(is.na(mse_value))) {
        missing_var <- c(
            missing_var,
            "diagnostics.out-of-sample.mse:2",
            "diagnostics.fcast-outsample-variance:2"
        )
    }

    stat_OOS_modalities <- data.frame(
        oos_mean = cut(
            x = as.double(mean_value),
            breaks = c(-Inf, thresholds[["oos_mean"]]),
            labels = names(thresholds[["oos_mean"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        oos_mse = cut(
            x = as.double(mse_value),
            breaks = c(-Inf, thresholds[["oos_mse"]]),
            labels = names(thresholds[["oos_mse"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        stringsAsFactors = FALSE
    )

    stat_OOS_values <- data.frame(
        oos_mean = as.double(mean_value),
        oos_mse = as.double(mse_value),
        stringsAsFactors = FALSE
    )

    return(list(
        modalities = stat_OOS_modalities,
        values = stat_OOS_values,
        missing = missing_var
    ))
}

extractDistributionTests <- function(
        demetra_m,
        thresholds = getOption("jdc_thresholds")
) {
    missing_var <- NULL

    kurtosis_pvalue <- find_variable(
        demetra_m,
        pattern = "(^residuals\\.kurtosis$)|(^kurtosis$)",
        type = "double",
        variable = "kurtosis",
        p_value = TRUE
    )
    if (all(is.na(kurtosis_pvalue))) {
        missing_var <- c(missing_var, "residuals.kurtosis:3")
    }

    skewness_pvalue <- find_variable(
        demetra_m,
        pattern = "(^residuals\\.skewness$)|(^skewness$)",
        type = "double",
        variable = "skewness",
        p_value = TRUE
    )
    if (all(is.na(skewness_pvalue))) {
        missing_var <- c(missing_var, "residuals.skewness:3")
    }

    homoskedasticity_pvalue <- find_variable(
        demetra_m,
        pattern = "(^residuals\\.lb2$)|(^lb2$)",
        type = "double",
        variable = "homoskedasticity",
        p_value = TRUE
    )
    if (all(is.na(homoskedasticity_pvalue))) {
        missing_var <- c(missing_var, "residuals.lb2:3")
    }

    normality_pvalue <- find_variable(
        demetra_m,
        pattern = "(^residuals\\.lb$)|(^lb$)|(^normality$)",
        type = "double",
        variable = "normality",
        p_value = TRUE
    )
    if (all(is.na(normality_pvalue))) {
        missing_var <- c(missing_var, "residuals.lb:3")
    }

    independency_pvalue <- find_variable(
        demetra_m,
        pattern = "(^residuals\\.doornikhansen$)|(^doornikhansen$)|(^dh$)|(^independence$)",
        type = "double",
        variable = "independency",
        p_value = TRUE
    )
    if (all(is.na(independency_pvalue))) {
        missing_var <- append(
            x = missing_var,
            values = c("residuals.dh:3", "residuals.doornikhansen:3")
        )
    }

    distribution_modalities <- data.frame(
        residuals_homoskedasticity = cut(
            x = homoskedasticity_pvalue,
            breaks = c(-Inf, thresholds[["residuals_normality"]]),
            labels = names(thresholds[["residuals_normality"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        residuals_skewness = cut(
            x = skewness_pvalue,
            breaks = c(-Inf, thresholds[["residuals_skewness"]]),
            labels = names(thresholds[["residuals_skewness"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        residuals_kurtosis = cut(
            x = kurtosis_pvalue,
            breaks = c(-Inf, thresholds[["residuals_kurtosis"]]),
            labels = names(thresholds[["residuals_kurtosis"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        residuals_normality = cut(
            x = normality_pvalue,
            breaks = c(-Inf, thresholds[["residuals_normality"]]),
            labels = names(thresholds[["residuals_normality"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        ),
        residuals_independency = cut(
            x = independency_pvalue,
            breaks = c(-Inf, thresholds[["residuals_independency"]]),
            labels = names(thresholds[["residuals_independency"]]),
            right = FALSE,
            include.lowest = TRUE,
            ordered_result = TRUE
        )
    )
    distribution_values <- data.frame(
        residuals_homoskedasticity = homoskedasticity_pvalue,
        residuals_skewness = skewness_pvalue,
        residuals_kurtosis = kurtosis_pvalue,
        residuals_normality = normality_pvalue,
        residuals_independency = independency_pvalue
    )

    return(list(
        modalities = distribution_modalities,
        values = distribution_values,
        missing = missing_var
    ))
}

extractOutliers <- function(
        demetra_m,
        thresholds = getOption("jdc_thresholds")
) {
    missing_var <- NULL

    nobs <- extractNobs(demetra_m)
    missing_var <- c(missing_var, nobs$missing)
    nobs <- nobs$values

    nout <- extractNout(demetra_m)
    missing_var <- c(missing_var, nout$missing)
    nout <- nout$values

    m7 <- extractM7(demetra_m)
    missing_var <- c(missing_var, m7$missing)
    m7 <- m7$values

    pct_outliers_value <- 100.0 * nout / nobs

    outliers_modalities <- data.frame(
        m7 = cut(
            x = m7,
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
        m7 = m7,
        pct_outliers = pct_outliers_value
    )

    return(list(
        modalities = outliers_modalities,
        values = outliers_values,
        missing = missing_var
    ))
}

extractSeasTest <- function(
        demetra_m,
        thresholds = getOption("jdc_thresholds")
) {
    missing_var <- NULL

    qs_residual_s_on_sa <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.seas\\.sa\\.qs$)|(^seas\\.sa\\.qs$)",
        type = "double",
        variable = "qs_residual_s_on_sa",
        p_value = TRUE
    )
    if (all(is.na(qs_residual_s_on_sa))) {
        missing_var <- append(
            x = missing_var,
            values = c("diagnostics.seas-sa-qs:2", "diagnostics.seas-sa-qs")
        )
    }

    qs_residual_sa_on_i <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.seas\\.i\\.qs$)|(^seas\\.i\\.qs$)",
        type = "double",
        variable = "qs_residual_sa_on_i",
        p_value = TRUE
    )
    if (all(is.na(qs_residual_sa_on_i))) {
        missing_var <- append(
            x = missing_var,
            values = c("diagnostics.seas-i-qs:2", "diagnostics.seas-i-qs")
        )
    }

    f_residual_s_on_sa <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.seas\\.sa\\.f$)|(^seas\\.sa.f$)",
        type = "double",
        variable = "f_residual_s_on_sa",
        p_value = TRUE
    )
    if (all(is.na(f_residual_s_on_sa))) {
        missing_var <- append(
            x = missing_var,
            values = c("diagnostics.seas-sa-f:2", "diagnostics.seas-sa-f")
        )
    }

    f_residual_sa_on_i <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.seas\\.i\\.f$)|(^seas\\.i\\.f$)",
        type = "double",
        variable = "f_residual_sa_on_i",
        p_value = TRUE
    )
    if (all(is.na(f_residual_sa_on_i))) {
        missing_var <- append(
            x = missing_var,
            values = c("diagnostics.seas-i-f:2", "diagnostics.seas-i-f")
        )
    }

    f_residual_td_on_sa <- find_variable(
        demetra_m,
        pattern = paste(
            "(^diagnostics\\.td\\.sa\\.last$)",
            "(^td\\.sa\\.last$)",
            sep = "|"
        ),
        type = "double",
        variable = "f_residual_td_on_sa",
        p_value = TRUE
    )
    if (all(is.na(f_residual_td_on_sa))) {
        missing_var <- append(
            x = missing_var,
            values = c("diagnostics.td-sa-last:2", "diagnostics.td-sa-last")
        )
    }

    f_residual_td_on_i <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.td\\.i\\.last$)|(^td\\.i\\.last$)",
        type = "double",
        variable = "f_residual_td_on_i",
        p_value = TRUE
    )
    if (all(is.na(f_residual_td_on_i))) {
        missing_var <- append(
            x = missing_var,
            values = c("diagnostics.td-i-last:2", "diagnostics.td-i-last")
        )
    }

    test_values <- cbind(
        qs_residual_s_on_sa,
        f_residual_s_on_sa,
        qs_residual_sa_on_i,
        f_residual_sa_on_i,
        f_residual_td_on_sa,
        f_residual_td_on_i
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
        missing = missing_var
    ))
}
