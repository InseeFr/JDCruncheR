# Score extraction

To extract score variables from
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
or
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
objects.

## Usage

``` r
extract_score(
  x,
  format_output = c("data.frame", "vector"),
  weighted_score = FALSE
)
```

## Arguments

- x:

  a
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  or
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

- format_output:

  string of characters indicating the output format: either a
  `data.frame` or a `vector`.

- weighted_score:

  logical indicating whether to extract the weighted score (if
  previously calculated) or the unweighted one. By default, the
  unweighted score is extracted.

## Value

`extract_score()` returns a data.frame with two column: the series name
and their score.

## Details

For
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
objects, the output is a vector or the object `NULL` if no score was
previously calculated. For
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
objects, it is a list of scores (`NULL` elements or vectors).

## See also

[Traduction
française](https://inseefr.github.io/JDCruncheR/reference/fr-extract_score.md)

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
QR1 <- compute_score(x = QR, n_contrib_score = 5)
QR2 <- compute_score(
    x = QR,
    score_pond = c(qs_residual_s_on_sa = 5, qs_residual_sa_on_i = 30,
                   f_residual_td_on_sa = 10, f_residual_td_on_i = 40,
                   oos_mean = 30, residuals_skewness = 15, m7 = 25)
)
mQR <- mQR_matrix(list(a = QR1, b = QR2))

# Extract score
extract_score(QR1)
#>    series score
#> 1  RF0610   145
#> 2  RF0620    45
#> 3  RF0811   300
#> 4  RF0812   310
#> 5  RF0893    30
#> 6  RF0899   195
#> 7  RF1011   560
#> 8  RF1012   560
#> 9  RF1013   505
#> 10 RF1020   545
#> 11 RF1031   255
#> 12 RF1032   310
#> 13 RF1039   535
extract_score(mQR)
#> $a
#>    series score
#> 1  RF0610   145
#> 2  RF0620    45
#> 3  RF0811   300
#> 4  RF0812   310
#> 5  RF0893    30
#> 6  RF0899   195
#> 7  RF1011   560
#> 8  RF1012   560
#> 9  RF1013   505
#> 10 RF1020   545
#> 11 RF1031   255
#> 12 RF1032   310
#> 13 RF1039   535
#> 
#> $b
#>    series score
#> 1  RF0610    70
#> 2  RF0620    45
#> 3  RF0811   215
#> 4  RF0812   250
#> 5  RF0893     0
#> 6  RF0899   150
#> 7  RF1011   425
#> 8  RF1012   425
#> 9  RF1013   475
#> 10 RF1020   365
#> 11 RF1031   110
#> 12 RF1032   250
#> 13 RF1039   380
#> 
```
