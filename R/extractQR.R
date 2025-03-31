
create_NA_type <- function(type = c("character", "integer", "double", "logical",
                                    "complex", "raw", "Date"),
                           len = 1L) {
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
        variable = "") {

    cols <- id_cols <- grep(pattern = pattern, colnames(demetra_m))

    # Colonnes adjacentes
    for (idx in id_cols) {
        k <- 1L
        while (grepl(pattern = "^X\\.(\\d){1,}$", colnames(demetra_m)[idx + k])) {
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
                double = is.double(x),
                integer = is.integer(x),
                character = is.character(x),
                logical = is.logical(x)
            ))
        }
    ))
    cols <- cols[type_cols]

    if (p_value && length(cols) > 0L) {
        p_cols <- which(unlist(lapply(
            X = demetra_m[, cols, drop = FALSE],
            FUN = function(x) all(x >= 0L & x <= 1L)
        )))
        cols <- cols[p_cols]
    }

    if (length(cols) == 0L) {
        return(create_NA_type(type = type, len = nrow(demetra_m)))
    } else if (length(cols) > 1L) {
        message("Multiple column found for extraction of ", variable, "\n",
                ifelse(p_value, "Last column selected", "first column selected"))
        return(demetra_m[, cols[ifelse(p_value, length(cols), 1L)], drop = TRUE])
    } else {
        return(demetra_m[, cols, drop = TRUE])
    }
}

#' @title Extraction d'un bilan qualité
#'
#' @description
#' Permet d'extraire un bilan qualité à partir du fichier CSV contenant la
#' matrice des diagnostics.
#'
#' @param matrix_output_file Chaîne de caracère. Chemin vers le fichier CSV
#' contenant la matrice des diagnostics.
#' @param file Chaîne de caracère. Chemin vers le fichier CSV contenant la
#' matrice des diagnostics. Cet argument remplace l'argument
#' \code{matrix_output_file}.
#' @param sep séparateur de caractères utilisé dans le fichier csv (par défaut
#' \code{sep = ";"})
#' @param dec séparateur décimal utilisé dans le fichier csv (par défaut
#' \code{dec = ","})
#' @param thresholds \code{list} de vecteurs numériques. Seuils appliqués aux
#' différents tests afin de classer en modalités \code{Good}, \code{Uncertain},
#' \code{Bad} et \code{Severe}.
#' Par défault, la valeur de l'option \code{"jdc_threshold"} est utilisée.
#' Vous pouvez appeler la fonction \code{\link{get_thresholds}} pour voir à quoi
#' doit ressemble l'objet \code{thresholds}.
#'
#' @details La fonction permet d'extraire un bilan qualité à partir d'un
#' fichier csv contenant l'ensemble des
#' diagnostics (généralement fichier \emph{demetra_m.csv}).
#'
#' Ce fichier peut être obtenu en lançant le cruncher
#' (\code{\link[rjwsacruncher]{cruncher}} ou
#' \code{\link[rjwsacruncher]{cruncher_and_param}}) avec l'ensemble des
#' paramètres de base pour les paramètres à exporter et l'option
#' \code{csv_layout = "vtable"} (par défaut) pour le format de sortie des
#' fichiers csv (option de \code{\link[rjwsacruncher]{cruncher_and_param}} ou de
#' \code{\link[rjwsacruncher]{create_param_file}} lors de la création du fichier
#' de paramètres).
#'
#' Le résultat de cette fonction est un objet \code{\link{QR_matrix}} qui est
#' une liste de trois paramètres :
#'
#' * le paramètre \code{modalities} est un \code{data.frame} contenant un
#'   ensemble de variables sous forme catégorielle (Good, Uncertain, Bad,
#'   Severe).
#' * le paramètre \code{values} est un \code{data.frame} contenant les valeurs
#'   associées aux indicateurs présents dans \code{modalities} (i.e. :
#'   p-valeurs, statistiques, etc.) ainsi que des variables qui n'ont pas de
#'   modalité (fréquence de la série et modèle ARIMA).
#' * le paramètre \code{score_formula} est initié à \code{NULL} : il contiendra
#'   la formule utilisée pour calculer le score (si le calcul est fait).
#'
#' Si \code{x} est fourni, les arguments \code{fichier} et
#' \code{matrix_output_file} sont ignorés. L'argument \code{fichier} désigne
#' également le chemin vers le fichier qui contient la matrice de diagnostic
#' (qui peut être importée en parallèle dans R et utilisée avec l'argument
#' \code{x}).
#'
#' @encoding UTF-8
#' @return Un objet de type \code{\link{QR_matrix}}.
#' @examples
#' # Chemin menant au fichier demetra_m.csv
#' demetra_path <- file.path(
#'     system.file("extdata", package = "JDCruncheR"),
#'     "WS/ws_ipi/Output/SAProcessing-1",
#'     "demetra_m.csv"
#' )
#'
#' # Extraire le bilan qualité à partir du fichier demetra_m.csv
#' QR <- extract_QR(file = demetra_path)
#'
#' print(QR)
#'
#' # Extraire les modalités de la matrice
#' QR[["modalities"]]
#' # Or:
#' QR[["modalities"]]
#'
#' @keywords internal
#' @name fr-extract_QR
NULL
#> NULL


#' @title Extraction of a quality report
#'
#' @description
#' To extract a quality report from the csv file containing the diagnostics
#' matrix.
#'
#' @param matrix_output_file the csv file containing the diagnostics matrix.
#' @param file the csv file containing the diagnostics matrix. This argument
#' supersedes the argument \code{matrix_output_file}.
#' @param x data.frame containing the diagnostics matrix.
#' @param sep the separator used in the csv file (by default, \code{sep = ";"})
#' @param dec the decimal separator used in the csv file (by default,
#' \code{dec = ","})
#' @param thresholds \code{list} of numerical vectors. Thresholds applied to the
#' various tests in order to classify into modalities \code{Good},
#' \code{Uncertain}, \code{Bad} and \code{Severe}.
#' By default, the value of the \code{"jdc_threshold"} option is used.
#' You can call the \code{\link{get_thresholds}} function to see what the
#' \code{thresholds} object should look like.
#'
#' @details This function generates a quality report from a csv file containing
#' diagnostics (usually from the file \emph{demetra_m.csv}).
#' The \emph{demetra_m.csv} file can be generated by launching the cruncher
#' (functions \code{\link[rjwsacruncher]{cruncher}} or
#' \code{\link[rjwsacruncher]{cruncher_and_param}}) with the default export
#' parameters, having used the default option \code{csv_layout = "vtable"} to
#' format the output tables of the functions
#' \code{\link[rjwsacruncher]{cruncher_and_param}} and
#' \code{\link[rjwsacruncher]{create_param_file}} when creating the parameters
#' file.
#'
#' This function returns a \code{\link{QR_matrix}} object, which is a list of 3
#' objects:
#'
#' * \code{modalities}, a \code{data.frame} containing several indicators and
#'   their categorical quality (Good, Uncertain, Bad, Severe).
#' * \code{values}, a \code{data.frame} containing the same indicators and the
#'   values that lead to their quality category (i.e.: p-values, statistics,
#'   etc.) as well as additional variables that don't have a modality/quality
#'   (series frequency and arima model).
#' * \code{score_formula} that will store the formula used to calculate the
#'   score (when relevant). Its initial value is \code{NULL}.
#'
#' If \code{x} is supplied, the \code{file} and \code{matrix_output_file}
#' arguments are ignored. The \code{file} argument also designates the path to
#' the file containing the diagnostic matrix (which can be imported into R in
#' parallel and used with the \code{x} argument).
#'
#' @encoding UTF-8
#'
#' @return a \code{\link{QR_matrix}} object.
#'
#' @family QR_matrix functions
#' @examples
#' # Path of matrix demetra_m
#' demetra_path <- file.path(
#'     system.file("extdata", package = "JDCruncheR"),
#'     "WS/ws_ipi/Output/SAProcessing-1",
#'     "demetra_m.csv"
#' )
#'
#' # Extract the quality report from the demetra_m file
#' QR <- extract_QR(file = demetra_path)
#'
#' print(QR)
#'
#' # Extract the modalities matrix:
#' QR[["modalities"]]
#' # Or:
#' QR[["modalities"]]
#'
#' @importFrom stats sd
#' @importFrom utils read.csv
#' @seealso [Traduction française][fr-extract_QR()]
#' @export
extract_QR <- function(file,
                       x,
                       matrix_output_file,
                       sep = ";",
                       dec = ",",
                       thresholds = getOption("jdc_thresholds")) {
    if (!missing(matrix_output_file)) {
        warning("The `matrix_output_file` argument is deprecated",
                " and will be removed in the future. ",
                "Please use the `file` argument instead or ",
                "the `x` argument which may contain a diagnostic matrix ",
                "that has already been imported.", call. = FALSE)
        file <- matrix_output_file
    }

    if (missing(x) && missing(file)) {
        stop("Please call extract_QR() on a csv file containing at least ",
             "one cruncher output matrix (demetra_m.csv for example) ",
             "with the argument `file` ",
             "or directly on a matrix with the argument `x`", call. = FALSE)
    } else if (missing(x)) {
        if (length(file) == 0L
            || !file.exists(file)
            || !endsWith(x = file, suffix = ".csv")) {
            stop("The chosen file desn't exist or isn't a csv file", call. = FALSE)
        }

        demetra_m <- read.csv(
            file = file,
            sep = sep,
            dec = dec,
            stringsAsFactors = FALSE,
            na.strings = c("NA", "?"),
            fileEncoding = "latin1",
            quote = ""
        )
    } else {
        demetra_m <- x
    }

    if (nrow(demetra_m) == 0L || ncol(demetra_m) == 0L) {
        stop("The chosen csv file is empty.", call. = FALSE)
    }

    series <- gsub(
        "(^ *)|(* $)", "",
        gsub("(^.* \\* )|(\\[frozen\\])", "", demetra_m[, 1L])
    )

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
    QR_values <- data.frame(
        series = series,
        normality[["values"]],
        test[["values"]],
        stat_OOS[["values"]],
        stat_Q[["values"]],
        outliers[["values"]],
        frequency = frequency_series[["values"]],
        arima_model = arima_model[["values"]]
    )
    missing_items <- c(
        normality[["missing"]],
        test[["missing"]],
        stat_OOS[["missing"]],
        stat_Q[["missing"]],
        outliers[["missing"]],
        frequency = frequency_series[["missing"]],
        arima_model = arima_model[["missing"]]
    )

    if (length(missing_items) > 0L) {
        warning("Some items are missing. Please re-compute the cruncher export with the options:",
                toString(missing_items), call. = FALSE)
    }

    QR <- QR_matrix(modalities = QR_modalities, values = QR_values)
    return(QR)
}

extractFrequency <- function(demetra_m) {

    missing_var <- NULL

    start_date <- find_variable(
        demetra_m,
        pattern = "(^span\\.start$)|(^start$)",
        type = "character",
        variable = "start"
    )
    if (all(is.na(start_date))) missing_var <- c(missing_var, "span.start")

    end_date <- find_variable(
        demetra_m,
        pattern = "(^span\\.end$)|(^end$)",
        type = "character",
        variable = "end"
    )
    if (all(is.na(end_date))) missing_var <- c(missing_var, "span.end")

    n <- find_variable(
        demetra_m,
        pattern = "(^span\\.n$)|(^n$)",
        type = "integer",
        variable = "n"
    )
    if (all(is.na(n))) missing_var <- c(missing_var, "span.n")

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
                x * (end_date[, 1L] - start_date[, 1L]) + (end_date[, 2L] - start_date[, 2L]) / (12L / x)
            },
            FUN.VALUE = double(nrow(demetra_m))
        ),
        nrow = nrow(demetra_m)
    )
    output <- vapply(
        X = seq_len(nrow(nobs_compute)),
        FUN = function(i) {
            freq[which((nobs_compute[i, ] == n[i])
                       | (nobs_compute[i, ] + 1L == n[i])
                       | (nobs_compute[i, ] - 1L == n[i]))[[1L]]]
        },
        FUN.VALUE = integer(1L)
    )
    return(list(values = output,
                missing = missing_var))
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
        pattern = "(^arima\\.q$)|(^q\\.*\\d*$)",
        type = "integer",
        variable = "arima.q"
    )
    if (all(is.na(arima_q))) missing_var <- c(missing_var, "arima.q")

    arima_bp <- find_variable(
        demetra_m,
        pattern = "(^arima\\.bp$)|(^bp\\.*\\d*$)",
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
        "(", arima_df[["arima_p"]], ",", arima_df[["arima_d"]], ",", arima_df[["arima_q"]], ")",
        "(", arima_df[["arima_bp"]], ",", arima_df[["arima_bd"]], ",", arima_df[["arima_bq"]], ")"
    )
    return(list(values = arima_df[["arima_model"]],
                missing = missing_var))
}

extractStatQ <- function(demetra_m, thresholds = getOption("jdc_thresholds")) {

    missing_var <- NULL

    q_value <- find_variable(
        demetra_m,
        pattern = "(^m\\.statistics\\.q$)|(^q\\.*\\d*$)",
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
    if (all(is.na(q_m2_value))) missing_var <- c(missing_var, "m-statistics.q-m2")

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

    return(list(modalities = stat_Q_modalities,
                values = stat_Q_values,
                missing = missing_var))
}

extractOOS_test <- function(demetra_m, thresholds = getOption("jdc_thresholds")) {

    missing_var <- NULL

    mean_value <- find_variable(
        demetra_m,
        pattern = "(^mean\\.*\\d*$)",
        type = "double",
        variable = "mean",
        p_value = TRUE
    )
    if (all(is.na(mean_value))) missing_var <- c(missing_var, "diagnostics.out-of-sample.mean:2")

    mse_value <- find_variable(
        demetra_m,
        pattern = "(^mse\\.*\\d*$)",
        type = "double",
        variable = "mse",
        p_value = TRUE
    )
    if (all(is.na(mse_value))) missing_var <- c(missing_var, "diagnostics.out-of-sample.mse:2")

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

    return(list(modalities = stat_OOS_modalities,
                values = stat_OOS_values,
                missing = missing_var))
}

extractDistributionTests <- function(demetra_m, thresholds = getOption("jdc_thresholds")) {

    missing_var <- NULL

    kurtosis_pvalue <- find_variable(
        demetra_m,
        pattern = "(^residuals\\.kurtosis$)|(^kurtosis$)",
        type = "double",
        variable = "kurtosis",
        p_value = TRUE
    )
    if (all(is.na(kurtosis_pvalue))) missing_var <- c(missing_var, "residuals.kurtosis:3")

    skewness_pvalue <- find_variable(
        demetra_m,
        pattern = "(^residuals\\.skewness$)|(^skewness$)",
        type = "double",
        variable = "skewness",
        p_value = TRUE
    )
    if (all(is.na(skewness_pvalue))) missing_var <- c(missing_var, "residuals.skewness:3")

    homoskedasticity_pvalue <- find_variable(
        demetra_m,
        pattern = "(^residuals\\.lb2$)|(^lb2$)",
        type = "double",
        variable = "homoskedasticity",
        p_value = TRUE
    )
    if (all(is.na(homoskedasticity_pvalue))) missing_var <- c(missing_var, "residuals.lb2:3")

    normality_pvalue <- find_variable(
        demetra_m,
        pattern = "(^residuals\\.lb$)|(^lb$)|(^normality$)",
        type = "double",
        variable = "normality",
        p_value = TRUE
    )
    if (all(is.na(normality_pvalue))) missing_var <- c(missing_var, "residuals.lb:3")

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

    return(list(modalities = distribution_modalities,
                values = distribution_values,
                missing = missing_var))
}

extractOutliers <- function(demetra_m, thresholds = getOption("jdc_thresholds")) {

    missing_var <- NULL

    n <- find_variable(
        demetra_m,
        pattern = "(^span\\.n$)|(^n$)",
        type = "integer",
        variable = "n"
    )
    if (all(is.na(n))) missing_var <- c(missing_var, "span.n")

    nout <- find_variable(
        demetra_m,
        pattern = "(^regression\\.nout$)|(^nout$)",
        type = "integer",
        variable = "nout"
    )
    if (all(is.na(nout))) missing_var <- c(missing_var, "regression.nout")

    pct_outliers_value <- 100.0 * nout / n

    m7 <- find_variable(
        demetra_m,
        pattern = "(^m\\.statistics\\.m7$)|(^m7$)",
        type = "double",
        variable = "m7"
    )
    if (all(is.na(m7))) missing_var <- c(missing_var, "m-statistics.m7")

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

    return(list(modalities = outliers_modalities,
                values = outliers_values,
                missing = missing_var))
}

extractSeasTest <- function(demetra_m, thresholds = getOption("jdc_thresholds")) {

    missing_var <- NULL

    qs_residual_sa_on_sa <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.seas\\.sa\\.qs$)|(^seas\\.sa\\.qs$)",
        type = "double",
        variable = "qs_residual_sa_on_sa",
        p_value = TRUE
    )
    if (all(is.na(qs_residual_sa_on_sa))) {
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

    f_residual_sa_on_sa <- find_variable(
        demetra_m,
        pattern = "(^diagnostics\\.seas\\.sa\\.f$)|(^seas\\.sa.f$)",
        type = "double",
        variable = "f_residual_sa_on_sa",
        p_value = TRUE
    )
    if (all(is.na(f_residual_sa_on_sa))) {
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
        pattern = "(^diagnostics\\.td\\.sa\\.last$)|(^td\\.sa\\.last$)",
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
        qs_residual_sa_on_sa, f_residual_sa_on_sa,
        qs_residual_sa_on_i, f_residual_sa_on_i,
        f_residual_td_on_sa, f_residual_td_on_i
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

    return(list(modalities = test_modalities,
                values = test_values,
                missing = missing_var))
}
