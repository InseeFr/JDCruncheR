#' Objets bilan qualité
#'
#' \code{QR_matrix()} permet de créer un objet de type \code{\link{QR_matrix}}
#' contenant un bilan qualité.
#'
#' \code{mQR_matrix()} permet de créer un objet de type \code{\link{mQR_matrix}}
#' qui est une liste de bilans qualité (donc d'objets \code{\link{QR_matrix}}).
#'
#' \code{is.QR_matrix()} et \code{is.mQR_matrix()} permettent de tester si un
#' objet est un bilan qualité ou une liste de bilans qualité.
#'
#'
#' @param modalities un \code{data.frame} contenant les modalités (Good, Bad,
#' etc.) associées aux variables.
#' @param values un \code{data.frame} contenant les valeurs (p-valeurs des
#' tests, statistiques, etc.) associées aux variables. Peut donc contenir plus
#' de variables que le data.frame \code{modalities}.
#' @param score_formula formule utilisée pour calculer le score global (s'il
#' existe).
#' @param x un objet de type \code{\link{QR_matrix}}, \code{\link{mQR_matrix}}
#' ou une liste d'objets \code{\link{QR_matrix}}.
#' @param ... des objets du même type que \code{x}.
#' @details Un objet  de type \code{\link{QR_matrix}} est une liste de trois
#' paramètres :
#' * le paramètre \code{modalities} est un \code{data.frame} contenant un
#'   ensemble de variables sous forme catégorielle (par défaut : Good,
#'   Uncertain, Bad, Severe).
#' * le paramètre \code{values}  est un \code{data.frame} contenant les valeurs
#'   associées aux indicateurs présents dans \code{modalities} (i.e. :
#'   p-valeurs, statistiques, etc.), ainsi que des variables qui n'ont pas de
#'   modalité (i.e. : fréquence de la série, modèle ARIMA, etc).
#' * le paramètre \code{score_formula} contient la formule utilisée pour
#'   calculer le score (une fois le calcul réalisé).
#'
#' @returns
#' \code{QR_matrix()} crée et renvoie un objet \code{\link{QR_matrix}}.
#' \code{mQR_matrix()} crée et renvoie un objet \code{\link{mQR_matrix}}
#' (c'est-à-dire une liste d'objets \code{\link{QR_matrix}}).
#' \code{is.QR_matrix()} et \code{is.mQR_matrix()} renvoient des valeurs
#' booléennes (\code{TRUE} ou \code{FALSE}).
#'
#' @encoding UTF-8
#' @keywords internal
#' @name fr-QR_matrix
NULL
#> NULL


#' @title Quality report objects
#'
#' @description
#' \code{mQR_matrix()} and \code{QR_matrix()} are creating one (or several)
#' quality report. The function
#' \code{is.QR_matrix()} and \code{is.mQR_matrix()} are functions to test
#' whether an object is a quality report or a list of quality reports.
#'
#' @param modalities a \code{data.frame} containing the output variables'
#' modalities (Good, Bad, etc.)
#' @param values a \code{data.frame} containing the output variables' values
#' (test p-values, test statistics, etc.) Therefore, the values data frame can
#' contain more variables than the data frame \code{modalities}.
#' @param score_formula the formula used to calculate the series score (if
#' defined).
#' @param x a \code{\link{QR_matrix}} object, a \code{\link{mQR_matrix}} object
#' or a list of \code{\link{QR_matrix}} objects.
#' @param ... objects of the same type as \code{x}.
#'
#' @details A\code{\link{QR_matrix}} object is a list of three items:
#' * \code{modalities}, a \code{data.frame} containing a set of categorical
#'   variables (by default: Good, Uncertain, Bad, Severe).
#' * \code{values}, a \code{data.frame} containing the values corresponding to
#'   the \code{modalities} indicators (i.e. p-values, statistics, etc.), as well
#'   as variables for which a modality cannot be defined (e.g. the series
#'   frequency, the ARIMA model, etc).
#' * \code{score_formula} contains the formula used to calculate the series
#'   score (once the calculus is done).
#'
#' @returns
#' \code{QR_matrix()} creates and returns a \code{\link{QR_matrix}} object.
#' \code{mQR_matrix()} creates and returns a \code{\link{mQR_matrix}} object
#' (ie. a list of \code{\link{QR_matrix}} objects). \code{is.QR_matrix()} and
#' \code{is.mQR_matrix()} return Boolean values (\code{TRUE} or \code{FALSE}).
#'
#' @encoding UTF-8
#' @name QR_matrix
#' @seealso [Traduction française][fr-QR_matrix()]
#' @export
QR_matrix <- function(modalities = NULL, values = NULL, score_formula = NULL) {
    QR <- list(
        modalities = modalities, values = values,
        score_formula = score_formula
    )
    class(QR) <- c("QR_matrix")
    QR
}
#' @export
#' @rdname QR_matrix
mQR_matrix <- function(x = list(), ...) {
    UseMethod("mQR_matrix", x)
}
#' @rdname QR_matrix
#' @export
is.QR_matrix <- function(x) {
    return(inherits(x, "QR_matrix"))
}
#' @export
mQR_matrix.QR_matrix <- function(x = QR_matrix(), ...) {
    mQR <- c(list(x), list(...))
    class(mQR) <- "mQR_matrix"
    return(mQR)
}
#' @export
mQR_matrix.default <- function(x = list(), ...) {
    mQR <- c(x, list(...))
    class(mQR) <- "mQR_matrix"
    return(mQR)
}
#' @export
mQR_matrix.mQR_matrix <- function(x = mQR_matrix.default(), ...) {
    mQR <- c(x, ...)
    class(mQR) <- "mQR_matrix"
    return(mQR)
}
#' @rdname QR_matrix
#' @export
is.mQR_matrix <- function(x) {
    return(inherits(x, "mQR_matrix"))
}



#' Affichage des objets QR_matrix et mQR_matrix
#'
#' Pour afficher un objet QR_matrix ou mQR_matrix.
#'
#' @param x objet de type \code{\link{mQR_matrix}} ou \code{\link{mQR_matrix}}.
#' @param print_variables booléen pour imprimer ou non les noms des indicateurs
#' (supplémentaire inclus).
#' @param print_score_formula booléen pour imprimer ou non la formule qui a
#' servi à calculer le score (le cas échéant).
#' @param score_statistics booléen pour imprimer ou non des statistiques sur les
#' scores de la \code{\link{mQR_matrix}} (le cas échéant).
#' @param ... autres arguments non utilisés.
#' @returns la méthode \code{print} imprime un objet \code{\link{mQR_matrix}} ou
#' \code{\link{mQR_matrix}} et le renvoie de manière invisible (via
#' \code{invisible(x)}).
#' @encoding UTF-8
#' @keywords internal
#' @name fr-print.QR_matrix
NULL
#> NULL


#' @title Printing QR_matrix and mQR_matrix objects
#'
#' @description
#' To print information on a QR_matrix or mQR_matrix object.
#'
#' @param x a \code{\link{mQR_matrix}} or \code{\link{mQR_matrix}} object.
#' @param print_variables logical indicating whether to print the indicators'
#' name (including additionnal variables).
#' @param print_score_formula logical indicating whether to print the formula
#' with which the score was calculated (when calculated).
#' @param score_statistics logical indicating whether to print the statistics
#' in the \code{\link{mQR_matrix}} scores (when calculated).
#' @param ... other unused arguments.
#'
#' @returns the \code{print} method prints a \code{\link{mQR_matrix}} or
#' \code{\link{mQR_matrix}} object and returns it invisibly (via
#' \code{invisible(x)}).
#'
#' @encoding UTF-8
#' @name print.QR_matrix
#' @seealso [Traduction française][fr-print.QR_matrix()]
#' @export
print.QR_matrix <- function(x,
                            print_variables = TRUE,
                            print_score_formula = TRUE,
                            ...) {
    nb_var <- nrow(x$modalities)
    nb_var_modalities <- ncol(x$modalities)
    nb_var_values <- ncol(x$values)

    if (is.null(nb_var)
        || is.null(nb_var_modalities)
        || is.null(nb_var_values)
        || nb_var * nb_var_modalities * nb_var_values == 0) {
        cat("The quality report matrix is empty")
        return(invisible(x))
    }
    cat(sprintf(
        ngettext(
            nb_var, "The quality report matrix has %d observations",
            "The quality report matrix has %d observations"
        ),
        nb_var
    ))
    cat("\n")
    cat(sprintf(
        ngettext(
            nb_var_modalities,
            "There are %d indicators in the modalities matrix",
            "There are %d indicators in the modalities matrix"
        ),
        nb_var_modalities
    ))
    cat(sprintf(
        ngettext(
            nb_var_values, " and %d indicators in the values matrix",
            " and %d indicators in the values matrix"
        ),
        nb_var_values
    ))
    cat("\n")
    if (print_variables) {
        cat("\n")
        names_var_modalities <- colnames(x$modalities)
        names_var_values <- colnames(x$values)
        names_var_values_sup <- names_var_values[!names_var_values %in% names_var_modalities]
        names_var_modalities <- paste(names_var_values, collapse = "  ")
        names_var_values_sup <- paste(names_var_values_sup, collapse = "  ")


        cat(sprintf(
            "The quality report matrix contains the following variables:\n%s\n",
            names_var_modalities
        ))
        cat("\n")
        if (all(names_var_values_sup == "")) {
            cat("There's no additionnal variable in the values matrix")
        } else {
            cat(sprintf(
                "The variables exclusively found in the values matrix are:\n%s",
                names_var_values_sup
            ))
        }
        cat("\n")
        if (length(names_var_values_sup) > 1) {
            cat(sprintf(
                ngettext(
                    length(names_var_values_sup),
                    "There's no additionnal variable in the values matrix",
                    "The variables exclusively found in the values matrix are:\n%s"
                ),
                names_var_values_sup
            ))
        }

        cat("\n")
    }


    score_value <- extract_score(x, format_output = "vector")
    if (is.null(score_value)) {
        cat("No score was calculated")
    } else {
        cat(sprintf(
            "The smallest score is %1g and the greatest is %2g\n",
            min(score_value, na.rm = TRUE), max(score_value, na.rm = TRUE)
        ))
        cat(sprintf(
            "The average score is %1g and its standard deviation is %2g",
            mean(score_value, na.rm = TRUE), sd(score_value, na.rm = TRUE)
        ))
    }
    if (print_score_formula && !is.null(x$score_formula)) {
        cat("\n\n")
        cat(sprintf(
            "The following formula was used to calculate the score:\n%s",
            as.character(x$score_formula)
        ))
    }
    return(invisible(x))
}

#' @rdname print.QR_matrix
#' @export
print.mQR_matrix <- function(x, score_statistics = TRUE, ...) {
    if (length(x) == 0) {
        cat("List without a quality report")
        return(invisible(x))
    }
    cat(sprintf(
        ngettext(
            length(x), "The object contains %d quality report(s)",
            "The object contains %d quality report(s)"
        ),
        length(x)
    ))
    cat("\n")
    bq_names <- names(x)
    bq_names[is.na(bq_names)] <- ""
    if (is.null(bq_names) || all(is.na(bq_names))) {
        cat("No quality report is named")
    } else {
        bq_names_na <- sum(is.na(bq_names))
        bq_valid_names <- bq_names[!is.na(bq_names)]
        cat(sprintf(
            ngettext(
                length(bq_valid_names),
                "%d quality report is named: %s",
                "%d quality reports are named: %s"
            ),
            length(bq_valid_names), paste(bq_valid_names, collapse = "  ")
        ))

        if (length(bq_names_na) > 1) {
            cat("\n")
            cat(sprintf(
                ngettext(
                    bq_names_na,
                    "%d quality report isn't named",
                    "%d quality reports aren't named"
                ),
                bq_names_na
            ))
        }
    }
    if (score_statistics) {
        cat("\n")
        score_values <- extract_score(x, format_output = "vector")
        all_score <- do.call(c, score_values)
        if (is.null(all_score)) {
            cat("No quality report has a calculated score")
        } else {
            cat(sprintf(
                "The average score over all quality reports is %g\n",
                mean(all_score, na.rm = TRUE)
            ))
            cat(sprintf(
                "The smallest score is %1g and the greatest is %2g\n",
                min(all_score, na.rm = TRUE), max(all_score, na.rm = TRUE)
            ))

            for (i in seq_along(score_values)) {
                cat("\n\n")
                score_value <- score_values[[i]]

                bq_name <- bq_names[i]
                if (is.null(bq_name) || is.na(bq_name)) {
                    bq_name <- ""
                } else {
                    bq_name <- paste0(" (", bq_name, ")")
                }

                if (is.null(score_value)) {
                    cat(sprintf("There is no calculated score for the quality report n.%d%s", i, bq_name))
                } else {
                    cat(sprintf(
                        "The quality report n.%d%s has an average score of %g\n", i, bq_name,
                        mean(score_value, na.rm = TRUE)
                    ))
                    cat(sprintf(
                        "The smallest score is %1g and the greatest is %2g\n",
                        min(score_value, na.rm = TRUE), max(score_value, na.rm = TRUE)
                    ))
                }
            }
        }
    }


    return(invisible(x))
}
