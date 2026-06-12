# Score extraction

To extract score variables from
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
or
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
objects.

## Usage

``` r
extract_score(
  x,
  format_output = c("data.frame", "vector"),
  weighted_score = FALSE
)
```

## Arguments

- x:

  a
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  or
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md).

- format_output:

  string of characters indicating the output format: either a
  `data.frame` or a `vector`.

- weighted_score:

  logical indicating whether to extract the weighted score (if
  previously calculated) or the unweighted one. By default, the
  unweighted score is extracted.

## Value

`extract_score()` returns a data.frame with two column: the series name
and their score.

## Details

For
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
objects, the output is a vector or the object `NULL` if no score was
previously calculated. For
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
objects, it is a list of scores (`NULL` elements or vectors).

## See also

[Traduction
française](https://inseefr.github.io/JDCruncheR/reference/fr-extract_score.md)

## Examples

``` r
# Path of matrix demetra_m
demetra_path <- file.path(
    system.file("extdata", package = "JDCruncheR"),
    "WS/WS_world/Output/SAProcessing-1",
    "demetra_m.csv"
)

# Extract the quality report from the demetra_m file
QR <- extract_QR(demetra_path)
#> Multiple column found for extraction of diagnostics.seas-i-qs:2, diagnostics.seas-i-qs
#> Last column selected
#> Multiple column found for extraction of diagnostics.seas-i-f:2, diagnostics.seas-i-f
#> Last column selected

# Compute the score
QR1 <- compute_score(x = QR, n_contrib_score = 5)
QR2 <- compute_score(
    x = QR,
    score_pond = c(qs_residual_s_on_sa = 5, qs_residual_sa_on_i = 30,
                   f_residual_td_on_sa = 10, f_residual_td_on_i = 40,
                   oos_mean = 30, residuals_skewness = 15, m7 = 25)
)
mQR <- mQR_matrix(list(a = QR1, b = QR2))

# Extract score
extract_score(QR1)
#>                      series score
#> 1  Siachen Glacier (frozen)     0
#> 2 Nagorno-Karabakh (frozen)     0
#> 3         Mongolia (frozen)   195
#> 4            India (frozen)    15
#> 5            Nepal (frozen)    10
#> 6      Philippines (frozen)    40
extract_score(mQR)
#> $a
#>                      series score
#> 1  Siachen Glacier (frozen)     0
#> 2 Nagorno-Karabakh (frozen)     0
#> 3         Mongolia (frozen)   195
#> 4            India (frozen)    15
#> 5            Nepal (frozen)    10
#> 6      Philippines (frozen)    40
#> 
#> $b
#>                      series score
#> 1  Siachen Glacier (frozen)     0
#> 2 Nagorno-Karabakh (frozen)     0
#> 3         Mongolia (frozen)    25
#> 4            India (frozen)     0
#> 5            Nepal (frozen)    15
#> 6      Philippines (frozen)    40
#> 
```
