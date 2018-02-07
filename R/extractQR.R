#' Extraction d'un bilan qualité
#'
#' Permet d'extraire un bilan qualité à partir d'un dossier contenant les résultats.
#'
#' @param matrix_output_file fichier CSV contenant la matrice des diagnostics. S'il n'est pas spécifié une fenêtre s'ouvre
#' pour sélectionner le fichier.
#' @param sep séparateur de caractères utilisé dans le fichier csv (par défaut \code{sep = ","})
#' @param dec séparateur décimal utilisé dans le fichier csv (par défaut \code{dec = ","})
#'
#' @details La fonction permet d'extraire un bilan qualité à partir d'un dossier contenant l'ensemble des résultats.
#' Ce dossier doit contenir : un fichier \emph{demetra_m.csv} contenant l'ensemble des diagnostics, un fichier
#' \emph{series_y.csv} contenant les séries brutes (en colonnes) et un dossier \emph{series_sa.csv} contenant
#' les séries CVS-CJO (en colonnes).
#'
#' Ces fichiers peuvent être obtenus en lançant le cruncher (\code{\link{cruncher}} ou \code{\link{cruncher_and_param}}) avec
#' l'ensemble des paramètres de base pour les paramètres à exporter, les séries "y" et "sa" dans les séries temporelles à exporter
#' et l'option \code{csv_layout = "vtable"} pour le format de sortie des fichiers csv (option de
#' \code{\link{cruncher_and_param}} ou de \code{\link{create_param_file}} lors de la création du
#' fichier de paramètres).
#'
#' Le résultat de cette fonction est un objet \code{\link{QR_matrix}} qui est une liste de trois paramètres :
#' * le paramètre \code{modalities} est un \code{data.frame} contenant un ensemble de variables sous forme catégorielle
#'   (Good, Uncertain, Bad, Severe).
#' * le paramètre \code{values} est un \code{data.frame} contenant les valeurs associées aux indicateurs présents dans
#'   \code{modalities} (i.e. : p-valeurs, statistiques, etc.) ainsi que des variables qui n'ont pas
#'   de modalité (fréquence de la série et modèle ARIMA).
#' * le paramètre \code{score_formula} est initié à \code{NULL} : il contiendra la formule utilisée pour
#'   calculer le score (si le calcul est fait).
#'
#' @encoding UTF-8
#' @return Un objet de type \code{\link{QR_matrix}}.
#' @family QR_matrix functions
#' @examples \dontrun{
#' QR <- extract_QR()
#' print(QR)
#' # Pour extraire la matrice des modalités :
#' QR$modalities
#' # Ou :
#' QR[["modalities"]]
#' }
#' @export
extract_QR <- function(matrix_output_file, sep = ";", dec = ","){
    if(missing(matrix_output_file) || is.null(matrix_output_file)){
        if(Sys.info()[['sysname']] == "Windows"){
            matrix_output_file <- utils::choose.files(caption = "Sélectionner le fichier contenant la matrice des paramètres",
                                             filters = c("Fichier CSV","*.csv"))
        }else{
            matrix_output_file <- base::file.choose()
        }
    }
    if(length(matrix_output_file) == 0)
        stop("Il faut choisir un fichier")
    if(!file.exists(matrix_output_file)|length(grep("\\.csv$",matrix_output_file))==0)
        stop("Le fichier n'existe pas ou n'est pas un fichier csv")

    demetra_m <- read.csv(file = matrix_output_file,
                      sep = sep, dec = dec, stringsAsFactors = FALSE,
                      na.strings = c("NA","?"))
    missing_variables <- which(is.na(match(c("qs.test.on.sa", "f.test.on.sa..seasonal.dummies.", "on.sa",
                                             "on.sa..last.3.years.","on.irregular","qs.test.on.i","f.test.on.i..seasonal.dummies.",
                                             "f.test.on.sa..td.", "f.test.on.i..td.","independence","normality"),
                                           colnames(demetra_m))))
    if(length(missing_variables)!=0){
        stop(paste0("Il manque le(s) variable(s) suivante(s) dans la matrice des diagnostics :\n"
                    ,c("qs.test.on.sa", "f.test.on.sa..seasonal.dummies.", "on.sa",
                       "on.sa..last.3.years.","on.irregular","qs.test.on.i","f.test.on.i..seasonal.dummies.",
                       "f.test.on.sa..td.", "f.test.on.i..td.","independence","normality")[missing_variables],
                    "\nRelancez l'export"))
    }

    demetra_m$series <- gsub("(^ *)|(* $)","",gsub("(^.* \\* )|(\\[frozen\\])","",demetra_m[,1]))
    demetra_m$frequency <- extractFrequency(demetra_m)

    demetra_m <- cbind(demetra_m,
                       extractARIMA(demetra_m),
                       extractStatQ(demetra_m),
                       extractOOS_test(demetra_m))
    homoskedasticity_df <- 2 * demetra_m$frequency - demetra_m$arima_p-demetra_m$arima_q-demetra_m$arima_bp-demetra_m$arima_bq
    demetra_m$homoskedasticity_pvalue <- 1 - pchisq(demetra_m$lb2, df = homoskedasticity_df)
    demetra_m$homoskedasticity_modality <- cut(demetra_m$homoskedasticity_pvalue,
                                               breaks = c(0, 0.01, 0.1, 1),
                                               labels = c("Bad", "Uncertain", "Good"),
                                               right = FALSE)
    demetra_m$mean_residuals_pvalue <- 2 * (1 - pt(abs(demetra_m$mean), demetra_m$neffectiveobs))
    demetra_m$mean_residuals_modality <- cut(demetra_m$mean_residuals_pvalue,
                                             breaks = c(0, 0.01, 0.1, 1),
                                             labels = c("Bad", "Uncertain", "Good"),
                                             right = FALSE)
    demetra_m$pct_outliers_value <- demetra_m[,match("number.of.outliers",colnames(demetra_m))+1] * 100
    demetra_m$pct_outliers_modality <- demetra_m$number.of.outliers
    demetra_m$m7_modality <- cut(demetra_m$m7,
                                 breaks = c(0, 1, 2, Inf),
                                 labels = c("Good", "Bad", "Severe"), right = FALSE)

    colnames(demetra_m)[match(c("qs.test.on.sa", "f.test.on.sa..seasonal.dummies.", "on.sa",
                                "on.sa..last.3.years.","on.irregular","qs.test.on.i","f.test.on.i..seasonal.dummies.",
                                "f.test.on.sa..td.", "f.test.on.i..td.","independence","normality"),
                              colnames(demetra_m))+1] <- paste0(c("qs.test.on.sa", "f.test.on.sa..seasonal.dummies.", "on.sa",
                                                                  "on.sa..last.3.years.","on.irregular","qs.test.on.i","f.test.on.i..seasonal.dummies.",
                                                                  "f.test.on.sa..td.", "f.test.on.i..td.","independence","normality"),"_pvalue")
    modalities_variables <- c("series","qs.test.on.sa", "f.test.on.sa..seasonal.dummies.", "on.sa",
                              "on.sa..last.3.years.","on.irregular","qs.test.on.i","f.test.on.i..seasonal.dummies.",
                              "f.test.on.sa..td.", "f.test.on.i..td.","mean_residuals_modality",
                              "independence","homoskedasticity_modality","normality","oos_mean_modality",
                              "oos_mse_modality","m7_modality","q_modality","q_m2_modality","pct_outliers_modality")

    values_variables <- c("series","qs.test.on.sa_pvalue","f.test.on.sa..seasonal.dummies._pvalue","on.sa_pvalue",
                          "on.sa..last.3.years._pvalue","on.irregular_pvalue","qs.test.on.i_pvalue","f.test.on.i..seasonal.dummies._pvalue",
                          "f.test.on.sa..td._pvalue","f.test.on.i..td._pvalue","mean_residuals_pvalue",
                          "independence_pvalue","homoskedasticity_pvalue","normality_pvalue","oos_mean_pvalue",
                          "oos_mse_pvalue","m7","q_value","q_m2_value","pct_outliers_value",
                          "frequency","arima_model")

    if(!all(modalities_variables %in% colnames(demetra_m),
            values_variables %in% colnames(demetra_m))){
        missing_variables <- unique(c(modalities_variables[!modalities_variables %in% colnames(demetra_m)],
                                      values_variables[!values_variables %in% colnames(demetra_m)]))
        missing_variables <- paste(missing_variables,collapse = "\n")
        stop(paste0("Il manque le(s) variable(s) suivante(s) dans la matrice des diagnostics :\n"
                    ,missing_variables,"\nRelancez l'export"))
    }

    names_QR_variables <- c("series","qs_residual_sa_on_sa","f_residual_sa_on_sa","combined_residual_sa_on_sa",
                            "combined_residual_sa_on_sa_last_years","combined_residual_sa_on_i",
                            "qs_residual_sa_on_i","f_residual_sa_on_i",
                            "f_residual_td_on_sa","f_residual_td_on_i","residuals_mean",
                            "residuals_independency","residuals_homoskedasticity","residual_normality",
                            "oos_mean","oos_mse","m7","q","q_m2","pct_outliers")
    QR_modalities <- demetra_m[,modalities_variables]
    QR_values <- demetra_m[,values_variables]
    rownames(QR_modalities) <- rownames(QR_values) <- NULL
    colnames(QR_values)[1:length(names_QR_variables)] <- colnames(QR_modalities) <- names_QR_variables
    QR_modalities[,-1] <- lapply(QR_modalities[,-1],factor,
                                 levels = c("Good", "Uncertain", "Bad","Severe"), ordered = TRUE)
    QR <- QR_matrix(modalities = QR_modalities, values = QR_values)
    QR
}

extractARIMA <- function(demetra_m){
    q_possibles <- grep("(^q$)|(^q\\.\\d$)",colnames(demetra_m))
    bp_possibles <- grep("(^bp$)|(^bp\\.\\d$)",colnames(demetra_m))
    if(length(q_possibles) > 1){
        col_q_possibles <- demetra_m[,q_possibles]
        val_q <- col_q_possibles[,which(sapply(col_q_possibles,is.integer))[1]]
    }
    if(length(bp_possibles) > 1){
        col_bq_possibles <- demetra_m[,bp_possibles]
        val_bq <- col_bq_possibles[,which(sapply(col_bq_possibles,is.integer))[1]]
    }

    if(!all(is.integer(val_q),is.integer(val_bq)))
        stop("Erreur dans l'extraction du paramètre q ou bq du modèle ARIMA : revoir l'extraction")
    arima <- data.frame(arima_p = demetra_m[,"p"], arima_d = demetra_m[,"d"], arima_q = val_q,
                        arima_bp = val_bq, arima_bd = demetra_m[,"bd"], arima_bq = demetra_m[,"bq"],
                        arima_model = demetra_m[,"arima"])
    return(arima)
}
extractOOS_test <- function(demetra_m){
    mean_possibles <- grep("(^mean$)|(^mean\\.\\d$)",colnames(demetra_m))
    if(length(mean_possibles) > 1){
        col_mean_possibles <- demetra_m[,mean_possibles]
        col_mean <- mean_possibles[sapply(col_mean_possibles,is.character)][1]
    }
    col_mse <- match("mse",colnames(demetra_m))[1]
    if(!all(is.character(demetra_m[,col_mean]),is.double(demetra_m[,col_mean+1]),
            is.character(demetra_m[,col_mse]),is.double(demetra_m[,col_mse+1])
    ))
        stop("Erreur dans l'extraction des diagnostics en out of sample")

    stat_OOS <- data.frame(demetra_m[,col_mean+c(0,1)], demetra_m[,col_mse+c(0,1)],
                           stringsAsFactors = FALSE)
    colnames(stat_OOS) <- c("oos_mean_modality","oos_mean_pvalue","oos_mse_modality","oos_mse_pvalue")
    return(stat_OOS)
}
extractStatQ <- function(demetra_m){
    q_possibles <- grep("(^q$)|(^q\\.\\d$)",colnames(demetra_m))
    q_m2_possibles <- grep("(^q\\.m2$)|(^q\\.m2\\.\\d$)",colnames(demetra_m))
    if(length(q_possibles) > 1){
        col_q_possibles <- demetra_m[,q_possibles]
        col_q <- q_possibles[sapply(col_q_possibles,is.character)][1]
    }
    if(length(q_m2_possibles) > 1){
        col_q_m2_possibles <- demetra_m[,q_m2_possibles]
        col_q_m2 <- q_m2_possibles[sapply(col_q_m2_possibles,is.character)]
    }
    if(!all(is.character(demetra_m[,col_q]),is.double(demetra_m[,col_q+1]),
            is.character(demetra_m[,col_q_m2]),is.double(demetra_m[,col_q_m2+1])))
        stop("Erreur dans l'extraction des stats Q et Q-M2")

    stat_Q <- data.frame(demetra_m[,col_q+c(0,1)], demetra_m[,col_q+c(0,1)],
                         stringsAsFactors = FALSE)
    colnames(stat_Q) <- c("q_modality","q_value","q_m2_modality","q_m2_value")

    return(stat_Q)
}
extractFrequency <- function(demetra_m){
    if(any(is.na(match(c("start","end","n"),colnames(demetra_m)))))
        stop("Erreur lors de l'extraction de la fréquence (il manque la date de début, date de fin ou le nombre d'obs)")
    start <- as.Date(demetra_m$start,format="%Y-%m-%d")
    end <- as.Date(demetra_m$end,format="%Y-%m-%d")
    n <- demetra_m$n
    i <- 3

    start <- data.frame(y = as.numeric(format(start,"%Y")), m = as.numeric(format(start,"%m")))
    end <- data.frame(y = as.numeric(format(end,"%Y")), m = as.numeric(format(end,"%m")))
    freq <- c(12,6,4,3,2)
    nobs_compute <- matrix(sapply(freq,function(x){
        x * (end[,1] - start[,1]) + (end[,2] - start[,2])/(12/x)
    }),nrow = nrow(demetra_m))
    return(sapply(1:nrow(nobs_compute), function(i){
        freq[which((nobs_compute[i,] == n[i]) | (nobs_compute[i,] + 1 == n[i]) | (nobs_compute[i,] - 1 == n[i]))[1]]
    }))
}
