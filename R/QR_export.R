#' Exporting QR_matrix objects in an Excel file
#'
#' To export a quality report in an Excel file.
#'
#' @param x a \code{QR_matrix} object.
#' @param layout the components of the report to export. By default, \code{layout = "all"}: the matrices modalities
#' (\code{"modalities"}) and values (\code{"values"}) are exported in separate files. To export them in a single file (in two sheets),
#' use \code{layout = "combined"}.
#' @param create logical indicating whether to create an Excel file if it doesn't exist yet (\code{create = TRUE} by default)
#' @param clear_sheet logical indicating whether to clear the Excel sheets before the export (\code{clear_sheet = TRUE} by default).
#' @param auto_format logical indicating whether to format the output (\code{auto_format = TRUE} by default).
#' @param file_name optional argument to choose the path and name of the file to export. If not specified, an *export.xls* will be created in the working directory.
#' @param sheet_names names of the exported Excel sheets. If not specified, the sheets will be named after the exported components.
#' If specified, existing sheets with these names will be overwritten.
#' @param ... other unused parameters.
#' @family QR_matrix functions
#' @export
export_xlsx.QR_matrix <- function(x, layout = c("all","modalities", "values", "combined"), file_name, sheet_names, ...) {
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
    stop("A QR_matrix or mQR_matrix object is required!")
}

#' Exporting mQR_matrix objects in Excel files
#'
#' To export several quality reports in Excel files
#'
#' @param x a\code{mQR_matrix} object to export.
#' @param export_dir export directory.
#' @param layout_file export parameter. By default, (\code{layout_file = "ByComponent"}) and an Excel file is exported for each part of the
#' quality report matrix (modalities and values matrices). To group both modalities and values reports/sheets into a single Excel file, use the option \code{layout_file = "ByQRMatrix"}.
#' @param file_extension possible values are (\code{".xls"} and \code{".xlsx"}).
#' @param layout elements of the report to export: see \code{\link{export_xlsx.QR_matrix}} .
#' @param ... other parameters of the function \code{\link{export_xlsx.QR_matrix}}.
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
        # To export a quality report per file:
        files_name <- normalizePath(file.path(export_dir,
                                             paste0(QR_matrix_names, file_extension)),
            mustWork = FALSE)
        for(i in 1:length(x)){
            export_xlsx(x[[i]],layout = layout, file_name = files_name[i], ...)
        }
    }else{
        # To export a file per element of the quality report
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
            # Index on the QR_matrix
            for(j in 1:length(final_layout)){
                # Index on the elements
                export_xlsx(x[[i]],layout = final_layout[j], file_name = files[j],
                            sheet_names = QR_matrix_names[i],
                            ...)
            }
        }

    }

    return(invisible(x))
}

