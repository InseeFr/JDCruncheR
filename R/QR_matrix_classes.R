#' Quality report objects
#'
#' \code{QR_matrix} creates a \code{QR_matrix} object containing a quality report.
#'
#' \code{mQR_matrix} creates a \code{mQR_matrix} object containing a list of quality reports (ie. a list of \code{QR_matrix} objects).
#'
#' \code{is.QR_matrix} and \code{is.mQR_matrix} are functions to test whether an object is a quality report or a list of quality reports.
#'
#'
#' @param modalities a \code{data.frame} containing the output variables' modalities (Good, Bad, etc.)
#' @param values a \code{data.frame} containing the output variables' values (test p-values, test statistics, etc.) Therefore, the values data frame can contain more variables
#' than the data frame \code{modalities}.
#' @param score_formula the formula used to calculate the series score (if defined).
#' @param x a \code{QR_matrix} object, a \code{mQR_matrix} object or a list of \code{QR_matrix} objects.
#' @param ... objects of the same type as \code{x}.
#' @details A\code{\link{QR_matrix}} object is a list of three items:
#' * \code{modalities}, a \code{data.frame} containing a set of categorical variables (by default: Good, Uncertain, Bad, Severe).
#' * \code{values}, a \code{data.frame} containing the values corresponding to the \code{modalities} indicators (i.e. p-values, statistics, etc.),
#' as well as variables for which a modality cannot be defined (e.g. the series frequency, the ARIMA model, etc).
#' * \code{score_formula} contains the formula used to calculate the series score (once the calculus is done).
#'
#' @encoding UTF-8
#' @name QR_matrix
#' @rdname QR_matrix
#' @export
QR_matrix <- function(modalities = NULL, values = NULL, score_formula = NULL){
    QR <- list(modalities = modalities, values = values,
               score_formula = score_formula)
    class(QR) <- c("QR_matrix")
    QR
}
#' @export
#' @rdname QR_matrix
mQR_matrix <- function(x = list(), ...){
    UseMethod("mQR_matrix", x)
}
#' @rdname QR_matrix
#' @export
is.QR_matrix <- function(x){
    inherits(x, "QR_matrix")
}
#' @export
mQR_matrix.QR_matrix <- function(x = QR_matrix(), ...){
    mQR <- c(list(x), list(...))
    class(mQR) <- "mQR_matrix"
    return(mQR)
}
#' @export
mQR_matrix.default <- function(x = list(), ...){
    mQR <- c(x, list(...))
    class(mQR) <- "mQR_matrix"
    return(mQR)
}
#' @export
mQR_matrix.mQR_matrix <- function(x = mQR_matrix.default(), ...){
    mQR <- c(x, ...)
    class(mQR) <- "mQR_matrix"
    return(mQR)
}
#' @rdname QR_matrix
#' @export
is.mQR_matrix <- function(x){
    inherits(x, "mQR_matrix")
}


#' Printing QR_matrix and mQR_matrix objects
#'
#' To print information on a QR_matrix or mQR_matrix object.
#'
#' @param x a \code{mQR_matrix} or \code{mQR_matrix} object.
#' @param print_variables logical indicating whether to print the indicators' name (including additionnal variables).
#' @param print_score_formula logical indicating whether to print the formula with which the score was calculated (when calculated).
#' @param score_statistics logical indicating whether to print the statistics in the \code{mQR_matrix} scores (when calculated).
#' @param ... other unused arguments.
#' @encoding UTF-8
#' @name print.QR_matrix
#' @rdname print.QR_matrix
#' @export
print.QR_matrix <- function(x, print_variables = TRUE, print_score_formula = TRUE, ...){
    nb_var <- nrow(x$modalities)
    nb_var_modalities <- ncol(x$modalities)
    nb_var_values <- ncol(x$values)

    if(is.null(nb_var) | is.null(nb_var_modalities) | is.null(nb_var_values) ||
       nb_var * nb_var_modalities * nb_var_values == 0){
        cat("The quality report matrix is empty")
        return(invisible(x))
    }
    cat(sprintf(ngettext(nb_var, "The quality report matrix has %d observations",
                         "The quality report matrix has %d observations"),
                nb_var))
    cat("\n")
    cat(sprintf(ngettext(nb_var_modalities, "There are %d indicators in the modalities matrix",
                         "There are %d indicators in the modalities matrix"),
                nb_var_modalities))
    cat(sprintf(ngettext(nb_var_values, " and %d indicators in the values matrix",
                         " and %d indicators in the values matrix"),
                nb_var_values))
    cat("\n")
    if(print_variables){
        cat("\n")
        names_var_modalities <- colnames(x$modalities)
        names_var_values <- colnames(x$values)
        names_var_values_sup <- names_var_values[!names_var_values %in% names_var_modalities]
        names_var_modalities <- paste(names_var_values, collapse = "  ")
        names_var_values_sup <- paste(names_var_values_sup, collapse = "  ")


        cat(sprintf("The quality report matrix contains the following variables:\n%s\n",
                    names_var_modalities)
        )
        cat("\n")
        if(all(names_var_values_sup=="")){
            cat("There's no additionnal variable in the values matrix")
        }else{
            cat(sprintf("The variables exclusively found in the values matrix are:\n%s",
                        names_var_values_sup))
        }
        cat("\n")
        if(length(names_var_values_sup) >1){


            cat(sprintf(ngettext(length(names_var_values_sup),
                                 "There's no additionnal variable in the values matrix",
                                 "The variables exclusively found in the values matrix are:\n%s"),
                        names_var_values_sup))

        }

        cat("\n")
    }


    score_value <- extract_score(x, format_output = "vector")
    if(is.null(score_value)){
        cat("No score was calculated")
    }else{
        cat(sprintf("The smallest score is %1g and the greatest is %2g\n",
                    min(score_value, na.rm = TRUE),max(score_value, na.rm = TRUE)))
        cat(sprintf("The average score is %1g and its standard deviation is %2g",
                    mean(score_value, na.rm = TRUE),sd(score_value, na.rm = TRUE)))
    }
    if(print_score_formula && !is.null(x$score_formula)){
        cat("\n\n")
        cat(sprintf("The following formula was used to calculate the score:\n%s",
                    as.character(x$score_formula)))
    }
    return(invisible(x))
}
#' @rdname print.QR_matrix
#' @export
print.mQR_matrix <- function(x, score_statistics = TRUE, ...){
    if(length(x) == 0){
        cat("List without a quality report")
        return(invisible(x))
    }
    cat(sprintf(ngettext(length(x), "The object contains %d quality report(s)",
                         "The object contains %d quality report(s)"),
                length(x)))
    cat("\n")
    bq_names <- names(x)
    bq_names[is.na(bq_names)] <- ""
    if(is.null(bq_names) || all(is.na(bq_names))){
        cat("No quality report is named")
    }else{
        bq_names_na <- sum(is.na(bq_names))
        bq_valid_names <- bq_names[!is.na(bq_names)]
        cat(sprintf(ngettext(length(bq_valid_names),
                             "%d quality report is named: %s",
                             "%d quality reports are named: %s"),
                    length(bq_valid_names),paste(bq_valid_names, collapse ="  ")))

        if(length(bq_names_na) > 1){
            cat("\n")
            cat(sprintf(ngettext(bq_names_na,
                                 "%d quality report isn't named",
                                 "%d quality reports aren't named"),
                        bq_names_na))
        }
    }
    if(score_statistics){
        cat("\n")
        score_values <- extract_score(x, format_output = "vector")
        all_score <- do.call(c,score_values)
        if(is.null(all_score)){
            cat("No quality report has a calculated score")
        }else{
            cat(sprintf("The average score over all quality reports is %g\n",
                        mean(all_score, na.rm=TRUE)))
            cat(sprintf("The smallest score is %1g and the greatest is %2g\n",
                        min(all_score, na.rm = TRUE),max(all_score, na.rm = TRUE)))

            for(i in 1 : length(score_values)){
                cat("\n\n")
                score_value <- score_values[[i]]

                bq_name <- bq_names[i]
                if(is.null(bq_name) || is.na(bq_name)){
                    bq_name <- ""
                }else{
                    bq_name <- paste0(" (",bq_name,")")
                }

                if(is.null(score_value)){
                    cat(sprintf("There is no calculated score for the quality report n°%d%s",i,bq_name))
                }else{
                    cat(sprintf("The quality report n°%d%s has an average score of %g\n",i,bq_name,
                                mean(score_value, na.rm=TRUE)))
                    cat(sprintf("The smallest score is %1g and the greatest is %2g\n",
                                min(score_value, na.rm = TRUE),max(score_value, na.rm = TRUE)))
                }
            }
        }
    }


    return(invisible(x))
}
