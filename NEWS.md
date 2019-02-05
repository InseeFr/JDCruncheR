# JDCruncher 0.2.3

 * la fonction `weighted_score()` crée maintenant une nouvelle variable `score_pond` plutôt que de remplacer l'ancienne. La fonction `extract_score()` permet d'extraire les deux scores.
 * changement des paramètres d'export par défaut du cruncher et des indicateurs utilisés pour le calcul du score dans la fonction `compute_score()`.
 * ajout d'un paramètre `conditional_indicator` à la fonction `compute_score()` permettant de réduire à 1 le poids de certains indicateurs en fonction des valeurs d'autres variables.

# JDCruncher 0.2.2

## Nouvelles fonctions

 * la fonction `score()` devient maintenant la fonction `extract_score()` et contient un nouveau paramètres pour contrôler le format en sortie. La fonction `score()` sera enlevée dans la prochaine version du package.
 * ajout de la fonction `add_indicator()` pour ajouter des variables dans la matrice des valeurs le bilan qualité.
 * ajout de la fonction `recode_indicator_num()` pour recoder les modalités d'une variable dans les bilans qualité.

## Modification des fonctions déjà existantes

 * désormais on ne peut plus retirer la colonne contenant le nom des séries avec `remove_indicators()` ou `retain_indicators()`
 * correction de bugs dans les fonctions `print.QR_matrix()` et `print.QR_matrix()`.
 * modification de la fonction `compute_score()` : desormais le paramètre score_formula n'existe plus et est remplacé par score_pond. Le score n'est plus calculé à partir d'une formule mais à partir d'un vecteur dont les noms correspondent aux variables à pondérer. Ajout également d'un paramètre n_contrib_score pour extraire les variables qui contribuent aux score et du paramètre na.rm pour prendre en compte les valeurs manquantes dans le calcul du score.
 * correction d'un bug dans la fonction `extract_QR()` : la stat q-m2 était égale à la stat Q.

# JDCruncher 0.2.1

Correction d'un bug sur les fonctions `retain_indicators()` et `remove_indicator()`.


# JDCruncher 0.2.0

## Nouvelles fonctions

 * `update_workspace()` qui permet de mettre à jour un workspace sans exporter de résultat.
 * ajout de fonctions pour extraire un bilan qualité de la matrice des diagnostics de JDemetra+. Ajout de fonctions de manipulation et d'export de ces objets.

## Modification des fonctions déjà existantes

 * ajout d'un paramètre `log_file` aux fonctions `cruncher()` et `cruncher_and_param()` pour exporter si besoin la log du cruncher.

## Autres modifications
 * mise à jour des options `default_matrix_item` et `default_tsmatrix_series` avec les paramètres de la version 2.2.0 de JDemetra+
