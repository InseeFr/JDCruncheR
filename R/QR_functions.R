#' Calcul d'un score global
#'
#' Permet de calculer un score global à partir d'un bilan qualité
#'
#' @param x objet de type \code{QR_matrix} ou \code{mQR_matrix}.
#' @param score_pond formule utilisée pour calculer le score global
#' @param modalities modalités triées par leur ordre d'importance dans le calcul du score (voir détails).
#' @param normalize_score_value chiffre indiquant la valeur de référence pour la normalisation des pondérations utilisées lors du
#' calcul du score. Si le paramètre n'est pas renseigné alors les poids ne seront pas normalisés.
#' @param na.rm booléen indiquant si les valeurs manquantes doivent être enlevées pour le calcul du score.
#' @param n_contrib_score entier indiquant le nombre de variables à créer dans la matrice des valeurs du
#' bilan qualité contenant les \code{n_contrib_score} plus grandes contributrices au score (voir détails).
#' si non spécifié alors aucune variable n'est créée.
#' @param ... autres paramètres non utilisés.
#' @details La fonction \code{compute_score} permet de calculer un score à partir des modalités
#' d'un bilan qualité. Pour cela chaque modalité est associée à un poids défini par le paramètre
#' \code{modalities}. Ainsi, le paramètre par défaut étant \code{c("Good", "Uncertain", "Bad","Severe")},
#' la valeur \code{"Good"} sera associée à la note 0, la valeur \code{"Uncertain"} sera associée
#' à la note 1, la valeur \code{"Bad"} sera associée à la note 2 et la valeur \code{"Bad"} sera associée à la note 3.
#'
#' Le calcul du score se fait grâce au paramètre \code{score_pond} qui est un vecteur de numeriques
#' nommé contenant des poids et dont les noms correspondent aux variables de la matrice des modalités
#' à utiliser dans le score. Ainsi, avec le paramètre \code{score_pond =
#' c(qs_residual_sa_on_sa = 10, f_residual_td_on_sa = 5)} le score sera calculé à partir des deux
#' variables qs_residual_sa_on_sa et f_residual_td_on_sa. Les notes associées aux modalités de
#' la variable qs_residual_sa_on_sa seront multipliées par 10 et celles associées à la variable
#' f_residual_td_on_sa seront multipliées par 5. Dans le calcul du score, certaines variables
#' peuvent être manquantes, pour ne pas prendre en compte ces valeurs dans le calcul il suffit
#' d'utiliser le paramètre \code{na.rm = TRUE}.
#'
#' Le paramètre \code{normalize_score_value} permet de normaliser les scores. Par exemple,
#' si l'on souhaite avoir des notes entre 0 et 20 il suffit d'utiliser le paramètre
#' \code{normalize_score_value = 20}.
#'
#' Le paramètre \code{n_contrib_score} permet d'ajouter des nouvelles variables à la matrice des valeurs
#' du bilan qualité dont les valeurs correspondent aux noms des variables qui contribuent le plus au score
#' de la série. \code{n_contrib_score} est un entier qui est égal au nombre de variables contributrices
#' que l'on souhaite exporter. Par exemple, pour \code{n_contrib_score = 3}, trois colonnes seront crées
#' contenant les trois plus grandes contributrices au score. Les noms des nouvelles variables sont
#' *i*_highest_score, *i* correspondant au rang en terme de contribution au score (1_highest_score
#' contiendra les noms des plus grandes contributrices, 2_highest_score
#' des deuxièmes plus grandes contributrices, etc.).
#' Seules les variables qui ont une contribution non nulle au score sont
#' prises en compte. Ainsi, si une série a un score nul alors toutes les colonnes *i*_highest_score
#' associées à cette série seront vides ; si une série a un score positif uniquement du fait
#' de la variable "m7" alors la valeur correspondante de le variable 1_highest_score sera égale à
#' "m7" et celle des autres variables *i*_highest_score seront vides.
#' @encoding UTF-8
#' @return Un objet de type \code{\link{QR_matrix}} ou \code{\link{mQR_matrix}}.
#' @examples \dontrun{
#' QR <- extract_QR()
#' QR <- compute_score(QR,n_contrib_score = 2)
#' QR
#' QR$modalities$score
#' }
#' @family QR_matrix functions
#' @name compute_score
#' @rdname compute_score
#' @export
compute_score.QR_matrix <- function(x,
                                    score_pond = c(qs_residual_sa_on_sa = 6.66,
                                                   f_residual_sa_on_sa = 6.68,
                                                   combined_residual_sa_on_sa = 6.66,
                                                   combined_residual_sa_on_sa_last_years = 15,
                                                   combined_residual_sa_on_i = 3.33,
                                                   qs_residual_sa_on_i = 3.33,
                                                   f_residual_sa_on_i = 3.34,
                                                   f_residual_td_on_sa = 10,
                                                   f_residual_td_on_i = 10,
                                                   residuals_mean = 10,
                                                   residuals_independency = 10,
                                                   residuals_homoskedasticity = 5,
                                                   residual_normality = 5,
                                                   m7 = 3,  q_m2 = 2),
                                    modalities = c("Good", "Uncertain", "", "Bad","Severe"),
                                    normalize_score_value,
                                    na.rm = FALSE,
                                    n_contrib_score,
                                    ...){
    # score_formula_exp <- as.expression(substitute(score_formula))

    QR_modalities <- x$modalities
    QR_modalities[,] <- lapply(QR_modalities, function(x){
        as.numeric(factor(x, levels = modalities, ordered = TRUE)) - 1
    })
    #On rajoute une ligne qui a la note maximale pour normalizer
    QR_modalities <- rbind(QR_modalities,
                           length(modalities) - 1)
    if(!all(names(score_pond) %in% colnames(QR_modalities)))
        stop("Il manque des variables : vérifiez le paramètre score_pond")
    QR_modalities <- QR_modalities[, names(score_pond)]
    for(nom_var in names(score_pond)){
        QR_modalities[, nom_var] <- QR_modalities[, nom_var] * score_pond[nom_var]
    }
    score <- base::rowSums(QR_modalities,
                           na.rm = na.rm)

    total_pond_id <- length(score)
    if(!missing(normalize_score_value)){
        if(!is.numeric(normalize_score_value))
            stop("La valeur de référence du score doit être un chiffre !")
        score <- score / score[total_pond_id] * normalize_score_value
    }
    score <- score[- total_pond_id]


    x$modalities[,grep("(_highest_contrib_score$)|(score)",
                       colnames(x$modalities))] <- NULL
    x$values[,grep("(_highest_contrib_score$)|(score)",
                       colnames(x$values))] <- NULL


    x$modalities$score <- score
    x$values$score <- score
    x$score_formula <- paste(score_pond, "*",
                             names(score_pond),
                             collapse = " + ")
    if(!missing(n_contrib_score) &&
       is.numeric(n_contrib_score) &&
       n_contrib_score >= 1){
        QR_modalities <- QR_modalities[- total_pond_id, ]
        n_contrib_score <- round(min(n_contrib_score, length(score_pond)))

        contrib <- t(sapply(1:nrow(QR_modalities),function(i){
            ligne_i <- QR_modalities[i,]
            res <- colnames(QR_modalities)[order(ligne_i,
                                                 decreasing = TRUE,
                                                 na.last = TRUE)]
            ligne_i <- ligne_i[,res]
            lignes_a_modif <- which(is.na(ligne_i) | ligne_i == 0)
            res[lignes_a_modif] <- ""
            res
        }))

        colnames(contrib) <- paste0(1:length(score_pond),
                                    "_highest_contrib_score")
        ncol_before_contrib <- ncol(x$values)
        x$values <- cbind(x$values,contrib[,1:n_contrib_score])
        colnames(x$values)[1:n_contrib_score + ncol_before_contrib] <-
            paste0(1:n_contrib_score,
                   "_highest_contrib_score")
    }


    return(x)
}
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
#' Permet de pondérer un score déjà calculé en fonction des variables.
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
#' @return L'objet en entrée avec le score recalculé
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
        x$modalities$score_pond <- x$modalities$score * pond
    }
    if(!is.na(match("score", colnames(x$values)))){
        x$values$score_pond <- x$values$score * pond
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
#' @param ... autres paramètres de la fonction \code{\link[base]{order}} (non utilisés pour l'instant).
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
#' @param format_output chaîne de caractères indiquant le format de l'objet en sortie :
#' soit un \code{data.frame} soit un \code{vector}.
#' @details Pour les objets \code{QR_matrix}, le score renvoyé est soit l'objet \code{NULL} si aucun score n'a été calculé ou un vecteur.
#' Pour les objets \code{mQR_matrix} il s'agit d'une liste de scores (\code{NULL} ou un vecteur).
#' @examples \dontrun{
#' QR <- extract_QR()
#' mQR <- mQR_matrix(QR, compute_score(QR))
#' extract_score(QR) # NULL
#' extract_score(mQR) # liste dont le premier élément est NULL
#' }
#' @family QR_matrix functions
#' @export
extract_score <- function(x, format_output = c("data.frame", "vector")){
    UseMethod("extract_score", x)
}

#' @export
extract_score.default <- function(x, format_output){
    stop("Il faut un objet de type QR_matrix ou mQR_matrix")
}
#' @export
extract_score.QR_matrix <- function(x, format_output = c("data.frame", "vector")){
    score <- x$modalities$score
    if(is.null(score))
        return(NULL)

    format_output <- match.arg(format_output)
    res <- switch (format_output,
        data.frame = x$modalities[,c("series", "score")],
        vector = {
            names(score) <- x$modalities$series
            score
        }
    )
    return(res)
}
#' @export
extract_score.mQR_matrix <- function(x, format_output = c("data.frame", "vector")){
    return(lapply(x,extract_score, format_output = format_output))
}
#' @export
score <- function(x){
    .Deprecated("extract_score")
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
#' (fonction \code{retain_indicators}) d'objets \code{QR_matrix} ou \code{mQR_matrix}. Le nom des séries
#' (colonne "series") ne peut être enlevé.
#'
#' @param x objet de type \code{QR_matrix} ou \code{mQR_matrix}.
#' @param ... noms des variables à retirer (ou conserver).
#' @examples \dontrun{
#' QR <- compute_score(extract_QR())
#' retain_indicators(QR,"score","m7") # On ne retient que les variables score et m7
#' retain_indicators(QR,c("score","m7")) #équivalent
#' score(remove_indicator(QR,"score")) # Il n'y a plus de score
#' }
#' @family var QR_matrix manipulation
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
    indicators <- setdiff(indicators, "series")

    modalities_to_remove <- which(colnames(x$modalities) %in% indicators)
    values_to_remove <- which(colnames(x$values) %in% indicators)
    if(length(modalities_to_remove) > 0){
        x$modalities <- x$modalities[, - modalities_to_remove]
    }
    if(length(values_to_remove) > 0){
        x$values <- x$values[, - values_to_remove]
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
    indicators <- c("series", indicators)

    modalities_to_retain <- which(colnames(x$modalities) %in% indicators)
    values_to_retain <- which(colnames(x$values) %in% indicators)
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
#' QR1 <- compute_score(QR1, score_pond = c(m7 = 2, q = 3, qs_residual_sa_on_sa = 5))
#' QR2 <- compute_score(QR1, score_pond = c(m7 = 2, qs_residual_sa_on_sa = 5))
#' rbind(QR1, QR2) # Une erreur est renvoyée
#' rbind(QR1, QR2, check_formula = FALSE)
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
            x$score_formula
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

#' Ajout d'un indicateur dans les objets QR_matrix
#'
#' Permet de rajouter un indicateur dans les objets \code{QR_matrix}. Le nom des séries
#' (colonne "series") ne peut être enlevé.
#'
#' @param x objet de type \code{QR_matrix} ou \code{mQR_matrix}.
#' @param indicator un \code{vector} ou un \code{data.frame} (voir détails).
#' @param variable_name chaîne de caractères contenant les noms des nouvelles variables.
#' @param ... autres paramètres de la fonction \code{\link[base]{merge}}.
#'
#' @details La fonction \code{add_indicator()} permet d'ajouter un indicateur dans la matrice des valeurs du bilan qualité.
#' Il n'est donc pas rajouté dans la matrice des modalités et ne peut être utilisée dans le calcul du score
#' (sauf pour le pondérer). Pour l'utiliser dans le calcul du score, il faudra d'abord la recoder avec la fonction
#' \code{\link{recode_indicator_num}}.
#'
#' L'indicateur à rajouter peut être sous deux formats : \code{vector} ou \code{data.frame}. Dans les deux
#' cas il faut que les valeurs à rajouter puissent être associées aux bonnes séries dans la matrice du bilan qualité :
#'  * dans le cas d'un \code{vector}, les éléments devront être nommés et les noms doivent correspondre ceux présents dans le
#'   bilan qualité (variable "series") ;
#'  * dans le cas d'un \code{data.frame}, il devra contenir une colonne "series" avec les noms des séries
#'  correspondantes.
#'
#' @family var QR_matrix manipulation
#' @export
add_indicator <- function(x, indicator, variable_name, ...){
    UseMethod("add_indicator", x)
}
#' @export
add_indicator.default <- function(x, indicator, variable_name, ...){
    stop("Il faut un objet de type QR_matrix ou mQR_matrix")
}
#' @export
add_indicator.QR_matrix <- function(x, indicator, variable_name, ...){
    if(is.vector(indicator)){
        if(is.null(names(indicator)))
            stop("Le vecteur doit être nommé !")
        indicator <- data.frame(series = names(indicator), val = indicator)
    }
    if(!is.data.frame(indicator))
        stop("L'objet en entrée doit être un vecteur ou un data.frame !")

    if(!"series" %in% colnames(indicator))
        stop('Il manque une colonne "series" au data.frame')
    if(ncol(indicator) < 2)
        stop('Il faut au moins deux colonnes')
    # On met la variable "series" en première position
    indicator <- indicator[,c("series",
                              grep("^series$", colnames(indicator),
                                   invert = TRUE,
                                   value = TRUE))]
    if(missing(variable_name)){
        variable_name <- colnames(indicator)[-1]
    }
    values <- x$values
    n_col <- ncol(values)
    values$initial_sort <- 1:nrow(values)
    values <- merge(values, indicator, by = "series",
                        all.x = TRUE, all.y = FALSE, ...)
    values <- values[order(values$initial_sort,decreasing = FALSE),]

    values$initial_sort <- NULL
    colnames(values)[- seq_len(n_col)] <- variable_name

    x$values <- values

    return(x)
}
#' @export
add_indicator.mQR_matrix <- function(x, indicator, variable_name, ...){
    return(mQR_matrix(lapply(x, add_indicator, variable_name = variable_name, ...)))
}

#' Re-encodage en modalités des variables
#'
#' Permet d'encoder des variables présentes dans la matrice des valeurs en des modalités
#' qui seront présentent dans la matrice des modalités.
#'
#' @param x objet de type \code{QR_matrix} ou \code{mQR_matrix}.
#' @param variable_name vecteur de chaînes de caractères contenant les noms des
#'  variables à recoder.
#' @param breaks voir fonction \code{\link[base]{cut}}.
#' @param labels voir fonction \code{\link[base]{cut}}.
#' @param ... autres paramètres de la fonction \code{\link[base]{cut}}.
#'
#' @family var QR_matrix manipulation
#' @export
recode_indicator_num <- function(x,
                                 variable_name,
                                 breaks = c(0, 0.01, 0.05,  0.1, 1),
                                 labels =  c("Good", "Uncertain", "Bad", "Severe"),
                                 ...){
    UseMethod("recode_indicator_num", x)
}
#' @export
recode_indicator_num.default <- function(x, variable_name, breaks, labels, ...){
    stop("Il faut un objet de type QR_matrix ou mQR_matrix")
}
#' @export
recode_indicator_num.QR_matrix <- function(x,
                                           variable_name,
                                           breaks = c(0, 0.01, 0.05,  0.1, 1),
                                           labels =  c("Good", "Uncertain", "Bad", "Severe"),
                                           ...){
    modalities <- x$modalities
    values <- x$values
    for (var in variable_name){
        if(var %in% colnames(values)){
            modalities[, var] <- cut(values[, var],
                                    breaks = breaks,
                                    labels = labels)
        }else{
            warning("La variable ", var, " n'existe pas.")
        }
    }

    x$modalities <- modalities

    return(x)
}
#' @export
recode_indicator_num.mQR_matrix <- function(x,
                                            variable_name,
                                            breaks = c(0, 0.01, 0.05,  0.1, 1),
                                            labels =  c("Good", "Uncertain", "Bad", "Severe"),
                                            ...){
    return(mQR_matrix(lapply(x,
                             recode_indicator_num,
                             variable_name = variable_name,
                             breaks = breaks,
                             labels = labels,
                             ...)))
}
