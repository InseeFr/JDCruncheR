
header_style <- openxlsx::createStyle(
    fontColour = "#ffffff",
    fgFill = "#4F80BD",
    textDecoration = "Bold",
    borderColour = "grey30"
)
severe_style <- openxlsx::createStyle(
    fontColour = "#ffffff",
    fgFill = "black", bgFill = "black",
    borderColour = "grey30",
    border = "TopBottomLeftRight"
)
bad_style <- openxlsx::createStyle(
    fontColour = "#9C0006",
    fgFill = "#FFC7CE", bgFill = "#FFC7CE",
    borderColour = "grey30",
    border = "TopBottomLeftRight"
)
good_style <- openxlsx::createStyle(
    fontColour = "#006100",
    fgFill = "#C6EFCE", bgFill = "#C6EFCE",
    borderColour = "grey30",
    border = "TopBottomLeftRight"
)
uncertain_style <- openxlsx::createStyle(
    fontColour = "#9c6a00",
    fgFill = "#ffeec7", bgFill = "#ffeec7",
    borderColour = "grey30",
    border = "TopBottomLeftRight"
)
border_style <- openxlsx::createStyle(
    border = "TopBottomLeftRight",
    borderColour = "grey30"
)
rowname_style <- openxlsx::createStyle(
    fontColour = "black",
    fgFill = "orange",
    textDecoration = "bold"
)


apply_BQ_style <- function(wb,
                           x,
                           values_sheet = NULL,
                           modalities_sheet = NULL) {

    if (!is.null(modalities_sheet)) {

        # Apply BQ style cell Modalities
        openxlsx::conditionalFormatting(
            wb = wb,
            sheet = modalities_sheet,
            rule = '=="Bad"',
            style = bad_style,
            cols = seq_len(ncol(x$modalities)),
            rows = 1 + seq_len(nrow(x$modalities))
        )
        openxlsx::conditionalFormatting(
            wb = wb,
            sheet = modalities_sheet,
            rule = '=="Good"',
            style = good_style,
            cols = seq_len(ncol(x$modalities)),
            rows = 1 + seq_len(nrow(x$modalities))
        )
        openxlsx::conditionalFormatting(
            wb = wb,
            sheet = modalities_sheet,
            rule = '=="Uncertain"',
            style = uncertain_style,
            cols = seq_len(ncol(x$modalities)),
            rows = 1 + seq_len(nrow(x$modalities))
        )
        openxlsx::conditionalFormatting(
            wb = wb,
            sheet = modalities_sheet,
            rule = '=="Severe"',
            style = severe_style,
            cols = seq_len(ncol(x$modalities)),
            rows = 1 + seq_len(nrow(x$modalities))
        )

        # Appliquer les styles aux bordures
        openxlsx::addStyle(
            wb = wb,
            sheet = modalities_sheet,
            style = border_style,
            cols = seq_len(ncol(x$modalities)),
            rows = 1 + seq_len(nrow(x$modalities)),
            gridExpand = TRUE
        )

        # Appliquer les styles aux noms de ligne (1ère colonne)
        openxlsx::addStyle(
            wb = wb,
            sheet = modalities_sheet,
            style = rowname_style,
            cols = 1,
            rows = 1 + seq_len(nrow(x$modalities)),
            gridExpand = TRUE
        )
    }

    if (!is.null(values_sheet)) {

        # Appliquer les styles aux bordures
        openxlsx::addStyle(
            wb = wb,
            sheet = values_sheet,
            style = border_style,
            cols = seq_len(ncol(x$values)),
            rows = 1 + seq_len(nrow(x$values)),
            gridExpand = TRUE
        )

        # Apply BQ style cell Modalities
        for (id_col in seq_len(ncol(x$values))) {
            name_col <- colnames(x$values)[id_col]
            if (name_col %in% colnames(x$modalities)) {
                for (id_row in seq_len(ncol(x$values))) {
                    cell_value <- as.character(x$modalities[id_row, name_col])
                    cell_style <- switch(
                        cell_value,
                        "Bad" = bad_style,
                        "Good" = good_style,
                        "Uncertain" = uncertain_style,
                        "Severe" = severe_style,
                        NULL
                    )
                    if (!is.null(cell_style)) {
                        openxlsx::addStyle(
                            wb = wb,
                            sheet = values_sheet,
                            style = cell_style,
                            rows = id_row + 1,
                            cols = id_col,
                            gridExpand = FALSE
                        )
                    }
                }
            }
        }

        # Appliquer les styles aux noms de ligne (1ère colonne)
        openxlsx::addStyle(
            wb = wb,
            sheet = values_sheet,
            style = rowname_style,
            cols = 1,
            rows = 1 + seq_len(nrow(x$values)),
            gridExpand = TRUE
        )
    }

    return(wb)
}

#' @title Export des objets QR_matrix dans un fichier Excel
#'
#' @description
#' Permet d'exporter un bilan qualité dans un fichier Excel.
#'
#' @param x objet de type \code{\link{QR_matrix}}.
#' @param file un objet de type \code{character} contenant le chemin menant au
#' fichier que l'on veut créer
#' @param auto_format booléen indiquant s'il faut formatter la sortie
#' (\code{auto_format = TRUE} par défaut).
#' @param overwrite booléen indiquant s'il faut ré-écrire créer le fichier Excel
#' s'il existe déjà (\code{create = TRUE} par défaut)
#' @param ... autres argument non utilisés
#'
#' @returns Renvoie de manière invisible (via \code{invisible(x)}) un objet de
#' classeur créé par \code{XLConnect::loadWorkbook()} pour une manipulation
#' ultérieure.
#'
#' @keywords internal
#' @name fr-export_xlsx.QR_matrix
NULL
#> NULL


#' @title Exporting QR_matrix objects in an Excel file
#'
#' @description
#' To export a quality report in an Excel file.
#'
#' @param x a \code{\link{QR_matrix}} object.
#' @param file a \code{character} object with the path to the file to export
#' que l'on veut créer
#' @param auto_format logical indicating whether to format the output
#' (\code{auto_format = TRUE} by default).
#' @param overwrite logical indicating whether to create an Excel file if it
#' doesn't exist yet (\code{create = TRUE} by default)
#' @param ... other unused arguments
#'
#' @returns Returns invisibly (via \code{invisible(x)}) a workbook object
#' created by \code{XLConnect::loadWorkbook()} for further manipulation.
#'
#' @family QR_matrix functions
#' @seealso [Traduction française][fr-export_xlsx.QR_matrix()]
#' @export
export_xlsx.QR_matrix <- function(x,
                                  file,
                                  auto_format = TRUE,
                                  overwrite = TRUE,
                                  ...) {

    ext <- tools::file_ext(file)
    if (nchar(ext) == 0) {
        file <- paste0(file, ".xslx")
    } else if (ext != "xlsx") {
        stop("The format of the file must be .xlsx .")
    }

    wb_qr <- openxlsx::createWorkbook(
        title = "QR for WS",
        subject = "Seasonal Adjustment"
    )

    openxlsx::addWorksheet(wb = wb_qr, sheetName = "Modalities")
    openxlsx::addWorksheet(wb = wb_qr, sheetName = "Values")

    openxlsx::writeData(
        wb = wb_qr,
        sheet = "Modalities",
        x = x$modalities,
        headerStyle = if (auto_format) header_style else NULL
    )
    openxlsx::writeData(
        wb = wb_qr,
        sheet = "Values",
        x = x$values,
        headerStyle = if (auto_format) header_style else NULL
    )

    if (auto_format) {
        wb_qr <- apply_BQ_style(wb = wb_qr, x = x,
                                values_sheet = "Values",
                                modalities_sheet = "Modalities")
    }

    openxlsx::saveWorkbook(wb = wb_qr, file = file, overwrite = overwrite)

    return(invisible(wb_qr))
}

#' @title Exporting QR_matrix or mQR_matrix objects in an Excel file
#'
#' @param x a \code{\link{QR_matrix}} or \code{\link{mQR_matrix}} object.
#' @param ... other parameters of the function
#' \code{\link{export_xlsx.QR_matrix}}.
#'
#' @returns
#' If \code{x} is a \code{\link{mQR_matrix}}, the function returns invisibly
#' (via \code{invisible(x)}) the same \code{\link{mQR_matrix}} object as
#' \code{x}.
#' Else if \code{x} is a \code{\link{QR_matrix}}, the function returns
#' invisibly (via \code{invisible(x)}) a workbook object created by
#' \code{XLConnect::loadWorkbook()} for further manipulation.
#'
#' @family QR_matrix functions
#' @export
export_xlsx <- function(x, ...) {
    UseMethod("export_xlsx", x)
}

#' @family QR_matrix functions
#' @export
export_xlsx.default <- function(x, ...) {
    stop("A QR_matrix or mQR_matrix object is required!")
}




#' Export des objets mQR_matrix dans des fichiers Excel
#'
#' Permet d'exporter dans des fichiers Excel une liste de bilan qualité
#'
#' @param x objet de type \code{\link{mQR_matrix}} à exporter.
#' @param export_dir dossier d'export des résultats.
#' @param layout_file paramètre d'export. Par défaut,
#' (\code{layout_file = "ByComponent"}) et un fichier Excel est exporté par
#' composante de la matrice bilan qualité (matrice des modalités ou des
#' valeurs), dont chaque feuille correspond à un bilan qualité. Pour avoir un
#' fichier par bilan qualité dont chaque feuille correspond à la composante
#' exportée, utiliser \code{layout_file = "ByQRMatrix"}.
#' La modalité \code{layout_file = "AllTogether"} correspond à la création d'un
#' fichier avec 2 feuilles par bilan qualité (\code{Values} et
#' \code{Modalities}).
#' @param auto_format booléen indiquant s'il faut formatter la sortie
#' (\code{auto_format = TRUE} par défaut).
#' @param overwrite booléen indiquant s'il faut ré-écrire créer le fichier Excel
#' s'il existe déjà (\code{create = TRUE} par défaut)
#' @param ... autres argument non utilisés
#'
#' @returns Renvoie de manière invisible (via \code{invisible(x)}) le même objet
#' \code{\link{mQR_matrix}} que \code{x}.
#'
#' @keywords internal
#' @name fr-export_xlsx.mQR_matrix
NULL
#> NULL


#' Exporting mQR_matrix objects in Excel files
#'
#' To export several quality reports in Excel files
#'
#' @param x a \code{\link{mQR_matrix}} object to export.
#' @param export_dir export directory.
#' @param layout_file export parameter. By default,
#' (\code{layout_file = "ByComponent"}) and an Excel file is exported for each
#' part of the quality report matrix (modalities and values matrices). To group
#' both modalities and values reports/sheets into a single Excel file, use the
#' option \code{layout_file = "ByQRMatrix"}.
#' @param auto_format logical indicating whether to format the output
#' (\code{auto_format = TRUE} by default).
#' @param overwrite logical indicating whether to create an Excel file if it
#' doesn't exist yet (\code{create = TRUE} by default)
#' @param ... other unused arguments
#'
#' @returns Returns invisibly (via \code{invisible(x)}) the same
#' \code{\link{mQR_matrix}} object as \code{x}.
#'
#' @family QR_matrix functions
#' @seealso [Traduction française][fr-export_xlsx.mQR_matrix()]
#' @export
export_xlsx.mQR_matrix <- function(
        x,
        export_dir,
        layout_file = c("ByComponent", "ByQRMatrix", "AllTogether"),
        auto_format = TRUE,
        overwrite = TRUE,
        ...) {

    #by component = 1file / component (different QR in same file) = 2 files
    #by QRMatrix = 1file / QR (different component in same file)
    #All together = All Qr and components in same file

    layout_file <- match.arg(layout_file)
    export_dir <- normalizePath(export_dir)

    if (layout_file == "ByQRMatrix") {
        for (id_qr in seq_along(x)) {
            qr <- x[[id_qr]]
            name <- ifelse(
                test = is.null(names(x)) || nchar(names(x)[id_qr]) == 0,
                yes = paste0("QR_", id_qr),
                no = names(x)[id_qr]
            )
            file <- file.path(export_dir, paste0(name, ".xlsx"))
            export_xlsx(x = qr,
                        file = file,
                        auto_format = auto_format,
                        overwrite = overwrite)
        }
    } else if (layout_file == "ByComponent") {

        wb_modalities <- openxlsx::createWorkbook(
            title = "Modalities of the QR",
            subject = "Seasonal Adjustment"
        )
        wb_values <- openxlsx::createWorkbook(
            title = "Values of the QR",
            subject = "Seasonal Adjustment"
        )

        for (id_qr in seq_along(x)) {
            qr <- x[[id_qr]]
            name <- ifelse(
                test = is.null(names(x)) || nchar(names(x)[id_qr]) == 0,
                yes = paste0("QR_", id_qr),
                no = names(x)[id_qr]
            )

            openxlsx::addWorksheet(wb = wb_modalities, sheetName = name)
            openxlsx::addWorksheet(wb = wb_values, sheetName = name)

            openxlsx::writeData(
                wb = wb_modalities,
                sheet = name,
                x = qr$modalities,
                headerStyle = if (auto_format) header_style else NULL
            )
            openxlsx::writeData(
                wb = wb_values,
                sheet = name,
                x = qr$values,
                headerStyle = if (auto_format) header_style else NULL
            )
            if (auto_format) {
                wb_modalities <- apply_BQ_style(wb = wb_modalities, x = qr,
                                                modalities_sheet = name)
                wb_values <- apply_BQ_style(wb = wb_values, x = qr,
                                            values_sheet = name)
            }
        }

        file_modalities <- file.path(export_dir, "modalities.xlsx")
        file_values <- file.path(export_dir, "values.xlsx")

        openxlsx::saveWorkbook(wb = wb_modalities,
                               file = file_modalities,
                               overwrite = overwrite)
        openxlsx::saveWorkbook(wb = wb_values,
                               file = file_values,
                               overwrite = overwrite)

    } else if (layout_file == "AllTogether") {

        wb_mqr <- openxlsx::createWorkbook(title = "Multiple QR",
                                           subject = "Seasonal Adjustment")

        for (id_qr in seq_along(x)) {
            qr <- x[[id_qr]]
            name <- ifelse(
                test = is.null(names(x))
                || nchar(names(x)[id_qr]) == 0
                || sum(names(x) == names(x)[id_qr]) > 1,
                yes = paste0("QR_", id_qr),
                no = names(x)[id_qr]
            )

            openxlsx::addWorksheet(
                wb = wb_mqr,
                sheetName = paste0(name, "_modalities")
            )
            openxlsx::addWorksheet(
                wb = wb_mqr,
                sheetName = paste0(name, "_values")
            )

            openxlsx::writeData(
                wb = wb_mqr,
                sheet = paste0(name, "_modalities"),
                x = qr$modalities,
                headerStyle = if (auto_format) header_style else NULL
            )
            openxlsx::writeData(
                wb = wb_mqr,
                sheet = paste0(name, "_values"),
                x = qr$values,
                headerStyle = if (auto_format) header_style else NULL
            )
            if (auto_format) {
                wb_mqr <- apply_BQ_style(wb = wb_mqr, x = qr,
                                         modalities_sheet = paste0(name, "_modalities"),
                                         values_sheet = paste0(name, "_values"))
            }
        }

        file <- file.path(export_dir, "mQR.xlsx")
        openxlsx::saveWorkbook(wb = wb_mqr, file = file, overwrite = overwrite)
    }

    return(invisible(x))
}
