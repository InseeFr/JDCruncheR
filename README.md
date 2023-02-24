
# `JDCruncheR`

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/JDCruncheR)](https://cran.r-project.org/package=JDCruncheR)

## Français 🇫🇷

### Présentation

Le but premier du package `JDCruncheR` est de fournir un accès rapide et facile au cruncher (`JWSACruncher`) depuis R. Le cruncher est un outil de mise à jour des workspaces de JDemetra+ sans avoir à ouvrir la GUI (Graphical User Interface). La dernière version peut être téléchargée ici : https://github.com/jdemetra/jwsacruncher/releases. Pour plus d'information, vous pouvez visiter la page [wiki](https://github.com/jdemetra/jwsacruncher/wiki).

Avec `JDCruncheR`, vous pouvez aussi générer des *bilans qualité* utilisant l'output du cruncher. Ce bilan est un résumé des diagnostiques de la désaisonnalisation. Il peut être utilisé pour repérer les séries les plus problématiques qui nécessitent une analyse plus fine. C'est très utile lorsqu'on a beaucoup de séries à désaisonnaliser, ce qui rend l'éxamination au cas par cas impossible rapidement.

### Installation

Il y a 2 methodes d'installation du package `JDCruncheR` :
    
- utiliser le package `remotes` :
    
``` r
# install.packages("remotes")
remotes::install_github("InseeFr/JDCruncheR", build_vignettes = TRUE)
```

- depuis le dossier compressé **.zip** ou **.tar.gz**, qui peuvent être trouvés ici : https://github.com/InseeFr/JDCruncheR/releases. Pour plus d'information sur l'installation et la configuration du package `JDCruncheR`, vous pouvez visiter la page [wiki](https://github.com/jdemetra/jwsacruncher/wiki)

## English 🇬🇧

### Overview

The primary objective of the `JDCruncheR` package is to provide a quick
and easy access to the JDemetra+ cruncher (`JWSACruncher`) from R. The
cruncher is a tool to update a JDemetra+ workspace, without having to
open the software itself. The latest version can be downloaded here:
    <https://github.com/jdemetra/jwsacruncher/releases>. For more
information, please refer to the [wiki page](https://github.com/jdemetra/jwsacruncher/wiki).

With `JDCruncheR`, you can also generate a *quality report* based on the
cruncher output. This report is a summary of the seasonal adjustment
diagnostics. It can be used to spot the most problematic series which
will require a finer analysis. This is most useful when dealing with a
great number of series, which renders impossible the examination of
every diagnostic for every series in a reasonable time.

### Installation

There are two ways to install the `JDCruncheR` package:
    
- using the `remotes` package:
    
``` r
# install.packages("remotes")
remotes::install_github("InseeFr/JDCruncheR", build_vignettes = TRUE)
```

- from the **.zip** or **.tar.gz** file, that can both be found here:
    <https://github.com/InseeFr/JDCruncheR/releases>. For more info on
the package installation and the cruncher configuration, please
refer to the [wiki](https://github.com/InseeFr/JDCruncheR/wiki).
