#' Score calculation
#'
#' To calculate a score for each series from a quality report
#'
#' @param x a \code{QR_matrix} or \code{mQR_matrix} object.
#' @param score_pond the formula used to calculate the series score.
#' @param modalities modalities ordered by importance in the score calculation (cf. details).
#' @param normalize_score_value integer indicating the reference value for weights normalisation. If missing, weights will not be normalised.
#' @param na.rm logical indicating whether missing values must be ignored when calculating the score.
#' @param n_contrib_score integer indicating the number of variables to create in the quality report's values matrix
#' to store the \code{n_contrib_score} greatest contributions to the score (cf. details).
#' If not specified, no variable is created.
#' @param conditional_indicator a \code{list} containing 3-elements sub-lists: "indicator", "conditions" and
#' "condition_modalities". To reduce down to 1 the weight of chosen indicators depending on other variables' values (cf. details).
#'
#' @param ... other unused parameters.
#' @details The function \code{compute_score} calculates a score from the modalities of a quality report: to each modality corresponds
#' a weight that depends on the parameter \code{modalities}. The default parameter is \code{c("Good", "Uncertain", "Bad","Severe")},
#' and the associated weights are respectively 0, 1, 2 and 3.
#'
#' The score calculation is based on the \code{score_pond} parameter, which is a named integer vector containing the weights
#' to apply to the (modalities matrix) variables. For example, with \code{score_pond = c(qs_residual_sa_on_sa = 10, f_residual_td_on_sa = 5)},
#' the score will be based on the variables qs_residual_sa_on_sa and f_residual_td_on_sa.
#' The qs_residual_sa_on_sa grades will be multiplied by 10 and the f_residual_td_on_sa grades, by 5.
#' To ignore the missing values when calculating a score, use the parameter \code{na.rm = TRUE}.
#'
#' The parameter \code{normalize_score_value} can be used to normalise the scores. For example, to have all scores between 0 and 20,
#' specify \code{normalize_score_value = 20}.
#'
#' When using parameter \code{n_contrib_score}, \code{n_contrib_score} new variables are added to the quality report's values matrix.
#' These new variables store the names of the variables that contribute the most to the series score.
#' For example, \code{n_contrib_score = 3} will add to the values matrix the three variables that contribute the most to the score.
#' The new variables' names are *i*_highest_score, with *i* being the rank in terms of contribution to the score (1_highest_score
#' contains the name of the greatest contributor, 2_highest_score the second greatest, etc).
#' Only the variables that have a non-zero contribution to the score are taken into account: if a series score is 0,
#' all *i*_highest_score variables will be empty. And if a series score is positive only because of the m7 statistic,
#' 1_highest_score will have a value of "m7" for this series and the other *i*_highest_score will be empty.
#'
#' Some indicators are only relevant under certain conditions. For example, the homoscedasticity test is only valid when the residuals are independant, and the normality tests,
#' only when the residuals are both independant and homoscedastic. In these cases, the parameter \code{conditional_indicator} can be of use
#' since it reduces the weight of some variables down to 1 when some conditions are met.
#' \code{conditional_indicator} is a \code{list} of 3-elements sub-lists:
#' - "indicator": the variable whose weight will be conditionally changed
#' - "conditions": the variables used to define the conditions
#' - "conditions_modalities": modalities that must be verified to induce the weight change
#' For example, \code{conditional_indicator = list(list(indicator = "residuals_skewness", conditions = c("residuals_independency", "residuals_homoskedasticity"), conditions_modalities = c("Bad","Severe")))},
#' reduces down to 1 the weight of the variable "residuals_skewness" when the modalities of the independancy test ("residuals_independency")
#' or the homoscedasticity test ("residuals_homoskedasticity") are "Bad" or "Severe".
#'
#' @encoding UTF-8
#' @return a \code{\link{QR_matrix}} or \code{\link{mQR_matrix}} object.
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
                                    score_pond = c(qs_residual_sa_on_sa = 30,
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
                                                   m7 = 5,  q_m2 = 5),
                                    modalities = c("Good", "Uncertain", "", "Bad","Severe"),
                                    normalize_score_value,
                                    na.rm = FALSE,
                                    n_contrib_score,
                                    conditional_indicator,
                                    ...){
    # score_formula_exp <- as.expression(substitute(score_formula))

    QR_modalities <- x$modalities
    QR_modalities[,] <- lapply(QR_modalities, function(x){
        as.numeric(factor(x, levels = modalities, ordered = TRUE)) - 1
    })
    # Creation of an additionnal row to store the maximum score to normalise the score variable
    QR_modalities <- rbind(QR_modalities,
                           length(modalities) - 1)
    if(!all(names(score_pond) %in% colnames(QR_modalities)))
        stop("Missing variables: please check the score_pond parameter")

    # Weight changes with the conditional_indicator parameter
    if(!missing(conditional_indicator) && length(conditional_indicator) > 0){
       for (i in 1:length(conditional_indicator)){
            indicator_condition <- conditional_indicator[[i]]

            if(any(is.na(match(c("indicator", "conditions", "conditions_modalities"),
                               names(indicator_condition)))))
                stop("There is an error in the specification of the indicator_condition variable")

            indicator_variables <- c(indicator_condition$indicator,
                                     indicator_condition$conditions)
            if(!all(indicator_variables %in% colnames(x$modalities)))
                stop("Missing variables: please check the indicator_variables parameter")

            # Series for which at least one conditions is verified
            series_to_change <- rowSums(sapply(indicator_condition$conditions,
                                               function(name) {
                                                   x$modalities[, name] %in% indicator_condition$conditions_modalities
                                               }), na.rm = TRUE)
            series_to_change <- which(series_to_change > 0)
            if(indicator_condition$indicator[1] %in% names(score_pond)){
                QR_modalities[series_to_change, indicator_condition$indicator[1]] <-
                    QR_modalities[series_to_change, indicator_condition$indicator[1]] /
                    score_pond[indicator_condition$indicator[1]]
            }
        }
    }

    QR_modalities <- QR_modalities[, names(score_pond)]

    for(nom_var in names(score_pond)){
        QR_modalities[, nom_var] <- QR_modalities[, nom_var] * score_pond[nom_var]
    }
    score <- base::rowSums(QR_modalities,
                           na.rm = na.rm)

    total_pond_id <- length(score)
    if(!missing(normalize_score_value)){
        if(!is.numeric(normalize_score_value))
            stop("The score's reference value must be a number!")
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
    stop("The function requires a QR_matrix or mQR_matrix object!")
}


#' Weighted score calculation
#'
#' To weight a pre-calculated score
#'
#' @param x a \code{QR_matrix} or \code{mQR_matrix} object
#' @param pond the weights to use. Can be an integer, a vector of integers, the name of one of the quality report variables
#' or a list of weights for the \code{mQR_matrix} objects.
#' @examples \dontrun{
#' QR <- extract_QR()
#' QR <- compute_score(QR)
#' weighted_score(QR, 2) # All scores are multiplied by 2
#' }
#' @family QR_matrix functions
#' @return the input with additionnal weighted score
#' @name weighted_score
#' @rdname weighted_score
#' @export
weighted_score <- function(x, pond = 1){
    UseMethod("weighted_score", x)
}
#' @export
weighted_score.default <- function(x, pond = 1){
    stop("This function requires a QR_matrix or mQR_matrix object")
}
#' @export
weighted_score.QR_matrix <- function(x, pond = 1){
    if(is.character(pond)){
        if(is.na(match(pond, colnames(x$values))))
            stop("The variable ",pond, " doesn't exist")
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

#' QR_matrix and mQR_matrix sorting
#'
#' To sort the quality reports on one or several variables
#'
#' @param x a \code{QR_matrix} or \code{mQR_matrix} object
#' @param decreasing logical indicating whether the quality reports must be sorted in ascending or decreasing order.
#' By default, the sorting is done in ascending order.
#' @param sort_variables They must be present in the modalities table.
#' @param ... other parameters of the function \code{\link[base]{order}} (unused for now)
#' @return the input with sorted quality reports
#' @examples \dontrun{
#' QR <- compute_score(extract_QR())
#' sort(QR, sort_variables = "score") # To sort by ascending values of the score
#' }
#' @family QR_matrix functions
#' @name sort
#' @rdname sort
#' @export
sort.QR_matrix <- function(x, decreasing = FALSE, sort_variables = "score", ...){
    modalities <- x$modalities
    if(!all(!is.na(match(sort_variables,colnames(modalities)))))
        stop("There is an error in the variables' names")
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



#' Score extraction
#'
#' To extract score variables from \code{QR_matrix} or \code{mQR_matrix} objects.
#'
#' @param x a \code{QR_matrix} or \code{mQR_matrix}.
#' @param format_output string of characters indicating the output format: either a \code{data.frame} or a \code{vector}.
#' @param weighted_score logical indicating whether to extract the weighted score (if previously calculated) or the unweighted one.
#' By default, the unweighted score is extracted.
#' @details For \code{QR_matrix} objects, the output is a vector or the object \code{NULL} if no score was previously calculated.
#' For \code{mQR_matrix} objects, it is a list of scores (\code{NULL} elements or vectors).
#' @examples \dontrun{
#' QR <- extract_QR()
#' mQR <- mQR_matrix(QR, compute_score(QR))
#' extract_score(QR)  # NULL
#' extract_score(mQR) # List whose first element is NULL
#' }
#' @family QR_matrix functions
#' @export
extract_score <- function(x, format_output = c("data.frame", "vector"), weighted_score = FALSE){
    UseMethod("extract_score", x)
}

#' @export
extract_score.default <- function(x, format_output, weighted_score){
    stop("This function requires a QR_matrix or mQR_matrix object")
}
#' @export
extract_score.QR_matrix <- function(x, format_output = c("data.frame", "vector"), weighted_score = FALSE){
    if(weighted_score){
        score <- x$modalities$score_pond
        if(is.null(score)){
            score <- x$modalities$score
            score_variable <- "score"
        }else{
            score_variable <- "score_pond"
        }
    }else{
        score <- x$modalities$score
        score_variable <- "score"
    }

    if(is.null(score))
        return(NULL)

    format_output <- match.arg(format_output)
    res <- switch (format_output,
        data.frame = x$modalities[,c("series", score_variable)],
        vector = {
            names(score) <- x$modalities$series
            score
        }
    )
    return(res)
}
#' @export
extract_score.mQR_matrix <- function(x, format_output = c("data.frame", "vector"), weighted_score = FALSE){
    return(lapply(x,extract_score, format_output = format_output, weighted_score = weighted_score))
}

#' Editing the indicators list
#'
#' Functions to remove indicators (\code{remove_indicators}) or retrain some indicators only (\code{retain_indicators})
#' from \code{QR_matrix} or \code{mQR_matrix} objects. The series names (column "series") cannot be removed.
#'
#' @param x a \code{QR_matrix} or \code{mQR_matrix} object.
#' @param ... names of the variable to remove (or keep)
#' @examples \dontrun{
#' QR <- compute_score(extract_QR())
#' retain_indicators(QR,"score","m7")    # Only the score and the m7 variables are kept
#' retain_indicators(QR,c("score","m7")) # equivalent syntax
#' score(remove_indicator(QR,"score"))   # The score is removed
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
    stop("This function requires a QR_matrix or mQR_matrix object")
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
    stop("This function requires a QR_matrix or mQR_matrix object")
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


#' Combining QR_matrix objects
#'
#' Function to combine multiple \code{QR_matrix} objects: line by line, both for the \code{modalities} and the \code{values} table.
#'
#' @param ... \code{QR_matrix} objects to combine.
#' @param check_formula logical indicating whether to check the score formulas' coherency.
#' By default, \code{check_formula = TRUE}: an error is returned if the scores were calculated with different formulas.
#' If \code{check_formula = FALSE}, no check is performed and the \code{score_formula} of the output is \code{NULL}.
#' @examples \dontrun{
#' QR <- extract_QR()
#' QR1 <- compute_score(QR1, score_pond = c(m7 = 2, q = 3, qs_residual_sa_on_sa = 5))
#' QR2 <- compute_score(QR1, score_pond = c(m7 = 2, qs_residual_sa_on_sa = 5))
#' rbind(QR1, QR2) # Returns an error
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
                stop("All arguments of this function must be QR_matrix objects", call. = FALSE)
            x$score_formula
        })
        list_formula_unique <- unique(list_formula)
        if( length(list_formula) != length(list_QR_matrix) | length(list_formula_unique) !=1)
            stop("All QR_matrices must have the same score formulas")
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
                                  stop("All arguments of this function must be QR_matrix objects",call. = FALSE)
                              x$modalities
                          }))
    values <- do.call(rbind,
                      lapply(list_QR_matrix, function(x) x$values))
    QR <- QR_matrix(modalities = modalities, values = values,
                    score_formula = score_formula)
    return(QR)
}

#' Adding an indicator in QR_matrix objects
#'
#' Function to add indicators in \code{QR_matrix} objects.
#'
#' @param x a \code{QR_matrix} or \code{mQR_matrix} object
#' @param indicator a \code{vector} or a \code{data.frame} (cf. details).
#' @param variable_name a string containing the name of the variables to add.
#' @param ... other parameters of the function \code{\link[base]{merge}}.
#'
#' @details The function \code{add_indicator()} adds a chosen indicator in the values matrix of a quality report.
#' Therefore, because said indicator isn't added in the modalities matrix, it cannot be used to calculate a score (except for weighting).
#' Before using the added variable for score calculation, the function \code{\link{recode_indicator_num}} will have to be adapted.
#'
#' The new indicator can be a \code{vector} or a \code{data.frame}. In both cases, its format must allow for pairing:
#'  * a \code{vector}'s elements must be named and these names must match those of the quality report (variable "series");
#'  * a \code{data.frame} must contain a "series" column that matches with the quality report's series.
#'
#' @family var QR_matrix manipulation
#' @export
add_indicator <- function(x, indicator, variable_name, ...){
    UseMethod("add_indicator", x)
}
#' @export
add_indicator.default <- function(x, indicator, variable_name, ...){
    stop("This function requires a QR_matrix or mQR_matrix object")
}
#' @export
add_indicator.QR_matrix <- function(x, indicator, variable_name, ...){
    if(is.vector(indicator)){
        if(is.null(names(indicator)))
            stop("The vector's elements must be named!")
        indicator <- data.frame(series = names(indicator), val = indicator)
    }
    if(!is.data.frame(indicator))
        stop("The function input must be a vector or a data.frame!")

    if(!"series" %in% colnames(indicator))
        stop('The data.frame is missing a column named "series"')
    if(ncol(indicator) < 2)
        stop('The data.frame must have at least two columns')
    # The "series" variable is moved in first position
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

#' Converting "values variables" into "modalities variables"
#'
#' To transform variables from the values matrix into categorical variables that can be added into the modalities matrix.
#'
#' @param x a \code{QR_matrix} or \code{mQR_matrix} object.
#' @param variable_name a vector of strings containing the names of the variables to convert.
#' @param breaks see function \code{\link[base]{cut}}.
#' @param labels see function \code{\link[base]{cut}}.
#' @param ... other parameters of the function \code{\link[base]{cut}}.
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
    stop("This function requires a QR_matrix or mQR_matrix object")
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
            warning("The variable ", var, " couldn't be found.")
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
