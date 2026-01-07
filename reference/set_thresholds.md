# Set values for thresholds

Set values for thresholds

## Usage

``` r
set_thresholds(test_name, thresholds)
```

## Arguments

- test_name:

  String. The name of the test to update.

- thresholds:

  Named vector of numerics. The upper values of each break of a
  threshold.

## Details

If `test_name` is missing, the argument `thresholds` is not used and all
thresholds will be updated to their default values.

If `test_name` is not missing, but if the argument `thresholds` is
missing then only the thresholds of the test `test_name` will be updated
to its default values.

Finally, if `test_name` and `thresholds` are not missing, then only the
thresholds of the test `test_name` are updated with the value
`thresholds`.

## Examples

``` r
# Set "m7"
set_thresholds(
    test_name = "m7",
    thresholds = c(Good = 0.8, Bad = 1.4, Severe = Inf)
)

# Set "oos_mean" to default
set_thresholds(test_name = "oos_mean")

# Set all thresholds to default
set_thresholds()
```
