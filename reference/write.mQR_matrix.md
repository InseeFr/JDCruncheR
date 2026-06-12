# Exporting mQR_matrix objects in Excel files

To export several quality reports in Excel files

## Usage

``` r
# S3 method for class 'mQR_matrix'
write(
  x,
  export_dir,
  layout_file = c("ByComponent", "ByQRMatrix", "AllTogether"),
  auto_format = TRUE,
  overwrite = TRUE,
  ...
)
```

## Arguments

- x:

  a
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  object to export.

- export_dir:

  export directory.

- layout_file:

  export parameter. By default, (`layout_file = "ByComponent"`) and an
  Excel file is exported for each part of the quality report matrix
  (modalities and values matrices). To group both modalities and values
  reports/sheets into a single Excel file, use the option
  `layout_file = "ByQRMatrix"`.

- auto_format:

  logical indicating whether to format the output (`auto_format = TRUE`
  by default).

- overwrite:

  logical indicating whether to create an Excel file if it doesn't exist
  yet (`create = TRUE` by default)

- ...:

  other unused arguments

## Value

Returns invisibly (via `invisible(x)`) the same
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
object as `x`.

## See also

[Traduction
française](https://inseefr.github.io/JDCruncheR/reference/fr-write.mQR_matrix.md)

Other QR_matrix functions:
[`extract_QR()`](https://inseefr.github.io/JDCruncheR/reference/extract_QR.md),
[`rbind.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/rbind.QR_matrix.md),
[`sort`](https://inseefr.github.io/JDCruncheR/reference/sort.md),
[`weighted_score()`](https://inseefr.github.io/JDCruncheR/reference/weighted_score.md),
[`write()`](https://inseefr.github.io/JDCruncheR/reference/write.md),
[`write.JVS_matrix()`](https://inseefr.github.io/JDCruncheR/reference/write.JVS_matrix.md),
[`write.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/write.QR_matrix.md)
