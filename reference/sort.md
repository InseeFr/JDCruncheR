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
[`extract_QR()`](https://inseefr.github.io/JDCruncheR/reference/extract_QR.md),
[`rbind.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/rbind.QR_matrix.md),
[`weighted_score()`](https://inseefr.github.io/JDCruncheR/reference/weighted_score.md),
[`write()`](https://inseefr.github.io/JDCruncheR/reference/write.md),
[`write.JVS_matrix()`](https://inseefr.github.io/JDCruncheR/reference/write.JVS_matrix.md),
[`write.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/write.QR_matrix.md),
[`write.mQR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/write.mQR_matrix.md)

## Examples

``` r
# Path of matrix demetra_m
demetra_path <- file.path(
    system.file("extdata", package = "JDCruncheR"),
    "WS/WS_world/Output/SAProcessing-1",
    "demetra_m.csv"
)

# Extract the quality report from the demetra_m file
QR <- extract_QR(demetra_path)
#> Multiple column found for extraction of diagnostics.seas-i-qs:2, diagnostics.seas-i-qs
#> Last column selected
#> Multiple column found for extraction of diagnostics.seas-i-f:2, diagnostics.seas-i-f
#> Last column selected

# Compute the score
QR <- compute_score(QR, n_contrib_score = 2)
print(QR[["modalities"]][["score"]])
#> [1]   0   0 195  15  10  40

# Sort the scores

# To sort by ascending scores
QR <- sort(QR, sort_variables = "score")
print(QR[["modalities"]][["score"]])
#> [1]   0   0  10  15  40 195
```
