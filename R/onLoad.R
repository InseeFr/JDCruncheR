.onLoad<-function(libname, pkgname){
    if(is.null(getOption("default_matrix_item")))
        options(default_matrix_item = c("span.start", "span.end", "span.n", "espan.start", "espan.end", "espan.n", "log", "adjust",
                                        paste0("regression.",c("lp", "ntd", "nmh", "easter", "nout", "noutao", "noutls", "nouttc",
                                                               "noutso", "td(*)", "out(*)")),
                                        paste0("likelihood.",c("neffectiveobs", "np", "logvalue", "adjustedlogvalue", "ssqerr", "aic",
                                                               "aicc", "bic", "bicc")),
                                        paste0("residuals.",c("ser", "ser-ml", "mean", "skewness", "kurtosis", "dh", "lb", "lb2",
                                                              "seaslb", "bp", "bp2", "seasbp", "nruns", "lruns")),
                                        paste0("arima",c("", ".mean", ".p", ".d", ".q", ".bp", ".bd", ".bq", ".phi(*)", ".bphi(*)",
                                                         ".th(*)", ".bth(*)")),
                                        paste0("decomposition.",c("seasonality", "parameters_cutoff", "model_changed", "ar_root(*)",
                                                                  "trendfilter", "seasfilter")),
                                        paste0("m-statistics.",c(paste0("m",1:11), "q", "q-m2")),
                                        paste0("diagnostics.",c("basic checks.definition:2", "basic checks.annual totals:2",
                                                                "visual spectral analysis.spectral seas peaks",
                                                                "visual spectral analysis.spectral td peaks",
                                                                paste0("regarima residuals.",
                                                                       c("normality:2", "independence:2","spectral td peaks:2",
                                                                         "spectral seas peaks:2")),
                                                                "outliers.number of outliers:2","m-statistics.q:2",
                                                                "m-statistics.q-m2:2", "seats.seas variance:2", "seats.irregular variance:2",
                                                                "seats.seas/irr cross-correlation:2",
                                                                paste0("residual seasonality tests.",
                                                                       c("qs test on sa:2","qs test on i:2",
                                                                         "f-test on sa (seasonal dummies):2",
                                                                         "f-test on i (seasonal dummies):2")),
                                                                paste("residual trading days tests.f-test on",
                                                                      c("sa (td):2", "i (td):2")),
                                                                "out-of-sample.mean:2", "out-of-sample.mse:2",
                                                                paste("combined residual seasonality test.on",
                                                                      c("sa:2", "sa (last 3 years):2", "irregular:2"))
                                        ))
        ))
    if(is.null(getOption("default_tsmatrix_series")))
        options(default_tsmatrix_series = c("y", "t","sa","s","i","ycal"))
    if(is.null(getOption("cruncher_bin_directory")))
        options(cruncher_bin_directory = "Y:/Logiciels/jwsacruncher-2.2.0/jdemetra-cli-2.2.0/bin")

}
