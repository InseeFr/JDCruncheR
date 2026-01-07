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
#>    series score
#> 1  RF0610   145
#> 2  RF0620    45
#> 3  RF0811   300
#> 4  RF0812   310
#> 5  RF0893    30
#> 6  RF0899   195
#> 7  RF1011   560
#> 8  RF1012   560
#> 9  RF1013   505
#> 10 RF1020   545
#> 11 RF1031   255
#> 12 RF1032   310
#> 13 RF1039   535
extract_score(mQR)
#> $a
#>    series score
#> 1  RF0610   145
#> 2  RF0620    45
#> 3  RF0811   300
#> 4  RF0812   310
#> 5  RF0893    30
#> 6  RF0899   195
#> 7  RF1011   560
#> 8  RF1012   560
#> 9  RF1013   505
#> 10 RF1020   545
#> 11 RF1031   255
#> 12 RF1032   310
#> 13 RF1039   535
#> 
#> $b
#>    series score
#> 1  RF0610    70
#> 2  RF0620    45
#> 3  RF0811   215
#> 4  RF0812   250
#> 5  RF0893     0
#> 6  RF0899   150
#> 7  RF1011   425
#> 8  RF1012   425
#> 9  RF1013   475
#> 10 RF1020   365
#> 11 RF1031   110
#> 12 RF1032   250
#> 13 RF1039   380
#> 
```
