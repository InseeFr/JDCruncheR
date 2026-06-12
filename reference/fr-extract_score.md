# Extraction du score

Permet d'extraire le score des objets
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
ou
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

## Arguments

- x:

  objet de type
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  ou
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

- format_output:

  chaîne de caractères indiquant le format de l'objet en sortie : soit
  un `data.frame` soit un `vector`.

- weighted_score:

  booléen indiquant s'il faut extraire le score pondéré (s'il existe) ou
  le score non pondéré. Par défaut, c'est le score non pondéré qui est
  extrait.

## Value

[`extract_score()`](https://inseefr.github.io/JDCruncheR/reference/extract_score.md)
renvoie un data.frame avec deux colonnes : le nom de la série et son
score.

## Details

Pour les objets
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md),
le score renvoyé est soit l'objet `NULL` si aucun score n'a été calculé,
soit un vecteur. Pour les objets
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md),
c'est une liste de scores (`NULL` ou un vecteur).

## Examples

``` r

# Chemin menant au fichier demetra_m.csv
demetra_path <- file.path(
    system.file("extdata", package = "JDCruncheR"),
    "WS/WS_world/Output/SAProcessing-1",
    "demetra_m.csv"
)

# Extraire le bilan qualité à partir du fichier demetra_m.csv
QR <- extract_QR(demetra_path)
#> Multiple column found for extraction of diagnostics.seas-i-qs:2, diagnostics.seas-i-qs
#> Last column selected
#> Multiple column found for extraction of diagnostics.seas-i-f:2, diagnostics.seas-i-f
#> Last column selected

# Calculer le score
QR1 <- compute_score(x = QR, n_contrib_score = 5)
QR2 <- compute_score(
    x = QR,
    score_pond = c(qs_residual_s_on_sa = 5, qs_residual_sa_on_i = 30,
                   f_residual_td_on_sa = 10, f_residual_td_on_i = 40,
                   oos_mean = 30, residuals_skewness = 15, m7 = 25)
)
mQR <- mQR_matrix(list(a = QR1, b = QR2))

# Extraire les scores
extract_score(QR1)
#>                      series score
#> 1  Siachen Glacier (frozen)     0
#> 2 Nagorno-Karabakh (frozen)     0
#> 3         Mongolia (frozen)   195
#> 4            India (frozen)    15
#> 5            Nepal (frozen)    10
#> 6      Philippines (frozen)    40
extract_score(mQR)
#> $a
#>                      series score
#> 1  Siachen Glacier (frozen)     0
#> 2 Nagorno-Karabakh (frozen)     0
#> 3         Mongolia (frozen)   195
#> 4            India (frozen)    15
#> 5            Nepal (frozen)    10
#> 6      Philippines (frozen)    40
#> 
#> $b
#>                      series score
#> 1  Siachen Glacier (frozen)     0
#> 2 Nagorno-Karabakh (frozen)     0
#> 3         Mongolia (frozen)    25
#> 4            India (frozen)     0
#> 5            Nepal (frozen)    15
#> 6      Philippines (frozen)    40
#> 
```
