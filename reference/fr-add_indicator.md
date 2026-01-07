# Ajout d'un indicateur dans les objets QR_matrix

Permet d'ajouter un indicateur dans les objets
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

## Arguments

- x:

  objet de type
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  ou
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

- indicator:

  un `vector` ou un `data.frame` (voir détails).

- variable_name:

  chaîne de caractères contenant les noms des nouvelles variables.

- ...:

  autres paramètres de la fonction
  [`merge`](https://rdrr.io/r/base/merge.html).

## Value

Cette fonction renvoie le même objet, enrichi de l'indicateur choisi.
Ainsi, si l'entrée `x` est une matrice QR, un objet de la classe
`QR_matrix` est renvoyé. Si le code d'entrée `x` est une matrice mQR, un
objet de la classe `mQR_matrix` est renvoyé.

## Details

La fonction
[`add_indicator()`](https://inseefr.github.io/JDCruncheR/reference/add_indicator.md)
permet d'ajouter un indicateur dans la matrice des valeurs du bilan
qualité. L'indicateur n'est donc pas ajouté dans la matrice des
modalités et ne peut être utilisé dans le calcul du score (sauf pour le
pondérer). Pour l'utiliser dans le calcul du score, il faudra d'abord le
recoder avec la fonction
[`recode_indicator_num`](https://inseefr.github.io/JDCruncheR/reference/recode_indicator_num.md).

L'indicateur à ajouter peut être sous deux formats : `vector` ou
`data.frame`. Dans les deux cas, il faut que les valeurs à ajouter
puissent être associées aux bonnes séries dans la matrice du bilan
qualité :

- dans le cas d'un `vector`, les éléments devront être nommés et les
  noms doivent correspondre à ceux présents dans le bilan qualité
  (variable "series") ;

- dans le cas d'un `data.frame`, il devra contenir une colonne "series"
  avec les noms des séries correspondantes.
