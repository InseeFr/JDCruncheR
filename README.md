
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{JDCruncheR}` <a href="https://inseefr.github.io/JDCruncheR/"><img src="man/figures/logo.png" align="right" height="150" style="float:right; height:150px;"/></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/JDCruncheR)](https://cran.r-project.org/package=JDCruncheR)
[![Linting
code](https://github.com/InseeFr/JDCruncheR/actions/workflows/lint.yaml/badge.svg)](https://github.com/InseeFr/JDCruncheR/actions/workflows/lint.yaml)
[![R-CMD-check](https://github.com/InseeFr/JDCruncheR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/InseeFr/JDCruncheR/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Français 🇫🇷

### Présentation

Le but premier du package `{JDCruncheR}` est de fournir un accès rapide
et facile au cruncher (`JWSACruncher`) depuis R. Le cruncher est un
outil de mise à jour des workspaces de JDemetra+ sans avoir à ouvrir la
GUI (Graphical User Interface). La dernière version peut être
téléchargée ici : <https://github.com/jdemetra/jwsacruncher/releases>.
Pour plus d’information, vous pouvez visiter la page
[wiki](https://github.com/jdemetra/jwsacruncher/wiki).

Avec `{JDCruncheR}`, vous pouvez aussi générer des *bilans qualité*
utilisant l’output du cruncher. Ce bilan est un résumé des diagnostiques
de la désaisonnalisation. Il peut être utilisé pour repérer les séries
les plus problématiques qui nécessitent une analyse plus fine. Cela est
très utile lorsqu’on a beaucoup de séries à désaisonnaliser.

### Installation

**🎉 `{JDCruncheR}` est maintenant disponible sur le CRAN ! 🎉**

Pour installer, il suffit de lancer la ligne de code suivante :

``` r
install.packages("JDCruncheR")
```

Pour obtenir la version en cours de développement depuis GitHub :

``` r
# Si le package remotes n'est pas installé
# install.packages("remotes")

# Installer la version en cours de développement depuis GitHub
remotes::install_github("InseeFr/JDCruncheR")
```

### Usage

``` r
library("JDCruncheR")
```

Les seuils des tests du bilan qualité sont personnalisables. Pour cela,
il faut modifier l’option `"jdc_thresholds"`.

Pour récupérer les valeurs des tests par défault, il faut appeler la
fonction `get_thresholds()` :

``` r
get_thresholds("m7")
#>   Good    Bad Severe 
#>      1      2    Inf
get_thresholds(default = TRUE)
#> $qs_residual_sa_on_sa
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $qs_residual_sa_on_i
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $f_residual_sa_on_sa
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $f_residual_sa_on_i
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $f_residual_td_on_sa
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $f_residual_td_on_i
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $residuals_independency
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
#> 
#> $residuals_homoskedasticity
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
#> 
#> $residuals_skewness
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
#> 
#> $residuals_kurtosis
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
#> 
#> $residuals_normality
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
#> 
#> $oos_mean
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
#> 
#> $oos_mse
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
#> 
#> $m7
#>   Good    Bad Severe 
#>      1      2    Inf 
#> 
#> $q
#> Good  Bad 
#>    1  Inf 
#> 
#> $q_m2
#> Good  Bad 
#>    1  Inf 
#> 
#> $pct_outliers
#>      Good Uncertain       Bad 
#>         3         5       Inf
```

Pour changer la valeur de l’option, on peut utiliser la fonction
`set_thresholds()` :

``` r
# Fixer les seuils à une certaine valeur
set_thresholds(test_name = "m7", thresholds = c(Good = 0.8, Bad = 1.4, Severe = Inf))
get_thresholds(test_name = "m7", default = FALSE)
#>   Good    Bad Severe 
#>    0.8    1.4    Inf

# Remettre tous les seuils à leur valeur par défaut
set_thresholds()
get_thresholds(test_name = "m7", default = FALSE)
#>   Good    Bad Severe 
#>      1      2    Inf
```

### Autres informations

Pour plus d’informations sur l’installation et la configuration du
package `{JDCruncheR}`, vous pouvez visiter la page
[wiki](https://github.com/jdemetra/jwsacruncher/wiki)

Pour une description plus complète des packages R pour JDemetra+ voir le
document de travail Insee [Les packages R pour JDemetra+ : une aide à la
désaisonnalisation](https://www.insee.fr/fr/statistiques/5019786)

## English 🇬🇧

### Overview

The primary objective of the `{JDCruncheR}` package is to provide a
quick and easy access to the JDemetra+ cruncher (`JWSACruncher`) from R.
The cruncher is a tool for updating JDemetra+ workspaces, without having
to open the graphical user interface. The latest version can be
downloaded here: <https://github.com/jdemetra/jwsacruncher/releases>.
For more information, please refer to the [wiki
page](https://github.com/jdemetra/jwsacruncher/wiki).

With `{JDCruncheR}`, you can also generate a *quality report* based on
the cruncher’s output. This report is a formatted summary of the
seasonal adjustment process master diagnostics and parameters. It can be
used to spot the most problematic series which will require a finer
analysis. This is most useful when dealing with a large number of
series.

### Installation

**🎉 `{JDCruncheR}` is now available on CRAN! 🎉**

To install it, you have to launch the following command line:

``` r
install.packages("JDCruncheR")
```

To get the current development version from GitHub:

``` r
# If remotes packages is not installed
# install.packages("remotes")

# Install development version from GitHub
remotes::install_github("InseeFr/JDCruncheR")
```

### Usage

``` r
library("JDCruncheR")
```

The thresholds of the QR tests can be customised You have to modify the
option `"jdc_thresholds"`.

To get the (default or not) values of the thresholds of the tests, you
can call the fonction `get_thresholds()` :

``` r
get_thresholds("m7")
#>   Good    Bad Severe 
#>      1      2    Inf
get_thresholds(default = TRUE)
#> $qs_residual_sa_on_sa
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $qs_residual_sa_on_i
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $f_residual_sa_on_sa
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $f_residual_sa_on_i
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $f_residual_td_on_sa
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $f_residual_td_on_i
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $residuals_independency
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
#> 
#> $residuals_homoskedasticity
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
#> 
#> $residuals_skewness
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
#> 
#> $residuals_kurtosis
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
#> 
#> $residuals_normality
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
#> 
#> $oos_mean
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
#> 
#> $oos_mse
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
#> 
#> $m7
#>   Good    Bad Severe 
#>      1      2    Inf 
#> 
#> $q
#> Good  Bad 
#>    1  Inf 
#> 
#> $q_m2
#> Good  Bad 
#>    1  Inf 
#> 
#> $pct_outliers
#>      Good Uncertain       Bad 
#>         3         5       Inf
```

To change the value of the option, you can use the fonction
`set_thresholds()`:

``` r
# Set threshold to imposed value
set_thresholds(test_name = "m7", thresholds = c(Good = 0.8, Bad = 1.4, Severe = Inf))
get_thresholds(test_name = "m7", default = FALSE)
#>   Good    Bad Severe 
#>    0.8    1.4    Inf

# Reset all thresholds to default
set_thresholds()
get_thresholds(test_name = "m7", default = FALSE)
#>   Good    Bad Severe 
#>      1      2    Inf
```

### Other informations

For more informations on installing and configuring the `{JDCruncheR}`
package, you can visit the
[wiki](https://github.com/jdemetra/jwsacruncher/wiki) page.

For a more comprehensive description of the R packages for JDemetra+
check the Insee working paper [R Tools for JDemetra+: Seasonal
adjustment made easier](https://www.insee.fr/en/statistiques/5019812)
