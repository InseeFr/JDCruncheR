testthat::test_that("QR works", {

    war1 <- paste("Some items are missing.",
                  "Please re-compute the cruncher export with the options:",
                  "diagnostics.out-of-sample.mean:2,",
                  "diagnostics.out-of-sample.mse:2")
    msg1 <- "Multiple column found for extraction of normality
Last column selected"
    msg2 <- "Multiple column found for extraction of independency
Last column selected"
    msg3 <- "Multiple column found for extraction of f_residual_sa_on_sa
Last column selected"
    msg4 <- "Multiple column found for extraction of f_residual_sa_on_i
Last column selected"

    path1 <- testthat::test_path("data", "demetra_m1.csv")
    expect_warning(object = {
        qr1 <- extract_QR(file = path1)
    }, regexp = war1)

    path2 <- testthat::test_path("data", "demetra_m2.csv")
    expect_message(
        object = expect_message(
            object = {
                qr2 <- extract_QR(file = path2)
            },
            regexp = msg1
        ),
        regexp = msg2
    )

    path3 <- testthat::test_path("data", "demetra_m3.csv")
    expect_message(
        object = expect_message(
            object = expect_warning(
                object = {
                    qr3 <- extract_QR(file = path3)
                },
                regexp = war1
            ),
            regexp = msg3
        ),
        regexp = msg4
    )
})
