# Converting "values variables" into "modalities variables"

To transform variables from the values matrix into categorical variables
that can be added into the modalities matrix.

## Usage

``` r
recode_indicator_num(
  x,
  variable_name,
  breaks = c(0, 0.01, 0.05, 0.1, 1),
  labels = c("Good", "Uncertain", "Bad", "Severe"),
  ...
)
```

## Arguments

- x:

  a
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  or
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  object.

- variable_name:

  a vector of strings containing the names of the variables to convert.

- breaks:

  see function [`cut`](https://rdrr.io/r/base/cut.html).

- labels:

  see function [`cut`](https://rdrr.io/r/base/cut.html).

- ...:

  other parameters of the [`cut`](https://rdrr.io/r/base/cut.html)
  function.

## Value

The function `recode_indicator_num()` returns the same object, enhanced
with the chosen indicator. So if the input `x` is a QR_matrix, an object
of class `QR_matrix` is returned. If the input `x` is a mQR_matrix, an
object of class `mQR_matrix` is returned.

## See also

[Traduction
française](https://inseefr.github.io/JDCruncheR/reference/fr-recode_indicator_num.md)

Other var QR_matrix manipulation:
[`QR_var_manipulation`](https://inseefr.github.io/JDCruncheR/reference/QR_var_manipulation.md),
[`add_indicator()`](https://inseefr.github.io/JDCruncheR/reference/add_indicator.md)
