# Ré-encodage en modalités des variables

Permet d'encoder des variables présentes dans la matrice des valeurs en
modalités ajoutables à la matrice des modalités.

## Arguments

- x:

  objet de type
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  ou
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

- variable_name:

  vecteur de chaînes de caractères contenant les noms des variables à
  recoder.

- breaks:

  voir l'argument éponyme de la fonction
  [`cut`](https://rdrr.io/r/base/cut.html).

- labels:

  voir l'argument éponyme de la fonction
  [`cut`](https://rdrr.io/r/base/cut.html).

- ...:

  autres paramètres de la fonction
  [`cut`](https://rdrr.io/r/base/cut.html).

## Value

La fonction
[`recode_indicator_num()`](https://inseefr.github.io/JDCruncheR/reference/recode_indicator_num.md)
renvoie le même objet, enrichi de l'indicateur choisi. Ainsi, si
l'entrée `x` est une matrice QR_matrix, un objet de classe `QR_matrix`
est renvoyé. Si le code d'entrée `x` est une matrice mQR, un objet de la
classe `mQR_matrix` est renvoyé.
