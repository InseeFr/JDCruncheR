
<!-- README.md is generated from README.Rmd. Please edit that file -->
L'objectif premier du package JDCruncheR est de permettre de lancer rapidement et plus facilement le cruncher (JWSACruncher) de JDemetra+. Le cruncher est un outil qui permet de mettre à jour un workspace de JDemetra+ à partir de la console, sans devoir ouvrir JDemetra+. La dernière version du cruncher est téléchargeable sous <https://github.com/jdemetra/jwsacruncher/releases>. Pour plus d'informations consulter le lien github du cruncher <https://github.com/jdemetra/jwsacruncher/wiki>.

JDCruncheR permet également de calculer un *bilan qualité*, à partir des résultats du cruncher, qui synthétise l'ensemble des diagnostics liés aux séries désaisonnalisée afin de repérer rapidement les séries les plus problématiques sur lesquelles il faut concentrer son analyse. Il est surtout utile dans le cas de la désaisonnalisation d'un grand nombre de séries puisqu'il est dans ce cas impossible de regarder l'ensemble des diagnostics pour chaque série dans un temps raisonnable.

Pour installer JDCruncheR rien de plus simple ! Deux solutions : soit utiliser le package devtools :

``` r
# install.packages("devtools")
devtools::install_github("AQLT/JDCruncheR")
```

Soit installer JDCruncheR à partir du **.zip** ou du **.tar.gz** du package qui peuvent être téléchargés à l'adresse <https://github.com/AQLT/JDCruncheR/releases>. Pour plus d'informations sur l'installation du package et la configuration du cruncher voir le [wiki](https://github.com/AQLT/JDCruncheR/wiki).
