# Export des objets QR_matrix dans un fichier Excel

Permet d'exporter un bilan qualité dans un fichier Excel.

## Arguments

- x:

  objet de type
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

- file:

  un objet de type `character` contenant le chemin menant au fichier que
  l'on veut créer

- auto_format:

  booléen indiquant s'il faut formatter la sortie (`auto_format = TRUE`
  par défaut).

- overwrite:

  booléen indiquant s'il faut ré-écrire créer le fichier Excel s'il
  existe déjà (`create = TRUE` par défaut)

- ...:

  autres argument non utilisés

## Value

Renvoie de manière invisible (via `invisible(x)`) un objet de classeur
créé par `XLConnect::loadWorkbook()` pour une manipulation ultérieure.
