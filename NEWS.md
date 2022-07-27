% Latest JDCruncher news

# JDCruncher 0.2.4

 * The functions' help pages as well as the package vignettes are now available both in French and English.
 * The function choose.file, not compatible with all OS, has been replaced by an error message.  

---

# JDCruncher 0.2.3

 * the function `weighted_score()` now creates a new `score_pond` variable, rather than replacing it. The function `extract_score()` extracts both weighted and unweighted scores.
 * change in the cruncher's default export parameters and in the indicators used by the function `compute_score()` to calculate the score.
 * addition of a `conditional_indicator` parameter to the function `compute_score()` to reduce down to 1 the weight of some indicators, depending on other variables' value.

---

# JDCruncher 0.2.2

## New functions

 * the function `score()` is replaced by the function `extract_score()` and has a new parameter to choose the output format. The function `score()` will be removed in the next version of the package.
 * addition of the function `add_indicator()` to add variables in the quality report's matrix of values.
 * addition of the function `recode_indicator_num()` to recode variable modalities in the quality report.

## Modification of pre-existing functions

 * the column containing the series names can no longer be removed when using the functions `remove_indicators()` ou `retain_indicators()`
 * bugs fixed in the functions `print.QR_matrix()` and `print.QR_matrix()`.
 * modification of `compute_score()`: the parameter score_formula is removed and replaced by score_pond. The score is calculated using the vector of variables to weight instead of a formula. The function now also carries two additional arguments: n_contrib_score to extract the variables that contribute the most to the score, and na.rm to take into account the missing values when calculating the score.
 * bug fixed in  `extract_QR()`: the Q-m2 stat was equal to the Q stat.

---

# JDCruncher 0.2.1

Bug fixed in the functions `retain_indicators()` and `remove_indicator()`.

---

# JDCruncher 0.2.0

## New functions

 * `update_workspace()` to update a workspace without exporting the results.
 * additionnal functions to extract a quality report from the JDemetra+ diagnostics matrix, as well as to use and export said quality reports.

##  Modification of pre-existing functions

 * addition of the parameter `log_file` to the functions `cruncher()` and `cruncher_and_param()` to export the cruncher log if required.

## Other modifications

 * update of the options `default_matrix_item` and `default_tsmatrix_series`, in accordance with the parameters of version 2.2.0 of JDemetra+.
