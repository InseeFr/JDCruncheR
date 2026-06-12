# Weighted score calculation

Function to weight a pre-calculated score

## Usage

``` r
weighted_score(x, pond = 1L)
```

## Arguments

- x:

  a
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  or
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  object

- pond:

  the weights to use. Can be an integer, a vector of integers, the name
  of one of the quality report variables or a list of weights for the
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  objects.

## Value

the input with an additionnal weighted score

## See also

[Traduction
française](https://inseefr.github.io/JDCruncheR/reference/fr-weighted_score.md)

Other QR_matrix functions:
[`extract_QR()`](https://inseefr.github.io/JDCruncheR/reference/extract_QR.md),
[`rbind.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/rbind.QR_matrix.md),
[`sort`](https://inseefr.github.io/JDCruncheR/reference/sort.md),
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

# Weighted score
QR <- weighted_score(QR, 2)
print(QR)
#> The quality report matrix has 6 observations
#> There are 20 indicators in the modalities matrix and 24 indicators in the values matrix
#> 
#> The quality report matrix contains the following variables:
#> series  residuals_homoskedasticity  residuals_skewness  residuals_kurtosis  residuals_normality  residuals_independency  qs_residual_s_on_sa  f_residual_s_on_sa  qs_residual_sa_on_i  f_residual_sa_on_i  f_residual_td_on_sa  f_residual_td_on_i  oos_mean  oos_mse  q  q_m2  m7  pct_outliers  frequency  arima_model  score  1_highest_contrib_score  2_highest_contrib_score  score_pond
#> 
#> The variables exclusively found in the values matrix are:
#> frequency  arima_model  1_highest_contrib_score  2_highest_contrib_score
#> 
#> The smallest score is 0 and the greatest is 195
#> The average score is 43.3333 and its standard deviation is 75.7408
#> 
#> The following formula was used to calculate the score:
#> 30 * qs_residual_s_on_sa + 30 * f_residual_s_on_sa + 20 * qs_residual_sa_on_i + 20 * f_residual_sa_on_i + 30 * f_residual_td_on_sa + 20 * f_residual_td_on_i + 15 * oos_mean + 10 * oos_mse + 15 * residuals_independency + 5 * residuals_homoskedasticity + 5 * residuals_skewness + 5 * m7 + 5 * q_m2

# Extract the weighted score
QR[["modalities"]][["score_pond"]]
#> [1]   0   0 390  30  20  80
```
