
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `JDCruncheR`

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/JDCruncheR)](https://cran.r-project.org/package=JDCruncheR)

## Français 🇫🇷

### Présentation

Le but premier du package `JDCruncheR` est de fournir un accès rapide et
facile au cruncher (`JWSACruncher`) depuis R. Le cruncher est un outil
de mise à jour des workspaces de JDemetra+ sans avoir à ouvrir la GUI
(Graphical User Interface). La dernière version peut être téléchargée
ici : <https://github.com/jdemetra/jwsacruncher/releases>. Pour plus
d’information, vous pouvez visiter la page
[wiki](https://github.com/jdemetra/jwsacruncher/wiki).

Avec `JDCruncheR`, vous pouvez aussi générer des *bilans qualité*
utilisant l’output du cruncher. Ce bilan est un résumé des diagnostiques
de la désaisonnalisation. Il peut être utilisé pour repérer les séries
les plus problématiques qui nécessitent une analyse plus fine. Cela est
très utile lorsqu’on a beaucoup de séries à désaisonnaliser.

### Installation

Il y a 2 méthodes d’installation du package `JDCruncheR` :

- utiliser le package `remotes` :

``` r
# install.packages("remotes")
remotes::install_github("InseeFr/JDCruncheR", build_vignettes = TRUE)
```

- depuis le dossier compressé **.zip** ou **.tar.gz**, qui peuvent être
  trouvés ici : <https://github.com/InseeFr/JDCruncheR/releases>. Pour
  plus d’informations sur l’installation et la configuration du package
  `JDCruncheR`, vous pouvez visiter la page
  [wiki](https://github.com/jdemetra/jwsacruncher/wiki)

Pour une description plus complète des packages R pour JDemetra+ voir le
document de travail Insee [Les packages R pour JDemetra+ : une aide à la
désaisonnalisation](https://www.insee.fr/fr/statistiques/5019786)

## English 🇬🇧

### Overview

The primary objective of the `JDCruncheR` package is to provide a quick
and easy access to the JDemetra+ cruncher (`JWSACruncher`) from R. The
cruncher is a tool for updating JDemetra+ workspaces, without having to
open the graphical user interface. The latest version can be downloaded
here: <https://github.com/jdemetra/jwsacruncher/releases>. For more
information, please refer to the [wiki
page](https://github.com/jdemetra/jwsacruncher/wiki).

With `JDCruncheR`, you can also generate a *quality report* based on the
cruncher’s output. This report is a formatted summary of the seasonal
adjustment process main diagnostics and parameters. It can be used to
spot the most problematic series which will require a finer analysis.
This is most useful when dealing with a large number of series.

### Installation

There are two ways to install the `JDCruncheR` package:

- using the `remotes` package:

``` r
# install.packages("remotes")
remotes::install_github("InseeFr/JDCruncheR", build_vignettes = TRUE)
```

- from the **.zip** or **.tar.gz** file, that can both be found here:
  <https://github.com/InseeFr/JDCruncheR/releases>.

For a more comprehensive description of the R packages for JDemetra+
check the Insee working paper [R Tools for JDemetra+: Seasonal
adjustment made easier](https://www.insee.fr/en/statistiques/5019812)
