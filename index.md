# **{JDCruncheR}**

## [🇫🇷 README en français](#pr%C3%A9sentation) \| [🇬🇧 README in english](#overview)

### Présentation

Le but premier du package **{JDCruncheR}** est de fournir un accès
rapide et facile au cruncher (`JWSACruncher`) depuis R. Le cruncher est
un outil de mise à jour des workspaces de JDemetra+ sans avoir à ouvrir
la GUI (Graphical User Interface). La dernière version peut être
téléchargée ici : <https://github.com/jdemetra/jwsacruncher/releases>.
Pour plus d’information, vous pouvez visiter la page
[wiki](https://github.com/jdemetra/jwsacruncher/wiki).

Avec **{JDCruncheR}**, vous pouvez aussi générer des *bilans qualité*
utilisant l’output du cruncher. Ce bilan est un résumé des diagnostiques
de la désaisonnalisation. Il peut être utilisé pour repérer les séries
les plus problématiques qui nécessitent une analyse plus fine. Cela est
très utile lorsqu’on a beaucoup de séries à désaisonnaliser.

### Installation

**🎉 {JDCruncheR} est maintenant disponible sur le CRAN ! 🎉**

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

#### Chargement du package

``` r
library("JDCruncheR")
```

#### Changer les seuils des tests statistiques

Les seuils des tests du bilan qualité sont personnalisables. Pour cela,
il faut modifier l’option `"jdc_thresholds"`.

Pour récupérer les valeurs des tests par défault, il faut appeler la
fonction
[`get_thresholds()`](https://inseefr.github.io/JDCruncheR/reference/get_thresholds.md)
:

``` r
get_thresholds("m7", default = TRUE)
#>   Good    Bad Severe 
#>      1      2    Inf
get_thresholds(default = TRUE)
#> $qs_residual_s_on_sa
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $qs_residual_sa_on_i
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $f_residual_s_on_sa
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
#> 
#> $grade
#>      Good Uncertain       Bad    Severe 
#>         0         1         3         5
```

Pour changer la valeur de l’option, on peut utiliser la fonction
[`set_thresholds()`](https://inseefr.github.io/JDCruncheR/reference/set_thresholds.md)
:

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

#### Changer les notes des modalités `Good`, `Uncertain`, `Bad` et `Severe`

Le mécanisme est le même que pour les seuils des tests statistiques avec
la valeur `"grade"` :

Pour récupérer la valeur par défault des notes, il faut appeler la
fonction
[`get_thresholds()`](https://inseefr.github.io/JDCruncheR/reference/get_thresholds.md)
:

``` r
get_thresholds("grade", default = TRUE)
#>      Good Uncertain       Bad    Severe 
#>         0         1         3         5
```

Pour changer la valeur de la note, on peut utiliser la fonction
[`set_thresholds()`](https://inseefr.github.io/JDCruncheR/reference/set_thresholds.md)
:

``` r
# Fixer les notes à une certaine valeur
set_thresholds(test_name = "grade", thresholds = c(Good = 0, Uncertain = 0.1, Bad = 1, Severe = 10))
get_thresholds(test_name = "grade", default = FALSE)
#>      Good Uncertain       Bad    Severe 
#>       0.0       0.1       1.0      10.0
```

#### Calculer un bilan qualité

Par exemple, en partant d’une matrice `demetra_m.csv` :

|        | n   | start      | end        | mean | skewness |     | kurtosis |     | lb2  |     | p   | d   | q   | bp  | bd  | bq  | m7  | q   | q.m2 |
|--------|-----|------------|------------|------|----------|-----|----------|-----|------|-----|-----|-----|-----|-----|-----|-----|-----|-----|------|
| France | 88  | 2012-10-01 | 2020-01-01 | 0.6  | 0.0      | 0.9 | 2.9      | 0.8 | 36.1 | 0.0 | 0   | 1   | 1   | 0   | 1   | 1   | 0.2 | 0.5 | 2.0  |
| Spain  | 78  | 2015-10-01 | 2022-03-01 | 0.4  | -0.4     | 0.0 | 4.6      | 0.0 | 17.3 | 0.7 | 0   | 0   | 1   | 0   | 1   | 1   | 0.8 | 1.5 | 1.3  |
| Greece | 112 | 2010-10-01 | 2020-01-01 | 0.5  | -0.3     | 0.0 | 3.7      | 0.0 | 46.9 | 0.0 | 3   | 1   | 1   | 0   | 1   | 1   | 0.3 | 0.4 | 0.8  |

On peut générer un bilan qualité :

``` r
BQ <- extract_QR(x = demetra_m)
print(BQ$modalities)
#>   series residuals_homoskedasticity residuals_skewness residuals_kurtosis
#> 1 France                       Good               Good               Good
#> 2  Spain                        Bad                Bad                Bad
#> 3 Greece                        Bad                Bad                Bad
#>   oos_mean oos_mse   m7    q q_m2 pct_outliers
#> 1     Good    <NA> Good Good  Bad         <NA>
#> 2     Good    <NA> Good  Bad  Bad         <NA>
#> 3     Good    <NA> Good  Bad Good         <NA>
```

#### Calculer un score

Il est possible maintenant de calculer un score à partir du bilan
qualité

``` r
BQ_score <- compute_score(
    x = BQ,
    score_pond = c(
        oos_mean = 15L, 
        residuals_kurtosis = 15L, 
        residuals_homoskedasticity = 5L, 
        residuals_skewness = 5L, 
        m7 = 5L, 
        q_m2 = 5L
    )
)
extract_score(x = BQ_score)
#>   series score
#> 1 France    60
#> 2  Spain   110
#> 3 Greece   100
```

#### Exporter un bilan qualité

Enfin il est possible d’exporter un bilan qualité via la fonction
`export_xlsx`.

### Autres informations

Pour plus d’informations sur l’installation et la configuration du
package **{JDCruncheR}**, vous pouvez visiter la page
[wiki](https://github.com/jdemetra/jwsacruncher/wiki)

Pour une description plus complète des packages R pour JDemetra+ voir le
document de travail Insee [Les packages R pour JDemetra+ : une aide à la
désaisonnalisation](https://www.insee.fr/fr/statistiques/5019786)

### Overview

The primary objective of the **{JDCruncheR}** package is to provide a
quick and easy access to the JDemetra+ cruncher (`JWSACruncher`) from R.
The cruncher is a tool for updating JDemetra+ workspaces, without having
to open the graphical user interface. The latest version can be
downloaded here: <https://github.com/jdemetra/jwsacruncher/releases>.
For more information, please refer to the [wiki
page](https://github.com/jdemetra/jwsacruncher/wiki).

With **{JDCruncheR}**, you can also generate a *quality report* based on
the cruncher’s output. This report is a formatted summary of the
seasonal adjustment process master diagnostics and parameters. It can be
used to spot the most problematic series which will require a finer
analysis. This is most useful when dealing with a large number of
series.

### Installation

**🎉 {JDCruncheR} is now available on CRAN! 🎉**

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

#### Loading the package

``` r
library("JDCruncheR")
```

#### Changing statistical test thresholds

The thresholds of the QR tests can be customised You have to modify the
option `"jdc_thresholds"`.

To get the (default or not) values of the thresholds of the tests, you
can call the fonction
[`get_thresholds()`](https://inseefr.github.io/JDCruncheR/reference/get_thresholds.md)
:

``` r
get_thresholds("m7")
#>   Good    Bad Severe 
#>      1      2    Inf
get_thresholds(default = TRUE)
#> $qs_residual_s_on_sa
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $qs_residual_sa_on_i
#>    Severe       Bad Uncertain      Good 
#>     0.001     0.010     0.050       Inf 
#> 
#> $f_residual_s_on_sa
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
#> 
#> $grade
#>      Good Uncertain       Bad    Severe 
#>         0         1         3         5
```

To change the value of the option, you can use the fonction
[`set_thresholds()`](https://inseefr.github.io/JDCruncheR/reference/set_thresholds.md):

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

#### Changing the scores for the `Good`, `Uncertain`, `Bad` and `Severe` modalities

The mechanism is the same as for the statistical test thresholds with
the `"grade"` value:

To retrieve the default grade value, call the
[`get_thresholds()`](https://inseefr.github.io/JDCruncheR/reference/get_thresholds.md)
function:

``` r
get_thresholds("grade", default = TRUE)
#>      Good Uncertain       Bad    Severe 
#>         0         1         3         5
```

To change the value of the grade, you can use the
[`set_thresholds()`](https://inseefr.github.io/JDCruncheR/reference/set_thresholds.md)
function:

``` r
# Set grades to a certain value
set_thresholds(test_name = "grade", thresholds = c(Good = 0, Uncertain = 0.1, Bad = 1, Severe = 10))
get_thresholds(test_name = "grade", default = FALSE)
#>      Good Uncertain       Bad    Severe 
#>       0.0       0.1       1.0      10.0
```

#### Calculate a quality report

For example, starting from a matrix `demetra_m.csv` :

|        | n   | start      | end        | mean | skewness |     | kurtosis |     | lb2  |     | p   | d   | q   | bp  | bd  | bq  | m7  | q   | q.m2 |
|--------|-----|------------|------------|------|----------|-----|----------|-----|------|-----|-----|-----|-----|-----|-----|-----|-----|-----|------|
| France | 88  | 2012-10-01 | 2020-01-01 | 0.6  | 0.0      | 0.9 | 2.9      | 0.8 | 36.1 | 0.0 | 0   | 1   | 1   | 0   | 1   | 1   | 0.2 | 0.5 | 2.0  |
| Spain  | 78  | 2015-10-01 | 2022-03-01 | 0.4  | -0.4     | 0.0 | 4.6      | 0.0 | 17.3 | 0.7 | 0   | 0   | 1   | 0   | 1   | 1   | 0.8 | 1.5 | 1.3  |
| Greece | 112 | 2010-10-01 | 2020-01-01 | 0.5  | -0.3     | 0.0 | 3.7      | 0.0 | 46.9 | 0.0 | 3   | 1   | 1   | 0   | 1   | 1   | 0.3 | 0.4 | 0.8  |

A quality report can be generated:

``` r
BQ <- extract_QR(x = demetra_m)
print(BQ$modalities)
#>   series residuals_homoskedasticity residuals_skewness residuals_kurtosis
#> 1 France                       Good               Good               Good
#> 2  Spain                        Bad                Bad                Bad
#> 3 Greece                        Bad                Bad                Bad
#>   oos_mean oos_mse   m7    q q_m2 pct_outliers
#> 1     Good    <NA> Good Good  Bad         <NA>
#> 2     Good    <NA> Good  Bad  Bad         <NA>
#> 3     Good    <NA> Good  Bad Good         <NA>
```

#### Calculate a score

It is now possible to calculate a score from the quality report:

``` r
BQ_score <- compute_score(
    x = BQ,
    score_pond = c(
        oos_mean = 15L, 
        residuals_kurtosis = 15L, 
        residuals_homoskedasticity = 5L, 
        residuals_skewness = 5L, 
        m7 = 5L, 
        q_m2 = 5L
    )
)
extract_score(x = BQ_score)
#>   series score
#> 1 France    60
#> 2  Spain   110
#> 3 Greece   100
```

#### Exporting a quality report

Finally, you can export a quality report using the `export_xlsx`
function.

### Other informations

For more informations on installing and configuring the **{JDCruncheR}**
package, you can visit the
[wiki](https://github.com/jdemetra/jwsacruncher/wiki) page.

For a more comprehensive description of the R packages for JDemetra+
check the Insee working paper [R Tools for JDemetra+: Seasonal
adjustment made easier](https://www.insee.fr/en/statistiques/5019812)
