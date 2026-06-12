# Tri des objets QR_matrix et mQR_matrix

Permet de trier les bilans qualité en fonction d'une ou plusieurs
variables.

## Arguments

- x:

  objet de type
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  ou
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

- decreasing:

  booléen indiquant si les bilans qualité doivent être triés par ordre
  croissant ou décroissant. Par défaut, le tri est effectué par ordre
  croissant.

- sort_variables:

  variables à utiliser pour le tri. Elles doivent être présentes dans
  les tables de modalités.

- ...:

  autres paramètres de la fonction
  [`order`](https://rdrr.io/r/base/order.html) (non utilisés pour
  l'instant).

## Value

L'objet en entrée avec les tables de bilan qualité triées.

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
QR <- compute_score(QR, n_contrib_score = 2)
print(QR[["modalities"]][["score"]])
#> [1]   0   0 195  15  10  40

# Trier les scores

# Pour trier par ordre croissant sur le score
QR <- sort(QR, sort_variables = "score")
print(QR[["modalities"]][["score"]])
#> [1]   0   0  10  15  40 195
```
