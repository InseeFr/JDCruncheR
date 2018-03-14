#' Export des objets QR_matrix dans un fichier Excel
#'
#' Permet d'exporter un bilan qualité dans un fichier Excel.
#'
#' @param x objet de type \code{QR_matrix}.
#' @param layout composantes du bilan à exporter. Par défaut \code{layout = "all"} : la matrice des modalités
#' (\code{"modalities"}) et celle des valeurs (\code{"values"}) sont exportées. Pour exporter la matrice
#' des modalités avec en plus les variables supplémentaires de la matrice des valeurs, utiliser
#' \code{layout = "combined"}.
#' @param create booléen indiquant s'il faut créer le fichier excel ou non (\code{create = TRUE} par défaut)
#' @param clear_sheet booléen indiquant s'il faut nettoyer les feuilles du fichier Excel avant l'export (
#' \code{clear_sheet = TRUE} par défaut).
#' @param auto_format booléen indiquant s'il faut formatter la sortie (\code{auto_format = TRUE} par défaut).
#' @param file_name argument optionnel indiquant chemin vers le fichier à exporter. Si no spécifié
#' alors un fichier *export.xls* est créé dans le working directory.
#' @param sheet_names nom des feuilles Excel en sortie. Si non spécifié alors le nom correspond à la composante exportée.
#' Si le paramètre est spécifié alors les éventuelles feuilles contenant ces noms sont supprimées.
#' @param ... autres paramètres non utilisés.
#' @family QR_matrix functions
#' @export
export_xlsx.QR_matrix <- function(x, layout = c("all","modalities", "values", "combined"),
                                  create = TRUE, clear_sheet = TRUE, auto_format = TRUE,
                                  file_name, sheet_names, ...) {
    layout <- match.arg(layout)
    file_name <- ifelse(missing(file_name), "export.xls", file_name)
    wb <- XLConnect::loadWorkbook(filename = file_name, create = create)
    sheets <- switch(layout, all = c("modalities", "values"),
                     combined = "values",
                     layout)
    exp_data <- switch(layout, combined = {
        data_v <- x[["values"]]
        data_m <- x[["modalities"]]
        joint_names <- colnames(data_m)[colnames(data_m) %in% colnames(data_v)]
        data_v[, joint_names] <- data_m[, joint_names]
        list(values = data_v)
    }, x)
    XLConnect::createSheet(wb, sheets)
    if (clear_sheet) {
        XLConnect::clearSheet(wb, sheets)
    }

    XLConnect::setStyleAction(wb,
                              XLConnect::XLC$STYLE_ACTION.DATA_FORMAT_ONLY)
    if (auto_format) {
        XLConnect::setDataFormatForType(wb,
                                        type = XLConnect::XLC$DATA_TYPE.NUMERIC,
                                        format = "0.000")

        cs <- XLConnect::createCellStyle(wb)
        XLConnect::setBorder(cs, side = "all",
                             type = XLConnect::XLC$BORDER.THIN,
                             color = XLConnect::XLC$COLOR.BLACK)
    }
    for (s in sheets) {
        data <- exp_data[[s]]
        XLConnect::writeWorksheet(wb, data = data, sheet = s, header = TRUE)
        if (auto_format) {
            XLConnect::setCellStyle(wb, sheet = s, row = 1:(nrow(data) + 1),
                                    col = 1:ncol(data), cellstyle = cs)
            XLConnect::setCellStyle(wb,
                                    formula = paste0(s, "!", "$A$1:",
                                                     XLConnect::idx2cref(c(nrow(data) + 1, ncol(data)))),
                                    cellstyle = cs)
            XLConnect::setColumnWidth(wb, sheet = s, column = 1:(ncol(data)),
                                      width = -1)
        }
    }
    if(!missing(sheet_names) && length(sheet_names) == length(sheets)){
        XLConnect::removeSheet(wb, sheet = sheet_names)
        XLConnect::renameSheet(wb, sheets, sheet_names)
    }
    XLConnect::saveWorkbook(wb)
    return(invisible(wb))
}
#' @export
export_xlsx <- function(x, ...){
    UseMethod("export_xlsx", x)
}
#' @export
export_xlsx.default <- function(x, ...){
    stop("Il faut un objet de type QR_matrix ou mQR_matrix")
}

#' Export des objets mQR_matrix dans des fichiers Excel
#'
#' Permet d'exporter dans des fichiers Excel une liste de bilan qualité
#'
#' @param x objet de type \code{mQR_matrix} à exporter.
#' @param export_dir dossier d'export des résultats.
#' @param layout_file paramètre d'export. Par défaut (\code{layout_file = "ByComponent"}) on a un fichier Excel par composante
#' de la matrice bilan qualité (matrice des modalités ou des valeurs) dont chaque feuille correspond à un bilan qualité. Pour avoir
#' un fichier par bilan qualité dont chaque feuille correspond à la composante exportée, utiliser \code{layout_file = "ByQRMatrix"}.
#' @param file_extension extension des fichiers (\code{".xls"} ou \code{".xlsx"}).
#' @param layout composantes du bilan à exporter : voir \code{\link{export_xlsx.QR_matrix}} .
#' @param ... autres paramètres de la fonction \code{\link{export_xlsx.QR_matrix}}.
#' @family QR_matrix functions
#' @export
export_xlsx.mQR_matrix <- function(x, export_dir = "./",
                                   layout_file = c("ByComponent","ByQRMatrix"),
                                   file_extension = c(".xls",".xlsx"),
                                   layout = c("all","modalities", "values", "combined"),
                                   ...){
    if(length(x) == 0)
        return(invisible(x))
    file_extension <- match.arg(file_extension)
    layout_file <- match.arg(layout_file)
    layout <- match.arg(layout)

    QR_matrix_names <- names(x)

    if(is.null(QR_matrix_names)){
        QR_matrix_names <- paste0("QR_",1:length(x))
    }else{
        QR_matrix_names[is.na(QR_matrix_names)] <- ""
        if(!is.na(match("", QR_matrix_names)))
            QR_matrix_names[match("", QR_matrix_names)] <- paste0("QR_",
                                                                  match("", QR_matrix_names))
    }


    if(layout_file == "ByQRMatrix"){
        #On exporte un fichier par bilan :
        files_name <- normalizePath(file.path(export_dir,
                                             paste0(QR_matrix_names, file_extension)),
            mustWork = FALSE)
        for(i in 1:length(x)){
            export_xlsx(x[[i]],layout = layout, file_name = files_name[i], ...)
        }
    }else{
        #On rassemble les bilans dans un fichier par composante
        files_name <- switch(layout,
                             all = c("modalities", "values"),
                             combined = "values",
                             layout)
        final_layout <- switch(layout,
                         all = c("modalities", "values"),
                         layout)

        files = normalizePath(
            file.path(export_dir,paste0(files_name, file_extension)),
            mustWork = FALSE)
        for(i in 1:length(x)){
            #Indice sur les QR_matrix
            for(j in 1:length(final_layout)){
                #Indice sur les composantes
                export_xlsx(x[[i]],layout = final_layout[j], file_name = files[j],
                            sheet_names = QR_matrix_names[i],
                            ...)
            }
        }

    }

    return(invisible(x))
}

