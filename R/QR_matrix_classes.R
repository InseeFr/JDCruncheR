#' Objets bilan qualité
#'
#' \code{QR_matrix} permet de créer un objet de type \code{QR_matrix} contenant un bilan qualité.
#'
#' \code{mQR_matrix} permet de créer un objet de type \code{mQR_matrix} qui est une liste de bilans qualité (donc d'objets \code{QR_matrix}).
#'
#' \code{is.QR_matrix} et \code{is.mQR_matrix} permettent de tester si un objet est un bilan qualité ou une liste de bilans qualité.
#'
#'
#' @param modalities un \code{data.frame} contenant les modalités (Good, Bad, etc.)
#' associées aux variables.
#' @param values un \code{data.frame} contenant les valeurs (p-valeurs des tests, statistiques, etc.)
#' associées aux variables. Peut donc contenir plus de variables que le paramètre \code{modalities}.
#' @param score_formula formule utilisée pour calculer le score global (s'il existe).
#' @param x un objet de type \code{QR_matrix}, \code{mQR_matrix} ou une liste d'objets \code{QR_matrix}.
#' @param ... des objets du même type que \code{x}.
#' @details Un objet  de type \code{\link{QR_matrix}} est une liste de trois paramètres :
#' * le paramètre \code{modalities} est un \code{data.frame} contenant un ensemble de variables sous forme catégorielle
#'   (par défaut : Good, Uncertain, Bad, Severe).
#' * le paramètre \code{values}  est un \code{data.frame} contenant les valeurs associées aux indicateurs présents dans
#'   \code{modalities} (i.e. : p-valeurs, statistiques, etc.) ainsi que des variables qui n'ont pas
#'   de modalité (e.g. : fréquence de la série, modèle ARIMA, etc.).
#' * le paramètre \code{score_formula} contient la formule utilisée pour calculer le score (une fois le calcul réalisé).
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


#' Printing QR_matrix and mQR_matrix
#'
#' Print a QR_matrix or a mQR_matrix.
#'
#' @param x object of class code{mQR_matrix} or \code{mQR_matrix}.
#' @param print_variables logical, indicating whether or not the variables names should be printed.
#' @param print_score_formula logical, indicating whether or not the score formula should be printed.
#' @param score_statistics logical, indicating whether or not the scores statistics should be printed.
#' @param ... autres arguments non utilisés.
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
        cat("Matrice de bilan qualité vide")
        return(invisible(x))
    }
    cat(sprintf(ngettext(nb_var, "Matrice du bilan qualité avec %d observation",
                         "Matrice du bilan qualité avec %d observations"),
                nb_var))
    cat("\n")
    cat(sprintf(ngettext(nb_var_modalities, "Il y a %d indicateur dans la matrice des modalités",
                         "Il y a %d indicateurs dans la matrice des modalités"),
                nb_var_modalities))
    cat(sprintf(ngettext(nb_var_values, " et %d indicateur dans la matrice des valeurs",
                         " et %d indicateurs dans la matrice des valeurs"),
                nb_var_values))
    cat("\n")
    if(print_variables){
        cat("\n")
        names_var_modalities <- colnames(x$modalities)
        names_var_values <- colnames(x$values)
        names_var_values_sup <- names_var_values[!names_var_values %in% names_var_modalities]
        names_var_modalities <- paste(names_var_values, collapse = "  ")
        names_var_values_sup <- paste(names_var_values_sup, collapse = "  ")


        cat(sprintf("La liste des indicateurs présents dans la matrice du bilan qualité est :\n%s\n",
                    names_var_modalities)
        )
        cat("\n")
        if(all(names_var_values_sup=="")){
            cat("Aucune variable supplémentaire dans la matrice des valeur")
        }else{
            cat(sprintf("La liste des indicateurs présents uniquement dans la matrice des valeurs est :\n%s",
                        names_var_values_sup))
        }
        cat("\n")
        if(length(names_var_values_sup) >1){


            cat(sprintf(ngettext(length(names_var_values_sup),
                                 "Aucune variable supplémentaire dans la matrice des valeurs",
                                 "La liste des indicateurs présents uniquement dans la matrice des valeurs est :\n%s"),
                        names_var_values_sup))

        }

        cat("\n")
    }


    score_value <- extract_score(x, format_output = "vector")
    if(is.null(score_value)){
        cat("Il n'y a aucun score de calculé")
    }else{
        cat(sprintf("Le plus petit score est de %1g et le plus grand est de %2g\n",
                    min(score_value, na.rm = TRUE),max(score_value, na.rm = TRUE)))
        cat(sprintf("La moyenne des scores est de %1g et l'écart-type est de %2g",
                    mean(score_value, na.rm = TRUE),sd(score_value, na.rm = TRUE)))
    }
    if(print_score_formula && !is.null(x$score_formula)){
        cat("\n\n")
        cat(sprintf("La formule utilisée pour le calcul du score est :\n%s",
                    as.character(x$score_formula)))
    }
    return(invisible(x))
}
#' @rdname print.QR_matrix
#' @export
print.mQR_matrix <- function(x, score_statistics = TRUE, ...){
    if(length(x) == 0){
        cat("Liste sans aucun bilan qualité")
        return(invisible(x))
    }
    cat(sprintf(ngettext(length(x), "L'objet contient %d bilan qualité",
                         "L'objet contient %d bilans qualité"),
                length(x)))
    cat("\n")
    bq_names <- names(x)
    bq_names[is.na(bq_names)] <- ""
    if(is.null(bq_names) || all(is.na(bq_names))){
        cat("Aucun bilan qualité n'a de nom")
    }else{
        bq_names_na <- sum(is.na(bq_names))
        bq_valid_names <- bq_names[!is.na(bq_names)]
        cat(sprintf(ngettext(length(bq_valid_names),
                             "%d bilan qualité a un nom : %s",
                             "%d bilans qualité ont un nom : %s"),
                    length(bq_valid_names),paste(bq_valid_names, collapse ="  ")))

        if(length(bq_names_na) > 1){
            cat("\n")
            cat(sprintf(ngettext(bq_names_na,
                                 "%d bilan qualité n'a pas de nom",
                                 "%d bilans qualité n'ont pas de nom"),
                        bq_names_na))
        }
    }
    if(score_statistics){
        cat("\n")
        score_values <- extract_score(x, format_output = "vector")
        all_score <- do.call(c,score_values)
        if(is.null(all_score)){
            cat("Aucun bilan qualité n'a de score de calculé")
        }else{
            cat(sprintf("Le moyenne des scores sur l'ensemble des bilans qualité est %g\n",
                        mean(all_score, na.rm=TRUE)))
            cat(sprintf("Le plus petit score est de %1g et le plus grand est de %2g\n",
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
                    cat(sprintf("Le bilan qualité n°%d%s n'a pas de score",i,bq_name))
                }else{
                    cat(sprintf("Le score moyen du bilan qualité n°%d%s est %g\n",i,bq_name,
                                mean(score_value, na.rm=TRUE)))
                    cat(sprintf("Le plus petit score est de %1g et le plus grand est de %2g\n",
                                min(score_value, na.rm = TRUE),max(score_value, na.rm = TRUE)))
                }
            }
        }
    }


    return(invisible(x))
}
