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

Ce fichier peut être obtenu en lançant le cruncher
([`cruncher`](https://aqlt.github.io/rjwsacruncher/reference/cruncher.html)
ou
[`cruncher_and_param`](https://aqlt.github.io/rjwsacruncher/reference/cruncher_and_param.html))
avec l'ensemble des paramètres de base pour les paramètres à exporter et
l'option `csv_layout = "vtable"` (par défaut) pour le format de sortie
des fichiers csv (option de
[`cruncher_and_param`](https://aqlt.github.io/rjwsacruncher/reference/cruncher_and_param.html)
ou de
[`create_param_file`](https://aqlt.github.io/rjwsacruncher/reference/create_param_file.html)
lors de la création du fichier de paramètres).

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
    "WS/WS_world/Output/SAProcessing-1",
    "demetra_m.csv"
)

# Extraire le bilan qualité à partir du fichier demetra_m.csv
QR <- extract_QR(file = demetra_path)
#> Multiple column found for extraction of diagnostics.seas-i-qs:2, diagnostics.seas-i-qs
#> Last column selected
#> Multiple column found for extraction of diagnostics.seas-i-f:2, diagnostics.seas-i-f
#> Last column selected

print(QR)
#> The quality report matrix has 6 observations
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
#>                      series residuals_homoskedasticity residuals_skewness
#> 1  Siachen Glacier (frozen)                       Good               Good
#> 2 Nagorno-Karabakh (frozen)                       Good               Good
#> 3         Mongolia (frozen)                       Good               Good
#> 4            India (frozen)                       Good               Good
#> 5            Nepal (frozen)                  Uncertain          Uncertain
#> 6      Philippines (frozen)                  Uncertain               Good
#>   residuals_kurtosis residuals_normality residuals_independency
#> 1               Good                Good                   Good
#> 2               Good                Good                   Good
#> 3               Good                Good                    Bad
#> 4               Good                Good              Uncertain
#> 5               Good                Good                   Good
#> 6               Good                Good              Uncertain
#>   qs_residual_s_on_sa f_residual_s_on_sa qs_residual_sa_on_i f_residual_sa_on_i
#> 1                Good               Good                Good               Good
#> 2                Good               Good                Good               Good
#> 3              Severe               Good                Good               Good
#> 4                Good               Good                Good               Good
#> 5                Good               Good                Good               Good
#> 6                Good               Good                Good               Good
#>   f_residual_td_on_sa f_residual_td_on_i oos_mean oos_mse    q q_m2   m7
#> 1                Good               Good     Good    Good Good Good Good
#> 2                Good               Good     Good    Good Good Good Good
#> 3                Good               Good     Good    Good Good Good Good
#> 4                Good               Good     Good    Good Good Good Good
#> 5                Good               Good     Good    Good Good Good Good
#> 6                Good          Uncertain     Good    Good Good Good Good
#>   pct_outliers
#> 1          Bad
#> 2          Bad
#> 3         Good
#> 4          Bad
#> 5          Bad
#> 6    Uncertain
# Or:
QR[["modalities"]]
#>                      series residuals_homoskedasticity residuals_skewness
#> 1  Siachen Glacier (frozen)                       Good               Good
#> 2 Nagorno-Karabakh (frozen)                       Good               Good
#> 3         Mongolia (frozen)                       Good               Good
#> 4            India (frozen)                       Good               Good
#> 5            Nepal (frozen)                  Uncertain          Uncertain
#> 6      Philippines (frozen)                  Uncertain               Good
#>   residuals_kurtosis residuals_normality residuals_independency
#> 1               Good                Good                   Good
#> 2               Good                Good                   Good
#> 3               Good                Good                    Bad
#> 4               Good                Good              Uncertain
#> 5               Good                Good                   Good
#> 6               Good                Good              Uncertain
#>   qs_residual_s_on_sa f_residual_s_on_sa qs_residual_sa_on_i f_residual_sa_on_i
#> 1                Good               Good                Good               Good
#> 2                Good               Good                Good               Good
#> 3              Severe               Good                Good               Good
#> 4                Good               Good                Good               Good
#> 5                Good               Good                Good               Good
#> 6                Good               Good                Good               Good
#>   f_residual_td_on_sa f_residual_td_on_i oos_mean oos_mse    q q_m2   m7
#> 1                Good               Good     Good    Good Good Good Good
#> 2                Good               Good     Good    Good Good Good Good
#> 3                Good               Good     Good    Good Good Good Good
#> 4                Good               Good     Good    Good Good Good Good
#> 5                Good               Good     Good    Good Good Good Good
#> 6                Good          Uncertain     Good    Good Good Good Good
#>   pct_outliers
#> 1          Bad
#> 2          Bad
#> 3         Good
#> 4          Bad
#> 5          Bad
#> 6    Uncertain
```
