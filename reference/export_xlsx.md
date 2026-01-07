# Exporting QR_matrix or mQR_matrix objects in an Excel file

Exporting QR_matrix or mQR_matrix objects in an Excel file

## Usage

``` r
export_xlsx(x, ...)
```

## Arguments

- x:

  a
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  or
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  object.

- ...:

  other parameters of the function
  [`export_xlsx.QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/export_xlsx.QR_matrix.md).

## Value

If `x` is a
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md),
the function returns invisibly (via `invisible(x)`) the same
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
object as `x`. Else if `x` is a
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md),
the function returns invisibly (via `invisible(x)`) a workbook object
created by `XLConnect::loadWorkbook()` for further manipulation.

## See also

Other QR_matrix functions:
[`export_xlsx.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/export_xlsx.QR_matrix.md),
[`export_xlsx.mQR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/export_xlsx.mQR_matrix.md),
[`extract_QR()`](https://inseefr.github.io/JDCruncheR/reference/extract_QR.md),
[`rbind.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/rbind.QR_matrix.md),
[`sort()`](https://inseefr.github.io/JDCruncheR/reference/sort.md),
[`weighted_score()`](https://inseefr.github.io/JDCruncheR/reference/weighted_score.md)
