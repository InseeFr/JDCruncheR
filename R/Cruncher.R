#' Lanceur de cruncher
#'
#' Fonction qui permet de lancer le cruncher sur un workspace à partir d'un fichier de paramètres.
#'
#' @param workspace chemin vers le workspace.
#' @param cruncher_bin_directory répertoire contenant contenant le dossier "Bin" du cruncher. Pour voir la
#' valeur par défaut exécuter le code \code{getOption("cruncher_bin_directory")}.
#' @param param_file_path chemin vers le fichier des paramètres à utiliser pour lancer le workspace.
#' Par défaut un fichier .params est recherché au même niveau que le workspace.
#' @param log_file nom du fichier qui contiendra la log du cruncher. Par défaut la log n'est pas exportée
#' @encoding UTF-8
#' @return L'adresse du workspace.
#' @family Cruncher functions
#' @export
cruncher <- function(workspace,
                     cruncher_bin_directory = getOption("cruncher_bin_directory"),
                     param_file_path, log_file){
    if(missing(workspace) || is.null(workspace)){
        if(Sys.info()[['sysname']] == "Windows"){
            workspace <- utils::choose.files(caption = "Sélectionner un workspace",
                                             filters = c("Fichier XML","*.xml"))
        }else{
            workspace <- base::file.choose()
        }
    }

    if(length(workspace) == 0)
        stop("Il faut sélectionner un workspace")

    if(length(workspace) > 1)
        stop("Il ne faut sélectionner qu'un workspace")

    #Il faut l'adresse entière du workspace et non pas l'adresse relative
    workspace <- normalizePath(workspace, mustWork = FALSE)
    workspace <- sub("\\.xml$","",workspace) #On enlève le .xml s'il existe dans l'adresse du workspace

    if(missing(param_file_path) || is.null(param_file_path)){
        param_file_path <- list.files(path = workspace,
                                      recursive = TRUE,
                                      pattern = "\\.params$",
                                      full.names = TRUE)
        if(length(param_file_path)!=0)
            stop("Aucun ou au moins 2 fichiers .param sont trouvés")
    }
    workspace <- paste0(workspace,".xml")

    if(!all(file.exists(paste0(cruncher_bin_directory,"/jwsacruncher"),
                        workspace,
                        param_file_path)))
        stop("Il y a une erreur dans l'adresse des paramètres, dans l'adresse du cruncher ou dans l'adresse du workspace")

    wd <- getwd()
    setwd(cruncher_bin_directory)

    log <- shell(paste0(
        "jwsacruncher \""
        , workspace
        ,"\" -x \""
        , param_file_path,"\""
    ), intern = TRUE)

    setwd(wd)

    if(!missing(log_file) && !is.null(log_file))
        writeLines(text = log, con = log_file)

    return(invisible(workspace))
}

#' Lanceur rapide de cruncher
#'
#' Fonction qui permet de lancer le cruncher sur un workspace tout en créant le fichier des paramètres.
#'
#' @param workspace chemin vers le workspace. Par défaut une fenêtre s'ouvre pour sélectionner le workspace.
#' @param cruncher_bin_directory répertoire contenant contenant le dossier "Bin" du cruncher.
#' @param rename_multi_documents booléen indiquant s'il faut renommer les dossiers contenant les sorties en fonction
#' des noms des multi-documents du workspace. Par défaut \code{rename_multi_documents = TRUE}.
#' Si \code{rename_multi_documents = FALSE} alors ce sont les noms des fichiers XML des multi_documents qui sont utilisés.
#' @param output dossier contenant les résultats du cruncher. Par défaut (\code{output = NULL}) un dossier "Output" est créé à l'adresse du workspace.
#' @param delete_existing_file utile uniquement si \code{rename_multi_documents = TRUE}, booléen indiquant s'il faut supprimer
#' les dossiers existants lors du renommage des dossiers. Par défaut (\code{delete_existing_file = NULL}) une boîte de dialogue s'ouvre
#' demandant l'action à réaliser.
#' @param log_file nom du fichier qui contiendra la log du cruncher. Par défaut la log n'est pas exportée
#' @param ... autres paramètres de la fonction \link{create_param_file}.
#' @encoding UTF-8
#' @return L'adresse du workspace.
#' @family Cruncher functions
#' @export
cruncher_and_param <- function(workspace = NULL,
                               cruncher_bin_directory = getOption("cruncher_bin_directory"),
                               rename_multi_documents = TRUE,
                               output = NULL,
                               delete_existing_file = NULL,
                               log_file = NULL,
                               ...){

    dossier_temp <- tempdir()
    fichier_param <- create_param_file(dossier_temp, output = output, ...)
    workspace <- cruncher(workspace = workspace, cruncher_bin_directory = cruncher_bin_directory,
                          param_file_path = fichier_param, log_file = log_file)

    if(rename_multi_documents){
        if(is.null(output))
            output <- paste0(sub("\\.xml","",workspace),"\\Output")

        noms_multi_documents <- multiprocessing_names(workspace)
        if (nrow(noms_multi_documents) == 0)
            stop("Aucun multi-document dans le workspace")
        noms_multi_documents$name <- paste0(output,"\\",noms_multi_documents$name)
        noms_multi_documents$file <- paste0(output,"\\",noms_multi_documents$file)
        noms_multi_documents <- noms_multi_documents[noms_multi_documents$name != noms_multi_documents$file,]

        if(any(file.exists(noms_multi_documents$name))){
            # Un des fichiers existe déjà !
            if(is.null(delete_existing_file)){
                message <- paste("Un ou plusieurs dossiers présents sous",output,"existent déjà.\nVoulez-vous le(s) supprimer ?")
                delete_existing_file <- winDialog(type = c("yesnocancel"),
                                                  message)

                delete_existing_file <- isTRUE(delete_existing_file=="YES")

            }
            if(delete_existing_file){
                unlink(noms_multi_documents$name[file.exists(noms_multi_documents$name)],
                       recursive = TRUE)
                file.rename(from = noms_multi_documents$file, to = noms_multi_documents$name)
            }else{
                warning("Certains dossiers existent déjà : aucun dossier n'est renommé")
            }

        }else{
            file.rename(from = noms_multi_documents$file, to = noms_multi_documents$name)
        }

    }

    return(invisible(workspace))
}

#' Noms multiprocessings JDemetra+/XML
#'
#' Fonction qui permet d'extraire le nom des multiprocessings sous JDemetra+ et les noms des fichiers XML associés.
#'
#' @param workspace chemin vers le workspace. Par défaut une fenêtre s'ouvre pour sélectionner le workspace.
#' @encoding UTF-8
#' @return Un \code{data.frame} contenant le nom des multiprocessings sous JDemetra+ (colonne \code{name}) et
#' le nom des fichiers XML associés (colonne \code{file})
#' @export
multiprocessing_names <- function(workspace){
    if(missing(workspace) || is.null(workspace)){
        if(Sys.info()[['sysname']] == "Windows"){
            workspace <- utils::choose.files(caption = "Sélectionner un workspace",
                                             filters = c("Fichier XML","*.xml"))
        }else{
            workspace <- base::file.choose()
        }
    }

    if(length(workspace) == 0)
        stop("Il faut sélectionner un workspace")
    if(length(workspace) > 1)
        stop("Il ne faut sélectionner qu'un workspace")

    workspace <- normalizePath(workspace, mustWork = FALSE)
    workspace <- paste0(sub("\\.xml$","",workspace),".xml")

    if(!file.exists(workspace))
        stop("Le workspace n'existe pas")

    xml_workspace <- suppressWarnings(XML::xmlParse(workspace, error = function(...){}))
    noms_objets <- XML::xmlToDataFrame(nodes = XML::getNodeSet(xml_workspace,
                                                               "//ns2:demetraGenericWorkspace/ns2:items/ns2:item"))
    noms_multi_documents <- noms_objets[grep("multi-documents",noms_objets$family),]
    noms_multi_documents <- noms_multi_documents[,c("name","file")]


    return(noms_multi_documents)
}

#' Mise à jour d'un workspace
#'
#' Fonction qui permet de mettre à jour un workspace sans exporter les résultats
#'
#' @param workspace chemin vers le workspace. Par défaut une fenêtre s'ouvre pour sélectionner le workspace.
#' @param policy méthode de rafraîchissement utilisée. Par défaut \code{policy = "parameters"} (paramètres re-estimés).
#' Les autres méthodes possibles sont :
#' \code{"outliers"} (les outliers sont identifiés et les paramètres re-estimés) ;
#' \code{"lastoutliers"} (les outliers sont ré-identifiés sur la dernière année et les paramètres re-estimés) ;
#' \code{"stochastic"} (le modèle arima et les outliers sont identifiés et les paramètres re-estimés) ;
#' \code{"complete"} (le modèle est complétement ré-estimé).
#' @param cruncher_bin_directory répertoire contenant contenant le dossier "Bin" du cruncher.
#' @encoding UTF-8
#' @return L'adresse du workspace.
#' @family Cruncher functions
#' @export
update_workspace <- function(workspace = NULL,
                             policy = "parameters",
                             cruncher_bin_directory = getOption("cruncher_bin_directory")){

    dossier_temp <- tempdir()
    fichier_param <- create_param_file(dossier_temp, output = dossier_temp, policy = policy,
                                       matrix_item = NULL, tsmatrix_series = NULL)
    workspace <- cruncher(workspace = workspace, cruncher_bin_directory = cruncher_bin_directory,
                          param_file_path = fichier_param)


    return(invisible(workspace))
}
