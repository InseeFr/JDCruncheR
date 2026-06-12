# JVS matrix object

`JVS_matrix()` are creating a quality report based on the Eurostat JVS
Plug-In.

## Usage

``` r
JVS_matrix(x = list())

# S3 method for class 'data.frame'
JVS_matrix(x)

# S3 method for class 'JVS_matrix'
JVS_matrix(x)

# Default S3 method
JVS_matrix(x)
```

## Arguments

- x:

  a `data.frame` containing the output variables' values (test p-values,
  test statistics, etc.) and modalities (Yes/No).

## Value

`JVS_matrix()` creates and returns a `JVS_matrix` object.

## Details

A[`QR_matrix`](https://inseefr.github.io/JDCruncheR/reference/QR_matrix.md)
object is a data.frame with 30 items:

- Series

- Method

- Period

- Nobs

- Start

- End

- Adjustment

- Presence of Seasonality in the Raw Series

- Presence of TD effects

- Log-Transformation

- ARIMA Model

- LeapYear

- MovingHoliday

- NbTD

- Noutliers

- Outlier1

- Outlier2

- Outlier3

- Residual Seasonality in SA Series (F-test)

- Residual TD Effect

- Q-Stat (for X13)

- Final Henderson Filter

- Stage 2 Henderson Filter

- Seasonal Filter

- Quality

- Autocorrelation of order 1 of the SA series

- Ljung-Box Test (P-value)

- Autocorrelation negative and significant

- Irregular Standard-Deviation

- Max-Adj
