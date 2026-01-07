# Editing the indicators list

Functions to remove indicators (`remove_indicators()`) or retrain some
indicators only (`retain_indicators()`) from
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
or
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
objects. The series names (column "series") cannot be removed.

## Usage

``` r
remove_indicators(x, ...)

retain_indicators(x, ...)
```

## Arguments

- x:

  a
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  or
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  object.

- ...:

  names of the variable to remove (or keep)

## Value

`remove_indicators()` returns the same object `x` reduced by the flags
and variables used as arguments ... So if the input `x` is a QR_matrix,
an object of class QR_matrix is returned. If the input `x` is a
mQR_matrix, an object of class mQR_matrix is returned.

## See also

[Traduction
française](https://inseefr.github.io/JDCruncheR/reference/fr-remove_indicators.md)

Other var QR_matrix manipulation:
[`add_indicator()`](https://inseefr.github.io/JDCruncheR/reference/add_indicator.md),
[`recode_indicator_num()`](https://inseefr.github.io/JDCruncheR/reference/recode_indicator_num.md)

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

# Retain indicators
retain_indicators(QR, "score", "m7") # retaining "score" and "m7"
#> The quality report matrix has 13 observations
#> There are 3 indicators in the modalities matrix and 3 indicators in the values matrix
#> 
#> The quality report matrix contains the following variables:
#> series  m7  score
#> 
#> There's no additionnal variable in the values matrix
#> 
#> The smallest score is 30 and the greatest is 560
#> The average score is 330.385 and its standard deviation is 194.866
#> 
#> The following formula was used to calculate the score:
#> 30 * qs_residual_s_on_sa + 30 * f_residual_s_on_sa + 20 * qs_residual_sa_on_i + 20 * f_residual_sa_on_i + 30 * f_residual_td_on_sa + 20 * f_residual_td_on_i + 15 * oos_mean + 10 * oos_mse + 15 * residuals_independency + 5 * residuals_homoskedasticity + 5 * residuals_skewness + 5 * m7 + 5 * q_m2
retain_indicators(QR, c("score", "m7")) # Same
#> The quality report matrix has 13 observations
#> There are 3 indicators in the modalities matrix and 3 indicators in the values matrix
#> 
#> The quality report matrix contains the following variables:
#> series  m7  score
#> 
#> There's no additionnal variable in the values matrix
#> 
#> The smallest score is 30 and the greatest is 560
#> The average score is 330.385 and its standard deviation is 194.866
#> 
#> The following formula was used to calculate the score:
#> 30 * qs_residual_s_on_sa + 30 * f_residual_s_on_sa + 20 * qs_residual_sa_on_i + 20 * f_residual_sa_on_i + 30 * f_residual_td_on_sa + 20 * f_residual_td_on_i + 15 * oos_mean + 10 * oos_mse + 15 * residuals_independency + 5 * residuals_homoskedasticity + 5 * residuals_skewness + 5 * m7 + 5 * q_m2

# Remove indicators
QR <- remove_indicators(QR, "score") # removing "score"

extract_score(QR) # is NULL because we removed the score indicator
#> NULL
```
