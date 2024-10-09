#' Calcul d'un score global
#'
#' Permet de calculer un score global à partir d'un bilan qualité
#'
#' @param x objet de type \code{\link{QR_matrix}} ou \code{\link{mQR_matrix}}.
#' @param score_pond formule utilisée pour calculer le score global.
#' @param modalities modalités triées par ordre d'importance dans le calcul du
#' score (voir détails).
#' @param normalize_score_value chiffre indiquant la valeur de référence pour la
#' normalisation des pondérations utilisées lors du calcul du score. Si le
#' paramètre n'est pas renseigné, les poids ne seront pas normalisés.
#' @param na.rm booléen indiquant si les valeurs manquantes doivent être
#' enlevées pour le calcul du score.
#' @param n_contrib_score entier indiquant le nombre de variables à créer dans
#' la matrice des valeurs du bilan qualité contenant les \code{n_contrib_score}
#' plus grandes contributrices au score (voir détails). S'il n'est pas spécifié,
#' aucune variable n'est créée.
#' @param conditional_indicator une \code{list} contenant des listes ayant 3
#' éléments : "indicator", "conditions" et "condition_modalities". Permet de
#' réduire à 1 le poids de certains indicateurs en fonction des valeurs d'autres
#' variables (voir détails).
#'
#' @param ... autres paramètres non utilisés.
#' @details La fonction \code{compute_score} permet de calculer un score à
#' partir des modalités d'un bilan qualité. Pour cela, chaque modalité est
#' associée à un poids défini par le paramètre \code{modalities}. Ainsi, le
#' paramètre par défaut étant \code{c("Good", "Uncertain", "Bad","Severe")},
#' la valeur \code{"Good"} sera associée à la note 0, la valeur
#' \code{"Uncertain"} sera associée à la note 1, la valeur \code{"Bad"} sera
#' associée à la note 2 et la valeur \code{"Bad"} sera associée à la note 3.
#' Le calcul du score se fait grâce au paramètre \code{score_pond}, qui est un
#' vecteur numérique nommé contenant des poids et dont les noms correspondent
#' aux variables de la matrice des modalités à utiliser dans le score. Ainsi,
#' avec le paramètre
#' \code{score_pond = c(qs_residual_sa_on_sa = 10, f_residual_td_on_sa = 5)}
#' le score sera calculé à partir des deux variables \code{qs_residual_sa_on_sa}
#' et \code{f_residual_td_on_sa}. Les notes associées aux modalités de la
#' variable \code{qs_residual_sa_on_sa} seront multipliées par 10 et celles
#' associées à la variable \code{f_residual_td_on_sa} seront multipliées par 5.
#' Dans le calcul du score, certaines variables peuvent être manquantes: pour ne
#' pas prendre en compte ces valeurs dans le calcul, il suffit d'utiliser le
#' paramètre \code{na.rm = TRUE}. Le paramètre \code{normalize_score_value}
#' permet de normaliser les scores.
#' Par exemple, si l'on souhaite avoir des notes entre 0 et 20, il suffit
#' d'utiliser le paramètre \code{normalize_score_value = 20}. Le paramètre
#' \code{n_contrib_score} permet d'ajouter de nouvelles variables à la matrice
#' des valeurs du bilan qualité dont les valeurs correspondent aux noms des
#' variables qui contribuent le plus au score de la série.
#' \code{n_contrib_score} est un entier égal au nombre de variables
#' contributrices que l'on souhaite exporter. Par exemple, pour
#' \code{n_contrib_score = 3}, trois colonnes seront créées et elles
#' contiendront les trois plus grandes contributrices au score. Les noms des
#' nouvelles variables sont *i*_highest_score, *i* correspondant au rang en
#' terme de contribution au score (1_highest_score contiendra les noms des plus
#' grandes contributrices, 2_highest_score des deuxièmes plus grandes
#' contributrices, etc). Seules les variables qui ont une contribution non nulle
#' au score sont prises en compte. Ainsi, si une série a un score nul, toutes
#' les colonnes *i*_highest_score associées à cette série seront vides. Et si
#' une série a un score positif uniquement du fait de la variable "m7", alors la
#' valeur correspondante à la variable 1_highest_score sera égale à "m7" et
#' celle des autres variables *i*_highest_score seront vides. Certains
#' indicateurs peuvent n'avoir de sens que sous certaines conditions.
#' Par exemple, le test d'homoscédasticité n'est valide que si les résidus sont
#' indépendants et les tests de normalité, que si les résidus sont indépendants
#' et homoscédastiques. Le paramètre \code{conditional_indicator} permet de
#' prendre cela en compte en réduisant, sous certaines conditions, à 1 le poids
#' de certains variables. C'est une \code{list} contenant des listes ayant 3
#' éléments :
#' - "indicator" : nom de la variable pour laquelle on veut ajouter des
#'   conditions
#' - "conditions" : nom des variables que l'on utilise pour conditionner
#' - "conditions_modalities" : modalités qui doivent être vérifiées pour
#'   modifier le poids Ainsi, avec le paramètre
#'   \code{conditional_indicator = list(list(indicator = "residuals_skewness",
#'   conditions = c("residuals_independency", "residuals_homoskedasticity"),
#'   conditions_modalities = c("Bad","Severe")))}, on réduit à 1 le poids de la
#'   variable "residuals_skewness" lorsque les modalités du test d'indépendance
#'   ("residuals_independency") ou du test d'homoscédasticité
#'   ("residuals_homoskedasticity") valent "Bad" ou "Severe".
#'
#' @encoding UTF-8
#' @return Un objet de type \code{\link{QR_matrix}} ou \code{\link{mQR_matrix}}.
#' @examples
#' # Chemin menant au fichier demetra_m.csv
#' demetra_path <- file.path(
#'     system.file("extdata", package = "JDCruncheR"),
#'     "WS/ws_ipi/Output/SAProcessing-1",
#'     "demetra_m.csv"
#' )
#'
#' # Extraire le bilan qualité à partir du fichier demetra_m.csv
#' QR <- extract_QR(demetra_path)
#'
#' # Compute the score
#' QR <- compute_score(QR, n_contrib_score = 2)
#' print(QR)
#'
#' # Extraire les modalités de la matrice
#' QR$modalities$score
#'
#' @keywords internal
#' @name fr-compute_score
NULL
#> NULL


#' Score calculation
#'
#' To calculate a score for each series from a quality report
#'
#' @param x a \code{\link{QR_matrix}} or \code{\link{mQR_matrix}} object.
#' @param score_pond the formula used to calculate the series score.
#' @param modalities modalities ordered by importance in the score calculation
#' (cf. details).
#' @param normalize_score_value integer indicating the reference value for
#' weights normalisation. If missing, weights will not be normalised.
#' @param na.rm logical indicating whether missing values must be ignored when
#' calculating the score.
#' @param n_contrib_score integer indicating the number of variables to create
#' in the quality report's values matrix to store the \code{n_contrib_score}
#' greatest contributions to the score (cf. details). If not specified, no
#' variable is created.
#' @param conditional_indicator a \code{list} containing 3-elements sub-lists:
#' "indicator", "conditions" and "condition_modalities". To reduce down to 1 the
#' weight of chosen indicators depending on other variables' values (cf.
#' details).
#'
#' @param ... other unused parameters.
#' @details The function \code{compute_score} calculates a score from the
#' modalities of a quality report: to each modality corresponds a weight that
#' depends on the parameter \code{modalities}. The default parameter is
#' \code{c("Good", "Uncertain", "Bad","Severe")}, and the associated weights are
#' respectively 0, 1, 2 and 3.
#'
#' The score calculation is based on the \code{score_pond} parameter, which is a
#' named integer vector containing the weights to apply to the (modalities
#' matrix) variables. For example, with
#' \code{score_pond = c(qs_residual_sa_on_sa = 10, f_residual_td_on_sa = 5)},
#' the score will be based on the variables \code{qs_residual_sa_on_sa} and
#' \code{f_residual_td_on_sa}. The \code{qs_residual_sa_on_sa} grades will be
#' multiplied by 10 and the \code{f_residual_td_on_sa grades}, by 5. To ignore
#' the missing values when calculating a score, use the parameter
#' \code{na.rm = TRUE}.
#'
#' The parameter \code{normalize_score_value} can be used to normalise the
#' scores. For example, to have all scores between 0 and 20, specify
#' \code{normalize_score_value = 20}.
#'
#' When using parameter \code{n_contrib_score}, \code{n_contrib_score} new
#' variables are added to the quality report's values matrix. These new
#' variables store the names of the variables that contribute the most to the
#' series score. For example, \code{n_contrib_score = 3} will add to the values
#' matrix the three variables that contribute the most to the score. The new
#' variables' names are *i*_highest_score, with *i* being the rank in terms of
#' contribution to the score (1_highest_score contains the name of the greatest
#' contributor, 2_highest_score the second greatest, etc). Only the variables
#' that have a non-zero contribution to the score are taken into account: if a
#' series score is 0, all *i*_highest_score variables will be empty. And if a
#' series score is positive only because of the m7 statistic, 1_highest_score
#' will have a value of "m7" for this series and the other *i*_highest_score
#' will be empty.
#'
#' Some indicators are only relevant under certain conditions. For example, the
#' homoscedasticity test is only valid when the residuals are independant, and
#' the normality tests, only when the residuals are both independant and
#' homoscedastic. In these cases, the parameter \code{conditional_indicator} can
#' be of use since it reduces the weight of some variables down to 1 when some
#' conditions are met. \code{conditional_indicator} is a \code{list} of
#' 3-elements sub-lists:
#' - "indicator": the variable whose weight will be conditionally changed
#' - "conditions": the variables used to define the conditions
#' - "conditions_modalities": modalities that must be verified to induce the
#'   weight change For example,
#'   \code{conditional_indicator = list(list(indicator = "residuals_skewness",
#'   conditions = c("residuals_independency", "residuals_homoskedasticity"),
#'   conditions_modalities = c("Bad","Severe")))}, reduces down to 1 the weight
#'   of the variable "residuals_skewness" when the modalities of the
#'   independancy test ("residuals_independency") or the homoscedasticity test
#'   ("residuals_homoskedasticity") are "Bad" or "Severe".
#'
#' @encoding UTF-8
#' @return a \code{\link{QR_matrix}} or \code{\link{mQR_matrix}} object.
#' @examples
#' # Path of matrix demetra_m
#' demetra_path <- file.path(
#'     system.file("extdata", package = "JDCruncheR"),
#'     "WS/ws_ipi/Output/SAProcessing-1",
#'     "demetra_m.csv"
#' )
#'
#' # Extract the quality report from the demetra_m file
#' QR <- extract_QR(demetra_path)
#'
#' # Calculer le score
#' QR <- compute_score(QR, n_contrib_score = 2)
#' print(QR)
#'
#' # Extract the modalities matrix:
#' QR$modalities$score
#'
#' @name compute_score
#' @rdname compute_score
#' @seealso [Traduction française][fr-compute_score()]
#' @export
compute_score.QR_matrix <- function(
        x,
        score_pond = c(
            qs_residual_sa_on_sa = 30,
            f_residual_sa_on_sa = 30,
            qs_residual_sa_on_i = 20,
            f_residual_sa_on_i = 20,
            f_residual_td_on_sa = 30,
            f_residual_td_on_i = 20,
            oos_mean = 15,
            oos_mse = 10,
            residuals_independency = 15,
            residuals_homoskedasticity = 5,
            residuals_skewness = 5,
            m7 = 5, q_m2 = 5
        ),
        modalities = c("Good", "Uncertain", "", "Bad", "Severe"),
        normalize_score_value,
        na.rm = FALSE,
        n_contrib_score,
        conditional_indicator,
        ...) {
    # score_formula_exp <- as.expression(substitute(score_formula))

    QR_modalities <- x$modalities
    QR_modalities[, ] <- lapply(QR_modalities, function(x) {
        as.numeric(factor(x, levels = modalities, ordered = TRUE)) - 1
    })
    # Creation of an additionnal row to store the maximum score to normalise the score variable
    QR_modalities <- rbind(
        QR_modalities,
        length(modalities) - 1
    )
    if (!all(names(score_pond) %in% colnames(QR_modalities))) {
        stop("Missing variables: please check the score_pond parameter")
    }

    # Weight changes with the conditional_indicator parameter
    if (!missing(conditional_indicator) && length(conditional_indicator) > 0) {
        for (i in seq_along(conditional_indicator)) {
            indicator_condition <- conditional_indicator[[i]]

            if (anyNA(match(
                c("indicator", "conditions", "conditions_modalities"),
                names(indicator_condition)
            ))) {
                stop("There is an error in the specification of the indicator_condition variable")
            }

            indicator_variables <- c(
                indicator_condition$indicator,
                indicator_condition$conditions
            )
            if (!all(indicator_variables %in% colnames(x$modalities))) {
                stop("Missing variables: please check the indicator_variables parameter")
            }

            # Series for which at least one conditions is verified
            series_to_change <- rowSums(sapply(
                indicator_condition$conditions,
                function(name) {
                    x$modalities[, name] %in% indicator_condition$conditions_modalities
                }
            ), na.rm = TRUE)
            series_to_change <- which(series_to_change > 0)
            if (indicator_condition$indicator[1] %in% names(score_pond)) {
                QR_modalities[series_to_change, indicator_condition$indicator[1]] <-
                    QR_modalities[series_to_change, indicator_condition$indicator[1]] / score_pond[indicator_condition$indicator[1]]
            }
        }
    }

    QR_modalities <- QR_modalities[, names(score_pond)]

    for (nom_var in names(score_pond)) {
        QR_modalities[, nom_var] <- QR_modalities[, nom_var] * score_pond[nom_var]
    }
    score <- base::rowSums(
        QR_modalities,
        na.rm = na.rm
    )

    total_pond_id <- length(score)
    if (!missing(normalize_score_value)) {
        if (!is.numeric(normalize_score_value)) {
            stop("The score's reference value must be a number!")
        }
        score <- score / score[total_pond_id] * normalize_score_value
    }
    score <- score[-total_pond_id]

    x$modalities[, grep(
        "(_highest_contrib_score$)|(score)",
        colnames(x$modalities)
    )] <- NULL
    x$values[, grep(
        "(_highest_contrib_score$)|(score)",
        colnames(x$values)
    )] <- NULL

    x$modalities$score <- score
    x$values$score <- score
    x$score_formula <- paste(
        score_pond, "*",
        names(score_pond),
        collapse = " + "
    )
    if (!missing(n_contrib_score)
        && is.numeric(n_contrib_score)
        && n_contrib_score >= 1) {
        QR_modalities <- QR_modalities[-total_pond_id, ]
        n_contrib_score <- round(min(n_contrib_score, length(score_pond)))

        contrib <- t(sapply(seq_len(nrow(QR_modalities)), function(i) {
            ligne_i <- QR_modalities[i, ]
            res <- colnames(QR_modalities)[order(t(ligne_i),
                                                 decreasing = TRUE,
                                                 na.last = TRUE)]
            ligne_i <- ligne_i[, res]
            lignes_a_modif <- which(is.na(ligne_i) | ligne_i == 0)
            res[lignes_a_modif] <- ""
            res
        }))

        colnames(contrib) <- paste0(
            seq_along(score_pond),
            "_highest_contrib_score"
        )
        ncol_before_contrib <- ncol(x$values)
        x$values <- cbind(x$values, contrib[, 1:n_contrib_score])
        colnames(x$values)[1:n_contrib_score + ncol_before_contrib] <-
            paste0(
                1:n_contrib_score,
                "_highest_contrib_score"
            )
    }

    return(x)
}

#' @rdname compute_score
#' @export
compute_score.mQR_matrix <- function(x, ...) {
    result <- mQR_matrix(lapply(x, compute_score, ...))
    return(result)
}
#' @export
compute_score <- function(x, ...) {
    UseMethod("compute_score", x)
}
#' @export
compute_score.default <- function(x, ...) {
    stop("The function requires a QR_matrix or mQR_matrix object!")
}




#' Calcul d'un score pondéré pour chaque observation
#'
#' Permet de pondérer un score déjà calculé en fonction de variables.
#'
#' @param x objet de type \code{\link{QR_matrix}} ou \code{\link{mQR_matrix}}.
#' @param pond pondération à appliquer au score. Il peut s'agir d'un nombre,
#' d'un vecteur de nombres, du nom d'une des variables du bilan qualité ou d'une
#' liste de pondérations pour les objets \code{\link{mQR_matrix}}.
#' @examples
#'
#' # Chemin menant au fichier demetra_m.csv
#' demetra_path <- file.path(
#'     system.file("extdata", package = "JDCruncheR"),
#'     "WS/ws_ipi/Output/SAProcessing-1",
#'     "demetra_m.csv"
#' )
#'
#' # Extraire le bilan qualité à partir du fichier demetra_m.csv
#' QR <- extract_QR(demetra_path)
#'
#' # Calculer le score
#' QR <- compute_score(QR, n_contrib_score = 2)
#' print(QR)
#'
#' # Pondérer le score
#' QR <- weighted_score(QR, 2)
#' print(QR)
#'
#' # Extraire le score pondéré
#' QR$modalities$score_pond
#'
#' @return L'objet en entrée avec le score recalculé
#' @keywords internal
#' @name fr-weighted_score
NULL
#> NULL


#' Weighted score calculation
#'
#' Function to weight a pre-calculated score
#'
#' @param x a \code{\link{QR_matrix}} or \code{\link{mQR_matrix}} object
#' @param pond the weights to use. Can be an integer, a vector of integers, the
#' name of one of the quality report variables or a list of weights for the
#' \code{\link{mQR_matrix}} objects.
#' @examples
#' # Path of matrix demetra_m
#' demetra_path <- file.path(
#'     system.file("extdata", package = "JDCruncheR"),
#'     "WS/ws_ipi/Output/SAProcessing-1",
#'     "demetra_m.csv"
#' )
#'
#' # Extract the quality report from the demetra_m file
#' QR <- extract_QR(demetra_path)
#'
#' # Compute the score
#' QR <- compute_score(QR, n_contrib_score = 2)
#'
#' # Weighted score
#' QR <- weighted_score(QR, 2)
#' print(QR)
#'
#' # Extract the weighted score
#' QR$modalities$score_pond
#'
#' @family QR_matrix functions
#' @return the input with an additionnal weighted score
#' @name weighted_score
#' @rdname weighted_score
#' @seealso [Traduction française][fr-weighted_score()]
#' @export
weighted_score <- function(x, pond = 1) {
    UseMethod("weighted_score", x)
}
#' @export
weighted_score.default <- function(x, pond = 1) {
    stop("This function requires a QR_matrix or mQR_matrix object")
}
#' @export
weighted_score.QR_matrix <- function(x, pond = 1) {
    if (is.character(pond)) {
        if (is.na(match(pond, colnames(x$values)))) {
            stop("The variable ", pond, " doesn't exist")
        }
        pond <- x$values[, pond]
    }
    if (!is.na(match("score", colnames(x$modalities)))) {
        x$modalities$score_pond <- x$modalities$score * pond
    }
    if (!is.na(match("score", colnames(x$values)))) {
        x$values$score_pond <- x$values$score * pond
    }
    return(x)
}
#' @export
weighted_score.mQR_matrix <- function(x, pond = 1) {
    if (!is.list(pond)) {
        result <- lapply(x, weighted_score, pond = pond)
    } else {
        if (length(pond) < length(x)) {
            stop("There are fewer weight sets than quality reports!")
        }
        result <- lapply(
            seq_along(x),
            function(i) weighted_score(x[[i]], pond = pond[[i]])
        )
    }
    names(result) <- names(x)
    result <- mQR_matrix(result)
    return(result)
}




#' @title Tri des objets QR_matrix et mQR_matrix
#'
#' @description
#' Permet de trier les bilans qualité en fonction d'une ou plusieurs variables.
#'
#' @param x objet de type \code{\link{QR_matrix}} ou \code{\link{mQR_matrix}}.
#' @param decreasing booléen indiquant si les bilans qualité doivent être triés
#' par ordre croissant ou décroissant.
#' Par défaut, le tri est effectué par ordre croissant.
#' @param sort_variables variables à utiliser pour le tri. Elles doivent être
#' présentes dans les tables de modalités.
#' @param ... autres paramètres de la fonction \code{\link[base]{order}} (non
#' utilisés pour l'instant).
#' @return L'objet en entrée avec les tables de bilan qualité triées.
#' @examples
#'
#' # Chemin menant au fichier demetra_m.csv
#' demetra_path <- file.path(
#'     system.file("extdata", package = "JDCruncheR"),
#'     "WS/ws_ipi/Output/SAProcessing-1",
#'     "demetra_m.csv"
#' )
#'
#' # Extraire le bilan qualité à partir du fichier demetra_m.csv
#' QR <- extract_QR(demetra_path)
#'
#' # Calculer le score
#' QR <- compute_score(QR, n_contrib_score = 2)
#' print(QR$modalities$score)
#'
#' # Trier les scores
#'
#' # Pour trier par ordre croissant sur le score
#' QR <- sort(QR, sort_variables = "score")
#' print(QR$modalities$score)
#'
#' @keywords internal
#' @name fr-sort.QR_matrix
NULL
#> NULL


#' QR_matrix and mQR_matrix sorting
#'
#' To sort the quality reports on one or several variables
#'
#' @param x a \code{\link{QR_matrix}} or \code{\link{mQR_matrix}} object
#' @param decreasing logical indicating whether the quality reports must be
#' sorted in ascending or decreasing order.
#' By default, the sorting is done in ascending order.
#' @param sort_variables They must be present in the modalities table.
#' @param ... other parameters of the function \code{\link[base]{order}} (unused
#' for now)
#' @return the input with sorted quality reports
#' @examples
#' # Path of matrix demetra_m
#' demetra_path <- file.path(
#'     system.file("extdata", package = "JDCruncheR"),
#'     "WS/ws_ipi/Output/SAProcessing-1",
#'     "demetra_m.csv"
#' )
#'
#' # Extract the quality report from the demetra_m file
#' QR <- extract_QR(demetra_path)
#'
#' # Compute the score
#' QR <- compute_score(QR, n_contrib_score = 2)
#' print(QR$modalities$score)
#'
#' # Sort the scores
#'
#' # To sort by ascending scores
#' QR <- sort(QR, sort_variables = "score")
#' print(QR$modalities$score)
#'
#' @family QR_matrix functions
#' @name sort
#' @rdname sort
#' @seealso [Traduction française][fr-sort.QR_matrix()]
#' @export
sort.QR_matrix <- function(x, decreasing = FALSE, sort_variables = "score", ...) {
    modalities <- x$modalities
    if (anyNA(match(sort_variables, colnames(modalities)))) {
        stop("There is an error in the variables' names")
    }
    modalities <- c(modalities[sort_variables], decreasing = decreasing)
    ordered_matrixBQ <- do.call(order, modalities)
    x$modalities <- x$modalities[ordered_matrixBQ, ]
    x$values <- x$values[ordered_matrixBQ, ]
    return(x)
}
#' @rdname sort
#' @export
sort.mQR_matrix <- function(x,
                            decreasing = FALSE,
                            sort_variables = "score",
                            ...) {
    result <- lapply(
        X = x,
        FUN = sort,
        sort_variables = sort_variables,
        decreasing = decreasing, ...
    )
    result <- mQR_matrix(result)
    return(result)
}





#' @title Extraction du score
#'
#' @description
#' Permet d'extraire le score des objets \code{\link{QR_matrix}} ou
#' \code{\link{mQR_matrix}}.
#'
#' @param x objet de type \code{\link{QR_matrix}} ou \code{\link{mQR_matrix}}.
#' @param format_output chaîne de caractères indiquant le format de l'objet en
#' sortie :
#' soit un \code{data.frame} soit un \code{vector}.
#' @param weighted_score booléen indiquant s'il faut extraire le score pondéré
#' (s'il existe) ou le score non pondéré.
#' Par défaut, c'est le score non pondéré qui est extrait.
#' @details Pour les objets \code{\link{QR_matrix}}, le score renvoyé est soit
#' l'objet \code{NULL} si aucun score n'a été calculé, soit un vecteur.
#' Pour les objets \code{\link{mQR_matrix}}, c'est une liste de scores
#' (\code{NULL} ou un vecteur).
#'
#' @returns \code{extract_score()} renvoie un data.frame avec deux colonnes : le
#' nom de la série et son score.
#'
#' @examples
#'
#' # Chemin menant au fichier demetra_m.csv
#' demetra_path <- file.path(
#'     system.file("extdata", package = "JDCruncheR"),
#'     "WS/ws_ipi/Output/SAProcessing-1",
#'     "demetra_m.csv"
#' )
#'
#' # Extraire le bilan qualité à partir du fichier demetra_m.csv
#' QR <- extract_QR(demetra_path)
#'
#' # Calculer le score
#' QR1 <- compute_score(x = QR, n_contrib_score = 5)
#' QR2 <- compute_score(
#'     x = QR,
#'     score_pond = c(qs_residual_sa_on_sa = 5, qs_residual_sa_on_i = 30,
#'                    f_residual_td_on_sa = 10, f_residual_td_on_i = 40,
#'                    oos_mean = 30, residuals_skewness = 15, m7 = 25)
#' )
#' mQR <- mQR_matrix(list(a = QR1, b = QR2))
#'
#' # Extraire les scores
#' extract_score(QR1)
#' extract_score(mQR)
#'
#' @keywords internal
#' @name fr-extract_score
NULL
#> NULL


#' Score extraction
#'
#' To extract score variables from \code{\link{QR_matrix}} or
#' \code{\link{mQR_matrix}} objects.
#'
#' @param x a \code{\link{QR_matrix}} or \code{\link{mQR_matrix}}.
#' @param format_output string of characters indicating the output format:
#' either a \code{data.frame} or a \code{vector}.
#' @param weighted_score logical indicating whether to extract the weighted
#' score (if previously calculated) or the unweighted one.
#' By default, the unweighted score is extracted.
#' @details For \code{\link{QR_matrix}} objects, the output is a vector or the
#' object \code{NULL} if no score was previously calculated.
#' For \code{\link{mQR_matrix}} objects, it is a list of scores (\code{NULL}
#' elements or vectors).
#'
#' @returns \code{extract_score()} returns a data.frame with two column: the
#' series name and their score.
#'
#' @examples
#' # Path of matrix demetra_m
#' demetra_path <- file.path(
#'     system.file("extdata", package = "JDCruncheR"),
#'     "WS/ws_ipi/Output/SAProcessing-1",
#'     "demetra_m.csv"
#' )
#'
#' # Extract the quality report from the demetra_m file
#' QR <- extract_QR(demetra_path)
#'
#' # Compute the score
#' QR1 <- compute_score(x = QR, n_contrib_score = 5)
#' QR2 <- compute_score(
#'     x = QR,
#'     score_pond = c(qs_residual_sa_on_sa = 5, qs_residual_sa_on_i = 30,
#'                    f_residual_td_on_sa = 10, f_residual_td_on_i = 40,
#'                    oos_mean = 30, residuals_skewness = 15, m7 = 25)
#' )
#' mQR <- mQR_matrix(list(a = QR1, b = QR2))
#'
#' # Extract score
#' extract_score(QR1)
#' extract_score(mQR)
#'
#' @seealso [Traduction française][fr-extract_score()]
#' @export
extract_score <- function(x,
                          format_output = c("data.frame", "vector"),
                          weighted_score = FALSE) {
    UseMethod("extract_score", x)
}

#' @export
extract_score.default <- function(x, format_output, weighted_score) {
    stop("This function requires a QR_matrix or mQR_matrix object")
}
#' @export
extract_score.QR_matrix <- function(x,
                                    format_output = c("data.frame", "vector"),
                                    weighted_score = FALSE) {
    if (weighted_score) {
        score <- x$modalities$score_pond
        if (is.null(score)) {
            score <- x$modalities$score
            score_variable <- "score"
        } else {
            score_variable <- "score_pond"
        }
    } else {
        score <- x$modalities$score
        score_variable <- "score"
    }

    if (is.null(score)) {
        return(NULL)
    }

    format_output <- match.arg(format_output)
    res <- switch(
        format_output,
        data.frame = x$modalities[, c("series", score_variable)],
        vector = {
            names(score) <- x$modalities$series
            score
        }
    )
    return(res)
}
#' @export
extract_score.mQR_matrix <- function(x,
                                     format_output = c("data.frame", "vector"),
                                     weighted_score = FALSE) {
    return(lapply(
        X = x,
        FUN = extract_score,
        format_output = format_output,
        weighted_score = weighted_score
    ))
}





#' Manipulation de la liste des indicateurs
#'
#' Permet de retirer des indicateurs (fonction \code{remove_indicators()}) ou de
#' n'en retenir que certains (fonction \code{retain_indicators()}) d'objets
#' \code{\link{QR_matrix}} ou \code{\link{mQR_matrix}}. Le nom des séries
#' (colonne "series") ne peut être enlevé.
#'
#' @param x objet de type \code{\link{QR_matrix}} ou \code{\link{mQR_matrix}}.
#' @param ... noms des variables à retirer (ou conserver).
#' @returns \code{remove_indicators()} renvoie le même objet \code{x} réduit par
#' les drapeaux et les variables utilisés comme arguments \dots Donc si l'entrée
#' \code{x} est une matrice QR_matrix, un objet de la classe QR_matrix est
#' renvoyé. Si le code d'entrée \code{x} est une matrice mQR, un objet de la
#' classe mQR_matrix est renvoyé.
#'
#' @examples
#'
#' # Chemin menant au fichier demetra_m.csv
#' demetra_path <- file.path(
#'     system.file("extdata", package = "JDCruncheR"),
#'     "WS/ws_ipi/Output/SAProcessing-1",
#'     "demetra_m.csv"
#' )
#'
#' # Extraire le bilan qualité à partir du fichier demetra_m.csv
#' QR <- extract_QR(demetra_path)
#'
#' # Calculer le score
#' QR <- compute_score(x = QR, n_contrib_score = 5)
#'
#' # Retenir certains indicateurs
#' retain_indicators(QR, "score", "m7") # Retiens les indicateurs "score" et "m7"
#' retain_indicators(QR, c("score", "m7")) # Pareil
#'
#' # Retirer des indicateurs
#' QR <- remove_indicators(QR, "score") # removing "score"
#'
#' extract_score(QR) # est NULL car l'indicateur "score a été retiré
#'
#' @keywords internal
#' @name fr-remove_indicators
NULL
#> NULL


#' Editing the indicators list
#'
#' Functions to remove indicators (\code{remove_indicators()}) or retrain some
#' indicators only (\code{retain_indicators()}) from \code{\link{QR_matrix}} or
#' \code{\link{mQR_matrix}} objects. The series names (column "series") cannot
#' be removed.
#'
#' @param x a \code{\link{QR_matrix}} or \code{\link{mQR_matrix}} object.
#' @param ... names of the variable to remove (or keep)
#'
#' @returns \code{remove_indicators()} returns the same object \code{x} reduced
#' by the flags and variables used as arguments \dots So if the input \code{x}
#' is a QR_matrix, an object of class QR_matrix is returned. If the input
#' \code{x} is a mQR_matrix, an object of class mQR_matrix is returned.
#'
#' @examples
#' # Path of matrix demetra_m
#' demetra_path <- file.path(
#'     system.file("extdata", package = "JDCruncheR"),
#'     "WS/ws_ipi/Output/SAProcessing-1",
#'     "demetra_m.csv"
#' )
#'
#' # Extract the quality report from the demetra_m file
#' QR <- extract_QR(demetra_path)
#'
#' # Compute the score
#' QR <- compute_score(QR, n_contrib_score = 2)
#'
#' # Retain indicators
#' retain_indicators(QR, "score", "m7") # retaining "score" and "m7"
#' retain_indicators(QR, c("score", "m7")) # Same
#'
#' # Remove indicators
#' QR <- remove_indicators(QR, "score") # removing "score"
#'
#' extract_score(QR) # is NULL because we removed the score indicator
#'
#' @family var QR_matrix manipulation
#' @name QR_var_manipulation
#' @rdname QR_var_manipulation
#' @seealso [Traduction française][fr-remove_indicators()]
#' @export
remove_indicators <- function(x, ...) {
    UseMethod("remove_indicators", x)
}
#' @export
remove_indicators.default <- function(x, ...) {
    stop("This function requires a QR_matrix or mQR_matrix object")
}
#' @export
remove_indicators.QR_matrix <- function(x, ...) {
    indicators <- c(...)
    indicators <- setdiff(indicators, "series")

    modalities_to_remove <- which(colnames(x$modalities) %in% indicators)
    values_to_remove <- which(colnames(x$values) %in% indicators)
    if (length(modalities_to_remove) > 0) {
        x$modalities <- x$modalities[, -modalities_to_remove]
    }
    if (length(values_to_remove) > 0) {
        x$values <- x$values[, -values_to_remove]
    }
    return(x)
}
#' @export
remove_indicators.mQR_matrix <- function(x, ...) {
    return(mQR_matrix(lapply(x, remove_indicators, ...)))
}
#' @rdname QR_var_manipulation
#' @export
retain_indicators <- function(x, ...) {
    UseMethod("retain_indicators", x)
}
#' @export
retain_indicators.default <- function(x, ...) {
    stop("This function requires a QR_matrix or mQR_matrix object")
}
#' @export
retain_indicators.QR_matrix <- function(x, ...) {
    indicators <- c(...)
    indicators <- c("series", indicators)

    modalities_to_retain <- which(colnames(x$modalities) %in% indicators)
    values_to_retain <- which(colnames(x$values) %in% indicators)
    if (length(modalities_to_retain) > 0) {
        x$modalities <- x$modalities[, modalities_to_retain]
    }
    if (length(values_to_retain) > 0) {
        x$values <- x$values[, values_to_retain]
    }
    return(x)
}
#' @export
retain_indicators.mQR_matrix <- function(x, ...) {
    return(mQR_matrix(lapply(x, retain_indicators, ...)))
}


#' Combiner par ligne des objets QR_matrix
#'
#' Permet de combiner plusieurs objets \code{\link{QR_matrix}} en combinant par
#' ligne les paramètres \code{modalities} et \code{values}.
#'
#' @param ... objets \code{\link{QR_matrix}} à combiner.
#' @param check_formula booléen indiquant s'il faut vérifier la cohérence dans
#' les formules de calcul du score.
#' Par défaut, \code{check_formula = TRUE} : la fonction renvoie une erreur si
#' des scores sont calculés avec des formules différentes. Si
#' \code{check_formula = FALSE}, alors il n'y a pas de vérification et le
#' paramètre \code{score_formula} de l'objet en sortie est \code{NULL}.
#'
#' @returns \code{rbind.QR_matrix()} renvoie un objet \code{\link{QR_matrix}}.
#'
#' @examples
#' # Chemin menant au fichier demetra_m.csv
#' demetra_path <- file.path(
#'     system.file("extdata", package = "JDCruncheR"),
#'     "WS/ws_ipi/Output/SAProcessing-1",
#'     "demetra_m.csv"
#' )
#'
#' # Extraire le bilan qualité à partir du fichier demetra_m.csv
#' QR <- extract_QR(demetra_path)
#'
#' # Calculer differents scores
#' QR1 <- compute_score(QR, score_pond = c(m7 = 2, q = 3, qs_residual_sa_on_sa = 5))
#' QR2 <- compute_score(QR, score_pond = c(m7 = 2, qs_residual_sa_on_sa = 5))
#'
#' # Fusionner 2 bilans qualité
#' try(rbind(QR1, QR2)) # Une erreur est renvoyée
#' rbind(QR1, QR2, check_formula = FALSE)
#'
#' @keywords internal
#' @name fr-rbind.QR_matrix
NULL
#> NULL


#' @title Combining QR_matrix objects
#'
#' @description
#' Function to combine multiple \code{\link{QR_matrix}} objects: line by line,
#' both for the \code{modalities} and the \code{values} table.
#'
#' @param ... \code{\link{QR_matrix}} objects to combine.
#' @param check_formula logical indicating whether to check the score formulas'
#' coherency.
#' By default, \code{check_formula = TRUE}: an error is returned if the scores
#' were calculated with different formulas. If \code{check_formula = FALSE}, no
#' check is performed and the \code{score_formula} of the output is \code{NULL}.
#'
#' @returns \code{rbind.QR_matrix()} returns a \code{\link{QR_matrix}} object.
#'
#' @examples
#' # Path of matrix demetra_m
#' demetra_path <- file.path(
#'     system.file("extdata", package = "JDCruncheR"),
#'     "WS/ws_ipi/Output/SAProcessing-1",
#'     "demetra_m.csv"
#' )
#'
#' # Extract the quality report from the demetra_m file
#' QR <- extract_QR(demetra_path)
#'
#' # Compute differents scores
#' QR1 <- compute_score(QR, score_pond = c(m7 = 2, q = 3, qs_residual_sa_on_sa = 5))
#' QR2 <- compute_score(QR, score_pond = c(m7 = 2, qs_residual_sa_on_sa = 5))
#'
#' # Merge two quality report
#' try(rbind(QR1, QR2)) # Une erreur est renvoyée
#' rbind(QR1, QR2, check_formula = FALSE)
#'
#' @family QR_matrix functions
#' @seealso [Traduction française][fr-rbind.QR_matrix()]
#' @export
rbind.QR_matrix <- function(..., check_formula = TRUE) {
    list_QR_matrix <- list(...)
    if (length(list_QR_matrix) == 0) {
        return(QR_matrix())
    }
    if (check_formula) {
        list_formula <- sapply(list_QR_matrix, function(x) {
            if (!is.QR_matrix(x)) {
                stop("All arguments of this function must be QR_matrix objects", call. = FALSE)
            }
            x$score_formula
        })
        list_formula_unique <- unique(list_formula)
        if (length(list_formula) != length(list_QR_matrix)
            || length(list_formula_unique) != 1) {
            stop("All QR_matrices must have the same score formulas")
        }
        if (is.list(list_formula_unique)) {
            score_formula <- NULL
        } else {
            score_formula <- list_QR_matrix[[1]]$formula
        }
    } else {
        score_formula <- NULL
    }

    modalities <- do.call(
        rbind,
        lapply(list_QR_matrix, function(x) {
            if (!is.QR_matrix(x)) {
                stop("All arguments of this function must be QR_matrix objects", call. = FALSE)
            }
            x$modalities
        })
    )
    values <- do.call(
        rbind,
        lapply(list_QR_matrix, function(x) x$values)
    )
    QR <- QR_matrix(
        modalities = modalities, values = values,
        score_formula = score_formula
    )
    return(QR)
}

#' Ajout d'un indicateur dans les objets QR_matrix
#'
#' Permet d'ajouter un indicateur dans les objets \code{\link{QR_matrix}}.
#'
#' @param x objet de type \code{\link{QR_matrix}} ou \code{\link{mQR_matrix}}.
#' @param indicator un \code{vector} ou un \code{data.frame} (voir détails).
#' @param variable_name chaîne de caractères contenant les noms des nouvelles
#' variables.
#' @param ... autres paramètres de la fonction \code{\link[base]{merge}}.
#'
#' @details La fonction \code{add_indicator()} permet d'ajouter un indicateur
#' dans la matrice des valeurs du bilan qualité. L'indicateur n'est donc pas
#' ajouté dans la matrice des modalités et ne peut être utilisé dans le calcul
#' du score (sauf pour le pondérer). Pour l'utiliser dans le calcul du score, il
#' faudra d'abord le recoder avec la fonction
#' \code{\link{recode_indicator_num}}.
#'
#' L'indicateur à ajouter peut être sous deux formats : \code{vector} ou
#' \code{data.frame}. Dans les deux cas, il faut que les valeurs à ajouter
#' puissent être associées aux bonnes séries dans la matrice du bilan qualité :
#'  * dans le cas d'un \code{vector}, les éléments devront être nommés et les
#'    noms doivent correspondre à ceux présents dans le bilan qualité (variable
#'    "series") ;
#'  * dans le cas d'un \code{data.frame}, il devra contenir une colonne "series"
#'    avec les noms des séries correspondantes.
#' @returns Cette fonction renvoie le même objet, enrichi de l'indicateur
#' choisi. Ainsi, si l'entrée \code{x} est une matrice QR, un objet de la classe
#' \code{QR_matrix} est renvoyé. Si le code d'entrée \code{x} est une matrice
#' mQR, un objet de la classe \code{mQR_matrix} est renvoyé.
#' @keywords internal
#' @name fr-add_indicator
NULL
#> NULL


#' Adding an indicator in QR_matrix objects
#'
#' Function to add indicators in \code{\link{QR_matrix}} objects.
#'
#' @param x a \code{\link{QR_matrix}} or \code{\link{mQR_matrix}} object
#' @param indicator a \code{vector} or a \code{data.frame} (cf. details).
#' @param variable_name a string containing the name of the variables to add.
#' @param ... other parameters of the function \code{\link[base]{merge}}.
#'
#' @details The function \code{add_indicator()} adds the chosen indicator to the
#' values matrix of a quality report. Therefore, because said indicator isn't
#' added in the modalities matrix, it cannot be used to calculate a score
#' (except for weighting). Before using the added variable for score
#' calculation, it will have to be coded with the function
#' \code{\link{recode_indicator_num}}.
#'
#' The new indicator can be a \code{vector} or a \code{data.frame}. In both
#' cases, its format must allow for pairing:
#'  * a \code{vector}'s elements must be named and these names must match those
#'    of the quality report (variable "series");
#'  * a \code{data.frame} must contain a "series" column that matches with the
#'    quality report's series.
#'
#' @returns This function returns the same object, enhanced with the chosen
#' indicator. So if the input \code{x} is a QR_matrix, an object of class
#' \code{QR_matrix} is returned. If the input \code{x} is a mQR_matrix, an
#' object of class \code{mQR_matrix} is returned.
#'
#' @family var QR_matrix manipulation
#' @seealso [Traduction française][fr-add_indicator()]
#' @export
add_indicator <- function(x, indicator, variable_name, ...) {
    UseMethod("add_indicator", x)
}
#' @export
add_indicator.default <- function(x, indicator, variable_name, ...) {
    stop("This function requires a QR_matrix or mQR_matrix object")
}
#' @export
add_indicator.QR_matrix <- function(x, indicator, variable_name, ...) {
    if (is.vector(indicator)) {
        if (is.null(names(indicator))) {
            stop("The vector's elements must be named!")
        }
        indicator <- data.frame(series = names(indicator), val = indicator)
    }
    if (!is.data.frame(indicator)) {
        stop("The function input must be a vector or a data.frame!")
    }

    if (!"series" %in% colnames(indicator)) {
        stop('The data.frame is missing a column named "series"')
    }
    if (ncol(indicator) < 2) {
        stop("The data.frame must have at least two columns")
    }
    # The "series" variable is moved in first position
    indicator <- indicator[, c(
        "series",
        grep(
            pattern = "^series$",
            x = colnames(indicator),
            invert = TRUE,
            value = TRUE
        )
    )]
    if (missing(variable_name)) {
        variable_name <- colnames(indicator)[-1]
    }
    values <- x$values
    n_col <- ncol(values)
    values$initial_sort <- seq_len(nrow(values))
    values <- merge(
        values, indicator,
        by = "series",
        all.x = TRUE, all.y = FALSE, ...
    )
    values <- values[order(values$initial_sort, decreasing = FALSE), ]

    values$initial_sort <- NULL
    colnames(values)[-seq_len(n_col)] <- variable_name

    x$values <- values

    return(x)
}
#' @export
add_indicator.mQR_matrix <- function(x, indicator, variable_name, ...) {
    return(mQR_matrix(lapply(x, add_indicator, variable_name = variable_name, ...)))
}


#' Ré-encodage en modalités des variables
#'
#' Permet d'encoder des variables présentes dans la matrice des valeurs en
#' modalités ajoutables à la matrice des modalités.
#'
#' @param x objet de type \code{\link{QR_matrix}} ou \code{\link{mQR_matrix}}.
#' @param variable_name vecteur de chaînes de caractères contenant les noms des
#' variables à recoder.
#' @param breaks voir l'argument éponyme de la fonction \code{\link[base]{cut}}.
#' @param labels voir l'argument éponyme de la fonction \code{\link[base]{cut}}.
#' @param ... autres paramètres de la fonction \code{\link[base]{cut}}.
#' @returns La fonction \code{recode_indicator_num()} renvoie le même objet,
#' enrichi de l'indicateur choisi. Ainsi, si l'entrée \code{x} est une matrice
#' QR_matrix, un objet de classe \code{QR_matrix} est renvoyé. Si le code
#' d'entrée \code{x} est une matrice mQR, un objet de la classe
#' \code{mQR_matrix} est renvoyé.
#' @keywords internal
#' @name fr-recode_indicator_num
NULL
#> NULL


#' @title Converting "values variables" into "modalities variables"
#'
#' @description
#' To transform variables from the values matrix into categorical variables
#' that can be added into the modalities matrix.
#'
#' @param x a \code{\link{QR_matrix}} or \code{\link{mQR_matrix}} object.
#' @param variable_name a vector of strings containing the names of the
#' variables to convert.
#' @param breaks see function \code{\link[base]{cut}}.
#' @param labels see function \code{\link[base]{cut}}.
#' @param ... other parameters of the \code{\link[base]{cut}} function.
#'
#' @returns The function \code{recode_indicator_num()} returns the same object,
#' enhanced with the chosen indicator. So if the input \code{x} is a QR_matrix,
#' an object of class \code{QR_matrix} is returned. If the input \code{x} is a
#' mQR_matrix, an object of class \code{mQR_matrix} is returned.
#'
#' @family var QR_matrix manipulation
#' @seealso [Traduction française][fr-recode_indicator_num()]
#' @export
recode_indicator_num <- function(
        x,
        variable_name,
        breaks = c(0, .01, .05, .1, 1),
        labels = c("Good", "Uncertain", "Bad", "Severe"),
        ...) {
    UseMethod("recode_indicator_num", x)
}
#' @export
recode_indicator_num.default <- function(x, variable_name, breaks, labels, ...) {
    stop("This function requires a QR_matrix or mQR_matrix object")
}
#' @export
recode_indicator_num.QR_matrix <- function(
        x,
        variable_name,
        breaks = c(0, .01, .05, .1, 1),
        labels = c("Good", "Uncertain", "Bad", "Severe"),
        ...) {
    modalities <- x$modalities
    values <- x$values
    for (var in variable_name) {
        if (var %in% colnames(values)) {
            modalities[, var] <- cut(
                values[, var],
                breaks = breaks,
                labels = labels
            )
        } else {
            warning("The variable ", var, " couldn't be found.")
        }
    }

    x$modalities <- modalities

    return(x)
}
#' @export
recode_indicator_num.mQR_matrix <- function(
        x,
        variable_name,
        breaks = c(0, .01, .05, .1, 1),
        labels = c("Good", "Uncertain", "Bad", "Severe"),
        ...) {
    return(mQR_matrix(x = lapply(
        X = x,
        FUN = recode_indicator_num,
        variable_name = variable_name,
        breaks = breaks,
        labels = labels,
        ...
    )))
}
