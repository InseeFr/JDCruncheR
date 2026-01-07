# Manipulation de la liste des indicateurs

Permet de retirer des indicateurs (fonction
[`remove_indicators()`](https://inseefr.github.io/JDCruncheR/reference/QR_var_manipulation.md))
ou de n'en retenir que certains (fonction
[`retain_indicators()`](https://inseefr.github.io/JDCruncheR/reference/QR_var_manipulation.md))
d'objets
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
ou
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).
Le nom des séries (colonne "series") ne peut être enlevé.

## Arguments

- x:

  objet de type
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  ou
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

- ...:

  noms des variables à retirer (ou conserver).

## Value

[`remove_indicators()`](https://inseefr.github.io/JDCruncheR/reference/QR_var_manipulation.md)
renvoie le même objet `x` réduit par les drapeaux et les variables
utilisés comme arguments ... Donc si l'entrée `x` est une matrice
QR_matrix, un objet de la classe QR_matrix est renvoyé. Si le code
d'entrée `x` est une matrice mQR, un objet de la classe mQR_matrix est
renvoyé.

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
QR <- compute_score(x = QR, n_contrib_score = 5)

# Retenir certains indicateurs
retain_indicators(QR, "score", "m7") # Retiens les indicateurs "score" et "m7"
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
retain_indicators(QR, c("score", "m7")) # Pareil
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

# Retirer des indicateurs
QR <- remove_indicators(QR, "score") # removing "score"

extract_score(QR) # est NULL car l'indicateur "score a été retiré
#> NULL
```
