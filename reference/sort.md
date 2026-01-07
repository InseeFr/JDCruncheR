# QR_matrix and mQR_matrix sorting

To sort the quality reports on one or several variables

## Usage

``` r
# S3 method for class 'QR_matrix'
sort(x, decreasing = FALSE, sort_variables = "score", ...)

# S3 method for class 'mQR_matrix'
sort(x, decreasing = FALSE, sort_variables = "score", ...)
```

## Arguments

- x:

  a
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  or
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  object

- decreasing:

  logical indicating whether the quality reports must be sorted in
  ascending or decreasing order. By default, the sorting is done in
  ascending order.

- sort_variables:

  They must be present in the modalities table.

- ...:

  other parameters of the function
  [`order`](https://rdrr.io/r/base/order.html) (unused for now)

## Value

the input with sorted quality reports

## See also

[Traduction
française](https://inseefr.github.io/JDCruncheR/reference/fr-sort.QR_matrix.md)

Other QR_matrix functions:
[`export_xlsx()`](https://inseefr.github.io/JDCruncheR/reference/export_xlsx.md),
[`export_xlsx.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/export_xlsx.QR_matrix.md),
[`export_xlsx.mQR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/export_xlsx.mQR_matrix.md),
[`extract_QR()`](https://inseefr.github.io/JDCruncheR/reference/extract_QR.md),
[`rbind.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/rbind.QR_matrix.md),
[`weighted_score()`](https://inseefr.github.io/JDCruncheR/reference/weighted_score.md)

## Examples

``` r
# Path of matrix demetra_m
demetra_path <- file.path(
    system.file("extdata", package = "JDCruncheR"),
    "WS/ws_ipi/Output/SAProcessing-1",
    "demetra_m.csv"
)

# Extract the quality report from the demetra_m file
QR <- extract_QR(demetra_path)
#> Multiple column found for extraction of q statistic
#> First column selected
#> Multiple column found for extraction of q-m2 statistic
#> First column selected
#> Multiple column found for extraction of mean
#> Last column selected

# Compute the score
QR <- compute_score(QR, n_contrib_score = 2)
print(QR[["modalities"]][["score"]])
#>  [1] 145  45 300 310  30 195 560 560 505 545 255 310 535

# Sort the scores

# To sort by ascending scores
QR <- sort(QR, sort_variables = "score")
print(QR[["modalities"]][["score"]])
#>  [1]  30  45 145 195 255 300 310 310 505 535 545 560 560
```
