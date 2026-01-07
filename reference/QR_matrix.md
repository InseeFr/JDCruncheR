# Quality report objects

`mQR_matrix()` and `QR_matrix()` are creating one (or several) quality
report. The function `is.QR_matrix()` and `is.mQR_matrix()` are
functions to test whether an object is a quality report or a list of
quality reports.

## Usage

``` r
QR_matrix(modalities = NULL, values = NULL, score_formula = NULL)

mQR_matrix(x = list(), ...)

is.QR_matrix(x)

is.mQR_matrix(x)
```

## Arguments

- modalities:

  a `data.frame` containing the output variables' modalities (Good, Bad,
  etc.)

- values:

  a `data.frame` containing the output variables' values (test p-values,
  test statistics, etc.) Therefore, the values data frame can contain
  more variables than the data frame `modalities`.

- score_formula:

  the formula used to calculate the series score (if defined).

- x:

  a `QR_matrix` object, a `mQR_matrix` object or a list of `QR_matrix`
  objects.

- ...:

  objects of the same type as `x`.

## Value

`QR_matrix()` creates and returns a `QR_matrix` object. `mQR_matrix()`
creates and returns a `mQR_matrix` object (ie. a list of `QR_matrix`
objects). `is.QR_matrix()` and `is.mQR_matrix()` return Boolean values
(`TRUE` or `FALSE`).

## Details

A`QR_matrix` object is a list of three items:

- `modalities`, a `data.frame` containing a set of categorical variables
  (by default: Good, Uncertain, Bad, Severe).

- `values`, a `data.frame` containing the values corresponding to the
  `modalities` indicators (i.e. p-values, statistics, etc.), as well as
  variables for which a modality cannot be defined (e.g. the series
  frequency, the ARIMA model, etc).

- `score_formula` contains the formula used to calculate the series
  score (once the calculus is done).

## See also

[Traduction
française](https://inseefr.github.io/JDCruncheR/reference/fr-QR_matrix.md)
