# Adding an indicator in QR_matrix objects

Function to add indicators in
[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
objects.

## Usage

``` r
add_indicator(x, indicator, variable_name, ...)
```

## Arguments

- x:

  a
  [`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  or
  [`mQR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
  object

- indicator:

  a `vector` or a `data.frame` (cf. details).

- variable_name:

  a string containing the name of the variables to add.

- ...:

  other parameters of the function
  [`merge`](https://rdrr.io/r/base/merge.html).

## Value

This function returns the same object, enhanced with the chosen
indicator. So if the input `x` is a QR_matrix, an object of class
`QR_matrix` is returned. If the input `x` is a mQR_matrix, an object of
class `mQR_matrix` is returned.

## Details

The function `add_indicator()` adds the chosen indicator to the values
matrix of a quality report. Therefore, because said indicator isn't
added in the modalities matrix, it cannot be used to calculate a score
(except for weighting). Before using the added variable for score
calculation, it will have to be coded with the function
[`recode_indicator_num`](https://inseefr.github.io/JDCruncheR/reference/recode_indicator_num.md).

The new indicator can be a `vector` or a `data.frame`. In both cases,
its format must allow for pairing:

- a `vector`'s elements must be named and these names must match those
  of the quality report (variable "series");

- a `data.frame` must contain a "series" column that matches with the
  quality report's series.

## See also

[Traduction
française](https://inseefr.github.io/JDCruncheR/reference/fr-add_indicator.md)

Other var QR_matrix manipulation:
[`QR_var_manipulation`](https://inseefr.github.io/JDCruncheR/reference/QR_var_manipulation.md),
[`recode_indicator_num()`](https://inseefr.github.io/JDCruncheR/reference/recode_indicator_num.md)
