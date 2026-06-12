# Exporting JVS_matrix objects in CSV or Excel files

To export several quality reports in CSV or Excel files

## Usage

``` r
# S3 method for class 'JVS_matrix'
write(
  x,
  format = c("csv", "xlsx"),
  export_dir = tempdir(),
  overwrite = TRUE,
  ...
)
```

## Arguments

- x:

  a
  [`JVS_matrix`](https://inseefr.github.io/JDCruncheR/reference/JVS_matrix.md)
  object to export.

- format:

  output format. One of `"csv"` or `"xlsx"`. The default is `"csv"`.

- export_dir:

  export directory.

- overwrite:

  logical indicating whether to create a CSV or Excel file if it doesn't
  exist yet (`create = TRUE` by default)

- ...:

  other unused arguments

## Value

Returns invisibly (via `invisible(x)`) the same
[`JVS_matrix`](https://inseefr.github.io/JDCruncheR/reference/JVS_matrix.md)
object as `x`.

## Details

- xlsx files will be exported with the package 'openxlsx'.

- csv files will be exported with the package 'utils'.

## See also

Other QR_matrix functions:
[`extract_QR()`](https://inseefr.github.io/JDCruncheR/reference/extract_QR.md),
[`rbind.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/rbind.QR_matrix.md),
[`sort`](https://inseefr.github.io/JDCruncheR/reference/sort.md),
[`weighted_score()`](https://inseefr.github.io/JDCruncheR/reference/weighted_score.md),
[`write()`](https://inseefr.github.io/JDCruncheR/reference/write.md),
[`write.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/write.QR_matrix.md),
[`write.mQR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/write.mQR_matrix.md)
