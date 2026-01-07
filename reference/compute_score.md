# Score calculation

To calculate a score for each series from a quality report

## Usage

``` r
# S3 method for class 'QR_matrix'
compute_score(
  x,
  score_pond = c(qs_residual_s_on_sa = 30L, f_residual_s_on_sa = 30L, qs_residual_sa_on_i
    = 20L, f_residual_sa_on_i = 20L, f_residual_td_on_sa = 30L, f_residual_td_on_i = 20L,
    oos_mean = 15L, oos_mse = 10L, residuals_independency = 15L,
    residuals_homoskedasticity = 5L, residuals_skewness = 5L, m7 = 5L, q_m2 = 5L),
  modalities = c("Good", "Uncertain", "", "Bad", "Severe"),
  normalize_score_value = NULL,
  na.rm = TRUE,
  n_contrib_score = NULL,
  conditional_indicator = NULL,
  thresholds = getOption("jdc_thresholds"),
  ...
)

# S3 method for class 'mQR_matrix'
compute_score(x, ...)
```

## Arguments

- x:

  a
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  or
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  object.

- score_pond:

  the formula used to calculate the series score.

- modalities:

  modalities ordered by importance in the score calculation (cf.
  details).

- normalize_score_value:

  integer indicating the reference value for weights normalisation. If
  missing, weights will not be normalised.

- na.rm:

  logical indicating whether missing values must be ignored when
  calculating the score.

- n_contrib_score:

  integer indicating the number of variables to create in the quality
  report's values matrix to store the `n_contrib_score` greatest
  contributions to the score (cf. details). If not specified, no
  variable is created.

- conditional_indicator:

  a `list` containing 3-elements sub-lists: "indicator", "conditions"
  and "condition_modalities". To reduce down to 1 the weight of chosen
  indicators depending on other variables' values (cf. details).

- thresholds:

  `list` of numerical vectors. Thresholds applied to the various tests
  in order to classify into modalities `Good`, `Uncertain`, `Bad` and
  `Severe`. By default, the value of the `"jdc_threshold"` option is
  used. You can call the
  [`get_thresholds`](https://inseefr.github.io/JDCruncheR/reference/get_thresholds.md)
  function to see what the `thresholds` object should look like.

- ...:

  other unused parameters.

## Value

a
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
or
[`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
object.

## Details

The function `compute_score` calculates a score from the modalities of a
quality report: to each modality corresponds a weight that depends on
the parameter `modalities`. The default parameter is
`c("Good", "Uncertain", "Bad","Severe")`, and the associated weights are
respectively 0, 1, 2 and 3.

The score calculation is based on the `score_pond` parameter, which is a
named integer vector containing the weights to apply to the (modalities
matrix) variables. For example, with
`score_pond = c(qs_residual_s_on_sa = 10, f_residual_td_on_sa = 5)`, the
score will be based on the variables `qs_residual_s_on_sa` and
`f_residual_td_on_sa`. The `qs_residual_s_on_sa` grades will be
multiplied by 10 and the `f_residual_td_on_sa grades`, by 5. To ignore
the missing values when calculating a score, use the parameter
`na.rm = TRUE`.

The parameter `normalize_score_value` can be used to normalise the
scores. For example, to have all scores between 0 and 20, specify
`normalize_score_value = 20`.

When using parameter `n_contrib_score`, `n_contrib_score` new variables
are added to the quality report's values matrix. These new variables
store the names of the variables that contribute the most to the series
score. For example, `n_contrib_score = 3` will add to the values matrix
the three variables that contribute the most to the score. The new
variables' names are *i*\_highest_score, with *i* being the rank in
terms of contribution to the score (1_highest_score contains the name of
the greatest contributor, 2_highest_score the second greatest, etc).
Only the variables that have a non-zero contribution to the score are
taken into account: if a series score is 0, all *i*\_highest_score
variables will be empty. And if a series score is positive only because
of the m7 statistic, 1_highest_score will have a value of "m7" for this
series and the other *i*\_highest_score will be empty.

Some indicators are only relevant under certain conditions. For example,
the homoscedasticity test is only valid when the residuals are
independant, and the normality tests, only when the residuals are both
independant and homoscedastic. In these cases, the parameter
`conditional_indicator` can be of use since it reduces the weight of
some variables down to 1 when some conditions are met.
`conditional_indicator` is a `list` of 3-elements sub-lists:

- "indicator": the variable whose weight will be conditionally changed

- "conditions": the variables used to define the conditions

- "conditions_modalities": modalities that must be verified to induce
  the weight change For example,
  `conditional_indicator = list(list(indicator = "residuals_skewness", conditions = c("residuals_independency", "residuals_homoskedasticity"), conditions_modalities = c("Bad","Severe")))`,
  reduces down to 1 the weight of the variable "residuals_skewness" when
  the modalities of the independancy test ("residuals_independency") or
  the homoscedasticity test ("residuals_homoskedasticity") are "Bad" or
  "Severe".

## See also

[Traduction
française](https://inseefr.github.io/JDCruncheR/reference/fr-compute_score.md)

## Examples

``` r
# Path of matrix demetra_m
demetra_path <- file.path(
    system.file("extdata", package = "JDCruncheR"),
    "WS/ws_ipi/Output/SAProcessing-1",
    "demetra_m.csv"
)

# Extract the quality report from the demetra_m file
QR <- extract_QR(demetra_path)
#> Multiple column found for extraction of q statistic
#> First column selected
#> Multiple column found for extraction of q-m2 statistic
#> First column selected
#> Multiple column found for extraction of mean
#> Last column selected

# Calculer le score
QR <- compute_score(QR, n_contrib_score = 2)
print(QR)
#> The quality report matrix has 13 observations
#> There are 19 indicators in the modalities matrix and 23 indicators in the values matrix
#> 
#> The quality report matrix contains the following variables:
#> series  residuals_homoskedasticity  residuals_skewness  residuals_kurtosis  residuals_normality  residuals_independency  qs_residual_s_on_sa  f_residual_s_on_sa  qs_residual_sa_on_i  f_residual_sa_on_i  f_residual_td_on_sa  f_residual_td_on_i  oos_mean  oos_mse  q  q_m2  m7  pct_outliers  frequency  arima_model  score  1_highest_contrib_score  2_highest_contrib_score
#> 
#> The variables exclusively found in the values matrix are:
#> frequency  arima_model  1_highest_contrib_score  2_highest_contrib_score
#> 
#> The smallest score is 30 and the greatest is 560
#> The average score is 330.385 and its standard deviation is 194.866
#> 
#> The following formula was used to calculate the score:
#> 30 * qs_residual_s_on_sa + 30 * f_residual_s_on_sa + 20 * qs_residual_sa_on_i + 20 * f_residual_sa_on_i + 30 * f_residual_td_on_sa + 20 * f_residual_td_on_i + 15 * oos_mean + 10 * oos_mse + 15 * residuals_independency + 5 * residuals_homoskedasticity + 5 * residuals_skewness + 5 * m7 + 5 * q_m2

# Extract the modalities matrix:
QR[["modalities"]][["score"]]
#>  [1] 145  45 300 310  30 195 560 560 505 545 255 310 535
```
