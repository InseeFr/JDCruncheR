#' Lanceur de cruncher
#'
#' Fonction qui permet de lancer le cruncher sur un workspace à partir d'un fichier de paramètres.
#'
#' @param workspace chemin vers le workspace.
#' @param cruncher_bin_directory répertoire contenant contenant le dossier "bin" du cruncher. Pour voir la valeur par défaut,
#' exécuter le code \code{getOption("cruncher_bin_directory")}.
#' @param param_file_path chemin vers le fichier des paramètres à utiliser pour lancer le workspace.
#' Par défaut, un fichier .params est recherché au même niveau que le workspace.
#' @param log_file nom du fichier qui contiendra la log du cruncher. Par défaut, la log n'est pas exportée.
#' @encoding UTF-8
#' @return l'adresse du workspace
#' @keywords internal
#' @name fr-cruncher
NULL
#> NULL


#' The Cruncher launcher
#'
#' Function to launch the cruncher on a workspace from a settings file.
#'
#' @param workspace path to the workspace.
#' @param cruncher_bin_directory path to the "bin" folder of the cruncher. To see the default value, compile \code{getOption("cruncher_bin_directory")}.
#' @param param_file_path path to the settings file. By default, a .params file is searched for in the same folder the workspace is stored in.
#' @param log_file name of the log file. By default, no log file is exported.
#' @encoding UTF-8
#' @return The workspace path
#' @family Cruncher functions
#' @seealso [Traduction française][fr-cruncher()]
#' @export
cruncher <- function(workspace = workspace,
                     cruncher_bin_directory = getOption("cruncher_bin_directory"),
                     param_file_path, log_file) {
    if (missing(workspace) || is.null(workspace)) {
        stop("Please call the cruncher() on a valid workspace")
    }

    if (length(workspace) == 0)
        stop("The first argument must be a non-null workspace path")

    if (length(workspace) > 1)
        stop("Please specify only one workspace path")

    # The path to the workspace must be "whole", not relative/from the setwd.
    workspace <- normalizePath(workspace, mustWork = FALSE)
    workspace <- sub("\\.xml$", "", workspace) # To remove the .xml from the workspace name, if needed

    if (missing(param_file_path) || is.null(param_file_path)) {
        param_file_path <- list.files(path = workspace,
                                      recursive = TRUE,
                                      pattern = "\\.params$",
                                      full.names = TRUE)
        if (length(param_file_path) != 0)
            stop("No or more than one .param file was found")
    }
    workspace <- paste0(workspace, ".xml")

    if (!file.exists(paste0(cruncher_bin_directory, "/jwsacruncher")))
        stop("There is an error in the path to the cruncher bin folder")
    if (!file.exists(workspace))
        stop("There is an error in the path to the workspace")
    if (!file.exists(param_file_path))
        stop("There is an error in the path to the .params file")

    wd <- getwd()
    setwd(cruncher_bin_directory)

    log <- shell(paste0(
        "jwsacruncher \""
        , workspace
        , "\" -x \""
        , param_file_path, "\""
    ), intern = TRUE)

    setwd(wd)

    if (!missing(log_file) && !is.null(log_file))
        writeLines(text = log, con = log_file)

    return(invisible(workspace))
}




#' Lanceur rapide de cruncher
#'
#' Fonction qui permet de lancer le cruncher sur un workspace tout en créant le fichier des paramètres.
#'
#' @param workspace chemin vers le workspace.
#' @param cruncher_bin_directory répertoire contenant contenant le dossier "bin" du cruncher.
#' @param rename_multi_documents booléen indiquant s'il faut renommer les dossiers contenant les sorties en fonction
#' des noms des multi-documents du workspace. Par défaut \code{rename_multi_documents = TRUE}.
#' Si \code{rename_multi_documents = FALSE}, alors ce sont les noms des fichiers XML des multi_documents qui sont utilisés.
#' @param output dossier contenant les résultats du cruncher. Par défaut, (\code{output = NULL}) et un dossier "Output" est créé à l'adresse du workspace.
#' @param delete_existing_file utile uniquement si \code{rename_multi_documents = TRUE}, booléen indiquant s'il faut supprimer
#' les dossiers existants lors du renommage des dossiers. Par défaut, (\code{delete_existing_file = NULL}) et une boîte de dialogue s'ouvre
#' demandant l'action à réaliser.
#' @param log_file nom du fichier qui contiendra la log du cruncher. Par défaut, la log n'est pas exportée.
#' @param ... autres paramètres de la fonction \link{create_param_file}.
#' @encoding UTF-8
#' @return L'adresse du workspace.
#' @keywords internal
#' @name fr-cruncher_and_param
NULL
#> NULL


#' Combined cruncher launcher
#'
#' Function to simultaneously crunch a workspace and create its .params file
#'
#' @param workspace path to the workspace.
#' @param cruncher_bin_directory path to the cruncher "bin" folder.
#' @param rename_multi_documents boolean indicating whether to rename the output folders to the crunched multiprocessings' names. By default, \code{rename_multi_documents = TRUE}.
#' If \code{rename_multi_documents = FALSE}, the multiprocessings' xml files' names are used.
#' @param output folder containing the cruncher results. By default, (\code{output = NULL}) and an "Output" folder is created within the workspace folder.
#' @param delete_existing_file boolean indicating whether to delete pre-existing files when renaming the folders. Only used when \code{rename_multi_documents = TRUE}.
#' By default, (\code{delete_existing_file = NULL}) and a dialogue box opens, asking whether to delete the files.
#' @param log_file log file name. By default, no log file is generated.
#' @param ... other parameters of the function \link{create_param_file}.
#' @encoding UTF-8
#' @return The workspace path.
#' @family Cruncher functions
#' @seealso [Traduction française][fr-cruncher_and_param()]
#' @export
cruncher_and_param <- function(workspace = workspace,
                               cruncher_bin_directory = getOption("cruncher_bin_directory"),
                               rename_multi_documents = TRUE,
                               output = NULL,
                               delete_existing_file = NULL,
                               log_file = NULL,
                               ...) {

    dossier_temp <- tempdir()
    fichier_param <- create_param_file(dossier_temp, output = output, ...)
    workspace <- cruncher(workspace = workspace, cruncher_bin_directory = cruncher_bin_directory,
                          param_file_path = fichier_param, log_file = log_file)

    if (rename_multi_documents) {
        if (is.null(output))
            output <- paste0(sub("\\.xml", "", workspace), "\\Output")

        noms_multi_documents <- multiprocessing_names(workspace)
        if (nrow(noms_multi_documents) == 0)
            stop("There is no multiprocessing in the workspace!")
        noms_multi_documents$name <- paste0(output, "\\", noms_multi_documents$name)
        noms_multi_documents$file <- paste0(output, "\\", noms_multi_documents$file)
        noms_multi_documents <- noms_multi_documents[noms_multi_documents$name != noms_multi_documents$file, ]

        if (any(file.exists(noms_multi_documents$name))) {

            if (is.null(delete_existing_file)) {
                message <- paste("There is already at least one file in ", output, ".\nDo you want to clear the output folder?")
                delete_existing_file <- utils::winDialog(type = c("yesnocancel"),
                                                         message)

                delete_existing_file <- isTRUE(delete_existing_file == "YES")

            }
            if (delete_existing_file) {
                unlink(noms_multi_documents$name[file.exists(noms_multi_documents$name)],
                       recursive = TRUE)
                file.rename(from = noms_multi_documents$file, to = noms_multi_documents$name)
            } else {
                warning("There were pre-existing files in the output folder: none were removed or renamed.")
            }

        } else {
            file.rename(from = noms_multi_documents$file, to = noms_multi_documents$name)
        }

    }

    return(invisible(workspace))
}




#' Noms multiprocessings JDemetra+/XML
#'
#' Fonction qui permet d'extraire le nom des multiprocessings visibles sous JDemetra+ ainsi que celui des fichiers XML associés.
#'
#' @param workspace chemin vers le workspace.
#' @encoding UTF-8
#' @return Un \code{data.frame} contenant le nom des multiprocessings (colonne \code{name}) et celui des fichiers XML associés (colonne \code{file}).
#' @keywords internal
#' @name fr-multiprocessing_names
NULL
#> NULL


#' JDemetra+/XML multiprocessings names
#'
#' Function to extract multiprocessings names as seen in the JDemetra+ interface as well as their xml files' names.
#'
#' @param workspace path to the workspace.
#' @encoding UTF-8
#' @return a \code{data.frame} with the multiprocessing names as seen in the JDemetra+ interface (column \code{name}) and the corresponding xml files names (column \code{file}).
#' @seealso [Traduction française][fr-multiprocessing_names()]
#' @export
multiprocessing_names <- function(workspace) {
    if (missing(workspace) || is.null(workspace)) {
        stop("Please call multiprocessing_names() on a valid workspace")
    }

    if (length(workspace) == 0)
        stop("The first argument must be a non-null workspace path")

    if (length(workspace) > 1)
        stop("Please specify only one workspace path")

    workspace <- normalizePath(workspace, mustWork = FALSE)
    workspace <- paste0(sub("\\.xml$", "", workspace), ".xml")

    if (!file.exists(workspace))
        stop("The workspace doesn't exist")

    xml_workspace <- suppressWarnings(XML::xmlParse(workspace, error = function(...) {}))
    noms_objets <- XML::xmlToDataFrame(nodes = XML::getNodeSet(doc = xml_workspace, path = "//ns2:demetraGenericWorkspace/ns2:items/ns2:item"))
    noms_multi_documents <- noms_objets[grep("multi-documents", noms_objets$family), ]
    noms_multi_documents <- noms_multi_documents[, c("name", "file")]

    return(noms_multi_documents)
}




#' Mise à jour d'un workspace
#'
#' Fonction qui permet de mettre à jour un workspace sans exporter les résultats
#'
#' @param workspace chemin vers le workspace.
#' @param policy méthode de rafraîchissement utilisée. Par défaut, \code{policy = "parameters"} (paramètres re-estimés).
#' Les autres méthodes possibles sont :
#'
#' \code{"outliers"} (les outliers sont identifiés et les paramètres ré-estimés) ;
#'
#' \code{"lastoutliers"} (les outliers sont ré-identifiés sur la dernière année et les paramètres ré-estimés) ;
#'
#' \code{"stochastic"} (le modèle arima et les outliers sont identifiés et les paramètres ré-estimés) ;
#'
#' \code{"complete"} (le modèle est complétement ré-estimé).
#'
#' @param cruncher_bin_directory répertoire contenant contenant le dossier "bin" du cruncher.
#' @encoding UTF-8
#' @return L'adresse du workspace.
#' @keywords internal
#' @name fr-update_workspace
NULL
#> NULL


#' Workspace update
#'
#' Function to update a workspace without exporting the results
#'
#' @param workspace path to the workspace.
#' @param policy refresh policy. By default, \code{policy = "parameters"}.
#' The other methods available are:
#'
#' \code{"current"} or \code{"n"} (fixed model + all new data are classified as additive outliers)
#'
#' \code{"fixed"} or \code{"f"} (fixed model: the model is unchanged)
#'
#' \code{"fixedparameters"} or \code{"fp"} (re-estimation of the regression coefficients)
#'
#' \code{"parameters"} or \code{"p"} (above + re-estimation of the arima coefficients)
#'
#' \code{"lastoutliers"} or \code{"l"} (above + re-identification of the outliers over the last year)
#'
#' \code{"outliers"} or \code{"o"} (above + re-identification of the outliers over the whole series span)
#'
#' \code{"stochastic"} or \code{"s"} (above + re-estimation of the arima model (orders))
#'
#' \code{"complete"} or \code{"c"} (the model is completely re-estimated).
#'
#' @param cruncher_bin_directory path to the cuncher "bin" folder.
#' @encoding UTF-8
#' @return The workspace address.
#' @family Cruncher functions
#' @seealso [Traduction française][fr-update_workspace()]
#' @export
update_workspace <- function(workspace = workspace,
                             policy = "parameters",
                             cruncher_bin_directory = getOption("cruncher_bin_directory")) {

    dossier_temp <- tempdir()
    fichier_param <- create_param_file(dossier_temp, output = dossier_temp, policy = policy,
                                       matrix_item = NULL, tsmatrix_series = NULL)
    workspace <- cruncher(workspace = workspace, cruncher_bin_directory = cruncher_bin_directory,
                          param_file_path = fichier_param)

    return(invisible(workspace))
}
