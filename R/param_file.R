#' Création du fichier des paramètres du cruncher
#'
#' Pour fonctionner, le cruncher a besoin d'un fichier de paramètres : \code{create_param_file} permet de le créer
#'
#' @param dir_file_param répertoire du dossier qui contiendra le fichier parametres.param des paramètres.
#' @param bundle nombre maximum de séries dans un fichier de sortie. Par défaut \code{bundle = 10000}.
#' @param csv_layout mise en page du fichier de sortie. Par défaut \code{csv_layout = "list"}. Autres
#' options : \code{csv_layout = "vtable"} ou \code{csv_layout = "htable"}.
#' @param csv_separator séparateur de colonnes utilisé dans le fichier csv. Par défaut \code{csv_separator = ";"}.
#' @param ndecs nombre de décimales dans les sorties (6 par défaut).
#' @param policy méthode de rafraîchissement utilisée. Par défaut \code{policy = "parameters"} (paramètres re-estimés).
#' Les autres méthodes possibles sont :
#' \code{"outliers"} (les outliers sont identifiés et les paramètres re-estimés) ;
#' \code{"lastoutliers"} (les outliers sont ré-identifiés sur la dernière année et les paramètres re-estimés) ;
#' \code{"stochastic"} (le modèle arima et les outliers sont identifiés et les paramètres re-estimés) ;
#' \code{"complete"} (le modèle est complétement ré-estimé).
#' @param output dossier où sont exportés les résultats. Par défaut (\code{output = NULL}) un dossier "Output" est créé à l'adresse du workspace.
#' @param matrix_item chaîne de caractères contenant les noms des paramètres à exporter (voir le manuel de JDemetra+).
#' Les paramètres par défaut sont obtenues en exécutant la commande \code{getOption("default_matrix_item")} (cette option
#' est initialisée aux mêmes paramètres par défaut que ceux de JDemetra+).
#' @param tsmatrix_series chaîne de caractères contenant les séries temporelles à exporter (voir le manuel de JDemetra+).
#'  Les paramètres par défaut sont obtenues en exécutant la commande \code{getOption("default_tsmatrix_series")} (cette option
#' est initialisée aux mêmes paramètres par défaut que ceux de JDemetra+)
#' @param paths_path chemins vers les fichiers d'entrée (Excel, xml...).
#' @return L'adresse du fichier de paramètres.
#' @encoding UTF-8
#' @family Cruncher functions
#' @export
create_param_file <- function(dir_file_param = getwd(), bundle = 10000, csv_layout = "list", csv_separator = ";",
                              ndecs = 6, policy = "parameters", output = NULL,
                              matrix_item = getOption("default_matrix_item"),
                              tsmatrix_series = getOption("default_tsmatrix_series"),
                              paths_path = NULL){
    first_line <- "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
    param_line <- paste("<wsaConfig bundle=", bundle, " csvlayout=", csv_layout, " csvseparator=",
                        csv_separator, " ndecs=",ndecs,">", sep = "\"")
    policy_line <- paste0("    <policy>", policy, "</policy>")

    output_line <- matrix_lines <- tsmatrix_lines <- path_lines <- NULL

    if(!is.null(output)){
        output <- normalizePath(output)
        output_line <- paste0("    <output>", gsub("/", "\\", output, fixed = TRUE), "</output>")
    }

    if(!is.null(matrix_item)){
        matrix_lines <- c("    <matrix>",
                          paste0("        <item>", matrix_item, "</item>"),
                          "    </matrix>")
    }

    if(!is.null(tsmatrix_series)){
        tsmatrix_lines <- c("    <tsmatrix>",
                            paste0("        <series>", tsmatrix_series, "</series>"),
                            "    </tsmatrix>")
    }

    if(!is.null(paths_path)){
        path_lines <- c("    <paths>",
                        paste0("        <path>", gsub("/", "\\", paths_path, fixed = TRUE), "</path>"),
                        "    </paths>")
    }

    file_param <- c(first_line, param_line, policy_line, output_line,
                    matrix_lines, tsmatrix_lines, path_lines,
                    "</wsaConfig>"
    )
    writeLines(file_param, con = paste0(dir_file_param,"/parametres.param"))
    return(invisible(paste0(dir_file_param,"/parametres.param")))
}




