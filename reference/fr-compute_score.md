# Calcul d'un score global

Permet de calculer un score global à partir d'un bilan qualité

## Arguments

- x:

  Objet de type
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  ou
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

- score_pond:

  formule utilisée pour calculer le score global.

- modalities:

  modalités triées par ordre d'importance dans le calcul du score (voir
  détails).

- normalize_score_value:

  Chiffre indiquant la valeur de référence pour la normalisation des
  pondérations utilisées lors du calcul du score. Si le paramètre n'est
  pas renseigné, les poids ne seront pas normalisés.

- na.rm:

  Booléen indiquant si les valeurs manquantes doivent être enlevées pour
  le calcul du score.

- n_contrib_score:

  Entier indiquant le nombre de variables à créer dans la matrice des
  valeurs du bilan qualité contenant les `n_contrib_score` plus grandes
  contributrices au score (voir détails). S'il n'est pas spécifié,
  aucune variable n'est créée.

- conditional_indicator:

  `list` contenant des listes ayant 3 éléments : "indicator",
  "conditions" et "condition_modalities". Permet de réduire à 1 le poids
  de certains indicateurs en fonction des valeurs d'autres variables
  (voir détails).

- thresholds:

  `list` de vecteurs numériques. Seuils appliqués aux différents tests
  afin de classer en modalités `Good`, `Uncertain`, `Bad` et `Severe`.
  Par défault, la valeur de l'option `"jdc_threshold"` est utilisée.
  Vous pouvez appeler la fonction
  [`get_thresholds`](https://inseefr.github.io/JDCruncheR/reference/get_thresholds.md)
  pour voir à quoi doit ressemble l'objet `thresholds`.

- ...:

  Autres paramètres non utilisés.

## Value

Un objet de type
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
ou
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

## Details

La fonction `compute_score` permet de calculer un score à partir des
modalités d'un bilan qualité. Pour cela, chaque modalité est associée à
un poids défini par le paramètre `modalities`. Ainsi, le paramètre par
défaut étant `c("Good", "Uncertain", "Bad","Severe")`, la valeur
`"Good"` sera associée à la note 0, la valeur `"Uncertain"` sera
associée à la note 1, la valeur `"Bad"` sera associée à la note 2 et la
valeur `"Bad"` sera associée à la note 3. Le calcul du score se fait
grâce au paramètre `score_pond`, qui est un vecteur numérique nommé
contenant des poids et dont les noms correspondent aux variables de la
matrice des modalités à utiliser dans le score. Ainsi, avec le paramètre
`score_pond = c(qs_residual_s_on_sa = 10, f_residual_td_on_sa = 5)` le
score sera calculé à partir des deux variables `qs_residual_s_on_sa` et
`f_residual_td_on_sa`. Les notes associées aux modalités de la variable
`qs_residual_s_on_sa` seront multipliées par 10 et celles associées à la
variable `f_residual_td_on_sa` seront multipliées par 5. Dans le calcul
du score, certaines variables peuvent être manquantes: pour ne pas
prendre en compte ces valeurs dans le calcul, il suffit d'utiliser le
paramètre `na.rm = TRUE`. Le paramètre `normalize_score_value` permet de
normaliser les scores. Par exemple, si l'on souhaite avoir des notes
entre 0 et 20, il suffit d'utiliser le paramètre
`normalize_score_value = 20`. Le paramètre `n_contrib_score` permet
d'ajouter de nouvelles variables à la matrice des valeurs du bilan
qualité dont les valeurs correspondent aux noms des variables qui
contribuent le plus au score de la série. `n_contrib_score` est un
entier égal au nombre de variables contributrices que l'on souhaite
exporter. Par exemple, pour `n_contrib_score = 3`, trois colonnes seront
créées et elles contiendront les trois plus grandes contributrices au
score. Les noms des nouvelles variables sont *i*\_highest_score, *i*
correspondant au rang en terme de contribution au score (1_highest_score
contiendra les noms des plus grandes contributrices, 2_highest_score des
deuxièmes plus grandes contributrices, etc). Seules les variables qui
ont une contribution non nulle au score sont prises en compte. Ainsi, si
une série a un score nul, toutes les colonnes *i*\_highest_score
associées à cette série seront vides. Et si une série a un score positif
uniquement du fait de la variable "m7", alors la valeur correspondante à
la variable 1_highest_score sera égale à "m7" et celle des autres
variables *i*\_highest_score seront vides. Certains indicateurs peuvent
n'avoir de sens que sous certaines conditions. Par exemple, le test
d'homoscédasticité n'est valide que si les résidus sont indépendants et
les tests de normalité, que si les résidus sont indépendants et
homoscédastiques. Le paramètre `conditional_indicator` permet de prendre
cela en compte en réduisant, sous certaines conditions, à 1 le poids de
certains variables. C'est une `list` contenant des listes ayant 3
éléments :

- "indicator" : nom de la variable pour laquelle on veut ajouter des
  conditions

- "conditions" : nom des variables que l'on utilise pour conditionner

- "conditions_modalities" : modalités qui doivent être vérifiées pour
  modifier le poids Ainsi, avec le paramètre
  `conditional_indicator = list(list(indicator = "residuals_skewness", conditions = c("residuals_independency", "residuals_homoskedasticity"), conditions_modalities = c("Bad","Severe")))`,
  on réduit à 1 le poids de la variable "residuals_skewness" lorsque les
  modalités du test d'indépendance ("residuals_independency") ou du test
  d'homoscédasticité ("residuals_homoskedasticity") valent "Bad" ou
  "Severe".

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

# Compute the score
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

# Extraire les modalités de la matrice
QR[["modalities"]][["score"]]
#>  [1] 145  45 300 310  30 195 560 560 505 545 255 310 535
```
