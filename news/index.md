# Changelog

## JDCruncheR 0.3.6.9000

All notable changes to this project will be documented in this file.

The format is based on [Keep a
Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### [Unreleased](https://github.com/InseeFr/JDCruncheR/compare/v0.3.6...HEAD)

#### Fixed

- Solved the partial coloring bug in the output file. The value tab is
  now colored in its entirety, not just part of it.
  [\#44](https://github.com/InseeFr/JDCruncheR/issues/44)
- `sa_on_sa` statistics are renamed in `s_on_sa`

### [0.3.6](https://github.com/InseeFr/JDCruncheR/compare/v0.3.5...v0.3.6) - 2025-07-24

#### Changed

- integer column (from demetra_m) are now recognized as numeric

#### Fixed

- extract_QR works now with missing information (as `start`, `end` and
  `n`)

#### Added

- New item for demetra_m in v3 (`diagnostics.fcast-outsample-mean`,
  `diagnostics.fcast-outsample-variance`)

### [0.3.5](https://github.com/InseeFr/JDCruncheR/compare/v0.3.4...v0.3.5) - 2025-04-14

#### Changed

- `na.rm = TRUE` by default in
  [`compute_score()`](https://inseefr.github.io/JDCruncheR/reference/compute_score.md)
  [\#36](https://github.com/InseeFr/JDCruncheR/issues/36)
- `extract_QR` accept demetra_m with duplicated columns

### [0.3.4](https://github.com/InseeFr/JDCruncheR/compare/v0.3.3...v0.3.4) - 2025-03-27

#### Changed

- Re-organise and simplify the process to integrate item to the
  demetra_m matrix (from v2 and v3)

### [0.3.3](https://github.com/InseeFr/JDCruncheR/compare/v0.3.2...v0.3.3) - 2025-02-20

#### Fixed

- remove the use of lambda function and base pipe for R version \< 4.1

### [0.3.2](https://github.com/InseeFr/JDCruncheR/compare/v0.3.1...v0.3.2) - 2025-02-07

#### Added

- New item `grade` to the `jdc_thresholds` option to specify the
  different grades when computing the score
- New arguments `file` which will replace `matrix_output_file` for
  [`extract_QR()`](https://inseefr.github.io/JDCruncheR/reference/extract_QR.md)
- New arguments `x` which can contains a diagnostic matrix for
  [`extract_QR()`](https://inseefr.github.io/JDCruncheR/reference/extract_QR.md)

#### Fixed

- bug in `recode_vec()` when changing the grades with `factor` object
- `extractQR()` works with v3 now

### [0.3.1](https://github.com/InseeFr/JDCruncheR/compare/v0.3.0...v0.3.1) - 2024-10-10

#### Fixed

- bug in
  [`export_xlsx()`](https://inseefr.github.io/JDCruncheR/reference/export_xlsx.md)
  with [`ifelse()`](https://rdrr.io/r/base/ifelse.html)

### [0.3.0](https://github.com/InseeFr/JDCruncheR/compare/v0.2.4...v0.3.0) - 2024-10-09

#### Changed

- Update readme
- remove all functions related to cruncher

#### Fixed

- resolve a bug linked to shell function
- resolve a bug related to accent colnames
- lintr is up-to-date
- `extract_QR` works with V3 workspaces
- Fixed bug with Tramo-Seats series –\> Now, WS with Tramo-Seats series
  are accepted!
- if column of demetra_m are not available, there will be NA instead
- lintr `any(is.na(...))` -\> `anyNA(...)`

#### Added

- GitHub Action to check the package
- New functions to manage the `jdc_thresholds` option

### [0.2.4](https://github.com/InseeFr/JDCruncheR/compare/v0.2.3...v0.2.4) - 2022-07-27

#### Added

- The functions’ help pages as well as the package vignettes are now
  available both in French and English.

#### Changed

- The function choose.file, not compatible with all OS, has been
  replaced by an error message.

### [0.2.3](https://github.com/InseeFr/JDCruncheR/compare/v0.2.2...v0.2.3) - 2019-02-05

#### Changed

- the function
  [`weighted_score()`](https://inseefr.github.io/JDCruncheR/reference/weighted_score.md)
  now creates a new `score_pond` variable, rather than replacing it. The
  function
  [`extract_score()`](https://inseefr.github.io/JDCruncheR/reference/extract_score.md)
  extracts both weighted and unweighted scores.
- change in the cruncher’s default export parameters and in the
  indicators used by the function
  [`compute_score()`](https://inseefr.github.io/JDCruncheR/reference/compute_score.md)
  to calculate the score.

#### Added

- addition of a `conditional_indicator` parameter to the function
  [`compute_score()`](https://inseefr.github.io/JDCruncheR/reference/compute_score.md)
  to reduce down to 1 the weight of some indicators, depending on other
  variables’ value.

### [0.2.2](https://github.com/InseeFr/JDCruncheR/compare/v0.2.1...v0.2.2) - 2018-03-14

#### Added

- the function `score()` is replaced by the function
  [`extract_score()`](https://inseefr.github.io/JDCruncheR/reference/extract_score.md)
  and has a new parameter to choose the output format. The function
  `score()` will be removed in the next version of the package.
- addition of the function
  [`add_indicator()`](https://inseefr.github.io/JDCruncheR/reference/add_indicator.md)
  to add variables in the quality report’s matrix of values.
- addition of the function
  [`recode_indicator_num()`](https://inseefr.github.io/JDCruncheR/reference/recode_indicator_num.md)
  to recode variable modalities in the quality report.

#### Changed

- the column containing the series names can no longer be removed when
  using the functions
  [`remove_indicators()`](https://inseefr.github.io/JDCruncheR/reference/QR_var_manipulation.md)
  ou
  [`retain_indicators()`](https://inseefr.github.io/JDCruncheR/reference/QR_var_manipulation.md)
- bugs fixed in the functions
  [`print.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/print.QR_matrix.md)
  and
  [`print.QR_matrix()`](https://inseefr.github.io/JDCruncheR/reference/print.QR_matrix.md).
- modification of
  [`compute_score()`](https://inseefr.github.io/JDCruncheR/reference/compute_score.md):
  the parameter score_formula is removed and replaced by score_pond. The
  score is calculated using the vector of variables to weight instead of
  a formula. The function now also carries two additional arguments:
  n_contrib_score to extract the variables that contribute the most to
  the score, and na.rm to take into account the missing values when
  calculating the score.
- bug fixed in
  [`extract_QR()`](https://inseefr.github.io/JDCruncheR/reference/extract_QR.md):
  the Q-m2 stat was equal to the Q stat.

### [0.2.1](https://github.com/InseeFr/JDCruncheR/compare/v0.2.0...v0.2.1) - 2018-01-22

#### Fixed

Bug fixed in the functions
[`retain_indicators()`](https://inseefr.github.io/JDCruncheR/reference/QR_var_manipulation.md)
and `remove_indicator()`.

### [0.2.0](https://github.com/InseeFr/JDCruncheR/releases/tag/v0.2.0) - 2017-11-18

#### Added

- `update_workspace()` to update a workspace without exporting the
  results.
- additionnal functions to extract a quality report from the JDemetra+
  diagnostics matrix, as well as to use and export said quality reports.

#### Changed

- addition of the parameter `log_file` to the functions `cruncher()` and
  `cruncher_and_param()` to export the cruncher log if required.
- update of the options `default_matrix_item` and
  `default_tsmatrix_series`, in accordance with the parameters of
  version 2.2.0 of JDemetra+.
