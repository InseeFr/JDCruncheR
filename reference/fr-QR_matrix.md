# Objets bilan qualité

[`QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
permet de créer un objet de type
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
contenant un bilan qualité.

## Arguments

- modalities:

  un `data.frame` contenant les modalités (Good, Bad, etc.) associées
  aux variables.

- values:

  un `data.frame` contenant les valeurs (p-valeurs des tests,
  statistiques, etc.) associées aux variables. Peut donc contenir plus
  de variables que le data.frame `modalities`.

- score_formula:

  formule utilisée pour calculer le score global (s'il existe).

- x:

  un objet de type
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md),
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  ou une liste d'objets
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

- ...:

  des objets du même type que `x`.

## Value

[`QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
crée et renvoie un objet
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).
[`mQR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
crée et renvoie un objet
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
(c'est-à-dire une liste d'objets
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)).
[`is.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
et
[`is.mQR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
renvoient des valeurs booléennes (`TRUE` ou `FALSE`).

## Details

[`mQR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
permet de créer un objet de type
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
qui est une liste de bilans qualité (donc d'objets
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)).

[`is.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
et
[`is.mQR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
permettent de tester si un objet est un bilan qualité ou une liste de
bilans qualité.

Un objet de type
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
est une liste de trois paramètres :

- le paramètre `modalities` est un `data.frame` contenant un ensemble de
  variables sous forme catégorielle (par défaut : Good, Uncertain, Bad,
  Severe).

- le paramètre `values` est un `data.frame` contenant les valeurs
  associées aux indicateurs présents dans `modalities` (i.e. :
  p-valeurs, statistiques, etc.), ainsi que des variables qui n'ont pas
  de modalité (i.e. : fréquence de la série, modèle ARIMA, etc).

- le paramètre `score_formula` contient la formule utilisée pour
  calculer le score (une fois le calcul réalisé).
