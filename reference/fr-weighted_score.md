# Calcul d'un score pondéré pour chaque observation

Permet de pondérer un score déjà calculé en fonction de variables.

## Arguments

- x:

  objet de type
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  ou
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

- pond:

  pondération à appliquer au score. Il peut s'agir d'un nombre, d'un
  vecteur de nombres, du nom d'une des variables du bilan qualité ou
  d'une liste de pondérations pour les objets
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

## Value

L'objet en entrée avec le score recalculé

## Examples

``` r
# Chemin menant au fichier demetra_m.csv
demetra_path <- file.path(
    system.file("extdata", package = "JDCruncheR"),
    "WS/ws_ipi/Output/SAProcessing-1",
    "demetra_m.csv"
)

# Extraire le bilan qualité à partir du fichier demetra_m.csv
QR <- extract_QR(demetra_path)
#> Multiple column found for extraction of q statistic
#> First column selected
#> Multiple column found for extraction of q-m2 statistic
#> First column selected
#> Multiple column found for extraction of mean
#> Last column selected

# Calculer le score
QR <- compute_score(QR, n_contrib_score = 2)
print(QR)
#> The quality report matrix has 13 observations
#> There are 19 indicators in the modalities matrix and 23 indicators in the values matrix
#> 
#> The quality report matrix contains the following variables:
#> series  residuals_homoskedasticity  residuals_skewness  residuals_kurtosis  residuals_normality  residuals_independency  qs_residual_s_on_sa  f_residual_s_on_sa  qs_residual_sa_on_i  f_residual_sa_on_i  f_residual_td_on_sa  f_residual_td_on_i  oos_mean  oos_mse  q  q_m2  m7  pct_outliers  frequency  arima_model  score  1_highest_contrib_score  2_highest_contrib_score
#> 
#> The variables exclusively found in the values matrix are:
#> frequency  arima_model  1_highest_contrib_score  2_highest_contrib_score
#> 
#> The smallest score is 30 and the greatest is 560
#> The average score is 330.385 and its standard deviation is 194.866
#> 
#> The following formula was used to calculate the score:
#> 30 * qs_residual_s_on_sa + 30 * f_residual_s_on_sa + 20 * qs_residual_sa_on_i + 20 * f_residual_sa_on_i + 30 * f_residual_td_on_sa + 20 * f_residual_td_on_i + 15 * oos_mean + 10 * oos_mse + 15 * residuals_independency + 5 * residuals_homoskedasticity + 5 * residuals_skewness + 5 * m7 + 5 * q_m2

# Pondérer le score
QR <- weighted_score(QR, 2)
print(QR)
#> The quality report matrix has 13 observations
#> There are 20 indicators in the modalities matrix and 24 indicators in the values matrix
#> 
#> The quality report matrix contains the following variables:
#> series  residuals_homoskedasticity  residuals_skewness  residuals_kurtosis  residuals_normality  residuals_independency  qs_residual_s_on_sa  f_residual_s_on_sa  qs_residual_sa_on_i  f_residual_sa_on_i  f_residual_td_on_sa  f_residual_td_on_i  oos_mean  oos_mse  q  q_m2  m7  pct_outliers  frequency  arima_model  score  1_highest_contrib_score  2_highest_contrib_score  score_pond
#> 
#> The variables exclusively found in the values matrix are:
#> frequency  arima_model  1_highest_contrib_score  2_highest_contrib_score
#> 
#> The smallest score is 30 and the greatest is 560
#> The average score is 330.385 and its standard deviation is 194.866
#> 
#> The following formula was used to calculate the score:
#> 30 * qs_residual_s_on_sa + 30 * f_residual_s_on_sa + 20 * qs_residual_sa_on_i + 20 * f_residual_sa_on_i + 30 * f_residual_td_on_sa + 20 * f_residual_td_on_i + 15 * oos_mean + 10 * oos_mse + 15 * residuals_independency + 5 * residuals_homoskedasticity + 5 * residuals_skewness + 5 * m7 + 5 * q_m2

# Extraire le score pondéré
QR[["modalities"]][["score_pond"]]
#>  [1]  290   90  600  620   60  390 1120 1120 1010 1090  510  620 1070
```
