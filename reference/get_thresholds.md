# Get all (default) thresholds

Get all (default) thresholds

## Usage

``` r
get_thresholds(test_name, default = TRUE)
```

## Arguments

- test_name:

  String. The name of the test to get.

- default:

  Boolean. (default is TRUE) If TRUE, the default threshold will be
  returned. If FALSE the current used thresholds.

## Details

If `test_name` is missing, all threshold will be returned.

## Examples

``` r
# Get all default thresholds
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
#> 

# Get all current thresholds
get_thresholds(default = FALSE)
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
#> 

# Get all current thresholds
get_thresholds(test_name = "oos_mean", default = FALSE)
#>       Bad Uncertain      Good 
#>      0.01      0.10       Inf 
```
