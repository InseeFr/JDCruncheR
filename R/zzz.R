
.onLoad <- function(libname, pkgname) {
    if (is.null(getOption("jdc_thresholds"))) {
        set_thresholds()
    }
}
