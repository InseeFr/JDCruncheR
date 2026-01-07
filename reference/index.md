# Package index

## Quality report

Functions to generate, edit and display a quality report

- [`extract_QR()`](https://inseefr.github.io/JDCruncheR/reference/extract_QR.md)
  : Extraction of a quality report
- [`QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  [`mQR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  [`is.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  [`is.mQR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  : Quality report objects
- [`rbind(`*`<QR_matrix>`*`)`](https://inseefr.github.io/JDCruncheR/reference/rbind.QR_matrix.md)
  : Combining QR_matrix objects
- [`print(`*`<QR_matrix>`*`)`](https://inseefr.github.io/JDCruncheR/reference/print.QR_matrix.md)
  [`print(`*`<mQR_matrix>`*`)`](https://inseefr.github.io/JDCruncheR/reference/print.QR_matrix.md)
  : Printing QR_matrix and mQR_matrix objects

## Manage indicator

Functions to add, remove and custom the variables and indicators
available

- [`compute_score(`*`<QR_matrix>`*`)`](https://inseefr.github.io/JDCruncheR/reference/compute_score.md)
  [`compute_score(`*`<mQR_matrix>`*`)`](https://inseefr.github.io/JDCruncheR/reference/compute_score.md)
  : Score calculation
- [`weighted_score()`](https://inseefr.github.io/JDCruncheR/reference/weighted_score.md)
  : Weighted score calculation
- [`extract_score()`](https://inseefr.github.io/JDCruncheR/reference/extract_score.md)
  : Score extraction
- [`remove_indicators()`](https://inseefr.github.io/JDCruncheR/reference/QR_var_manipulation.md)
  [`retain_indicators()`](https://inseefr.github.io/JDCruncheR/reference/QR_var_manipulation.md)
  : Editing the indicators list
- [`add_indicator()`](https://inseefr.github.io/JDCruncheR/reference/add_indicator.md)
  : Adding an indicator in QR_matrix objects
- [`recode_indicator_num()`](https://inseefr.github.io/JDCruncheR/reference/recode_indicator_num.md)
  : Converting "values variables" into "modalities variables"
- [`sort(`*`<QR_matrix>`*`)`](https://inseefr.github.io/JDCruncheR/reference/sort.md)
  [`sort(`*`<mQR_matrix>`*`)`](https://inseefr.github.io/JDCruncheR/reference/sort.md)
  : QR_matrix and mQR_matrix sorting

## Export

Functions to export a quality report

- [`export_xlsx(`*`<mQR_matrix>`*`)`](https://inseefr.github.io/JDCruncheR/reference/export_xlsx.mQR_matrix.md)
  : Exporting mQR_matrix objects in Excel files
- [`export_xlsx(`*`<QR_matrix>`*`)`](https://inseefr.github.io/JDCruncheR/reference/export_xlsx.QR_matrix.md)
  : Exporting QR_matrix objects in an Excel file
- [`export_xlsx()`](https://inseefr.github.io/JDCruncheR/reference/export_xlsx.md)
  : Exporting QR_matrix or mQR_matrix objects in an Excel file

## Threshold

Functions to manage, reset and custom thresholds

- [`get_thresholds()`](https://inseefr.github.io/JDCruncheR/reference/get_thresholds.md)
  : Get all (default) thresholds
- [`set_thresholds()`](https://inseefr.github.io/JDCruncheR/reference/set_thresholds.md)
  : Set values for thresholds
