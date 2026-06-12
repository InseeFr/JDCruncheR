# Export des objets mQR_matrix dans des fichiers Excel

Permet d'exporter dans des fichiers Excel une liste de bilan qualité

## Arguments

- x:

  objet de type
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  à exporter.

- export_dir:

  dossier d'export des résultats.

- layout_file:

  paramètre d'export. Par défaut, (`layout_file = "ByComponent"`) et un
  fichier Excel est exporté par composante de la matrice bilan qualité
  (matrice des modalités ou des valeurs), dont chaque feuille correspond
  à un bilan qualité. Pour avoir un fichier par bilan qualité dont
  chaque feuille correspond à la composante exportée, utiliser
  `layout_file = "ByQRMatrix"`. La modalité
  `layout_file = "AllTogether"` correspond à la création d'un fichier
  avec 2 feuilles par bilan qualité (`Values` et `Modalities`).

- auto_format:

  booléen indiquant s'il faut formatter la sortie (`auto_format = TRUE`
  par défaut).

- overwrite:

  booléen indiquant s'il faut ré-écrire créer le fichier Excel s'il
  existe déjà (`create = TRUE` par défaut)

- ...:

  autres argument non utilisés

## Value

Renvoie de manière invisible (via `invisible(x)`) le même objet
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
que `x`.
