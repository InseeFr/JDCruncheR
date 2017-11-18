.onLoad<-function(libname, pkgname){
    if(is.null(getOption("default_matrix_item")))
        options(default_matrix_item = c("span.start", "span.end", "span.n", "espan.start", "espan.end", "espan.n",
                                        "likelihood.neffectiveobs", "likelihood.np", "likelihood.logvalue", "likelihood.adjustedlogvalue",
                                        "likelihood.ssqerr", "likelihood.aic", "likelihood.aicc", "likelihood.bic", "likelihood.bicc",
                                        "residuals.ser", "residuals.ser-ml", "residuals.mean", "residuals.skewness", "residuals.kurtosis",
                                        "residuals.dh", "residuals.lb", "residuals.lb2", "residuals.seaslb", "residuals.bp", "residuals.bp2",
                                        "residuals.seasbp", "residuals.nruns", "residuals.lruns", "m-statistics.m1", "m-statistics.m2",
                                        "m-statistics.m3", "m-statistics.m4", "m-statistics.m5", "m-statistics.m6", "m-statistics.m7",
                                        "m-statistics.m8", "m-statistics.m9", "m-statistics.m10", "m-statistics.m11", "m-statistics.q",
                                        "m-statistics.q-m2", "diagnostics.quality", "diagnostics.basic checks.definition:2",
                                        "diagnostics.basicchecks.annual totals:2", "diagnostics.visual spectral analysis.spectral seas peaks",
                                        "diagnostics.visual spectral analysis.spectral td peaks", "diagnostics.regarima residuals.normality:2",
                                        "diagnostics.regarima residuals.independence:2", "diagnostics.regarimaresiduals.spectral td peaks:2",
                                        "diagnostics.regarimaresiduals.spectral seas peaks:2", "diagnostics.residualseasonality.on sa:2",
                                        "diagnostics.residualseasonality.onsa (last 3 years):2", "diagnostics.residualseasonality.on irregular:2",
                                        "diagnostics.seats.seas variance:2", "diagnostics.seats.irregular variance:2",
                                        "diagnostics.seats.seas/irr cross-correlation:2", "log", "adjust", "arima.mean", "arima.p", "arima.d",
                                        "arima.q", "arima.bp", "arima.bd", "arima.bq", paste0("arima.phi(",1:4,")"), paste0("arima.th(",1:4,")"),
                                        "arima.bphi(1)", "arima.bth(1)",
                                        "regression.lp:3", "regression.ntd", paste0("regression.td(",1:7,"):3"), "regression.nmh",
                                        "regression.easter:3", "regression.nout", paste0("regression.out(",1:16,"):3"), "decomposition.seasonality", "decomposition.trendfilter",
                                        "decomposition.seasfilter"))
    if(is.null(getOption("default_tsmatrix_series")))
        options(default_tsmatrix_series = c("y","t","sa","s","i","ycal"))
    if(is.null(getOption("cruncher_bin_directory")))
        options(cruncher_bin_directory = "C:/Program Files/jwsacruncher-2.0.0/bin/")

}
