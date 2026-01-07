# Extraction d'un bilan qualité

Permet d'extraire un bilan qualité à partir du fichier CSV contenant la
matrice des diagnostics.

## Arguments

- matrix_output_file:

  Chaîne de caracère. Chemin vers le fichier CSV contenant la matrice
  des diagnostics.

- file:

  Chaîne de caracère. Chemin vers le fichier CSV contenant la matrice
  des diagnostics. Cet argument remplace l'argument
  `matrix_output_file`.

- sep:

  séparateur de caractères utilisé dans le fichier csv (par défaut
  `sep = ";"`)

- dec:

  séparateur décimal utilisé dans le fichier csv (par défaut
  `dec = ","`)

- thresholds:

  `list` de vecteurs numériques. Seuils appliqués aux différents tests
  afin de classer en modalités `Good`, `Uncertain`, `Bad` et `Severe`.
  Par défault, la valeur de l'option `"jdc_threshold"` est utilisée.
  Vous pouvez appeler la fonction
  [`get_thresholds`](https://inseefr.github.io/JDCruncheR/reference/get_thresholds.md)
  pour voir à quoi doit ressemble l'objet `thresholds`.

## Value

Un objet de type
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

## Details

La fonction permet d'extraire un bilan qualité à partir d'un fichier csv
contenant l'ensemble des diagnostics (généralement fichier
*demetra_m.csv*).

Ce fichier peut être obtenu en lançant le cruncher (`cruncher` ou
`cruncher_and_param`) avec l'ensemble des paramètres de base pour les
paramètres à exporter et l'option `csv_layout = "vtable"` (par défaut)
pour le format de sortie des fichiers csv (option de
`cruncher_and_param` ou de `create_param_file` lors de la création du
fichier de paramètres).

Le résultat de cette fonction est un objet
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
qui est une liste de trois paramètres :

- le paramètre `modalities` est un `data.frame` contenant un ensemble de
  variables sous forme catégorielle (Good, Uncertain, Bad, Severe).

- le paramètre `values` est un `data.frame` contenant les valeurs
  associées aux indicateurs présents dans `modalities` (i.e. :
  p-valeurs, statistiques, etc.) ainsi que des variables qui n'ont pas
  de modalité (fréquence de la série et modèle ARIMA).

- le paramètre `score_formula` est initié à `NULL` : il contiendra la
  formule utilisée pour calculer le score (si le calcul est fait).

Si `x` est fourni, les arguments `fichier` et `matrix_output_file` sont
ignorés. L'argument `fichier` désigne également le chemin vers le
fichier qui contient la matrice de diagnostic (qui peut être importée en
parallèle dans R et utilisée avec l'argument `x`).

## Examples

``` r
# Chemin menant au fichier demetra_m.csv
demetra_path <- file.path(
    system.file("extdata", package = "JDCruncheR"),
    "WS/ws_ipi/Output/SAProcessing-1",
    "demetra_m.csv"
)

# Extraire le bilan qualité à partir du fichier demetra_m.csv
QR <- extract_QR(file = demetra_path)
#> Multiple column found for extraction of q statistic
#> First column selected
#> Multiple column found for extraction of q-m2 statistic
#> First column selected
#> Multiple column found for extraction of mean
#> Last column selected

print(QR)
#> The quality report matrix has 13 observations
#> There are 18 indicators in the modalities matrix and 20 indicators in the values matrix
#> 
#> The quality report matrix contains the following variables:
#> series  residuals_homoskedasticity  residuals_skewness  residuals_kurtosis  residuals_normality  residuals_independency  qs_residual_s_on_sa  f_residual_s_on_sa  qs_residual_sa_on_i  f_residual_sa_on_i  f_residual_td_on_sa  f_residual_td_on_i  oos_mean  oos_mse  q  q_m2  m7  pct_outliers  frequency  arima_model
#> 
#> The variables exclusively found in the values matrix are:
#> frequency  arima_model
#> 
#> No score was calculated

# Extraire les modalités de la matrice
QR[["modalities"]]
#>    series residuals_homoskedasticity residuals_skewness residuals_kurtosis
#> 1  RF0610                  Uncertain               Good               Good
#> 2  RF0620                       Good                Bad                Bad
#> 3  RF0811                  Uncertain                Bad                Bad
#> 4  RF0812                        Bad               Good          Uncertain
#> 5  RF0893                       Good               Good               Good
#> 6  RF0899                       Good               Good               Good
#> 7  RF1011                       Good               Good               Good
#> 8  RF1012                       Good               Good               Good
#> 9  RF1013                        Bad                Bad                Bad
#> 10 RF1020                        Bad               Good          Uncertain
#> 11 RF1031                        Bad          Uncertain                Bad
#> 12 RF1032                       Good               Good               Good
#> 13 RF1039                        Bad          Uncertain                Bad
#>    residuals_normality residuals_independency qs_residual_s_on_sa
#> 1                 Good                   Good                Good
#> 2                  Bad                   Good                Good
#> 3                  Bad                    Bad                Good
#> 4                 Good                    Bad                Good
#> 5                 Good              Uncertain                Good
#> 6                 Good                    Bad                Good
#> 7                 Good                    Bad              Severe
#> 8                 Good                    Bad              Severe
#> 9                  Bad                    Bad                 Bad
#> 10           Uncertain                    Bad              Severe
#> 11                 Bad                    Bad                 Bad
#> 12                Good                    Bad                Good
#> 13                 Bad                    Bad              Severe
#>    f_residual_s_on_sa qs_residual_sa_on_i f_residual_sa_on_i
#> 1                Good                Good               Good
#> 2                Good                Good               Good
#> 3                Good                Good               Good
#> 4                Good                Good               Good
#> 5                Good                Good               Good
#> 6                Good                Good               Good
#> 7                Good              Severe               Good
#> 8                Good              Severe               Good
#> 9                Good                 Bad               Good
#> 10               Good                 Bad               Good
#> 11               Good           Uncertain               Good
#> 12               Good                Good               Good
#> 13               Good                 Bad               Good
#>    f_residual_td_on_sa f_residual_td_on_i oos_mean   oos_mse    q q_m2   m7
#> 1                  Bad          Uncertain     Good       Bad  Bad Good Good
#> 2                 Good               Good     Good       Bad  Bad Good Good
#> 3               Severe                Bad     Good Uncertain  Bad  Bad Good
#> 4               Severe             Severe     Good      Good  Bad Good Good
#> 5                 Good               Good     Good      Good  Bad  Bad Good
#> 6                  Bad                Bad     Good      Good Good Good Good
#> 7               Severe             Severe     Good      Good  Bad  Bad Good
#> 8               Severe             Severe     Good      Good Good  Bad Good
#> 9               Severe             Severe     Good      Good  Bad  Bad  Bad
#> 10              Severe             Severe     Good Uncertain  Bad  Bad Good
#> 11           Uncertain          Uncertain     Good       Bad  Bad Good Good
#> 12              Severe             Severe     Good      Good  Bad  Bad Good
#> 13              Severe             Severe     Good Uncertain Good Good Good
#>    pct_outliers
#> 1     Uncertain
#> 2           Bad
#> 3          Good
#> 4          Good
#> 5          Good
#> 6          Good
#> 7          Good
#> 8          Good
#> 9          Good
#> 10         Good
#> 11    Uncertain
#> 12         Good
#> 13         Good
# Or:
QR[["modalities"]]
#>    series residuals_homoskedasticity residuals_skewness residuals_kurtosis
#> 1  RF0610                  Uncertain               Good               Good
#> 2  RF0620                       Good                Bad                Bad
#> 3  RF0811                  Uncertain                Bad                Bad
#> 4  RF0812                        Bad               Good          Uncertain
#> 5  RF0893                       Good               Good               Good
#> 6  RF0899                       Good               Good               Good
#> 7  RF1011                       Good               Good               Good
#> 8  RF1012                       Good               Good               Good
#> 9  RF1013                        Bad                Bad                Bad
#> 10 RF1020                        Bad               Good          Uncertain
#> 11 RF1031                        Bad          Uncertain                Bad
#> 12 RF1032                       Good               Good               Good
#> 13 RF1039                        Bad          Uncertain                Bad
#>    residuals_normality residuals_independency qs_residual_s_on_sa
#> 1                 Good                   Good                Good
#> 2                  Bad                   Good                Good
#> 3                  Bad                    Bad                Good
#> 4                 Good                    Bad                Good
#> 5                 Good              Uncertain                Good
#> 6                 Good                    Bad                Good
#> 7                 Good                    Bad              Severe
#> 8                 Good                    Bad              Severe
#> 9                  Bad                    Bad                 Bad
#> 10           Uncertain                    Bad              Severe
#> 11                 Bad                    Bad                 Bad
#> 12                Good                    Bad                Good
#> 13                 Bad                    Bad              Severe
#>    f_residual_s_on_sa qs_residual_sa_on_i f_residual_sa_on_i
#> 1                Good                Good               Good
#> 2                Good                Good               Good
#> 3                Good                Good               Good
#> 4                Good                Good               Good
#> 5                Good                Good               Good
#> 6                Good                Good               Good
#> 7                Good              Severe               Good
#> 8                Good              Severe               Good
#> 9                Good                 Bad               Good
#> 10               Good                 Bad               Good
#> 11               Good           Uncertain               Good
#> 12               Good                Good               Good
#> 13               Good                 Bad               Good
#>    f_residual_td_on_sa f_residual_td_on_i oos_mean   oos_mse    q q_m2   m7
#> 1                  Bad          Uncertain     Good       Bad  Bad Good Good
#> 2                 Good               Good     Good       Bad  Bad Good Good
#> 3               Severe                Bad     Good Uncertain  Bad  Bad Good
#> 4               Severe             Severe     Good      Good  Bad Good Good
#> 5                 Good               Good     Good      Good  Bad  Bad Good
#> 6                  Bad                Bad     Good      Good Good Good Good
#> 7               Severe             Severe     Good      Good  Bad  Bad Good
#> 8               Severe             Severe     Good      Good Good  Bad Good
#> 9               Severe             Severe     Good      Good  Bad  Bad  Bad
#> 10              Severe             Severe     Good Uncertain  Bad  Bad Good
#> 11           Uncertain          Uncertain     Good       Bad  Bad Good Good
#> 12              Severe             Severe     Good      Good  Bad  Bad Good
#> 13              Severe             Severe     Good Uncertain Good Good Good
#>    pct_outliers
#> 1     Uncertain
#> 2           Bad
#> 3          Good
#> 4          Good
#> 5          Good
#> 6          Good
#> 7          Good
#> 8          Good
#> 9          Good
#> 10         Good
#> 11    Uncertain
#> 12         Good
#> 13         Good
```
