# Combiner par ligne des objets QR_matrix

Permet de combiner plusieurs objets
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
en combinant par ligne les paramètres `modalities` et `values`.

## Arguments

- ...:

  objets
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  à combiner.

- check_formula:

  booléen indiquant s'il faut vérifier la cohérence dans les formules de
  calcul du score. Par défaut, `check_formula = TRUE` : la fonction
  renvoie une erreur si des scores sont calculés avec des formules
  différentes. Si `check_formula = FALSE`, alors il n'y a pas de
  vérification et le paramètre `score_formula` de l'objet en sortie est
  `NULL`.

## Value

[`rbind.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/rbind.QR_matrix.md)
renvoie un objet
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

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

# Calculer differents scores
QR1 <- compute_score(QR, score_pond = c(m7 = 2, q = 3, qs_residual_s_on_sa = 5))
QR2 <- compute_score(QR, score_pond = c(m7 = 2, qs_residual_s_on_sa = 5))

# Fusionner 2 bilans qualité
try(rbind(QR1, QR2)) # Une erreur est renvoyée
#> Error : All QR_matrices must have the same score formulas.
rbind(QR1, QR2, check_formula = FALSE)
#> The quality report matrix has 26 observations
#> There are 19 indicators in the modalities matrix and 21 indicators in the values matrix
#> 
#> The quality report matrix contains the following variables:
#> series  residuals_homoskedasticity  residuals_skewness  residuals_kurtosis  residuals_normality  residuals_independency  qs_residual_s_on_sa  f_residual_s_on_sa  qs_residual_sa_on_i  f_residual_sa_on_i  f_residual_td_on_sa  f_residual_td_on_i  oos_mean  oos_mse  q  q_m2  m7  pct_outliers  frequency  arima_model  score
#> 
#> The variables exclusively found in the values matrix are:
#> frequency  arima_model
#> 
#> The smallest score is 0 and the greatest is 34
#> The average score is 13.9231 and its standard deviation is 12.0828
```
