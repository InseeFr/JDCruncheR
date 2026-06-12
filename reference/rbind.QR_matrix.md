# Combining QR_matrix objects

Function to combine multiple
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
objects: line by line, both for the `modalities` and the `values` table.

## Usage

``` r
# S3 method for class 'QR_matrix'
rbind(..., check_formula = TRUE)
```

## Arguments

- ...:

  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  objects to combine.

- check_formula:

  logical indicating whether to check the score formulas' coherency. By
  default, `check_formula = TRUE`: an error is returned if the scores
  were calculated with different formulas. If `check_formula = FALSE`,
  no check is performed and the `score_formula` of the output is `NULL`.

## Value

`rbind.QR_matrix()` returns a
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
object.

## See also

[Traduction
française](https://inseefr.github.io/JDCruncheR/reference/fr-rbind.QR_matrix.md)

Other QR_matrix functions:
[`extract_QR()`](https://inseefr.github.io/JDCruncheR/reference/extract_QR.md),
[`sort`](https://inseefr.github.io/JDCruncheR/reference/sort.md),
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

# Compute differents scores
QR1 <- compute_score(QR, score_pond = c(m7 = 2, q = 3, qs_residual_s_on_sa = 5))
QR2 <- compute_score(QR, score_pond = c(m7 = 2, qs_residual_s_on_sa = 5))

# Merge two quality report
try(rbind(QR1, QR2)) # Une erreur est renvoyée
#> Error : All QR_matrices must have the same score formulas.
rbind(QR1, QR2, check_formula = FALSE)
#> The quality report matrix has 12 observations
#> There are 19 indicators in the modalities matrix and 21 indicators in the values matrix
#> 
#> The quality report matrix contains the following variables:
#> series  residuals_homoskedasticity  residuals_skewness  residuals_kurtosis  residuals_normality  residuals_independency  qs_residual_s_on_sa  f_residual_s_on_sa  qs_residual_sa_on_i  f_residual_sa_on_i  f_residual_td_on_sa  f_residual_td_on_i  oos_mean  oos_mse  q  q_m2  m7  pct_outliers  frequency  arima_model  score
#> 
#> The variables exclusively found in the values matrix are:
#> frequency  arima_model
#> 
#> The smallest score is 0 and the greatest is 25
#> The average score is 4.16667 and its standard deviation is 9.73124
```
