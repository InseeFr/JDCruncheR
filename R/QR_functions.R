#' Calcul d'un score global
#'
#' Permet de calculer un score global à partir d'un bilan qualité
#'
#' @param x objet de type \code{QR_matrix} ou \code{mQR_matrix}.
#' @param score_formula formule utilisée pour calculer le score global
#' @param modalities modalités triées par leur ordre d'importance dans le calcul du score. Par défaut
#' \code{modalities = c("Good", "Uncertain", "Bad","Severe")} : la valeur \code{"Good"} sera associée à la note 0,
#' la valeur \code{"Uncertain"} sera associée à la note 1, la valeur \code{"Bad"} sera associée à la note 2, etc.
#' @param normalize_score_value chiffre indiquant la valeur de référence pour la normalisation des pondérations utilisées lors du
#' calcul du score. C'est-à-dire que s'il est renseigné alors la somme des pondérations utilisées sera égal à cette valeur.
#' Si le paramètre n'est pas renseigné alors les poids ne seront pas normalisés.
#' @param ... arguments de la fonction \code{compute_score} associées à la classe \code{QR_matrix}
#' (ou paramètres non utilisées).
#' @encoding UTF-8
#' @return Un objet de type \code{\link{QR_matrix}} ou \code{\link{mQR_matrix}}.
#' @examples \dontrun{
#' QR <- extract_QR()
#' QR <- compute_score(QR)
#' QR
#' QR$modalities$score
#' }
#' @family QR_matrix functions
#' @name compute_score
#' @rdname compute_score
#' @export
compute_score.QR_matrix <- function(x,
                                    score_formula = 6.66 * qs_residual_sa_on_sa + 6.68 * f_residual_sa_on_sa + 6.66 * combined_residual_sa_on_sa +
                                        15 * combined_residual_sa_on_sa_last_years + 3.33 * combined_residual_sa_on_i +
                                        3.33 * qs_residual_sa_on_i + 3.34 * f_residual_sa_on_i +
                                        10 * f_residual_td_on_sa + 10 * f_residual_td_on_i + 10 * residuals_mean +
                                        10 * residuals_independency + 5 * residuals_homoskedasticity + 5 * residual_normality +
                                        3 * m7 + 2 * q_m2,
                                    modalities = c("Good", "Uncertain", "Bad","Severe"),
                                    normalize_score_value,
                                    ...){
    score_formula_exp <- as.expression(substitute(score_formula))

    QR_modalities <- x$modalities
    QR_modalities[,] <- lapply(QR_modalities,function(x){
        as.numeric(factor(x,levels = modalities, ordered = TRUE)) - 1
    })
    QR_modalities <- rbind(QR_modalities,1)
    score <- tryCatch(with(QR_modalities,eval(score_formula_exp)),error=function(x){
        errorMessage <- paste0("Erreur dans l'expression : ",as.character(score_formula_exp),
                               "\nPensez à vérifier les noms des variables")
        stop(errorMessage,call. = FALSE)
    })
    total_pond_id <- length(score)
    if(!missing(normalize_score_value)){
        if(!is.numeric(normalize_score_value))
            stop("La valeur de référence du score doit être un chiffre !")
        score <- score / score[total_pond_id] * normalize_score_value
    }

    score <- score[- total_pond_id]

    x$modalities$score <- score
    x$values$score <- score
    x$score_formula <- score_formula_exp

    return(x)
}
#' @rdname compute_score
#' @export
compute_score.mQR_matrix <- function(x, ...){
    result <- mQR_matrix(lapply(x, compute_score, ...))
    return(result)
}
#' @export
compute_score <- function(x, ...){
    UseMethod("compute_score", x)
}
#' @export
compute_score.default <- function(x,  ...){
    stop("Il faut un objet de type QR_matrix ou mQR_matrix")
}


#' Calcul d'un score pondéré pour chaque observation
#'
#' Permet de pondérer un score déjà calculé en fonction des variables
#'
#' @param x objet de type \code{QR_matrix} ou \code{mQR_matrix}.
#' @param pond pondération à appliquer au score. Il peut s'agir d'un nombre, d'un vecteur de nombres, du nom
#' d'une des variables du bilan qualité ou d'une liste de pondérations pour les objets \code{mQR_matrix}.
#' @examples \dontrun{
#' QR <- extract_QR()
#' QR <- compute_score(QR)
#' weighted_score(QR, 2) # Tous les scores sont multipliés par 2
#' }
#' @family QR_matrix functions
#' @return L'objet en entrée avec le score recalculé.
#' @name weighted_score
#' @rdname weighted_score
#' @export
weighted_score <- function(x, pond = 1){
    UseMethod("weighted_score", x)
}
#' @export
weighted_score.default <- function(x, pond = 1){
    stop("Il faut un objet de type QR_matrix ou mQR_matrix")
}
#' @export
weighted_score.QR_matrix <- function(x, pond = 1){
    if(is.character(pond)){
        if(is.na(match(pond, colnames(x$values))))
            stop("La variable ",pond, " n'existe pas")
        pond <- x$values[,pond]
    }
    if(!is.na(match("score",  colnames(x$modalities)))){
        x$modalities$score <- x$modalities$score * pond
    }
    if(!is.na(match("score", colnames(x$values)))){
        x$values$score <- x$values$score * pond
    }
    return(x)
}
#' @export
weighted_score.mQR_matrix <- function(x, pond = 1){
    if(!is.list(pond)){
        result <- lapply(x, weighted_score, pond = pond)
    }else{
        if(length(pond) < length(x))
            stop("Il y a moins de pondérations que de bilans qualité !")
        result <- lapply(1:length(x),
                         function(i) weighted_score(x[[i]], pond = pond[[i]]))

    }
    names(result) <- names(x)
    result <- mQR_matrix(result)
    return(result)
}

#' Tri des objets QR_matrix et mQR_matrix
#'
#' Permet de trier les bilans qualité en fonction d'une ou plusieurs variables.
#'
#' @param x objet de type \code{QR_matrix} ou \code{mQR_matrix}.
#' @param decreasing booléen indiquant si les bilans qualité doivent être triés par ordre croissant ou décroissant.
#' Par défaut le tri est effectué par ordre croissant.
#' @param sort_variables variables à utiliser pour le tri qui sont présentes dans les tables des modalités.
#' @param ... autres paramètres de la fonction \code{\link[base]{order}}.
#' @return L'objet en entrée avec les tables de bilan qualité triées.
#' @examples \dontrun{
#' QR <- compute_score(extract_QR())
#' sort(QR, sort_variables = "score") #Pour trier par ordre croissant sur le score
#' }
#' @family QR_matrix functions
#' @name sort
#' @rdname sort
#' @export
sort.QR_matrix <- function(x, decreasing = FALSE, sort_variables = "score", ...){
    modalities <- x$modalities
    if(!all(!is.na(match(sort_variables,colnames(modalities)))))
        stop("Il y a une erreur dans les noms des variables")
    modalities <- c(modalities[sort_variables], decreasing = decreasing)
    ordered_matrixBQ <- do.call(order, modalities)
    x$modalities <- x$modalities[ordered_matrixBQ,]
    x$values <- x$values[ordered_matrixBQ,]
    return(x)
}
#' @rdname sort
#' @export
sort.mQR_matrix <- function(x, decreasing = FALSE, sort_variables = "score", ...){
    result <- lapply(x, sort, sort_variables = sort_variables,
                     decreasing = decreasing, ...)
    result <- mQR_matrix(result)
    return(result)
}



#' Extraction du score
#'
#' Permet d'extraire le score des objets \code{QR_matrix} ou \code{mQR_matrix}.
#'
#' @param x objet de type \code{QR_matrix} ou \code{mQR_matrix}.
#' @details Pour les objets \code{QR_matrix}, le score renvoyé est soit l'objet \code{NULL} si aucun score n'a été calculé ou un vecteur.
#' Pour les objets \code{mQR_matrix} il s'agit d'une liste de scores (\code{NULL} ou un vecteur).
#' @examples \dontrun{
#' QR <- extract_QR()
#' mQR <- mQR_matrix(QR, compute_score(QR))
#' score(QR) # NULL
#' score(mQR) # liste dont le premier élément est NULL
#' }
#' @family QR_matrix functions
#' @export
score <- function(x){
    UseMethod("score", x)
}

#' @export
score.default <- function(x){
    stop("Il faut un objet de type QR_matrix ou mQR_matrix")
}
#' @export
score.QR_matrix <- function(x){
    return(x$modalities$score)
}
#' @export
score.mQR_matrix <- function(x){
    return(lapply(x,score))
}


#' Manipulation de la liste des indicateurs
#'
#' Permet de retirer des indicateurs (fonction \code{remove_indicators}) ou de n'en retenir que certains
#' (fonction \code{retain_indicators}) d'objets \code{QR_matrix} ou \code{mQR_matrix}.
#'
#' @param x objet de type \code{QR_matrix} ou \code{mQR_matrix}.
#' @param ... noms des variables à retirer (ou conserver).
#' @examples \dontrun{
#' QR <- compute_score(extract_QR())
#' retain_indicators(QR,"score","m7") # On ne retiend que les variables score et m7
#' retain_indicators(QR,c("score","m7")) #équivalent
#' score(remove_indicator(QR,"score")) # Il n'y a plus de score
#' }
#' @family QR_matrix functions
#' @name QR_var_manipulation
#' @rdname QR_var_manipulation
#' @export
remove_indicators <- function(x, ...){
    UseMethod("remove_indicators", x)
}
#' @export
remove_indicators.default <- function(x, ...){
    stop("Il faut un objet de type QR_matrix ou mQR_matrix")
}
#' @export
remove_indicators.QR_matrix <- function(x, ...){
    indicators <- c(...)
    modalities_to_remove <- which(colnames(x$modalities) %in% indicators)
    values_to_remove <- which(colnames(x$value) %in% indicators)
    if(length(modalities_to_remove) > 0){
        x$modalities <- x$modalities[, - modalities_to_remove]
    }
    if(length(modalities_to_remove) > 0){
        x$values <- x$values[, - modalities_to_remove]
    }
    return(x)
}
#' @export
remove_indicators.mQR_matrix <- function(x, ...){
    return(mQR_matrix(lapply(x, remove_indicators, ...)))
}
#' @rdname QR_var_manipulation
#' @export
retain_indicators <- function(x, ...){
    UseMethod("retain_indicators", x)
}
#' @export
retain_indicators.default <- function(x, ...){
    stop("Il faut un objet de type QR_matrix ou mQR_matrix")
}
#' @export
retain_indicators.QR_matrix <- function(x, ...){
    indicators <- c(...)
    modalities_to_retain <- which(colnames(x$modalities) %in% indicators)
    values_to_retain <- which(colnames(x$value) %in% indicators)
    if(length(modalities_to_retain) > 0){
        x$modalities <- x$modalities[, modalities_to_retain]
    }
    if(length(values_to_retain) > 0){
        x$values <- x$values[, values_to_retain]
    }
    return(x)
}
#' @export
retain_indicators.mQR_matrix <- function(x, ...){
    return(mQR_matrix(lapply(x, retain_indicators, ...)))
}


#' Combiner par ligne des objets QR_matrix
#'
#' Permet de combiner plusieurs objets \code{QR_matrix} en combinant par ligne les paramètres \code{modalities}
#' et \code{values}.
#'
#' @param ... objets \code{QR_matrix} à combiner.
#' @param check_formula booléen indiquant s'il faut vérifier la cohérence dans les formule du calcul du score.
#' Par défaut \code{check_formula = TRUE} : la fonction renvoie une erreur si des scores sont calculés avec des formules différentes.
#' Si \code{check_formula = FALSE} alors il n'y a pas de vérification et le paramètre \code{score_formula} de l'objet
#' en sortie est \code{NULL}.
#' @examples \dontrun{
#' QR <- extract_QR()
#' QR1 <- compute_score(QR1, score_formula = 2 * m7 + 3 * q + 5 * qs_residual_sa_on_sa)
#' QR2 <- compute_score(QR1, score_formula = 2 * m7 + 5 * qs_residual_sa_on_sa)
#' cbind(QR1, QR2) # Une erreur est renvoyée
#' cbind(QR1, QR2, check_formula = FALSE)
#' }
#' @family QR_matrix functions
#' @export
rbind.QR_matrix <- function(..., check_formula = TRUE){
    list_QR_matrix <- list(...)
    if(length(list_QR_matrix) == 0)
        return(QR_matrix())
    if(check_formula){
        list_formula <- sapply(list_QR_matrix,function(x){
            if(! is.QR_matrix(x))
                stop("Tous les objets doivent être de type QR_matrix", call. = FALSE)
            as.character(x$score_formula)
        })
        list_formula_unique <- unique(list_formula)
        if( length(list_formula) != length(list_QR_matrix) | length(list_formula_unique) !=1)
            stop("Les formules de calcul du score doivent être identiques")
        if(is.list(list_formula_unique)){
            score_formula <- NULL
        }else{
            score_formula <- list_QR_matrix[[1]]$formula
        }
    }else{
        score_formula <- NULL
    }

    modalities <- do.call(rbind,
                          lapply(list_QR_matrix, function(x){
                              if(! is.QR_matrix(x))
                                  stop("Tous les objets doivent être de type QR_matrix",call. = FALSE)
                              x$modalities
                          }))
    values <- do.call(rbind,
                      lapply(list_QR_matrix, function(x) x$values))
    QR <- QR_matrix(modalities = modalities, values = values,
                    score_formula = score_formula)
    return(QR)
}
