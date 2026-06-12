# Exporting QR_matrix objects in an Excel file

To export a quality report in an Excel file.

## Usage

``` r
# S3 method for class 'QR_matrix'
write(x, file, auto_format = TRUE, overwrite = TRUE, ...)
```

## Arguments

- x:

  a
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  object.

- file:

  a `character` object with the path to the file to export que l'on veut
  créer

- auto_format:

  logical indicating whether to format the output (`auto_format = TRUE`
  by default).

- overwrite:

  logical indicating whether to create an Excel file if it doesn't exist
  yet (`create = TRUE` by default)

- ...:

  other unused arguments

## Value

Returns invisibly (via `invisible(x)`) a workbook object created by
`XLConnect::loadWorkbook()` for further manipulation.

## See also

[Traduction
française](https://inseefr.github.io/JDCruncheR/reference/fr-write.QR_matrix.md)

Other QR_matrix functions:
[`extract_QR()`](https://inseefr.github.io/JDCruncheR/reference/extract_QR.md),
[`rbind.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/rbind.QR_matrix.md),
[`sort`](https://inseefr.github.io/JDCruncheR/reference/sort.md),
[`weighted_score()`](https://inseefr.github.io/JDCruncheR/reference/weighted_score.md),
[`write()`](https://inseefr.github.io/JDCruncheR/reference/write.md),
[`write.JVS_matrix()`](https://inseefr.github.io/JDCruncheR/reference/write.JVS_matrix.md),
[`write.mQR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/write.mQR_matrix.md)
